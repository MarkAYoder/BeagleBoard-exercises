# This may be needed to run rt
echo 950000 | sudo tee /sys/fs/cgroup/cpu/cpu.rt_runtime_us 

