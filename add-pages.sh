#!/bin/bash

# 自动将HTML文件添加到pages.json的Shell脚本
# 适用于Linux系统

# 配置变量
JSON_FILE="pages.json"
HTML_DIR="."  # 搜索HTML文件的目录
BACKUP_FILE="${JSON_FILE}.bak"

# 检查jq工具是否安装 (jq用于处理JSON)
check_jq() {
    if ! command -v jq &> /dev/null; then
        echo "错误: 未安装jq工具。请先安装jq: sudo apt-get install jq 或 sudo yum install jq"
        exit 1
    fi
}

# 创建pages.json如果不存在
create_json_if_not_exists() {
    if [ ! -f "$JSON_FILE" ]; then
        echo "[]" > "$JSON_FILE"
        echo "已创建空的pages.json文件"
    fi
}

# 备份pages.json
backup_json() {
    cp "$JSON_FILE" "$BACKUP_FILE"
    echo "已备份pages.json到$BACKUP_FILE"
}

# 提取HTML标题
extract_title() {
    local html_file="$1"
    # 使用sed提取<title>标签内容
    local title=$(sed -n 's/.*<title>\(.*\)<\/title>.*/\1/p' "$html_file" | head -1)
    # 如果没有title标签，使用文件名
    if [ -z "$title" ]; then
        title=$(basename "$html_file" .html)
        title=$(echo "$title" | tr '-' ' ' | tr '_' ' ')
        title=$(echo "$title" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
    fi
    echo "$title"
}

# 生成描述
generate_description() {
    local html_file="$1"
    local base_name=$(basename "$html_file" .html)
    # 根据文件名生成默认描述
    case "$base_name" in
        "about") echo "了解我们的项目背景、团队和目标" ;;
        "contact") echo "获取联系方式，与我们取得联系" ;;
        "features") echo "详细介绍项目的各种功能和特性" ;;
        "index") echo "项目主页" ;;
        *) echo "这是$base_name页面的描述" ;;
    esac
}

# 生成随机CSS图像类
generate_css_image() {
    local css_classes=(
        "css-image-abstract-gradient"
        "css-image-communication"
        "css-image-features"
        "css-image-add-page"
        "css-image-tech-style"
        "css-image-geometric"
        "css-image-minimalist"
    )
    local random_index=$((RANDOM % ${#css_classes[@]}))
    echo "${css_classes[$random_index]}"
}

# 添加HTML文件到pages.json
add_html_to_json() {
    local html_file="$1"
    local file_name=$(basename "$html_file")

    # 检查文件是否已存在于pages.json中
    local exists=$(jq -r --arg file "$file_name" '.[] | select(.file == $file) | .file' "$JSON_FILE")

    if [ -n "$exists" ]; then
        echo "跳过: $file_name 已存在于pages.json中"
        return
    fi

    # 提取信息
    local title=$(extract_title "$html_file")
    local description=$(generate_description "$html_file")
    local css_class=$(generate_css_image)
    local placeholder="https://via.placeholder.com/400x200?text=$(echo "$title" | tr ' ' '+')"

    # 构建新页面JSON对象
    local new_page=$(jq -n --arg title "$title" --arg desc "$description" --arg file "$file_name" --arg css "$css_class" --arg placeholder "$placeholder" \
        '{
            title: $title,
            description: $desc,
            file: $file,
            imageType: "css",
            imageClass: $css,
            image: $placeholder
        }')

    # 添加到pages.json
    local temp_file=$(mktemp)
    jq --argjson new_page "$new_page" '. + [$new_page]' "$JSON_FILE" > "$temp_file"
    mv "$temp_file" "$JSON_FILE"

    echo "已添加: $file_name -> $title"
}

# 主程序
main() {
    echo "=== HTML文件自动添加到pages.json工具 ==="

    # 检查jq
    check_jq

    # 创建pages.json（如果不存在）
    create_json_if_not_exists

    # 备份
    backup_json

    # 寻找所有HTML文件
    echo -e "\n正在搜索HTML文件..."
    local html_files=($(find "$HTML_DIR" -name "*.html" -type f | grep -v ".claude" | sort))

    if [ ${#html_files[@]} -eq 0 ]; then
        echo "未找到HTML文件"
        exit 0
    fi

    # 添加每个HTML文件
    echo -e "\n开始添加HTML文件到pages.json:"
    for html_file in "${html_files[@]}"; do
        # 跳过index.html（如果不需要可以注释掉）
        if [ "$(basename "$html_file")" == "index.html" ]; then
            continue
        fi
        add_html_to_json "$html_file"
    done

    # 提示完成
    echo -e "\n=== 完成！ ==="
    echo "已处理${#html_files[@]}个HTML文件"
    echo "可以在$JSON_FILE中查看结果"
    echo "备份文件: $BACKUP_FILE"
    echo -e "\n使用CSS生成图像，您可以访问: http://localhost:8000/css-images-demo.html 查看样式"
}

# 执行主程序
main