# 在线问诊平台 - API接口设计文档

> **文档版本**: v1.1
> **创建日期**: 2026-05-10
> **作者**: 架构设计团队
> **状态**: 已修订

---

## 修订记录

| 版本 | 日期 | 变更说明 |
|-----|------|---------|
| v1.0 | 2026-05-10 | 初始版本 |
| v1.1 | 2026-05-10 | 新增预约模块API、药师端API、客服模块API、大屏数据API、消息通知API |
| v1.2 | 2026-05-10 | 修正章节编号；修正URL规范中的双斜杠错误 |

---

## 1. API设计规范

### 1.1 接口规范

```
┌─────────────────────────────────────────────────────────────────────┐
│                        API 基础规范                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  协议:     HTTPS                                                    │
│  编码:     UTF-8                                                    │
│  格式:     JSON                                                     │
│  认证:     Bearer Token (JWT)                                       │
│  版本:     URL路径版本 /api/v1/                                     │
│  时间戳:   Unix时间戳(秒)                                           │
│  命名:     小写下划线 (snake_case)                                  │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.2 URL 设计规范

```
┌─────────────────────────────────────────────────────────────────────┐
│                        URL 命名规范                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  资源命名:  复数名词，小写，单数特殊情况除外                          │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  GET    /api/v1/users              # 获取用户列表            │    │
│  │  GET    /api/v1/users/{id}         # 获取单个用户            │    │
│  │  POST   /api/v1/users              # 创建用户                │    │
│  │  PUT    /api/v1/users/{id}         # 更新用户                │    │
│  │  DELETE /api/v1/users/{id}         # 删除用户                │    │
│  │  PATCH  /api/v1/users/{id}         # 部分更新用户            │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  嵌套资源:  不超过2层                                                │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  GET    /api/v1/users/{id}/addresses       # 获取用户地址    │    │
│  │  GET    /api/v1/users/{id}/orders         # 获取用户订单    │    │
│  │  POST   /api/v1/users/{id}/addresses       # 添加用户地址    │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  动作命名:  动词作为查询参数或路径                                    │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  POST   /api/v1/inquiries/{id}/cancel      # 取消问诊       │    │
│  │  POST   /api/v1/inquiries/{id}/complete    # 完成问诊       │    │
│  │  POST   /api/v1/orders/{id}/refund         # 申请退款       │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.3 HTTP 方法语义

| 方法 | 语义 | 幂等性 | 安全性 | 用途 |
|-----|------|-------|-------|------|
| GET | 读取资源 | 是 | 是 | 查询数据 |
| POST | 创建资源 | 否 | 否 | 新增数据 |
| PUT | 完整替换 | 是 | 否 | 全量更新 |
| PATCH | 部分更新 | 否 | 否 | 增量更新 |
| DELETE | 删除资源 | 是 | 否 | 删除数据 |

---

## 2. 通用请求响应规范

### 2.1 请求头规范

