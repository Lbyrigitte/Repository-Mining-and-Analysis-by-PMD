# Repository Mining and Analysis by PMD

## Overview
This project provides a **Docker-based program** that performs static analysis on each commit of a selected Java Git repository using [PMD](https://pmd.github.io/).  
It is designed for **software repository mining** and generates detailed analysis results per commit, along with a final summary report.

## Core Functionalities
- Support for local and remote Git repositories
- Dockerized execution
- Commit-by-commit traversal of the full Git history
- PMD static analysis performed on each revision
- Per-commit JSON reports with detailed findings
- Summary report generation including commit count, average number of Java files, average warnings, and types of warnings
- Configurable input/output paths and rulesets for flexible setup

## Update
- Remove unnecessary/redundant files
```
example-ruleset.xml
minimal-ruleset.xml
simple-ruleset.xml
ultra-minimal-ruleset.xml

DOCKER_USAGE.md
LOCAL_USAGE.md
PMD_PATH_CONFIG.md
PERFORMANCE_OPTIMIZATION.md

docker-compose.yml

requirements.txt

./output
./pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0
```
- Update the details of dockerfile

- Modify the generate_summary function in the summary_generator.py file to fix the bug where the output summary format was incorrect.

- Modify the parser.paese_args function and add the '--jvm-opts' parameter in the main.py file to explicitly allocate JVM heap memory.

- Update the details of README.md to provide a clear version

## Project Structure
(project-root) **pmd_miner**/  
├── output                         
│   ├── commits                   # Detailed analysis results per commit (JSON files)  
│   ├── logs                      # Log files  
│   └── summary.json              # Aggregated summary report  
│
├── main.py                       # Main program entry point  
├── git_analyzer.py               # Module for analyzing Git repository history  
├── pmd_runner.py                 # Module for running PMD static analysis  
├── result_processor.py           # Module for processing raw PMD results  
├── summary_generator.py          # Module for generating final summary reports  
├── requirements.txt              # Python dependencies  
├── Dockerfile                    # Docker image definition  
├── test_performance_display.py   # Test script for visualizing performance across commits  
└── README.md                     # Project documentation  

##  Installation & Execution
### Prerequisites
 - **Docker** — Installed and configured (https://www.docker.com/)
 - **PMD** — Installed and configured (https://pmd.github.io/)
 - **Python 3.7+** — Installed
 - **Git** — Installed
 - **Java 11+** — Installed

###  Installation Steps 
 **Step 1: To install Docker, please refer to the official Docker documentation**  
```
### Add Docker's official GPG key ###

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
```
```
### Add the repository to Apt sources ###

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
```
### Install the latest version ###

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```
### Check docker installation ###

sudo docker version
sudo docker run hello-world
sudo docker images
sudo docker ps -a
sudo usermod -aG docker ${USER}
docker run  --rm -d -p 8080:80 --name my-nginx nginx
```
**Step 2: Install dependencies including git, java, python**
```
sudo apt-get install git
sudo apt install -y openjdk-11-jdk
sudo apt install -y python3 python3-pip
pip install gitpython
```

 **Step 3: Environment Preparation and Check**
``` 
sudo mkdir -p /home/user/pmd_miner 
cd /home/user/pmd_miner 
ls -ld /home/user/pmd_miner 
echo $USER
sudo chown -R $USER:$USER
```

**Step 4: Update the Dockerfile to install PMD and clone the remote repository with the PMD analysis code**

```
cd /home/user/pmd_miner 
nano Dockerfile
```
```
##### Details of Dockerfile #####

# Use Python 3.9 slim image as base
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    default-jdk \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME environment variable
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH=$PATH:$JAVA_HOME/bin

# Download and install PMD including rulesets
ENV PMD_VERSION=7.15.0
RUN curl -L -o pmd.zip https://github.com/pmd/pmd/releases/download/pmd_releases%2F${PMD_VERSION}/pmd-dist-${PMD_VERSION}-bin.zip \
    && unzip pmd.zip -d /opt \
    && rm pmd.zip

# Set PMD path
ENV PMD_HOME=/opt/pmd-bin-${PMD_VERSION}
ENV PATH="$PMD_HOME/bin:$PATH"

# Clone my github 
RUN git clone https://github.com/Lbyrigitte/Repository-Mining-and-Analysis-by-PMD.git /app

# Install Python dependencies
RUN pip install --no-cache-dir \
    GitPython==3.1.40 \
    requests==2.31.0 \
    click==8.1.7 \
    tqdm==4.66.1 \
    python-dateutil==2.8.2

# Create output directory
RUN mkdir -p /app/output

# Set default command with PMD path
ENTRYPOINT ["python", "main.py"]
CMD ["--help"]
```

**Step 5: Build the docker image**
```
docker build --progress=plain -t pmd-analyzer .

### If you see a warning such as ###
[current commit information was not captured by the build: failed to read current commit information with git rev-parse --is-inside-work-tree]
### It means that the current directory is not a Git repository. This does not affect the execution of the program. ###

### To avoid it, please run ###
DOCKER_BUILDKIT=0 docker build --progress=plain -t pmd-analyzer .
```

**Step 6: Test docker container**
```
docker run -it --rm --entrypoint /bin/bash pmd-analyzer
java -version
python3 --version
pmd --version
```
**Step 7: Test the clone conditions of docker container**
```
docker run -it --rm --entrypoint /bin/bash pmd-analyzer
ls /app

### A successful clone can be confirmed if the local repository contains the same content as the remote repository. ###
```

### Execution Steps
**Step 1: Run analysis on a remote repository (Linux path example)**
```
### Outside the container ###

docker run --rm \
-v $(pwd)/output:/app/output \
pmd-analyzer \
https://github.com/apache/commons-lang.git \
--ruleset rulesets/java/quickstart.xml \
--output-dir /app/output \
--pmd-path /opt/pmd-bin-7.15.0 \
--skip-download \
--max-commits 10 \
--verbose

### If run for a long time ###
### Delete `--rm` and add `-d` to avoid task interruptions caused by screen lock/disconnection/screen crash. ###

docker run -d \
--name pmd_ana \
-v $(pwd)/output:/app/output \
pmd-analyzer \
https://github.com/apache/commons-lang.git \
--ruleset rulesets/java/quickstart.xml \
--output-dir /app/output \
--pmd-path /opt/pmd-bin-7.15.0 \
--skip-download \
--verbose

### To prevent the program from exceeding memory limits, use `--memory=20g` and `--jvm-opts="-Xmx15g"` to explicitly set the total memory and JVM heap memory.

docker run -d \
  --name pmd_ana \
  --cpus=12 \
  --memory=20g \
  -v $(pwd)/output:/app/output \
  pmd \
  --jvm-opts="-Xmx15g" \
  https://github.com/apache/commons-lang.git \
  --ruleset rulesets/java/quickstart.xml \
  --output-dir /app/output \
  --pmd-path /opt/pmd-bin-7.15.0 \
  --skip-download \
  --verbose
``` 
```
### Inside the container ###

python /app/main.py https://github.com/apache/commons-lang.git \
--ruleset /opt/pmd-bin-7.15.0/rulesets/java/quickstart.xml \
--output-dir /app/output \
--pmd-path /opt/pmd-bin-7.15.0 \
--skip-download \
--max-commits 10
```
**Step 2: Change parameters**
```
--max-commits # Set maximum commits
--ruleset # Select the official rulesets (such as quickstart.xml, bestpractices.xml, codestyle.xml, etc.)
```

**Step 3: Check the log midway**
```
docker logs -f pmd_ana
```
```
docker rm pmd_ana
```
**Step 4: Monitor resource changes in running containers**
```
docker stats pmd_ana
```
```
docker stats --no-stream pmd_ana
```
#### Docker stats numeric field
`CPU %`: CPU percentage used (single core = 100%)  
`MEM USAGE/LIMIT`: Container actual memory/maximum memory limit  
`MEM %`: The percentage of memory occupied relative to the limit  
`NET I/O`: Cumulative network input/output  
`BLOCK I/O`: Cumulative disk reads and writes to the container  
`PIDS`: Number of processes running in the container


## Output Description
**Part 1: Structure**   

├── commits/                # Detailed analysis of each commit    
│         ├── abc123.json   # Commit hash.json    
│         └── def456.json    
├── summary.json            # Summary statistics    
└── logs/                   # Log files    

 **Part 2: Commit level data (`output/commits/*.json`)**  

- Commit information (hash, author, date, message)
- Java file statistics (number, number of lines, file list)
- PMD analysis results (number of violations, detailed violation information)
- Calculation statistics (violation density, quality ratio, etc.)

 **Part 3: Summary data (`output/summary.json`)**
- Basic information of the warehouse
- Number and average statistics of Java files
- Average statistics of warnings
- Rules violation statistics
- Time trend analysis

 **View summary results**

 ` cat output/summary.json` 

**View commit details**

` ls output/commits/`  
` cat output/commits/6627f7ad.json`

 **View logs**  
` cat output/logs/*.log`
 
#### Top-level fields
- **`location`**: The repository path or URL to analyze
- **`stat_of_repository`**: Repository statistics
- **`stat_of_warnings`**: Warning statistics

#### Repository Statistics (`stat_of_repository`)

- **`number_of_commits`**: Total number of commits analyzed
- **`avg_of_num_java_files`**: Average number of Java files
- **`avg_of_num_warnings`**: Average number of warnings

#### Warning Statistics (`stat_of_warnings`): Lists total violations by rule name
- **`EmptyCatchBlock`**: Number of empty catch block violations
- **`SimplifyBooleanReturns`**: Number of Boolean return simplification violations
- **`UnusedLocalVariable`**: Number of unused local variable violations
- **`SystemPrintln`**: Number of System.out.println violations
- **`UnnecessaryReturn`**: Number of unnecessary return violations

#### Summary.json file in flat format:
```json
{
  "location": "https://github.com/apache/commons-lang.git",
  "stat_of_repository": {
    "number_of_commits": 10,
    "avg_of_num_java_files": 27.0,
    "avg_of_num_warnings": 18.7
  },
  "stat_of_warnings": {
    "EmptyCatchBlock": 99,
    "SimplifyBooleanReturns": 18,
    "UnusedLocalVariable": 70
  }
}
```

## Performance
**Target Performance**: ≤ 1 second/commit  
**Docker run**: ≤ 1 second/commit (0.6 second with quickstart.xml)

## Image management
 - View images

    `docker images static-analyzer ` 

- Delete images

    `docker rmi static-analyzer ` 


- Clean up all unused resources

    `docker system prune -a`
  
## Debug
 - Enter container debugging

`docker run -it --rm --entrypoint /bin/bash pmd-analyzer ` 

 - View files in container

`docker run --rm --entrypoint pmd-analyzer ls -la /app/  `

 - Check PMD installation

`docker run --rm --entrypoint pmd-analyzer /app/pmd/pmd-bin-7.15.0/bin/pmd --version  `

- When the computation is too large, the memory requested by the process/container may exceed the available quota, or the system may have insufficient remaining memory. In such cases, the kernel OOM Killer may terminate the process, resulting in `docker ps -a` showing `Exited (137)`. To prevent this, it is necessary to set a reasonable upper memory limit for the container and leave sufficient margin for the JVM.

- Use `--memory=20g` and `--jvm-opts="-Xmx15g"` to explicitly allocate container memory and JVM heap memory.

- Monitor memory usage with `docker stats pmd_ana` to ensure it does not approach the upper limit.

- Adjust host system configuration if necessary to provide adequate resources.

## Contributions
Welcome to submit issues and pull requests to improve this project.

## License
This project uses the MIT license.
