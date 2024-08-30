#!/bin/bash

# Start stress testing

# Stress CPU with 4 workers
echo "Stressing CPU..."

# Run CPU stress test for 5 minutes
timeout 300 stress --cpu 4 &

# Stress memory with 2 workers, each consuming 4GB
echo "Stressing Memory..."
timeout 300 stress --vm 2 --vm-bytes 4G &

# Stress Disk I/O by writing a 1GB file
echo "Stressing Disk I/O..."
timeout 300 dd if=/dev/zero of=/tmp/testfile bs=1M count=1024 oflag=direct &

# Stress Network by generating traffic (replace IP with target machine or your own IP)
echo "Stressing Network..."
timeout 300 iperf3-darwin -c 127.0.0.1 -u -b 100M -t 300 &

# Wait for all background processes to finish
wait

# Clean up
echo "Cleaning up..."
rm -f /tmp/testfile

echo "Stress test completed!"
