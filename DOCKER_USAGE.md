# Docker Running Usage

 ##  System requirements
 - **docker** installed
 - **docker-compose** installed

## Environment Check

 1. Docker version `docker --version`

 2. Docker compose version

     `docker-compose --version`

 3.   Build the image

     docker build --progress=plain -t static-analyzer .


## Configuration options

### Docker Compose configuration

 **- Remote repository configuration (`docker-compose.yml`)**
```yaml  
#name: static-analysis-project  
  
services:  
static-analyzer:  
build: .  
container_name: static-analyzer  
volumes:  
 - ./output:/app/output  
command: [  
"https://github.com/apache/commons-lang.git",  
"--ruleset", "minimal-ruleset.xml",  
"--pmd-path", "/app/pmd/pmd-bin-7.15.0",  
"--max-commits", "20",  
"--verbose"  
]  
```

 ## Run
 
 **1. Direct use Docker run**
 **Analyze remote repositories：**
```
 docker run --rm -v "$(pwd)/output:/app/output" static-analyzer \  
    https://github.com/apache/commons-lang.git \  
    --ruleset minimal-ruleset.xml \  
    --pmd-path /app/pmd/pmd-bin-7.15.0 \  
    --max-commits 10 \  
    --verbose
```
   
 **Analyze local repositories：**
```
docker run --rm \  
-v "/home/user/pmd_miner/local-repo:/app/repo:ro" \  
-v "/home/user/pmd_miner/output:/app/output" \  
static-analyzer \  
/app/repo \  
--ruleset simple-ruleset.xml \  
--pmd-path /app/pmd/pmd-bin-7.15.0 \  
--verbose  
```

 **2. Using docker-compose (remote repository)**

**Fast test for 20:**

  `  docker-compose up static-analyzer`

**Full Analysis**


    docker-compose --profile full up static-analyzer-full

or

    docker compose --profile full run --rm static-analyzer-full



 **3. Run in the background**

    docker-compose up -d static-analyzer  
**4.View the results**

 - **View summary results**

  ` cat output/summary.json` 

 - **View commit details**

` ls output/commits/`

 - **View logs**

` cat output/logs/*.log`



## Ruleset selection

| Rule set | Number of rules | Analysis speed | Applicable scenarios |
|--------|----------|----------|----------|
|`ultra-minimal-ruleset.xml`|5|Fastest|Performance optimization|
| `minimal-ruleset.xml` | 8 | Fast | Quick test |
| `simple-ruleset.xml` | ~100 | Medium | Daily analysis |
| `example-ruleset.xml` | ~200 | Slow | Detailed analysis

## Output description
### Structure
output/
├── commits/ # Detailed analysis of each commit
│         ├── abc123.json # Commit hash.json
│         └── def456.json
├── summary.json # Summary statistics
└── logs/ # Log files

## Container Management

 - View running status

    `docker-compose ps`

 - View logs

    `docker-compose logs static-analyzer`

 - View logs in real time
 
   `docker-compose logs -f static-analyzer`

 - Stop service

    `docker-compose down`

 - Stop and delete volume

   `docker-compose down -v`

## Image management

 - View images

    `docker images static-analyzer ` 

  

 - rebuild images

    `docker-compose build --no-cache ` 

  

 - delete images

    `docker rmi static-analyzer ` 

  

 - Clean up all unused resources

    `docker system prune -a`

  
## Debug

 - Enter container debugging

`docker run -it --rm static-analyzer /bin/bash ` 
  

 - View files in container

`docker run --rm static-analyzer ls -la /app/  `
  

 - Check PMD installation

`docker run --rm static-analyzer /app/pmd/pmd-bin-7.15.0/bin/pmd --version  `

## Performance reference

- **Docker version performance**: about 3-6 seconds/commit
- **Complete environment**: Java + PMD + Python + Git
- **Image size**: about 898MB
- **Memory usage**: 2-4GB is recommended

## Performance optimization
### Allocate more resources

    docker run --memory=4g --cpus=2 --rm \  
    -v "$(pwd)/output:/app/output" static-analyzer \  
    https://github.com/apache/commons-lang.git \  
    --ruleset minimal-ruleset.xml \  
    --pmd-path /app/pmd/pmd-bin-7.15.0 \  
    --max-commits 10 \  
    --verbose

### Use minimal ruleset

    docker run --rm -v "$(pwd)/output:/app/output" static-analyzer \  
    repo-url --ruleset ultra-minimal-ruleset.xml --max-commits 50

### Create batch analysis script

    repos=(  
    "https://github.com/apache/commons-lang.git"  
    "https://github.com/apache/commons-io.git"  
    )  
      
    for repo in "${repos[@]}"; do  
    echo "分析: $repo"  
    docker run --rm -v "/home/user/pmd_miner/app/output" static-analyzer \  
    "$repo" \  
    --ruleset minimal-ruleset.xml \  
    --pmd-path /app/pmd/pmd-bin-7.15.0 \  
    --max-commits 20  
    done

