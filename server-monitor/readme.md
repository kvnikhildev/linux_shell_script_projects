# Linux Server Health Monitoring Script

## Project Overview

This project is a Bash-based Linux Server Health Monitoring Script.

It monitors important system resources and services on an Ubuntu/Linux machine.

The script automatically checks:

- Server uptime
- CPU utilization
- Memory utilization
- Disk utilization
- SSH service status
- Cron service status

It also compares resource usage against predefined thresholds and generates warning messages when usage is too high.

---

## Project Objectives

The main objectives of this project are:

1. Monitor Linux server health.
2. Identify high CPU utilization.
3. Identify high memory utilization.
4. Monitor disk space usage.
5. Check whether important services are running.
6. Maintain logs with timestamps.
7. Generate warnings when resource usage exceeds configured limits.

---

## Technologies Used

| Technology | Purpose |
|---|---|
| Linux (Ubuntu) | Operating system |
| Bash | Scripting language |
| systemctl | Service monitoring |
| top | CPU monitoring |
| free | Memory monitoring |
| df | Disk monitoring |
| awk | Extract and process command output |
| cut | Extract specific fields |
| tr | Remove unwanted characters |
| tee | Display and save log messages |
| date | Generate timestamps |
| uptime | Check server uptime |

---

## Project Structure

```text
linux-server-monitor/
│
├── server-monitor.sh
│
└── README.md
```

The monitoring logs are stored separately:

```text
/var/log/server-monitor/
│
└── health.log
```

---

## Configuration

The script uses the following configuration variables:

```bash
LOG_DIR="/var/log/server-monitor"
LOG_FILE="$LOG_DIR/health.log"

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
```

### Explanation

| Variable | Description |
|---|---|
| LOG_DIR | Directory where monitoring logs are stored |
| LOG_FILE | Log file path |
| CPU_THRESHOLD | Maximum acceptable CPU usage |
| MEMORY_THRESHOLD | Maximum acceptable memory usage |
| DISK_THRESHOLD | Maximum acceptable disk usage |

If CPU, memory, or disk usage reaches or exceeds 80%, the script generates a warning.

---

## Monitoring Components

### 1. Server Uptime

Command:

```bash
uptime -p
```

Purpose:

Displays how long the Linux system has been running.

Example:

```text
up 2 hours, 30 minutes
```

### 2. CPU Monitoring

Command:

```bash
top -bn1 | awk '/Cpu\(s\)/ {print 100-$8}' | cut -d. -f1
```

Purpose:

- `top -bn1` takes one snapshot of system activity.
- `awk` searches for the CPU information.
- `$8` extracts the idle percentage in the expected output format.
- `100-$8` calculates CPU usage.
- `cut -d. -f1` removes the decimal portion.

Example:

```text
CPU Usage: 85%
WARNING: High CPU utilization!
```

Note: The CPU field position can vary depending on the `top` version and output format. Check the actual output on your machine.

### 3. Memory Monitoring

Command:

```bash
free | awk '/Mem:/ {printf "%.0f", $3/$2 * 100}'
```

Purpose:

- `free` displays memory information.
- `$2` represents total memory.
- `$3` represents used memory.
- `$3/$2 * 100` calculates the used memory percentage.
- `printf "%.0f"` prints a rounded whole number.

Example:

```text
Memory Usage: 85%
WARNING: High Memory utilization!
```

Note: This calculates the percentage using the `used` column, which includes memory used by cache. For a better estimate of actual memory pressure, consider using the `available` column.

### 4. Disk Monitoring

Command:

```bash
df -P / | awk 'NR==2 {print $5}' | tr -d '%'
```

Purpose:

- `df -P /` checks disk usage for the root filesystem.
- `awk` extracts the second output line.
- `$5` extracts the usage percentage.
- `tr -d '%'` removes the percentage symbol.

Example:

```text
Disk Usage: 85%
WARNING: Disk space is running low!
```

### 5. Service Monitoring

Command:

```bash
for service in ssh cron; do
    if systemctl is-active --quiet "$service"; then
        log_message "$service service is RUNNING"
    else
        log_message "WARNING: $service service is NOT RUNNING"
    fi
done
```

Purpose:

Checks whether SSH and Cron services are active.

Important Bash concepts:

- `for` loops through multiple service names.
- `if` checks a condition.
- `systemctl is-active` checks service status.
- `--quiet` suppresses normal output.
- `then` executes commands when the condition succeeds.
- `else` executes commands when the condition fails.
- `fi` ends the if condition.
- `done` ends the for loop.


## Installation and Execution

### Step 1: Create a project directory

```bash
mkdir linux-server-monitor
cd linux-server-monitor
```

### Step 2: Create the Bash script

```bash
nano server-monitor.sh
```

Paste your monitoring script and save it.

### Step 3: Make the script executable

```bash
chmod +x server-monitor.sh
```

### Step 4: Execute the script

Because the log directory is under `/var/log`, run the script with sudo:

```bash
sudo ./server-monitor.sh
```

### Step 5: View the monitoring logs

```bash
sudo cat /var/log/server-monitor/health.log
```

To continuously watch new log entries:

```bash
sudo tail -f /var/log/server-monitor/health.log
```

Press `Ctrl + C` to stop watching.



## Bash Concepts Practiced

This project helps beginners understand:

| Bash Concept | Example |
|---|---|
| Variables | `CPU_THRESHOLD=80` |
| Command substitution | `$(uptime -p)` |
| Functions | `log_message()` |
| For loops | `for service in ssh cron` |
| If conditions | `if [ "$CPU_USAGE" -ge 80 ]` |
| Pipes | `command1 \| command2` |
| Awk | Extracting CPU and memory values |
| Cut | Removing decimal values |
| Tr | Removing percentage symbols |
| Exit status | Checking whether a service is active |
| Logging | Saving monitoring information |

---

Nikhil 
