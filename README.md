# 前端自动导航项目

这是一个基于前端技术构建的自动导航项目，通过读取 JSON 配置文件自动生成所有页面的导航卡片。

## 项目特点

### 核心功能
- **自动页面索引**：系统读取 `pages.json` 配置文件，自动生成所有页面的导航卡片
- **响应式设计**：适配各种设备屏幕尺寸（手机、平板、桌面）
- **易于扩展**：添加新页面只需修改 JSON 配置文件
- **安全防护**：实现多种安全措施防止常见攻击

### 安全特性
1. **XSS 防护**：所有内容进行 HTML 转义处理
2. **内容安全策略 (CSP)**：限制资源加载来源
3. **点击劫持防护**：`X-Frame-Options: DENY`
4. **内容类型嗅探防护**：`X-Content-Type-Options: nosniff`
5. **XSS 过滤**：`X-XSS-Protection: 1; mode=block`

## 项目结构

```
├── index.html        # 主页 - 自动生成导航卡片
├── pages.json        # 页面配置文件 - 列出所有页面信息
├── about.html        # 示例页面：关于我们
├── contact.html      # 示例页面：联系我们
├── features.html     # 示例页面：功能介绍
├── add-page.html     # 帮助页面：如何添加新页面
└── README.md         # 项目说明文档
```

## 使用方法

### 访问项目
将项目部署到服务器后，通过访问 `index.html` 即可看到所有页面的导航卡片。

### 添加新页面

1. **创建 HTML 文件**：
   ```html
   <!DOCTYPE html>
   <html lang="zh-CN">
   <head>
       <meta charset="UTF-8">
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <!-- 安全头部 -->
       <meta http-equiv="Content-Security-Policy" content="default-src 'self';">
       <meta http-equiv="X-XSS-Protection" content="1; mode=block">
       <meta http-equiv="X-Frame-Options" content="DENY">
       <meta http-equiv="X-Content-Type-Options" content="nosniff">

       <title>新页面</title>
       <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.5.3/css/bootstrap.min.css">
   </head>
   <body>
       <div class="container mt-4">
           <h1>新页面</h1>
           <p>页面内容</p>
           <a href="index.html" class="btn btn-primary">返回主页</a>
       </div>
   </body>
   </html>
   ```

2. **更新 pages.json**：
   ```json
   [
       {
           "title": "新页面",
           "description": "新页面的简短描述",
           "file": "new-page.html",
           "image": "https://via.placeholder.com/400x200?text=New+Page"
       }
   ]
   ```

### 自定义样式
可以通过修改 `index.html` 中的 CSS 样式来自定义卡片外观和整体布局。

## 部署建议

1. **使用 HTTPS**：确保通过 HTTPS 协议访问网站
2. **服务器配置**：
   - 启用 CSP 头部
   - 设置安全的响应头
   - 限制文件访问权限
3. **定期更新**：保持依赖库和框架的最新版本

## 技术栈

- **HTML5**：页面结构
- **CSS3**：样式设计
- **JavaScript (ES6+)**：交互逻辑
- **Bootstrap 4**：UI 框架（CDN）

## 浏览器兼容性

支持所有现代浏览器：
- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## 许可证

MIT License
