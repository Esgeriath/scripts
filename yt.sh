#!/bin/sh

cd ~/.local/repo/ytsCRAP || exit 1
pgrep php || php -S 0.0.0.0:8000 &
firefox http://localhost:8000/x.php