```
┌─────────────────────────────────────────────────────────────────────┐
│                        通用请求头                                    │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  Content-Type:          application/json                             │
│  Authorization:         Bearer {token}                               │
│  X-App-Version:        1.0.0                                        │
│  X-Device-Type:        ios / android / web / h5 / miniapp            │
│  X-Device-Id:         设备唯一标识                                   │
│  X-Request-Id:         UUID 请求追踪ID                               │
│  X-Timestamp:          Unix时间戳(秒)                                │
│  X-Nonce:              随机字符串(防重放)                             │
│  X-Signature:          请求签名(安全接口)                             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 成功响应格式

```json
// 单个资源
{
    "code": 200,
    "message": "success",
    "data": {
        "id": 10001,
        "name": "张三",
        "phone": "138****8000"
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123def456"
}

// 资源列表
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {"id": 1, "name": "张三"},
            {"id": 2, "name": "李四"}
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 100,
            "totalPages": 5,
            "hasNext": true,
            "hasPrev": false
        }
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123def456"
}
```

### 2.3 错误响应格式

```json
// 通用错误
{
    "code": 400,
    "message": "请求参数错误",
    "error": {
        "code": "INVALID_PARAMETER",
        "field": "phone",
        "reason": "手机号格式不正确"
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123def456"
}

// 业务错误
{
    "code": 422,
    "message": "医生不在线，无法接诊",
    "error": {
        "code": "DOCTOR_OFFLINE",
        "reason": "DOCTOR_OFFLINE",
        "detail": "该医生当前不在线，请选择其他医生"
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123def456"
}

// 表单错误
{
    "code": 422,
    "message": "表单验证失败",
    "error": {
        "code": "VALIDATION_ERROR",
        "fields": [
            {"field": "phone", "message": "手机号不能为空"},
            {"field": "password", "message": "密码长度至少6位"}
        ]
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123def456"
}
```

---

## 3. 错误码规范

### 3.1 HTTP 状态码

| 状态码 | 说明 | 使用场景 |
|-------|------|---------|
| 200 | OK | 请求成功，有响应体 |
| 201 | Created | 资源创建成功 |
| 204 | No Content | 请求成功，无响应体(删除) |
| 400 | Bad Request | 请求参数错误 |
| 401 | Unauthorized | 未认证/Token无效 |
| 403 | Forbidden | 无权限访问 |
| 404 | Not Found | 资源不存在 |
| 409 | Conflict | 资源冲突(重复创建) |
| 422 | Unprocessable Entity | 业务校验失败 |
| 429 | Too Many Requests | 请求过于频繁 |
| 500 | Internal Server Error | 服务器内部错误 |
| 502 | Bad Gateway | 网关错误 |
| 503 | Service Unavailable | 服务不可用 |

### 3.2 业务错误码

| 错误码 | 说明 | HTTP状态码 | 处理建议 |
|-------|------|-----------|---------|
| **通用错误 (1xxx)** |
| 1000 | 系统内部错误 | 500 | 联系技术支持 |
| 1001 | 登录失效 | 401 | 重新登录 |
| 1002 | Token过期 | 401 | 刷新Token |
| 1003 | 无效Token | 401 | 重新登录 |
| 1004 | 签名验证失败 | 401 | 检查签名 |
| 1005 | 请求过期 | 400 | 同步时间 |
| 1006 | 权限不足 | 403 | 申请权限 |
| **认证错误 (11xx)** |
| 1101 | 用户不存在 | 404 | 检查手机号 |
| 1102 | 密码错误 | 400 | 重新输入 |
| 1103 | 账号已被禁用 | 403 | 联系客服 |
| 1104 | 账号未实名 | 403 | 完成实名认证 |
| 1105 | 验证码错误 | 400 | 重新获取 |
| 1106 | 验证码已过期 | 400 | 重新获取 |
| **问诊错误 (3xxx)** |
| 3001 | 医生不在线 | 422 | 选择其他医生 |
| 3002 | 医生不接诊 | 422 | 选择其他医生 |
| 3003 | 问诊已结束 | 422 | 发起新问诊 |
| 3004 | 问诊已取消 | 422 | 发起新问诊 |
| 3005 | 不在可预约时间 | 422 | 选择其他时段 |
| 3006 | 预约已满 | 422 | 选择其他时段 |
| 3007 | 问诊费用未支付 | 422 | 先支付 |
| 3008 | 不支持的问诊类型 | 400 | 检查参数 |
| **处方错误 (4xxx)** |
| 4001 | 处方已过期 | 422 | 重新问诊开方 |
| 4002 | 处方已作废 | 422 | 联系药师 |
| 4003 | 处方未审核 | 422 | 等待审核 |
| **订单错误 (5xxx)** |
| 5001 | 订单不存在 | 404 | 检查订单号 |
| 5002 | 订单已支付 | 422 | 无需重复支付 |
| 5003 | 订单已取消 | 422 | 无需操作 |
| 5004 | 订单已超时 | 422 | 重新下单 |
| 5005 | 退款申请已提交 | 422 | 等待处理 |
| 5006 | 退款审核不通过 | 422 | 查看原因 |
| 5007 | 不支持该支付方式 | 400 | 选择其他方式 |
| **药品错误 (6xxx)** |
| 6001 | 药品不存在 | 404 | 检查药品ID |
| 6002 | 药品已下架 | 422 | 选择其他药品 |
| 6003 | 药品库存不足 | 422 | 调整数量 |
| 6004 | 药品无处方 | 422 | 先获取处方 |

---

## 4. 认证模块 API

### 4.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| POST /auth/sms/send | 发送验证码 | 公开 |
| POST /auth/sms/login | 验证码登录 | 公开 |
| POST /auth/login | 密码登录 | 公开 |
| POST /auth/wechat/login | 微信登录 | 公开 |
| POST /auth/logout | 退出登录 | 已登录 |
| POST /auth/refresh | 刷新Token | 已登录 |
| POST /auth/bind/wechat | 绑定微信 | 已登录 |

### 4.2 接口详情

#### 发送验证码

```http
POST /api/v1/auth/sms/send
Content-Type: application/json

{
    "phone": "13800138000",
    "scene": "login"
}
```

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| phone | string | 是 | 手机号 |
| scene | string | 是 | 场景: login/register/findPwd/changeMobile |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "expiresIn": 300
    }
}
```

#### 验证码登录

```http
POST /api/v1/auth/sms/login
Content-Type: application/json

{
    "phone": "13800138000",
    "smsCode": "123456"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "userId": 10001,
        "nickname": "张三",
        "avatar": "https://cdn.example.com/avatar.jpg",
        "userType": 1,
        "isNewUser": true,
        "token": "eyJhbGciOiJIUzI1NiIs...",
        "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
        "expiresIn": 604800
    }
}
```

#### 密码登录

```http
POST /api/v1/auth/login
Content-Type: application/json

{
    "phone": "13800138000",
    "password": "Aa123456!"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "userId": 10001,
        "nickname": "张三",
        "avatar": "https://cdn.example.com/avatar.jpg",
        "userType": 1,
        "isRealName": true,
        "token": "eyJhbGciOiJIUzI1NiIs...",
        "refreshToken": "eyJhbGciOiJIUzI1NiIs...",
        "expiresIn": 604800
    }
}
```

---

## 5. 用户模块 API

### 5.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /users/me | 获取当前用户信息 | 已登录 |
| PUT /users/me | 更新用户信息 | 已登录 |
| PUT /users/me/password | 修改密码 | 已登录 |
| GET /users/me/profile | 获取健康档案 | 已登录 |
| PUT /users/me/profile | 更新健康档案 | 已登录 |
| GET /users/me/addresses | 获取收货地址 | 已登录 |
| POST /users/me/addresses | 添加收货地址 | 已登录 |
| PUT /users/me/addresses/{id} | 更新收货地址 | 已登录 |
| DELETE /users/me/addresses/{id} | 删除收货地址 | 已登录 |
| PUT /users/me/addresses/{id}/default | 设置默认地址 | 已登录 |

### 5.2 接口详情

#### 获取当前用户信息

```http
GET /api/v1/users/me
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "userId": 10001,
        "phone": "138****8000",
        "nickname": "张三",
        "avatar": "https://cdn.example.com/avatar.jpg",
        "realName": "张*三",
        "gender": 1,
        "birthday": "1990-01-01",
        "userType": 1,
        "realNameStatus": 2,
        "balance": 100.00,
        "integral": 500,
        "vipStatus": 1,
        "vipExpireTime": "2027-01-01"
    }
}
```

#### 获取健康档案

```http
GET /api/v1/users/me/profile
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "userId": 10001,
        "height": 175.5,
        "weight": 70.0,
        "bloodType": "O",
        "allergyHistory": "青霉素",
        "medicalHistory": "无",
        "familyHistory": "父亲有高血压",
        "chronicDisease": "无",
        "emergencyContact": "李四",
        "emergencyPhone": "13900139000"
    }
}
```

#### 添加收货地址

```http
POST /api/v1/users/me/addresses
Authorization: Bearer {token}
Content-Type: application/json

{
    "receiverName": "张三",
    "receiverPhone": "13800138000",
    "province": "北京市",
    "city": "北京市",
    "district": "朝阳区",
    "detailAddress": "某某路123号",
    "isDefault": 1,
    "addressTag": "家"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "id": 1,
        "receiverName": "张三",
        "receiverPhone": "13800138000",
        "province": "北京市",
        "city": "北京市",
        "district": "朝阳区",
        "detailAddress": "某某路123号",
        "fullAddress": "北京市朝阳区某某路123号",
        "isDefault": 1,
        "addressTag": "家"
    }
}
```

---

## 6. 科室与医生模块 API

### 6.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /departments | 获取科室列表 | 公开 |
| GET /departments/{id} | 获取科室详情 | 公开 |
| GET /doctors | 获取医生列表 | 已登录 |
| GET /doctors/{id} | 获取医生详情 | 已登录 |
| GET /doctors/{id}/schedules | 获取医生排班 | 已登录 |
| GET /doctors/recommended | 获取推荐医生 | 已登录 |
| GET /doctors/search | 搜索医生 | 已登录 |
| GET /doctors/hot | 获取热门医生 | 已登录 |

### 6.2 接口详情

#### 获取科室列表

```http
GET /api/v1/departments
```

```json
{
    "code": 200,
    "message": "success",
    "data": [
        {
            "id": 1,
            "name": "内科",
            "icon": "https://cdn.example.com/icon/1.png",
            "children": [
                {"id": 11, "name": "消化内科", "icon": null},
                {"id": 12, "name": "心内科", "icon": null},
                {"id": 13, "name": "神经内科", "icon": null}
            ]
        },
        {
            "id": 2,
            "name": "外科",
            "icon": "https://cdn.example.com/icon/2.png",
            "children": [
                {"id": 21, "name": "普外科", "icon": null},
                {"id": 22, "name": "骨科", "icon": null}
            ]
        }
    ]
}
```

#### 获取医生列表

```http
GET /api/v1/doctors?departmentId=1&page=1&pageSize=20&sort=rating&isOnline=1
Authorization: Bearer {token}
```

| 参数 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| departmentId | int | 否 | 科室ID |
| title | string | 否 | 职称筛选 |
| isOnline | int | 否 | 是否在线: 0全部 1仅在线 |
| sort | string | 否 | 排序: rating/price/consultationCount |
| keyword | string | 否 | 搜索关键词 |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "doctorId": 1001,
                "doctorName": "王医生",
                "title": "主任医师",
                "titleLevel": 1,
                "departmentId": 1,
                "departmentName": "心内科",
                "hospitalName": "北京协和医院",
                "hospitalLevel": "三甲",
                "specialty": "高血压、冠心病、心律失常",
                "avatar": "https://cdn.example.com/doctor/1001.jpg",
                "rating": 4.9,
                "reviewCount": 256,
                "consultationCount": 2560,
                "price": 30.00,
                "videoPrice": 80.00,
                "voicePrice": 50.00,
                "isOnline": true,
                "isAccepting": true,
                "isFollowed": false,
                "tags": ["态度好", "有耐心", "专业"]
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 156,
            "totalPages": 8,
            "hasNext": true,
            "hasPrev": false
        }
    }
}
```

#### 获取医生详情

```http
GET /api/v1/doctors/1001
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "doctorId": 1001,
        "doctorName": "王医生",
        "title": "主任医师",
        "departmentName": "心内科",
        "hospitalName": "北京协和医院",
        "hospitalLevel": "三甲",
        "specialty": "高血压、冠心病、心律失常",
        "introduction": "从事心血管内科临床工作30年...",
        "experienceYears": 30,
        "educationBackground": "医学博士",
        "avatar": "https://cdn.example.com/doctor/1001.jpg",
        "rating": 4.9,
        "reviewCount": 256,
        "consultationCount": 2560,
        "price": 30.00,
        "videoPrice": 80.00,
        "voicePrice": 50.00,
        "isOnline": true,
        "isAccepting": true,
        "isFollowed": true,
        "followCount": 1520,
        "recentReviews": [
            {
                "rating": 5,
                "content": "医生很耐心，讲解很详细",
                "userName": "张*",
                "createdAt": "2026-05-08"
            }
        ]
    }
}
```

#### 获取医生排班

```http
GET /api/v1/doctors/1001/schedules?startDate=2026-05-10&endDate=2026-05-16
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": [
        {
            "date": "2026-05-10",
            "dayOfWeek": "星期六",
            "isWorkday": true,
            "timeSlots": [
                {
                    "timeSlotId": 1,
                    "timeSlotName": "上午",
                    "timeSlotStart": "09:00",
                    "timeSlotEnd": "12:00",
                    "price": 30.00,
                    "maxAppointments": 20,
                    "remainingAppointments": 5,
                    "status": 1
                },
                {
                    "timeSlotId": 2,
                    "timeSlotName": "下午",
                    "timeSlotStart": "14:00",
                    "timeSlotEnd": "18:00",
                    "price": 30.00,
                    "maxAppointments": 20,
                    "remainingAppointments": 20,
                    "status": 1
                }
            ]
        }
    ]
}
```

---

## 7. 问诊模块 API

### 7.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| POST /inquiries | 创建问诊 | 已登录 |
| GET /inquiries | 获取问诊列表 | 已登录 |
| GET /inquiries/{id} | 获取问诊详情 | 已登录 |
| PUT /inquiries/{id}/accept | 医生接诊 | 已登录(医生) |
| PUT /inquiries/{id}/complete | 结束问诊 | 已登录(医生) |
| PUT /inquiries/{id}/cancel | 取消问诊 | 已登录 |
| GET /inquiries/{id}/messages | 获取问诊消息 | 已登录 |
| POST /inquiries/{id}/messages | 发送消息 | 已登录 |
| POST /inquiries/{id}/review | 评价问诊 | 已登录 |
| POST /inquiries/{id}/pay | 支付问诊 | 已登录 |

### 7.2 接口详情

#### 创建问诊

```http
POST /api/v1/inquiries
Authorization: Bearer {token}
Content-Type: application/json

