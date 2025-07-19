# PMD路径配置说明

## 📁 当前PMD安装位置

本项目已包含PMD 7.15.0安装包，位于：
```
e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0\
```

## 🚀 使用方法

### 本地运行

使用 `--pmd-path` 参数指定PMD路径：

```bash
python main.py <repository> --ruleset simple-ruleset.xml --pmd-path "e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0"
```

### Docker运行

Docker镜像已包含PMD，无需额外配置：

```bash
docker run --rm -v "e:\jiedan\编程测试\output:/app/output" static-analyzer \
  <repository> \
  --ruleset minimal-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --max-commits 10
```

## ⚙️ 路径配置

### Windows路径格式

- **绝对路径**: `e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0`
- **相对路径**: `.\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0`

### Linux/Mac路径格式

如果在Linux/Mac环境下使用，路径格式为：
- **绝对路径**: `/path/to/pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0`
- **相对路径**: `./pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0`

## 🔧 验证PMD安装

### 本地验证

```bash
# Windows
"e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0\bin\pmd.bat" --version

# Linux/Mac
./pmd/pmd-dist-7.15.0-bin/pmd-bin-7.15.0/bin/pmd --version
```

### Docker验证

```bash
docker run --rm static-analyzer /app/pmd/pmd-bin-7.15.0/bin/pmd --version
```

## 📝 配置示例

### 完整命令示例

```bash
# 本地运行 - 分析远程仓库
python main.py https://github.com/apache/commons-lang.git \
  --ruleset simple-ruleset.xml \
  --pmd-path "e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0" \
  --max-commits 50 \
  --output-dir ./analysis-results \
  --verbose

# 本地运行 - 分析本地仓库
python main.py "C:\path\to\local\java\project" \
  --ruleset minimal-ruleset.xml \
  --pmd-path "e:\jiedan\编程测试\pmd\pmd-dist-7.15.0-bin\pmd-bin-7.15.0" \
  --verbose

# Docker运行 - 分析远程仓库
docker run --rm -v "e:\jiedan\编程测试\output:/app/output" static-analyzer \
  https://github.com/apache/commons-lang.git \
  --ruleset minimal-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --max-commits 20 \
  --verbose

# Docker运行 - 分析本地仓库
docker run --rm \
  -v "e:\jiedan\编程测试\local-repo:/app/repo:ro" \
  -v "e:\jiedan\编程测试\output:/app/output" \
  static-analyzer \
  /app/repo \
  --ruleset simple-ruleset.xml \
  --pmd-path /app/pmd/pmd-bin-7.15.0 \
  --verbose
```

## ⚠️ 注意事项

1. **路径分隔符**: Windows使用反斜杠 `\`，Linux/Mac使用正斜杠 `/`
2. **引号**: 包含空格的路径需要用引号包围
3. **权限**: 确保PMD二进制文件有执行权限
4. **Java环境**: PMD需要Java 11+运行环境

## 🛠️ 故障排除

### 常见错误

1. **路径不存在**
   ```
   错误: PMD binary not found at specified path
   解决: 检查PMD路径是否正确
   ```

2. **权限问题**
   ```
   错误: Permission denied
   解决: 确保PMD二进制文件有执行权限
   ```

3. **Java版本问题**
   ```
   错误: Java version not supported
   解决: 确保安装Java 11+
   ```

## 📖 相关文档

- [LOCAL_USAGE.md](LOCAL_USAGE.md) - 本地运行详细指南
- [DOCKER_USAGE.md](DOCKER_USAGE.md) - Docker运行详细指南
- [README.md](README.md) - 项目总览
