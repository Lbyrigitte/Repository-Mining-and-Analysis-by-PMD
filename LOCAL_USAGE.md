# Local Running Usage


 ##  System requirements
 - **Python 3.7+** installed
 - **Git** installed
 - **java 11+** installed

##  Environment Preparation

 **- Check Python Version**
 `python3 --version`

 **- Check Java Version** 
 `java -version`

 **- Check Git Version**
 `git --version`

 **- Use virtual environments** to avoid new security mechanisms introduced in Ubuntu 23+ / Debian Bookworm+ ** 

 **- Execute in  pmd_miner directoryn**

```
    cd /home/user/pmd_miner
    sudo apt install python3-venv
    python3 -m venv venv

    source venv/bin/activate
```
 **- Install Dependencies**

    `pip install -r requirements.txt`

 **- View ，Modify and Check permissions**
```
     ls -l /home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0/bin/pmd
     
     chmod +x /home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0/bin/pmd
     
     /home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0/bin/pmd --version

```
## Run

 ###  Analyze Remote  Repository

 **1. Fast test for 10 commits**
    `python main.py https://github.com/apache/commons-lang.git --ruleset simple-ruleset.xml --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0" --max-commits 10 `
 
 **2.Standard analyze for 100 commits**

     `python main.py https://github.com/apache/commons-lang.git --ruleset simple-ruleset.xml --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0" --max-commits 100 `

**3.Formal analysis**
Delete the"--max-commits":

    `python main.py https://github.com/apache/commons-lang.git --ruleset simple-ruleset.xml --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0" `



 ###  Analyze Local  Repository

    `python main.py /home/user/pmd_miner/local-repo --ruleset simple-ruleset.xml --pmd-path "/home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0"`

 **- Use an existing PMD installation** (recommended, improves performance)

    `python main.py /path/to/repo --ruleset simple-ruleset.xml --pmd-path "  /home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0"`

 ###  View the results
```
    ls ./analysis-results/
    cat ./analysis-results/summary.json
```
## Common parameters
| Parameters |Description   |Example  |
|--|--|--|
|`--output-dir`  |Output directory  | `--output-dir ./results`  |
| `--max-commits` | Limit number of submissions | `--max-commits 100` |
|  `--verbose`|  Detailed output| `--verbose` |
| `--pmd-path` | PMD installation path | `--pmd-path "  /home/user/pmd_miner/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0"` |

## Ruleset selection

| Rule set | Number of rules | Analysis speed | Applicable scenarios |
|--------|----------|----------|----------|
|`ultra-minimal-ruleset.xml`|5|Fastest|Complex item,Analyze the problem,Performance optimization|
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

### Each submitted JSON file contains:

- **commit**: basic information of the submission (hash, author, date, message)
- **java_files**: Java file statistics (number, total number of lines, file list)
- **pmd_analysis**: PMD analysis results (number of violations, violation details)
- **statistics**: calculation statistics (violation density, file quality ratio, etc.)

###   Summary file format
summary.json contains:

- **repository**: repository information
- **java_files**: average statistics of Java files
- **warnings**: average statistics of warnings
- **rule_statistics**: statistics of violations of each rule
- **temporal_trends**: time trend analysis


## Common Errors

1. **Java not found**

Error: Java is not available or not in PATH

Solution: Install Java 11+ and make sure it is in PATH
2. **PMD download failed**

Error: Failed to download PMD

Solution: Use --pmd-path to specify an existing PMD installation


3. **Git repository access failed**

Error: Repository path does not exist

Solution: Check if the repository path or URL is correct


4. **Permission error**
Error: Permission denied

Solution: Make sure the output directory has write permission. For example:

   ` sudo chmod u+rw /home/user/pmd_miner/output/summary.json`

## Debug
Use the `--verbose` parameter to get detailed information:

   `python main.py repo --ruleset simple-ruleset.xml --verbose`

## Performance Reference
- **Target Performance**: ≤1 second/submit
- **After optimization**: ≤1 second/submit (using existing PMD + simplified ruleset)
- **Ultra-Simplified Ruleset**: **< 1 sec/submit**  (ultra-minimal-ruleset.xml)
- **Minimal Ruleset**: ~2-5 sec/submit (minimal-ruleset.xml)
- **Standard Ruleset**: ~5-15 sec/submit (simple-ruleset.xml)
- **Full Ruleset**: ~10-30 sec/submit (example-ruleset.xml)