{
    "doctorId": 1001,
    "inquiryType": 1,
    "diseaseDescription": "最近经常头疼，已经持续一周，伴有失眠症状",
    "symptoms": "头疼,失眠",
    "symptomDuration": "1周",
    "symptomSeverity": 2,
    "images": ["https://cdn.example.com/report1.jpg"],
    "medicationHistory": "无",
    "allergyInfo": "青霉素过敏"
}
```

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| doctorId | long | 是 | 医生ID |
| inquiryType | int | 是 | 问诊类型: 1图文 2语音 3视频 |
| diseaseDescription | string | 是 | 病情描述(10-500字) |
| symptoms | string | 否 | 症状列表(逗号分隔) |
| symptomDuration | string | 否 | 症状持续时间 |
| symptomSeverity | int | 否 | 严重程度: 1轻微 2一般 3严重 |
| images | string[] | 否 | 病情图片URL列表(最多9张) |
| medicationHistory | string | 否 | 既往用药情况 |
| allergyInfo | string | 否 | 过敏信息 |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "inquiryId": 50001,
        "inquiryNo": "INQ202605100000001",
        "doctorName": "王医生",
        "inquiryType": 1,
        "inquiryTypeName": "图文问诊",
        "totalAmount": 30.00,
        "actualAmount": 30.00,
        "paymentStatus": 0,
        "status": 1,
        "statusName": "待支付",
        "payDeadline": "2026-05-10 23:59:59",
        "expireMinutes": 30
    }
}
```

