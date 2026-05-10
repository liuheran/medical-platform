# AGENTS.md - 在线问诊平台项目规范

> 本文件定义了在线问诊平台项目的全局开发规范、AI Agent 工作准则和项目认知固化。

---

## 项目概述

| 项目名称 | 在线问诊平台 |
|----------|--------------|
| 项目路径 | `f:\振涛弘业\实训项目\医疗项目` |
| 技术栈 | Spring Boot 3.2 + Spring Cloud 微服务 |
| 数据库 | MySQL 8.0 + Redis 7.0 |
| 当前阶段 | 设计阶段 → 准备开发阶段 |

---

## 项目结构

```
医疗项目/
├── prd/                          # 产品需求文档
│   ├── 在线问诊平台.md            # PRD完整版
│   ├── 设计文档/                   # 设计文档
│   │   ├── 01_系统架构设计.md
│   │   ├── 02_数据库设计.md
│   │   ├── 03_API接口设计.md
│   │   └── 04_UI设计规范.md
│   └── 对话记录_完整版.md
├── doc/                          # 开发文档 (待创建)
├── sql/                          # SQL脚本 (待创建)
└── source/                       # 源代码 (待创建)
    ├── gateway/                  # API网关服务
    ├── user-center/              # 用户中心服务
    ├── inquiry-center/           # 问诊中心服务
    ├── prescription-center/      # 处方中心服务
    ├── order-center/             # 订单中心服务
    └── admin/                    # 管理后台服务
```

---

## 技术架构

### 核心技术选型

| 组件 | 技术选型 | 版本 | 说明 |
|------|----------|------|------|
| 后端框架 | Spring Boot | 3.2.x | 主框架 |
| 微服务框架 | Spring Cloud Alibaba | 2023.x | 微服务生态 |
| 服务注册 | Nacos | 2.2.x | 注册中心+配置中心 |
| 网关 | Spring Cloud Gateway | 4.1.x | API网关 |
| 数据库 | MySQL | 8.0.x | 主数据库 |
| 缓存 | Redis | 7.0.x | 分布式缓存 |
| 消息队列 | RocketMQ | 5.x | 异步消息 |
| 分布式事务 | Seata | 2.x | AT模式 |
| 服务通信 | Dubbo | 3.x | RPC通信 |
| 链路追踪 | SkyWalking | 9.x | 分布式追踪 |
| 日志系统 | ELK Stack | 8.x | 日志收集 |
| 文件存储 | MinIO | latest | 对象存储 |
| 实时通信 | WebSocket + Netty | - | 消息推送 |

### 端口规划

| 服务 | 端口 | 说明 |
|------|------|------|
| Nacos | 8848 | 注册中心 |
| MySQL | 3306 | 数据库 |
| Redis | 6379 | 缓存 |
| RocketMQ | 8080/9876 | Broker/Console |
| MinIO | 9000 | 文件存储 |
| API Gateway | 8080 | 网关端口 |
| User Service | 8081 | 用户服务 |
| Inquiry Service | 8082 | 问诊服务 |
| Prescription Service | 8083 | 处方服务 |
| Order Service | 8084 | 订单服务 |

---

## 数据库设计

### 核心表结构

#### 用户相关
- `sys_user` - 用户表
- `patient_profile` - 患者扩展信息
- `doctor` - 医生信息表
- `pharmacist` - 药师信息表
- `department` - 科室表

#### 问诊相关
- `inquiry` - 问诊记录表
- `inquiry_message` - 问诊消息表
- `inquiry_evaluation` - 问诊评价表

#### 处方相关
- `prescription` - 处方表
- `prescription_drug` - 处方药品明细表
- `drug` - 药品表

#### 订单相关
- `order` - 订单表
- `order_item` - 订单明细表
- `payment` - 支付记录表

详见：`prd/设计文档/02_数据库设计.md`

---

## API 接口规范

### 接口版本
- 当前版本：v1
- 基础路径：`/api/v1`
- 示例：`/api/v1/user/login`

### 统一响应格式
```json
{
  "code": 200,
  "message": "success",
  "data": {},
  "timestamp": 1700000000000
}
```

### 错误码规范
| 范围 | 说明 |
|------|------|
| 1xxx | 系统级错误 |
| 2xxx | 用户认证错误 |
| 3xxx | 业务逻辑错误 |
| 4xxx | 参数校验错误 |
| 5xxx | 第三方服务错误 |

详见：`prd/设计文档/03_API接口设计.md`

