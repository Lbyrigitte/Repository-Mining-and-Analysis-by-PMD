
# Repository Mining and Analysis by PMD

## Introduction

This's a program running on [Docker](https://www.docker.com/), which performs static analysis on each commit of a  selected Java Git repository using [PMD](https://pmd.github.io/) , and generates per-commit JSON reports along with a final summary report for software repository mining purposes.

## Core functionalities

- Support local and remote Git repositories 

- Docker containerization support

-   Traverse Git history commit-by-commit
    
-   Run PMD static analysis on each revision
    
-   Output per-commit results as JSON files
    
-   Generate a summary report showing commit count, average number of Java files, average warnings, and warning types
 
-  Configurable input/output paths and ruleset



## Project Structure
 (project-root)**pmd_miner**/
├── main.py # Main program entry
├── git_analyzer.py # Git repository analysis module
├── pmd_runner.py # PMD execution module
├── result_processor.py # Result processing module
├── summary_generator.py # Summary generation module
├── requirements.txt # Python dependencies
├── *.xml # PMD rule set file
├── Dockerfile # Docker image definition
├── docker-compose.yml # Remote repository analysis configuration
├── LOCAL_USAGE.md # Local operation guide
├── README.md         # This file
└── DOCKER_USAGE.md # Docker operation guide
 
## Usage Instructions or Examples

Will be detailed in the section below.


##  Installation & Execution

### Prerequisites

 - **Docker** installed and configured(https://www.docker.com/)
 - **PMD** installed and configured: [https://pmd.github.io/](https://pmd.github.io/)
 - **Python 3.7+** installed
 - **Git** installed
 - **java 11+** installed

###  Installation Steps 

 **1. **To install Docker, follow the official documentation:**
 (**Add Docker's official GPG key**:)**

     bash sudo apt-get update
        sudo apt-get install ca-certificates curl
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc

( **Add the repository to Apt sources**:)

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

(**To install the latest version, run**:)

     bash sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

(**Check docker installation**)

    bash sudo docker version
         sudo docker run hello-world
         sudo docker images
         sudo docker ps -a
         sudo usermod -aG docker ${USER}
         docker run  --rm -d -p 8080:80 --name my-nginx nginx

**2. Install dependencies including git, java, python**

    bash sudo apt-get install git
         sudo apt install -y openjdk-11-jdk
         sudo apt install -y python3 python3-pip
         pip install gitpython
 
 **3. Environment Preparation and Check**

    bash sudo mkdir -p /home/user/pmd_miner 
                cd /home/user/pmd_miner 
                ls -ld /home/user/pmd_miner 
               echo $USER
                 sudo chown -R $USER:$USER       

**4. Modify *Dockerfile* (including PMD installatin inside)**

    bash cd /home/user/pmd_miner 
                 nano Dockerfile
    
The *Dockerfile* :

    # Use Python 3.9 slim image as base  
    FROM python:3.9-slim  
      
    # Set working directory  
    WORKDIR /app  
      
    # Install system dependencies  
    RUN apt-get update &amp;&amp; apt-get install -y \  
    git \  
    wget \  
    unzip \  
    default-jdk \  
    curl \  
    &amp;&amp; rm -rf /var/lib/apt/lists/*  
      
    # Set JAVA_HOME environment variable  
    ENV JAVA_HOME=/usr/lib/jvm/default-java  
    ENV PATH=$PATH:$JAVA_HOME/bin  
      
    # Copy local PMD installation  
    COPY pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0 /app/pmd/pmd-bin-7.15.0  
      
    # Set PMD permissions and path  
    RUN chmod +x /app/pmd/pmd-bin-7.15.0/bin/pmd &amp;&amp; \  
    chmod +x /app/pmd/pmd-bin-7.15.0/bin/pmd.bat  
      
    # Set PMD path  
    ENV PMD_HOME=/app/pmd/pmd-bin-7.15.0  
    ENV PATH=$PATH:$PMD_HOME/bin  
      
    # Copy requirements file  
    COPY requirements.txt .  
      
    # Install Python dependencies  
    RUN pip install --no-cache-dir -r requirements.txt  
      
    # Copy application code  
    COPY *.py ./  
    COPY *.xml ./  
      
    # Create output directory  
    RUN mkdir -p /app/output  
      
    # Set default command with PMD path  
    ENTRYPOINT ["python", "main.py"]  
    CMD ["--help"]
    

**5. Build *requirements.txt*  in the same directory as Dockerfile**
The *requirements.txt* :

    GitPython==3.1.40  
    requests==2.31.0  
    click==8.1.7  
    tqdm==4.66.1  
    python-dateutil==2.8.2

 **6. Build the docker image**

    bash docker build --progress=plain -t static-analyzer .
**7. Test docker container**

    bash docker run -it pmd_miner /bin/bash 
         java -version
         python3 --version
         pmd -version

### Execution

 **1.  Select the running mode**
       
 - **Local running**: Run directly in the local environment → See [LOCAL_USAGE.md](LOCAL_USAGE.md)
 
 - **Docker running**: Run using a Docker container→ See [DOCKER_USAGE.md](DOCKER_USAGE.md)

 
**2. Run locally (fast, but supposed to follow [DOCKER_USAGE.md](DOCKER_USAGE.md))**

    bash
    # 1. Install dependencies
    pip install -r requirements.txt
    
    # 2. Run analysis
    python main.py https://github.com/apache/commons-lang.git \
    --ruleset minimal-ruleset.xml \
    --max-commits 10 \
    --verbose

 **3. Docker run (recommended, supposed to follow [DOCKER_USAGE.md](DOCKER_USAGE.md))**

    # 1. Build image
    docker build –progress=plain -t static-analyzer .
    
    # 2. Run analysis (Linux path example)
    
    docker run --rm -v "$(pwd)/output:/app/output" static-analyzer \  
    https://github.com/apache/commons-lang.git \  
    --ruleset minimal-ruleset.xml \  
    --pmd-path /app/pmd/pmd-bin-7.15.0 \  
    --max-commits 10 \  
    --verbose

### Output

 **1. Output Format**

 Commit level data (`output/commits/*.json`)
- Commit information (hash, author, date, message)
- Java file statistics (number, number of lines, file list)
- PMD analysis results (number of violations, detailed violation information)
- Calculation statistics (violation density, quality ratio, etc.)

 ****2. Summary data (`output/summary.json`)**
- Basic information of the warehouse
- Number and average statistics of Java files
- Average statistics of warnings
- Rules violation statistics
- Time trend analysis
 
 **3. Ruleset selection**

| Rule set | Number of rules | Analysis speed | Applicable scenarios |
|--------|----------|----------|----------|
| `minimal-ruleset.xml` | 8 | Fastest | Quick test |
| `simple-ruleset.xml` | ~100 | Medium | Daily analysis |
| `example-ruleset.xml` | ~200 | Slow | Detailed analysis

 **4. Detailed documentation**

- **[LOCAL_USAGE.md](LOCAL_USAGE.md)** - Complete guide for running locally
- **[DOCKER_USAGE.md](DOCKER_USAGE.md)** - Complete guide for running Docker
- **[PMD_PATH_CONFIG.md](PMD_PATH_CONFIG.md)** - PMD path configuration instructions



**5. Performance**

- **Local run**: about 10-15 seconds/commit
- **Docker run**: about 3-6 seconds/commit
- **After optimization**: about 2-5 seconds/commit (using existing PMD + simplified ruleset)




###