#### 获取问诊列表

```http
GET /api/v1/inquiries?status=3&page=1&pageSize=20
Authorization: Bearer {token}
```

| 参数 | 类型 | 说明 |
|-----|------|------|
| status | int | 状态: 1待支付 2待接诊 3问诊中 4待取药 5已完成 6已取消 |
| type | int | 问诊类型: 1图文 2语音 3视频 |
| startDate | string | 开始日期 |
| endDate | string | 结束日期 |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "inquiryId": 50001,
                "inquiryNo": "INQ202605100000001",
                "doctorId": 1001,
                "doctorName": "王医生",
                "doctorAvatar": "https://cdn.example.com/doctor/1001.jpg",
                "doctorTitle": "主任医师",
                "departmentName": "心内科",
                "inquiryType": 1,
                "inquiryTypeName": "图文问诊",
                "diseaseDescription": "最近经常头疼...",
                "status": 3,
                "statusName": "问诊中",
                "startTime": "2026-05-10 10:00:00",
                "unreadCount": 2,
                "lastMessage": {
                    "content": "医生: 从什么时候开始的？",
                    "createdAt": "2026-05-10 10:30:00"
                }
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 50,
            "totalPages": 3
        }
    }
}
```

#### 获取问诊详情

```http
GET /api/v1/inquiries/50001
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "inquiryId": 50001,
        "inquiryNo": "INQ202605100000001",
        "userId": 10001,
        "doctorId": 1001,
        "doctorName": "王医生",
        "doctorAvatar": "https://cdn.example.com/doctor/1001.jpg",
        "doctorTitle": "主任医师",
        "hospitalName": "北京协和医院",
        "departmentName": "心内科",
        "inquiryType": 1,
        "inquiryTypeName": "图文问诊",
        "diseaseDescription": "最近经常头疼，已经持续一周...",
        "symptoms": "头疼,失眠",
        "images": ["https://cdn.example.com/report1.jpg"],
        "status": 3,
        "statusName": "问诊中",
        "startTime": "2026-05-10 10:00:00",
        "effectiveDuration": 1800,
        "doctorDiagnosis": null,
        "doctorAdvice": null,
        "prescriptionId": null,
        "totalAmount": 30.00,
        "actualAmount": 30.00,
        "paymentStatus": 1,
        "paymentTime": "2026-05-10 09:55:00",
        "isReviewed": false
    }
}
```

#### 发送消息

```http
POST /api/v1/inquiries/50001/messages
Authorization: Bearer {token}
Content-Type: application/json

{
    "messageType": 1,
    "content": "医生你好，我已经做过CT检查了",
    "images": ["https://cdn.example.com/ct-report.jpg"]
}
```

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| messageType | int | 是 | 消息类型: 1文本 2图片 3语音 4视频 |
| content | string | 是 | 消息内容 |
| mediaUrl | string | 否 | 媒体文件URL |
| mediaDuration | int | 否 | 媒体时长(秒) |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "messageId": 100001,
        "messageType": 1,
        "content": "医生你好，我已经做过CT检查了",
        "senderType": 1,
        "senderId": 10001,
        "createdAt": "2026-05-10 10:35:00",
        "isRead": false
    }
}
```

#### 评价问诊

```http
POST /api/v1/inquiries/50001/review
Authorization: Bearer {token}
Content-Type: application/json

{
    "rating": 5,
    "attitudeRating": 5,
    "skillRating": 5,
    "content": "医生很专业，讲解很详细，给了很好的建议",
    "tags": ["态度好", "专业", "有耐心"],
    "images": ["https://cdn.example.com/review-img.jpg"]
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "reviewId": 10001,
        "rating": 5
    }
}
```

---

## 8. 处方模块 API

