# CSS 生成图像使用指南

## 什么是 CSS 生成图像？

CSS 生成图像是完全使用 Cascading Style Sheets (CSS) 创建的图像，无需外部图片文件。它们具有以下优点：

- **加载更快**：没有额外的 HTTP 请求
- **可缩放**：矢量性质，放大不失真
- **可定制**：通过修改 CSS 轻松调整样式
- **动画效果**：可以添加丰富的动画和过渡
- **减少依赖**：无需管理外部图像文件

## 如何使用

### 在 homepage 上使用

1. 编辑 `pages.json` 文件
2. 为需要使用 CSS 图像的页面添加 `imageType` 和 `imageClass` 字段：

```json
{
    "title": "页面标题",
    "description": "页面描述",
    "file": "page.html",
    "imageType": "css",
    "imageClass": "css-image-abstract-gradient"
}
```

### 在其他 HTML 页面中直接使用

```html
<div class="css-image-abstract-gradient"></div>
```

## 可用的 CSS 图像样式

### 1. `css-image-abstract-gradient`
- 抽象渐变背景
- 适用页面：关于我们、团队介绍
- 特点：紫色渐变 + 点阵图案动画

### 2. `css-image-communication`
- 通信/联系主题
- 适用页面：联系我们、客户支持
- 特点：信封图标 + 脉冲动画

### 3. `css-image-features`
- 功能/特性展示
- 适用页面：功能介绍、产品特性
- 特点：网格布局 + 滑动动画

### 4. `css-image-add-page`
- 添加/创建主题
- 适用页面：帮助指南、添加页面教程
- 特点：加号图标 + 旋转边框动画

### 5. `css-image-tech-style`
- 科技/技术主题
- 适用页面：技术介绍、开发文档
- 特点：网格纹理 + 简洁设计

### 6. `css-image-geometric`
- 几何/抽象主题
- 适用页面：创意展示、设计页面
- 特点：锥形渐变 + 旋转动画

### 7. `css-image-minimalist`
- 极简/现代主题
- 适用页面：现代风格网站、作品集
- 特点：双层圆形设计 + 阴影效果

## 自定义 CSS 图像

您可以在 `css/generated-images.css` 文件中修改或添加新的 CSS 图像样式。以下是创建 CSS 图像的常见技术：

### 渐变背景
```css
background: linear-gradient(135deg, #color1 0%, #color2 100%);
```

### 动画效果
```css
@keyframes pulse {
    from { transform: scale(1); }
    to { transform: scale(1.1); }
}

.element {
    animation: pulse 2s ease-in-out infinite;
}
```

### 伪元素
```css
.element::before {
    content: '';
    position: absolute;
    /* 样式定义 */
}
```

### 形状和边框
```css
border-radius: 50%; /* 圆形 */
border-radius: 8px; /* 圆角 */
clip-path: polygon(0 0, 100% 0, 50% 100%); /* 三角形 */
```

## 演示页面

访问 `css-images-demo.html` 查看所有 CSS 生成图像的实时演示。

## 浏览器兼容性

CSS 生成图像使用现代 CSS 特性，支持所有现代浏览器（Chrome、Firefox、Safari、Edge）。对于旧版浏览器，系统会自动回退到传统的 placeholder 图像。