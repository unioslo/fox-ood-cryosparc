## Wait for the CryoSPARC server to start
echo "Waiting for CryoSPARC server to open port ${port}..."
echo "TIMING - Starting wait at: $(date)"
# Increased timeout to 3600s for CryoSPARC v5 database upgrade which can take up to 1h
if wait_until_port_used "${host}:${port}" 3600; then
  echo "Discovered CryoSPARC server listening on port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
else
  echo "Timed out waiting for CryoSPARC server to open port ${port}!"
  echo "TIMING - Wait ended at: $(date)"
  pkill -P ${SCRIPT_PID}
  clean_up 1
fi
sleep 2