### 8.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| POST /prescriptions | 开具处方 | 已登录(医生) |
| GET /prescriptions | 获取处方列表 | 已登录 |
| GET /prescriptions/{id} | 获取处方详情 | 已登录 |
| GET /prescriptions/{id}/drugs | 获取处方药品 | 已登录 |
| PUT /prescriptions/{id}/audit | 审核处方 | 已登录(药师) |

### 8.2 接口详情

#### 获取处方列表

```http
GET /api/v1/prescriptions?status=1&page=1&pageSize=20
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "prescriptionId": 60001,
                "prescriptionNo": "RX202605100000001",
                "inquiryId": 50001,
                "doctorName": "王医生",
                "doctorTitle": "主任医师",
                "diagnosis": "原发性高血压",
                "totalAmount": 150.00,
                "status": 2,
                "statusName": "审核通过",
                "validStartTime": "2026-05-10",
                "validEndTime": "2026-05-17",
                "createdAt": "2026-05-10 11:00:00",
                "drugCount": 2
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 10,
            "totalPages": 1
        }
    }
}
```

#### 获取处方详情

```http
GET /api/v1/prescriptions/60001
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "prescriptionId": 60001,
        "prescriptionNo": "RX202605100000001",
        "inquiryId": 50001,
        "doctorName": "王医生",
        "doctorTitle": "主任医师",
        "hospitalName": "北京协和医院",
        "diagnosis": "原发性高血压",
        "diagnosisCode": "I10",
        "advice": "注意低盐饮食，适当运动",
        "lifestyleAdvice": "保持心情愉悦，避免情绪激动",
        "totalAmount": 150.00,
        "status": 2,
        "statusName": "审核通过",
        "validStartTime": "2026-05-10",
        "validEndTime": "2026-05-17",
        "pharmacistName": "刘药师",
        "auditTime": "2026-05-10 11:30:00",
        "drugs": [
            {
                "drugId": 1001,
                "drugName": "硝苯地平缓释片",
                "specification": "20mg*30片",
                "quantity": 2,
                "unit": "盒",
                "price": 35.00,
                "subtotal": 70.00,
                "usage": "口服",
                "dosage": "1片",
                "frequency": "每日2次",
                "duration": "7天"
            },
            {
                "drugId": 1002,
                "drugName": "缬沙坦胶囊",
                "specification": "80mg*7片",
                "quantity": 2,
                "unit": "盒",
                "price": 40.00,
                "subtotal": 80.00,
                "usage": "口服",
                "dosage": "1粒",
                "frequency": "每日1次",
                "duration": "7天"
            }
        ]
    }
}
```

---

## 9. 订单模块 API

### 9.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| POST /orders | 创建订单 | 已登录 |
| GET /orders | 获取订单列表 | 已登录 |
| GET /orders/{id} | 获取订单详情 | 已登录 |
| PUT /orders/{id}/cancel | 取消订单 | 已登录 |
| POST /orders/{id}/pay | 支付订单 | 已登录 |
| GET /orders/{id}/pay-params | 获取支付参数 | 已登录 |
| GET /orders/{id}/pay-result | 查询支付结果 | 已登录 |
| POST /orders/{id}/refund | 申请退款 | 已登录 |
| GET /orders/{id}/refund | 获取退款信息 | 已登录 |

### 9.2 接口详情

#### 创建订单

```http
POST /api/v1/orders
Authorization: Bearer {token}
Content-Type: application/json

{
    "orderType": 2,
    "prescriptionId": 60001,
    "addressId": 1,
    "items": [
        {"drugId": 1001, "quantity": 2},
        {"drugId": 1002, "quantity": 1}
    ],
    "couponId": 1001,
    "remark": "请尽快发货"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "orderId": 70001,
        "orderNo": "ORD202605100000001",
        "orderType": 2,
        "totalAmount": 150.00,
        "discountAmount": 10.00,
        "couponAmount": 10.00,
        "freightAmount": 0.00,
        "actualAmount": 140.00,
        "status": 1,
        "statusName": "待支付",
        "payDeadline": "2026-05-10 23:59:59",
        "items": [
            {
                "itemId": 1,
                "drugId": 1001,
                "drugName": "硝苯地平缓释片",
                "specification": "20mg*30片",
                "quantity": 2,
                "price": 35.00,
                "subtotal": 70.00
            }
        ],
        "receiverAddress": "北京市朝阳区某某路123号"
    }
}
```

#### 获取订单列表

```http
GET /api/v1/orders?status=2&page=1&pageSize=20
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "orderId": 70001,
                "orderNo": "ORD202605100000001",
                "orderType": 2,
                "orderTypeName": "药品订单",
                "totalAmount": 150.00,
                "actualAmount": 140.00,
                "status": 2,
                "statusName": "待发货",
                "paymentTime": "2026-05-10 12:00:00",
                "expressCompany": null,
                "expressNo": null,
                "items": [
                    {"drugName": "硝苯地平缓释片", "quantity": 2},
                    {"drugName": "缬沙坦胶囊", "quantity": 1}
                ]
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 25,
            "totalPages": 2
        }
    }
}
```

---

## 10. 药品模块 API

### 10.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /drugs | 获取药品列表 | 已登录 |
| GET /drugs/{id} | 获取药品详情 | 已登录 |
| GET /drugs/search | 搜索药品 | 已登录 |
| GET /drugs/categories | 获取药品分类 | 已登录 |
| GET /drugs/hot | 获取热门药品 | 已登录 |
| GET /drugs/recommend | 获取推荐药品 | 已登录 |

### 10.2 接口详情

#### 搜索药品

