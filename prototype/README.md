# 在线问诊平台 - HTML可交互原型

> 本原型基于需求文档和设计规范生成，可直接在浏览器中预览和交互。

## 快速预览

### 患者端
直接打开 `patient/index.html`

### 医生端
直接打开 `doctor/index.html`

### 管理端
直接打开 `admin/dashboard.html` 或 `admin/index.html`

---

## 文件结构

```
prototype/
├── README.md
├── patient/                    # 患者端
│   ├── index.html             # 入口选择页
│   ├── login.html             # 登录页
│   ├── register.html          # 注册页
│   ├── home.html              # 首页
│   ├── search.html            # 搜索页
│   ├── doctor-list.html       # 医生列表
│   ├── doctor-detail.html     # 医生详情
│   ├── inquiry-chat.html      # 问诊聊天
│   ├── video-call.html        # 视频问诊
│   ├── prescription-list.html  # 处方列表
│   ├── prescription-detail.html # 处方详情
│   ├── order-list.html        # 订单列表
│   ├── order-detail.html      # 订单详情
│   ├── profile.html           # 个人中心
│   ├── health-record.html     # 健康档案
│   └── real-name.html         # 实名认证
├── doctor/                     # 医生端
│   ├── index.html             # 入口页
│   ├── login.html             # 登录页
│   ├── dashboard.html         # 工作台
│   ├── patient-list.html      # 患者列表
│   ├── patient-detail.html    # 患者详情
│   ├── prescription-write.html # 开具处方
│   ├── schedule.html          # 排班管理
│   └── profile.html           # 个人设置
├── admin/                      # 管理端
│   ├── index.html             # 入口页
│   ├── login.html             # 登录页
│   ├── dashboard.html         # 仪表盘
│   ├── user-management.html   # 用户管理
│   ├── doctor-management.html  # 医生管理
│   ├── order-management.html  # 订单管理
│   └── drug-management.html   # 药品管理
├── css/
│   ├── common.css             # 通用样式
│   ├── patient.css            # 患者端样式
│   ├── doctor.css             # 医生端样式
│   └── admin.css              # 管理端样式
└── js/
    ├── common.js              # 通用JS
    └── mock-data.js           # 模拟数据
```

---

## 技术说明

- 纯HTML/CSS/JS，无任何依赖
- 使用 localStorage 模拟登录状态
- CSS变量实现主题色
- 响应式设计，支持手机和PC
- 页面间通过 URL 参数传递数据

---

## 设计规范

遵循 `04_UI设计规范.md` 中的规范：

| 项目 | 值 |
|------|-----|
| 主色 | #1890FF (医疗蓝) |
| 成功色 | #52C41A |
| 警告色 | #FA8C16 |
| 错误色 | #FF4D4F |
| 基础单位 | 4px |
| 圆角 | 4px / 8px / 12px |

---

## 交互说明

### 页面跳转
- 所有按钮可点击跳转
- 使用 URL 参数传递数据（如 `doctor-detail.html?id=1001`）

### 登录模拟
- 输入任意手机号和密码即可登录
- 登录后可访问需要认证的页面

### 数据模拟
- 所有数据通过 JS 模拟
- 可在 `js/mock-data.js` 中修改

---

## 业务流程

### 患者问诊流程
1. 登录 → 首页
2. 选择科室/医生 → 医生列表
3. 查看医生详情 → 选择问诊类型
4. 填写病情描述 → 支付问诊费
5. 进入问诊 → 与医生聊天
6. 问诊结束 → 查看处方
7. 购买药品 → 订单管理

### 医生接诊流程
1. 登录 → 工作台
2. 查看待接诊 → 接诊
3. 查看患者信息 → 问诊沟通
4. 开具处方 → 结束问诊
5. 排班管理 → 设置出诊时间
