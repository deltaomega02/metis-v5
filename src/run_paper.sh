#!/bin/bash
cd /home/botuser/metis-v4
set -a; source v4.env; set +a
exec /home/botuser/metis-f2/venv/bin/python -u paper_leverage.py