```http
GET /api/v1/drugs/search?keyword=高血压&categoryId=1&page=1&pageSize=20
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "drugId": 1001,
                "drugName": "硝苯地平缓释片",
                "commonName": "硝苯地平缓释片(II)",
                "specification": "20mg*30片",
                "manufacturer": "拜耳医药",
                "price": 35.00,
                "originalPrice": 45.00,
                "image": "https://cdn.example.com/drug/1001.jpg",
                "drugType": 1,
                "drugTypeName": "处方药",
                "prescriptionRequired": true,
                "stock": 100,
                "salesCount": 5000,
                "isHot": true
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 50,
            "totalPages": 3
        }
    }
}
```

---

## 11. 预约模块 API

### 11.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /appointments/slots | 获取可预约号源 | 已登录 |
| POST /appointments | 创建预约 | 已登录 |
| GET /appointments | 获取预约列表 | 已登录 |
| GET /appointments/{id} | 获取预约详情 | 已登录 |
| POST /appointments/{id}/cancel | 取消预约 | 已登录 |
| PUT /appointments/{id}/check-in | 签到 | 已登录 |
| GET /appointments/{id}/qrcode | 获取签到二维码 | 已登录 |

### 11.2 接口详情

#### 获取可预约号源

```http
GET /api/v1/appointments/slots?doctorId=1001&date=2026-05-15
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "doctorId": 1001,
        "doctorName": "王医生",
        "departmentName": "心内科",
        "date": "2026-05-15",
        "dayOfWeek": "星期四",
        "slots": [
            {
                "scheduleId": 1001,
                "timeSlotId": 1,
                "timeSlotName": "上午",
                "startTime": "09:00",
                "endTime": "12:00",
                "price": 30.00,
                "maxCount": 20,
                "remainingCount": 5,
                "status": 1,
                "statusName": "可预约"
            },
            {
                "scheduleId": 1002,
                "timeSlotId": 2,
                "timeSlotName": "下午",
                "startTime": "14:00",
                "endTime": "18:00",
                "price": 30.00,
                "maxCount": 20,
                "remainingCount": 0,
                "status": 2,
                "statusName": "已满"
            }
        ]
    }
}
```

#### 创建预约

```http
POST /api/v1/appointments
Authorization: Bearer {token}
Content-Type: application/json

{
    "scheduleId": 1001,
    "timeSlotId": 1,
    "patientName": "张三",
    "patientPhone": "13800138000",
    "patientGender": 1,
    "patientAge": "35岁",
    "symptoms": "胸闷、心悸"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "appointmentId": 80001,
        "appointmentNo": "APT202605100000001",
        "doctorName": "王医生",
        "appointmentDate": "2026-05-15",
        "timeSlotName": "上午",
        "startTime": "09:00",
        "endTime": "12:00",
        "status": 1,
        "statusName": "待支付",
        "totalAmount": 30.00,
        "actualAmount": 30.00,
        "payDeadline": "2026-05-10 23:59:59"
    }
}
```

---

## 12. 药师端 API

### 12.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /pharmacist/tasks | 获取审核任务列表 | 已登录(药师) |
| GET /pharmacist/prescriptions/{id} | 获取处方详情 | 已登录(药师) |
| POST /pharmacist/prescriptions/{id}/audit | 审核处方 | 已登录(药师) |
| GET /pharmacist/orders | 获取订单列表 | 已登录(药师) |
| POST /pharmacist/orders/{id}/ship | 发货 | 已登录(药师) |
| GET /pharmacist/stats | 获取工作统计 | 已登录(药师) |

### 12.2 接口详情

#### 获取审核任务列表

```http
GET /api/v1/pharmacist/tasks?status=1&page=1&pageSize=20
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "taskId": 90001,
                "prescriptionId": 60001,
                "prescriptionNo": "RX202605100000001",
                "doctorName": "王医生",
                "hospitalName": "北京协和医院",
                "patientName": "张三",
                "patientAge": "45岁",
                "diagnosis": "原发性高血压",
                "drugCount": 2,
                "totalAmount": 150.00,
                "createTime": "2026-05-10 10:00:00",
                "waitTime": 3600,
                "priority": 1
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 50,
            "totalPages": 3
        }
    }
}
```

#### 审核处方

```http
POST /api/v1/pharmacist/prescriptions/60001/audit
Authorization: Bearer {token}
Content-Type: application/json

{
    "result": 1,
    "remark": "处方审核通过，请按时取药",
    "images": []
}
```

| 字段 | 类型 | 必填 | 说明 |
|-----|------|-----|------|
| result | int | 是 | 审核结果: 1通过 2拒绝 |
| remark | string | 否 | 审核备注 |
| images | string[] | 否 | 审核凭证图片 |

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "prescriptionId": 60001,
        "status": 2,
        "statusName": "审核通过",
        "auditTime": "2026-05-10 14:30:00"
    }
}
```

---

## 13. 客服模块 API

### 13.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| POST /complaints | 提交投诉 | 已登录 |
| GET /complaints | 获取投诉列表 | 已登录 |
| GET /complaints/{id} | 获取投诉详情 | 已登录 |
| POST /feedback | 提交建议 | 已登录 |
| GET /feedback | 获取建议列表 | 已登录 |
| POST /tickets | 创建工单 | 已登录 |
| GET /tickets | 获取工单列表 | 已登录 |
| GET /tickets/{id} | 获取工单详情 | 已登录 |
| POST /tickets/{id}/confirm | 确认完成 | 已登录 |

### 13.2 接口详情

#### 提交投诉

```http
POST /api/v1/complaints
Authorization: Bearer {token}
Content-Type: application/json

{
    "targetType": 1,
    "targetId": 1001,
    "type": 1,
    "content": "医生服务态度恶劣，回复不及时",
    "images": ["https://cdn.example.com/complaint/1.jpg"],
    "contact": "13800138000"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "complaintId": 100001,
        "complaintNo": "CMP202605100000001",
        "status": 1,
        "statusName": "待处理"
    }
}
```

#### 创建工单

```http
POST /api/v1/tickets
Authorization: Bearer {token}
Content-Type: application/json