---

## 开发规范

### Java 开发规范

#### 命名规范
- **类名**：大驼峰 (PascalCase)，如 `UserService`
- **方法名**：小驼峰 (camelCase)，如 `getUserById`
- **常量**：全大写下划线分隔，如 `MAX_RETRY_COUNT`
- **包名**：全小写，如 `com.example.user`

#### 分层架构
```
controller/     # 控制层，接收请求
service/       # 服务层，业务逻辑
repository/    # 数据访问层
entity/        # 实体类
dto/           # 数据传输对象
vo/            # 视图对象
config/        # 配置类
constant/      # 常量类
exception/     # 异常类
```

#### 注解使用
- `@RestController` - RESTful控制器
- `@Service` - 服务类
- `@Repository` - 数据访问类
- `@Component` - 通用组件
- `@Configuration` - 配置类
- `@Valid` / `@Validated` - 参数校验

### Git 提交规范

#### 提交格式
```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type 类型
| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | 缺陷修复 |
| docs | 文档更新 |
| style | 代码格式 |
| refactor | 重构 |
| perf | 性能优化 |
| test | 测试相关 |
| chore | 构建/工具 |

#### 示例
```
feat(user): 添加手机号登录功能

- 实现短信验证码发送
- 添加登录接口
- 集成JWT token

Closes #123
```

### 代码审查清单
- [ ] 代码符合命名规范
- [ ] 方法有适当的注释
- [ ] 异常处理完善
- [ ] 参数校验完整
- [ ] 无硬编码配置
- [ ] 单元测试覆盖
- [ ] 无安全漏洞

---

## 项目开发计划

### 开发阶段

| 阶段 | 内容 | 预计时间 |
|------|------|----------|
| Day1-2 | 基础设施 | 项目初始化、微服务框架、数据库脚本 |
| Day3-4 | 用户认证 | 注册登录、实名认证、JWT + Redis |
| Day5-7 | 问诊核心 | 图文/语音/视频问诊、WebSocket |
| Day8-10 | 医生处方 | 电子处方、药师审核、用药提醒 |
| Day11-14 | 订单药品 | 支付、订单管理、药品管理 |
| Day15-18 | 管理后台 | CMS、统计报表、权限管理 |

---

## AI Agent 工作准则

### CodeBuddy 使用指南

#### 适用场景
1. **代码生成**：根据需求生成完整模块代码
2. **代码审查**：检查代码质量、安全、性能
3. **缺陷修复**：定位并修复Bug
4. **文档生成**：生成API文档、注释
5. **架构设计**：辅助技术方案设计

#### 交互模式
1. **Ask 模式**：咨询问题、获取建议
2. **Agent 模式**：执行复杂多步骤任务
3. **Inline 模式**：编辑器内实时辅助

#### 最佳实践
1. 提供清晰的上下文信息
2. 分步骤验证AI生成的代码
3. 重要逻辑需要人工复核
4. 保持对话记录便于追溯

### Prompt 编写技巧

#### ✅ 推荐写法
```
请帮我生成用户登录的Service层代码：
- 接收username和password参数
- 使用BCrypt加密验证密码
- 验证成功后生成JWT token
- 返回用户信息（不包含密码）
```

#### ❌ 避免写法
```
写个登录代码
```

---

## 常用命令

### 项目构建
```bash
# 编译项目
mvn clean compile

# 打包
mvn clean package -DskipTests

# 运行单个服务
java -jar target/xxx.jar

# Docker 构建
docker build -t xxx:latest .
```

### 数据库操作
```sql
-- 初始化数据库
source sql/init.sql

-- 执行迁移
mvn flyway:migrate

-- 备份数据库
mysqldump -u root -p dbname > backup.sql
```

### Docker Compose
```bash
# 启动基础设施
docker-compose up -d mysql redis nacos

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

---

## 联系方式

| 角色 | 职责 | 说明 |
|------|------|------|
| 项目负责人 | 整体把控 | - |
| 技术负责人 | 技术决策 | - |
| 开发团队 | 代码实现 | - |
| AI助手 | 技术辅助 | CodeBuddy |

---

## 变更记录

| 版本 | 日期 | 修改人 | 修改内容 |
|------|------|--------|----------|
| v1.0 | 2026-05-10 | AI Assistant | 初始版本 |

---

> 本文档为项目全局认知固化文件，所有AI Agent和开发人员应遵循此规范。
> 如有更新，请同步更新此文档并通知相关人员。
