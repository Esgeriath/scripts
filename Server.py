#!/bin/python
import os, sys, socket
import threading, ssl
import select, json
from datetime import datetime, timedelta
from datetime import time as d_time
import argparse, time, re
import logging
from abc import ABC, abstractmethod
import numpy as np

# Sites delayed (only when not blocked)
DELAYED = {
    # "hostname": time_seconds,
    "www.facebook.com": 20,
    "www.reddit.com": 20, "www.redditstatic.com": 20,
    "www.youtube.com": 20,
    # "www.xkcd.com": 10, "imgs.xkcd.com":5, # added impulses, so delay is no longer needed.
}

hr = lambda h, m: d_time(h, m, 0)

# time peirod block
def now_between(start, end):
    def inner():
        x = datetime.now().time()
        if start <= end: # blocking during day
            return start <= x <= end
        else: # blocking over night
            return start <= x or x <= end
    return inner

# tricky to access time period block
def trick():
    now_minute = datetime.now().minute
    now_second = datetime.now().second
    value = (now_minute % 2 == 1) or (now_second // 4 % 3 != 1)
    print(f'[trick] : {now_minute = }, {now_second = }, {value = }')
    return value
    # the tricky part; bloking if minute is 1 mod 2. (odd).
    # even wnen the minute is even, there is still 2/3 chance of blocking
    # (changing every 4 seconds) -- very annoying, as it should be.

class impulse: # preventing refreshing by adding more time
    MINIMAL = timedelta(microseconds=200_000)
    def __init__(self, seconds=60):
        self._s = seconds
        self._interval = timedelta(seconds=seconds)
        self._last_time = datetime.now()
        self._count = 0
    def __call__(self):
        now = datetime.now()
        res = (diff := (now - self._last_time)) > self._interval or diff < impulse.MINIMAL
        # self._last_time = now # questionable choice; perhaps some counter to delay less after some tries
        if res:
            self._count = 0
            self._last_time = now
        else:
            # resetting time and setting it to be up to 2 times longer (in limit)
            self._last_time = now + self._s * timedelta(seconds = 1 - np.exp(-diff.total_seconds()))
            self._count += 1
        print(f'[impulse] : {now = }, {res = }, count = {self._count}')
        return not res

def any_fun(*funs):
    return lambda: any(map(lambda f: f(), funs))
def all_fun(*funs):
    return lambda: all(map(lambda f: f(), funs))


# Sites blocked when function returns true
TIMEBLOCKED = {
    # "hostname": block_if_true_function,
    "www.xkcd.com":                  now_between(hr(22, 00), hr(19, 30)),
    "imgs.xkcd.com":        any_fun( now_between(hr(22, 30), hr(19, 30)), impulse()),
    "www.youtube.com":               now_between(hr(22, 40), hr(18, 00)),
    "www.facebook.com":     any_fun( now_between(hr(21, 30), hr( 9, 30)), trick),
    "9anime.to":                     now_between(hr(23, 00), hr(20, 00)),
    "bflix.io":                      now_between(hr(23, 00), hr(20, 00)),
    "www.reddit.com":       all_fun( now_between(hr(21, 00), hr( 9, 30)), trick),
    "www.redditstatic.com": all_fun( now_between(hr(21, 00), hr( 9, 30)), trick),
}

def is_blocked_rn(host):
    if host not in TIMEBLOCKED:
        return False
    return TIMEBLOCKED[host]()

logging.basicConfig(level=logging.INFO, format="[%(asctime)s] [%(process)s] [%(levelname)s] %(message)s")
logg = logging.getLogger(__name__)

BACKLOG = 50
MAX_THREADS = 200
BLACKLISTED = ["minesweeper.online"]
MAX_CHUNK_SIZE = 16 * 1024

class StaticResponse:
    connection_established = b"HTTP/1.1 200 Connection Established\r\n\r\n"
    block_response = b'HTTP/1.1 200 OK\r\nPragma: no-cache\r\nCache-Control: no-cache\r\nContent-Type: text/html\r\nDate: Sat, 15 Feb 2020 07:04:42 GMT\r\nConnection: close\r\n\r\n<html><head><title>ISP ERROR</title></head><body><p style="text-align: center;">&nbsp;</p><p style="text-align: center;">&nbsp;</p><p style="text-align: center;">&nbsp;</p><p style="text-align: center;">&nbsp;</p><p style="text-align: center;">&nbsp;</p><p style="text-align: center;">&nbsp;</p><p style="text-align: center;"><span><strong>**YOU ARE NOT AUTHORIZED TO ACCESS THIS WEB PAGE | YOUR PROXY SERVER HAS BLOCKED THIS DOMAIN**</strong></span></p><p style="text-align: center;"><span><strong>**CONTACT YOUR PROXY ADMINISTRATOR**</strong></span></p></body></html>'

class Error:
    STATUS_503 = "Service Unavailable"
    STATUS_505 = "HTTP Version Not Supported"

for key in filter(lambda x: x.startswith("STATUS"), dir(Error)):
    _, code = key.split("_")
    value = getattr(Error, f"STATUS_{code}")
    setattr(Error, f"STATUS_{code}", f"HTTP/1.1 {code} {value}\r\n\r\n".encode())

class Method:
    get = "GET"
    put = "PUT"
    head = "HEAD"
    post = "POST"
    patch = "PATCH"
    delete = "DELETE"
    options = "OPTIONS"
    connect = "CONNECT"

class Protocol:
    http10 = "HTTP/1.0"
    http11 = "HTTP/1.1"
    http20 = "HTTP/2.0"

class Request:
    def __init__(self, raw:bytes):
        self.raw = raw
        self.raw_split = raw.split(b"\r\n")
        self.log = self.raw_split[0].decode()

        self.method, self.path, self.protocol = self.log.split(" ")

        raw_host = re.findall(rb"host: (.*?)\r\n", raw.lower())

        # http protocol 1.1
        if raw_host:
            raw_host = raw_host[0].decode()
            if raw_host.find(":") != -1:
                self.host, self.port = raw_host.split(":")
                self.port = int(self.port)
            else:
                self.host = raw_host

        # http protocol 1.0 and below
        if "://" in self.path:
            path_list = self.path.split("/")
            if path_list[0] == "http:":
                self.port = 80
            if path_list[0] == "https:":
                self.port = 443

            host_n_port = path_list[2].split(":")
            if len(host_n_port) == 1:
                self.host = host_n_port[0]

            if len(host_n_port) == 2:
                self.host, self.port = host_n_port
                self.port = int(self.port)

            self.path = f"/{'/'.join(path_list[3:])}"

        elif self.path.find(":") != -1:
            self.host, self.port =  self.path.split(":")
            self.port = int(self.port)


    def header(self):
        raw_split = self.raw_split[1:]
        _header = dict()
        for line in raw_split:
            if not line:
                continue
            broken_line = line.decode().split(":")
            _header[broken_line[0].lower()] = ":".join(broken_line[1:])

        return _header

class Response:
    def __init__(self, raw:bytes):
        self.raw = raw
        self.raw_split = raw.split(b"\r\n")
        self.log = self.raw_split[0]

        try:
            self.protocol, self.status, self.status_str = self.log.decode().split(" ")
        except Exception as e:
            self.protocol, self.status, self.status_str = ("", "", "")

class ConnectionHandle(threading.Thread):
    def __init__(self, connection, client_addr):
        super().__init__()
        self.client_conn = connection
        self.client_addr = client_addr

    def run(self):
        rawreq = self.client_conn.recv(MAX_CHUNK_SIZE)
        if not rawreq:
            return
        
        req = Request(rawreq)
        blocked = is_blocked_rn(req.host) or req.host in BLACKLISTED

        if req.host in DELAYED and not blocked:
            time.sleep(DELAYED[req.host])

        if req.protocol == Protocol.http20:
            self.client_conn.send(Error.STATUS_505)
            self.client_conn.close()
            return

        if blocked:
            self.client_conn.send(StaticResponse.block_response)
            self.client_conn.close()
            logg.info(f"{req.method:<8} {req.path} {req.protocol} BLOCKED")
            return

        self.server_conn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        try:
            self.server_conn.connect((req.host, req.port))
        except:
            self.client_conn.send(Error.STATUS_503)
            self.client_conn.close()
            return

        if req.method == Method.connect:
            self.client_conn.send(StaticResponse.connection_established)
        else:
            self.server_conn.send(rawreq)

        res = None

        while True:
            triple = select.select([self.client_conn, self.server_conn], [], [], 60)[0]
            if not len(triple):
                break
            try:
                if self.client_conn in triple:
                    data = self.client_conn.recv(MAX_CHUNK_SIZE)
                    if not data:
                        break
                    self.server_conn.send(data)
                if self.server_conn in triple:
                    data = self.server_conn.recv(MAX_CHUNK_SIZE)
                    if not res:
                        res = Response(data)
                        logg.info(f"{req.method:<8} {req.path} {req.protocol} {res.status if res else ''}")
                    if not data:
                        break
                    self.client_conn.send(data)
            except ConnectionAbortedError:
                break


    def __del__(self):
        if hasattr(self, "server_conn"):
            self.server_conn.close()
        self.client_conn.close()


class Server:
    def __init__(self, host:str, port:int):
        logg.info(f"Proxy server starting")
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.bind((host, port))
        self.sock.listen(BACKLOG)
        logg.info(f"Listening at: http://{host}:{port}")

    def thread_check(self):
        while True:
            if threading.active_count() >= MAX_THREADS:
                time.sleep(1)
            else:
                return

    def start(self):
        try:
            while True:
                conn, client_addr = self.sock.accept()
                self.thread_check()
                s = ConnectionHandle(conn, client_addr)
                s.start()
        except KeyboardInterrupt:
            # shutting down server "normally"
            print("\nStopping server")

    def __del__(self):
        self.sock.close()
        print("Closing sockets")


if __name__ == '__main__':
    ser = Server(host="127.0.0.1", port=8889)
    ser.start()