{
    "category": 1,
    "priority": 2,
    "title": "订单无法支付",
    "content": "尝试多次支付都失败",
    "images": [],
    "contact": "13800138000"
}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "ticketId": 110001,
        "ticketNo": "TKT202605100000001",
        "status": 1,
        "statusName": "待分配"
    }
}
```

---

## 14. 大屏数据 API

### 14.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /databoard/realtime | 获取实时数据 | 已登录(管理) |
| GET /databoard/summary | 获取统计汇总 | 已登录(管理) |
| GET /databoard/trend | 获取趋势数据 | 已登录(管理) |
| WS /ws/databoard | WebSocket实时推送 | 已登录(管理) |

### 14.2 接口详情

#### 获取实时数据

```http
GET /api/v1/databoard/realtime
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "todayInquiryCount": 256,
        "todayAppointmentCount": 128,
        "todayOrderCount": 89,
        "todayAmount": 25680.00,
        "activeDoctors": 45,
        "activeUsers": 1520,
        "pendingPrescriptionCount": 23,
        "pendingRefundCount": 5,
        "updateTime": "2026-05-10 14:30:00"
    }
}
```

#### 获取统计汇总

```http
GET /api/v1/databoard/summary?type=week
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "type": "week",
        "startDate": "2026-05-04",
        "endDate": "2026-05-10",
        "inquiryCount": 1560,
        "appointmentCount": 890,
        "orderCount": 456,
        "totalAmount": 125680.00,
        "inquiryGrowth": 15.6,
        "orderGrowth": 8.3,
        "topDepartments": [
            {"name": "心内科", "count": 256},
            {"name": "消化内科", "count": 198}
        ],
        "topDrugs": [
            {"name": "硝苯地平缓释片", "count": 156},
            {"name": "奥美拉唑肠溶胶囊", "count": 132}
        ]
    }
}
```

---

## 15. 消息通知 API

### 15.1 接口列表

| 接口 | 方法 | 说明 | 认证 |
|-----|------|------|------|
| GET /notifications | 获取消息列表 | 已登录 |
| GET /notifications/{id} | 获取消息详情 | 已登录 |
| GET /notifications/count | 获取未读数量 | 已登录 |
| PUT /notifications/read | 标记已读 | 已登录 |
| PUT /notifications/read-all | 全部已读 | 已登录 |
| DELETE /notifications/{id} | 删除消息 | 已登录 |

### 15.2 接口详情

#### 获取消息列表

```http
GET /api/v1/notifications?type=1&isRead=0&page=1&pageSize=20
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "list": [
            {
                "id": 130001,
                "type": 2,
                "typeName": "订单通知",
                "title": "您的订单已发货",
                "content": "订单号ORD202605100000001已发货，快递公司：顺丰速运",
                "linkType": "order",
                "linkId": "70001",
                "isRead": false,
                "createdAt": "2026-05-10 14:00:00"
            }
        ],
        "pagination": {
            "page": 1,
            "pageSize": 20,
            "total": 50,
            "totalPages": 3
        },
        "unreadCount": 12
    }
}
```

---

## 16. 幂等性设计

### 16.1 幂等Token

```http
POST /api/v1/common/idempotent-token
Authorization: Bearer {token}
```

```json
{
    "code": 200,
    "message": "success",
    "data": {
        "token": "idem_abc123xyz789",
        "expiresIn": 3600
    }
}
```

### 16.2 幂等请求示例

```http
POST /api/v1/orders
Authorization: Bearer {token}
X-Idempotent-Token: idem_abc123xyz789
Content-Type: application/json

{
    "orderType": 2,
    "totalAmount": 100.00
}
```

---

## 17. 限流设计

### 17.1 限流规格

| 接口类型 | 限制值 | 时间窗口 | 触发动作 |
|---------|-------|---------|---------|
| 公开接口 | 100次/分钟 | 1分钟 | 返回429 |
| 认证接口 | 1000次/分钟 | 1分钟 | 返回429 |
| 验证码接口 | 5次/小时 | 1小时 | 返回429 |
| 登录接口 | 10次/分钟 | 1分钟 | 返回429 |
| 支付接口 | 100次/分钟 | 1分钟 | 返回429 |

### 17.2 限流响应

```json
{
    "code": 429,
    "message": "请求过于频繁，请稍后再试",
    "error": {
        "code": "RATE_LIMIT_EXCEEDED",
        "retryAfter": 60
    },
    "timestamp": 1715312400,
    "requestId": "req_abc123"
}
```

---

## 18. 版本管理

### 18.1 版本策略

```
1. 当前版本: /api/v1/
2. 维护周期: 当前版本 + 上一版本
3. 废弃通知: 提前6个月发出 Sunset 头
4. 响应头:
   X-API-Version: v1
   Sunset: Sat, 01 Jan 2027 00:00:00 GMT
