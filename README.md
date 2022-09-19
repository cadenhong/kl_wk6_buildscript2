# kl_wk6_buildscript2
Bash script to automatically check the server's processes and ask user to terminate any processes that exceeds 350 MB of memory usage

### Script Flow
- See [buildscript2.sh](https://github.com/cadenhong/kl_wk6_buildscript2/blob/main/buildscript2.sh) for step by step description of code
- Even after all the processes are terminated, the last while loop will continue to ask for a PID to terminate - only way to exit the script at this point is to enter "q" or "Q" to quit

### Files
- [buildscript2.sh](https://github.com/cadenhong/kl_wk6_buildscript2/blob/main/buildscript2.sh): Script to check for processes exceeding 350 MB of memory usage
- [kill.txt](https://github.com/cadenhong/kl_wk6_buildscript2/blob/main/kill.txt): Contains only PID of processes, used to check against user input of PID to kill
- [organized.csv](https://github.com/cadenhong/kl_wk6_buildscript2/blob/main/organized.csv): PID and converted memory (from KB to MB) of processes that exceeds 350 MB in memory usage - content used to display to user
- [processes.txt](https://github.com/cadenhong/kl_wk6_buildscript2/blob/main/processes.txt): Contains all processes generated using `ps aux` sorted by rss column (i.e. memory in KB)
