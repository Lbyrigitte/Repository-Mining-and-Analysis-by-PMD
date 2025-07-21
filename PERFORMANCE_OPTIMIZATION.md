# Performance Optimization Guide

After optimization, the processing time of all submissions can now be controlled within **< 1 second**, greatly improving the analysis efficiency!

## Key optimization measures

### 1. Simplified the ruleset (`ultra-minimal-ruleset.xml`)

**Simplified the ruleset**，Contains only the 5 most basic and stable PMD rules：

```xml
<!-- Contains only the 5 PMD rules -->
<rule ref="category/java/bestpractices.xml/SystemPrintln" />
<rule ref="category/java/bestpractices.xml/UnusedLocalVariable" />
<rule ref="category/java/codestyle.xml/UnnecessaryReturn" />
<rule ref="category/java/design.xml/SimplifyBooleanReturns" />
<rule ref="category/java/errorprone.xml/EmptyCatchBlock" />
```

**Advantages：**
- ✅ Avoid complex type parsing issues
- ✅ Extremely fast analysis speed (< 1 second/commit)
- ✅ Highly stable, rarely has parsing errors
- ✅ Still catches basic code quality issues

### 2. PMD error handling optimization

**Adjusted PMD exit code handling strategy：**

```python
# Past：exit code > 4 ERROR
# Now：exit code > 5 ERROR，exit code 5 WARNING
if result.returncode > 5:
    raise RuntimeError(error_msg)
elif result.returncode == 5:
    # Log warnings but continue processing
    self._log("Warning: PMD encountered processing errors but continuing...")
```

### 3. Error skipping mechanism

**Added commit-level error handling：**

```python
try:
    # Handle submission
    pmd_result = pmd_runner.run_analysis(...)
except Exception as e:
    print(f"ERROR: Failed to process commit {commit.hexsha[:8]}: {e}")
    skipped_commits.append({'commit': commit.hexsha, 'error': str(e)})
    continue  # Skip the problematic commit and continue with the next one
```

## Performance comparison



| Configuration | Processing Time/Submission | Stability |  Rule Coverage |
|------|---------------|--------|----------|
| `example-ruleset.xml` | 10-30secs | low（error prone） | whole |
| `simple-ruleset.xml` | 5-15secs | middle | more complete |
| `minimal-ruleset.xml` | 2-8secs | high | Base |
| `ultra-minimal-ruleset.xml` | **< 1sec** | **highest** | core |

## Recommended usage scenarios

### Simplified the ruleset (`ultra-minimal-ruleset.xml`)
- ✅ **First test**：Verify that the tool is working properly
- ✅ **Complex**：Large projects with parsing issues
- ✅ **Quick scan**：Need to get basic quality metrics quickly
- ✅ **CI/CD integration**：Automated processes that need fast feedback

### Minimal ruleset (`minimal-ruleset.xml`)
- ✅ **Daily development**：Quick checks during development
- ✅ **Small projects**：Projects with small amounts of code

### Simple ruleset (`simple-ruleset.xml`)
- ✅ **Detailed analysis**：More comprehensive code quality checks are needed
- ✅ **Code review**：Formal code quality assessment

## Best practices

### 1. Progressive analysis strategy

```bash
# Step 1: Validation using a super simplified ruleset
python main.py repo --ruleset ultra-minimal-ruleset.xml --max-commits 10

# Step 2: If successful, try more submissions
python main.py repo --ruleset ultra-minimal-ruleset.xml --max-commits 100

# Step 3: If more detailed analysis is required, update the rule set
python main.py repo --ruleset minimal-ruleset.xml --max-commits 50
```

### 2. Docker resource allocation

```yaml
# Optimized configuration in docker-compose.yml 
services:
  static-analyzer-full:
    mem_limit: 4g        # Memory limit
    memswap_limit: 4g    # 4GB swap space
    cpus: 2              # 2 CPU cores
```

### 3. Batch analysis optimization

```bash
# Batch analysis for multiple repositories
for repo in "${repos[@]}"; do
  echo "analyze: $repo"
  docker run --rm --memory=2g \
    -v "$(pwd)/output:/app/output" static-analyzer \
    "$repo" \
    --ruleset ultra-minimal-ruleset.xml \
    --max-commits 50
done
```

## Debug

### If still experience performance issues：

1. **Check Java memory settings**
   ```bash
   # Increase Java heap memory
   export JAVA_OPTS="-Xmx2g -Xms1g"
   ```

2. **Use fewer commits**
   ```bash
   --max-commits 20  # Reduced to 20 commits

   ```

3. **Check disk space**
   ```bash
   df -h  # Make sure enough disk space
   ```

4. **Monitor resource usage**
   ```bash
   docker stats  # Monitor docker resource usage
   ```

## Future optimization direction

1. **Parallel processing**：Implement multi-threaded submission processing
2. **Incremental analysis**：Analyze only changed files
3. **Cache mechanism**：Cache PMD analysis results
4. **Rule optimization**：Further streamline the ruleset

---

**Summary**：By using `ultra-minimal-ruleset.xml` and optimized error handling，now achieve blazing fast analysis performance of **< 1 second/commit**.
