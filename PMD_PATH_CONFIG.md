# PMD path configuration instruction

## PMD installation location

PMD 7.15.0 installation package is located in:
```
/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0\
```

## Usage

### Local

use the `--pmd-path` to get the pmd path:

```bash
python main.py <repository> --ruleset simple-ruleset.xml --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0"
```

### Docker run

PMD is included in Docker image ：

```bash
docker run --rm -v "/home/user/pmd_miner/output:/app/output" static-analyzer \
  <repository> \
  --ruleset minimal-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --max-commits 10
```

## path configuration

### Linux path format

- **Absolute path(AP)**: `/path/to/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0`
- **Relative path(RP)**: `./pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0`

## Verify the intallation of PMD

### local verification

```bash

# Linux
./pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0/bin/pmd --version
```

### Docker verificatiin
```bash
docker run --rm static-analyzer /app/pmd/pmd-bin-7.15.0/bin/pmd --version
```

## Configuration example


```bash
# Local - Analyze Remote  Repository
python main.py https://github.com/apache/commons-lang.git \
  --ruleset simple-ruleset.xml \
  --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0" \
  --max-commits 50 \
  --output-dir ./analysis-results \
  --verbose

# Local - Analyze Local  Repository
python main.py "/home/user/pmd_miner/local-repo" \
  --ruleset minimal-ruleset.xml \
  --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0" \
  --verbose

# Docker Run - remote repositories
docker run --rm -v "$(pwd)/output:/app/output" static-analyzer \
  https://github.com/apache/commons-lang.git \
  --ruleset minimal-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --max-commits 20 \
  --verbose

# Docker run - Analyze Local  Repository
docker run --rm \
-v "/home/user/pmd_miner/local-repo:/app/repo:ro" \  
-v "/home/user/pmd_miner/output:/app/output" \  
static-analyzer \ 
  /app/repo \
  --ruleset simple-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --verbose
```

## Notes

1. **Path separator**: Windows:`\`，Linux/Mac: `/`
2. **Quote**: Paths containing spaces need to be enclosed in quotation marks
3. **Permissions**: The PMD binary file has execution permissions
4. **Java ENvironment**: PMD needs Java 11+

## Trouble removal

### Common fault 

1. **Path not found**
   ```
   Fault: PMD binary not found at specified path
   Solution: check PMD path
   ```

2. **Permissions**
   ```
   Fault: Permission denied
   Solution: Make sure the PMD binary file has execution permissions
   ```

3. **Java version**
   ```
   Fault: Java version not supported
   Solution: Make sure to install Java 11+
   ```

## Relevant files

- [LOCAL_USAGE.md](LOCAL_USAGE.md) - Local run detailed guide
- [DOCKER_USAGE.md](DOCKER_USAGE.md) - Docker run detailed guide
- [README.md](README.md) - Project ovrview
