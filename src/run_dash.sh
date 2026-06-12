#!/bin/bash
cd /home/botuser/metis-v4
set -a; source v4.env; set +a
exec /home/botuser/ATHENA/athena/bin/python -m streamlit run dashboard.py \
  --server.port 8501 --server.address 0.0.0.0 --server.headless true \
  --browser.gatherUsageStats false