```

### 18.2 非破坏性变更

以下变更不需要新版本:
- 新增可选请求参数
- 新增响应字段
- 新增API端点
- 修正字段说明

以下变更需要新版本:
- 删除或重命名字段
- 修改字段类型
- 修改必填参数
- 修改认证方式

---


## 19. 版本历史

| 版本 | 日期 | 作者 | 变更说明 |
|-----|------|------|---------|
| v1.0 | 2026-05-10 | 架构设计团队 | 初始版本 |
| v1.1 | 2026-05-10 | 架构设计团队 | 新增预约模块API(11)、药师端API(12)、客服模块API(13)、大屏数据API(14)、消息通知API(15)；调整章节编号 |
| v1.2 | 2026-05-10 | 架构设计团队 | 修正章节编号(16.1/16.2/18.1/18.2)；修正URL规范双斜杠错误 |
| v1.3 | 2026-05-10 | 架构设计团队 | **新增**: WebSocket实时通讯设计(20)、RBAC权限矩阵(21)、错误码分段设计(22)；按服务类型划分错误码(1xxx-18xx) |

---

## 20. WebSocket 实时通讯设计

### 20.1 WebSocket 连接规范

```
连接地址: wss://api.example.com/ws/v1/connect
认证方式: URL参数 + Token
```

### 20.2 消息类型定义

| 消息类型 | type值 | 说明 | 方向 |
|---------|-------|------|------|
| 认证 | auth | 连接认证 | 双向 |
| 认证确认 | auth_ack | 认证结果 | 单向(服务端) |
| 问诊消息 | inquiry_message | 问诊聊天消息 | 双向 |
| 消息已读 | message_read | 消息已读回执 | 双向 |
| 医生上下线 | doctor_status | 医生在线状态变更 | 单向(服务端) |
| 问诊状态变更 | inquiry_status | 问诊状态变更通知 | 单向(服务端) |
| 处方推送 | prescription_push | 新处方推送 | 单向(服务端) |
| 订单通知 | order_notify | 订单状态变更 | 单向(服务端) |
| 系统通知 | system_notice | 系统消息推送 | 单向(服务端) |
| 心跳 | ping/pong | 保持连接 | 双向 |

### 20.3 心跳机制

```json
// 客户端心跳 (每30秒发送)
{"type": "ping", "timestamp": 1715312400}

// 服务端响应
{"type": "pong", "timestamp": 1715312400}
```

### 20.4 断线重连策略

```java
public class WebSocketClient {
    private int maxReconnectAttempts = 5;
    private long reconnectInterval = 3000;
    
    public void reconnect() {
        int attempts = 0;
        while (attempts < maxReconnectAttempts) {
            try {
                connect();
                return;
            } catch (Exception e) {
                attempts++;
                Thread.sleep(reconnectInterval * attempts);
            }
        }
        showReconnectFailedDialog();
    }
}
```

---

## 21. RBAC 权限矩阵

### 21.1 角色定义

| 角色 | role值 | 说明 |
|-----|--------|------|
| 患者 | PATIENT | 普通用户，可发起问诊、购药 |
| 医生 | DOCTOR | 医疗人员，可接诊、开具处方 |
| 药师 | PHARMACIST | 药学人员，可审核处方 |
| 管理员 | ADMIN | 系统管理员 |
| 客服 | CUSTOMER_SERVICE | 客服人员 |

### 21.2 权限矩阵

| 模块 | 操作 | 患者 | 医生 | 药师 | 管理员 | 客服 |
|-----|------|------|------|------|--------|------|
| 用户模块 | 查看个人信息 | ✅自己的 | ✅自己的 | ✅自己的 | ✅全部 | ❌ |
| 问诊模块 | 发起问诊 | ✅自己的 | ❌ | ❌ | ❌ | ❌ |
| 问诊模块 | 接诊 | ❌ | ✅自己的 | ❌ | ❌ | ❌ |
| 问诊模块 | 开具处方 | ❌ | ✅自己的 | ❌ | ❌ | ❌ |
| 处方模块 | 审核处方 | ❌ | ❌ | ✅自己的 | ✅ | ❌ |
| 订单模块 | 订单发货 | ❌ | ❌ | ✅自己的 | ✅ | ❌ |
| 客服模块 | 处理投诉 | ❌ | ❌ | ❌ | ✅ | ✅ |
| 管理模块 | 用户管理 | ❌ | ❌ | ❌ | ✅ | ❌ |

### 21.3 权限注解实现

```java
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequiresPermission {
    String module();
    String action();
    String[] roles() default {};
}

// 使用示例
@RequiresPermission(module = "inquiry", action = "accept", roles = {"DOCTOR"})
@PutMapping("/{id}/accept")
public Result<Void> acceptInquiry(@PathVariable Long id) {
    return inquiryService.accept(id);
}
```

---

## 22. 错误码分段设计（按服务）

### 22.1 错误码分段

| 服务 | 错误码段 | 示例 | 说明 |
|-----|---------|------|------|
| 通用服务 | 1xxx | 1001 | 认证、签名、限流等 |
| 用户服务 | 11xx | 1101 | 用户相关 |
| 医生服务 | 12xx | 1201 | 医生相关 |
| 问诊服务 | 13xx | 1301 | 问诊相关 |
| 处方服务 | 14xx | 1401 | 处方相关 |
| 订单服务 | 15xx | 1501 | 订单相关 |
| 药品服务 | 16xx | 1601 | 药品相关 |
| 预约服务 | 18xx | 1801 | 预约相关 |

### 22.2 核心错误码

| 错误码 | 说明 | HTTP状态 | 处理建议 |
|-------|------|---------|---------|
| 1001 | 系统内部错误 | 500 | 联系技术支持 |
| 1002 | 登录失效 | 401 | 重新登录 |
| 1003 | Token过期 | 401 | 刷新Token |
| 1006 | 权限不足 | 403 | 申请权限 |
| 1007 | 请求过于频繁 | 429 | 稍后重试 |
| 1101 | 用户不存在 | 404 | 检查手机号 |
| 1102 | 密码错误 | 400 | 重新输入 |
| 1203 | 医生不在线 | 422 | 选择其他医生 |
| 1204 | 医生不接诊 | 422 | 选择其他医生 |
| 1301 | 问诊不存在 | 404 | 检查问诊ID |
| 1302 | 问诊已结束 | 422 | 发起新问诊 |
| 1401 | 处方不存在 | 404 | 检查处方ID |
| 1402 | 处方已过期 | 422 | 重新问诊开方 |
| 1501 | 订单不存在 | 404 | 检查订单号 |
| 1502 | 订单已支付 | 422 | 无需重复支付 |
| 1601 | 药品不存在 | 404 | 检查药品ID |
| 1603 | 药品库存不足 | 422 | 调整数量 |

---

*文档结束*
