# Shell脚本使用指南 - 自动添加HTML页面到pages.json

## 功能介绍

这个Shell脚本可以自动将指定目录下的HTML文件添加到`pages.json`配置文件中，用于在项目主页上显示。

## 主要特性

- **自动检测**：自动查找目录下所有HTML文件
- **智能提取**：从HTML文件中提取标题
- **自动生成**：生成默认描述和随机CSS图像样式
- **安全检查**：避免重复添加同一文件
- **备份机制**：自动备份原始pages.json文件
- **CSS图像**：默认使用项目中的CSS生成图像系统

## 系统要求

### Linux系统
- 支持Ubuntu, CentOS, Debian等
- **jq工具**：用于处理JSON文件 (需要先安装)

### Windows系统
- Windows 10/11
- PowerShell 5.1或更高版本
- 无需额外安装工具

## 安装jq

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install jq
```

### CentOS/RHEL
```bash
sudo yum install epel-release
sudo yum install jq
```

### macOS (使用Homebrew)
```bash
brew install jq
```

## 使用方法

### Linux系统
1. **赋予脚本执行权限**
   ```bash
   chmod +x add-pages.sh
   ```

2. **运行脚本**
   ```bash
   ./add-pages.sh
   ```

### Windows系统
1. **打开PowerShell**
   - 按下 `Win + X`，选择「Windows PowerShell」或「终端」
   - 导航到项目目录：`cd D:\path\to\project`

2. **运行PowerShell脚本**
   ```powershell
   .\add-pages.ps1
   ```

3. **查看结果**
脚本将自动：
- 检测所有HTML文件
- 提取标题和生成描述
- 为每个页面分配随机CSS图像样式
- 更新pages.json文件
- 创建备份文件

## 配置选项

在脚本开头可以修改以下配置：

```bash
# 配置变量
JSON_FILE="pages.json"      # JSON配置文件路径
HTML_DIR="."                # 搜索HTML文件的目录
BACKUP_FILE="${JSON_FILE}.bak"  # 备份文件路径
```

## 跳过文件

默认情况下，脚本会跳过`index.html`文件，如果需要添加`index.html`，可以注释掉以下代码：

```bash
# 跳过index.html（如果不需要可以注释掉）
if [ "$(basename "$html_file")" == "index.html" ]; then
    continue
fi
```

## 自定义描述

脚本根据文件名生成默认描述，可以在`generate_description`函数中修改：

```bash
# 生成描述
generate_description() {
    local html_file="$1"
    local base_name=$(basename "$html_file" .html)
    # 根据文件名生成默认描述
    case "$base_name" in
        "about") echo "了解我们的项目背景、团队和目标" ;;
        "contact") echo "获取联系方式，与我们取得联系" ;;
        "features") echo "详细介绍项目的各种功能和特性" ;;
        *) echo "这是$base_name页面的描述" ;;
    esac
}
```

## 备份机制

脚本自动创建pages.json的备份文件：
- 备份文件名为：`pages.json.bak`
- 如果需要恢复，可以使用：`cp pages.json.bak pages.json`

## 输出示例

```
=== HTML文件自动添加到pages.json工具 ===
已备份pages.json到pages.json.bak

正在搜索HTML文件...

开始添加HTML文件到pages.json:
跳过: about.html 已存在于pages.json中
跳过: contact.html 已存在于pages.json中
跳过: features.html 已存在于pages.json中
跳过: add-page.html 已存在于pages.json中
跳过: css-images-demo.html 已存在于pages.json中

=== 完成！ ===
已处理6个HTML文件
可以在pages.json中查看结果
备份文件: pages.json.bak

使用CSS生成图像，您可以访问: http://localhost:8000/css-images-demo.html 查看样式
```

## 注意事项

1. 脚本会忽略隐藏目录（如`.claude`）
2. 确保有足够的权限读写文件
3. 对于大型项目，建议先测试少量文件
4. 如果HTML文件没有`<title>`标签，将使用文件名作为标题