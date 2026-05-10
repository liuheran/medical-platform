-- ============================================
-- 在线问诊平台数据库初始化脚本
-- 数据库名称: hospital_online
-- 创建时间: 2026-05-10
-- ============================================

-- 创建数据库（如果不存在）
CREATE DATABASE IF NOT EXISTS hospital_online
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE hospital_online;

-- ============================================
-- 用户相关表
-- ============================================

-- 用户表（患者）
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(255) NOT NULL COMMENT '密码',
    phone VARCHAR(20) COMMENT '手机号',
    email VARCHAR(100) COMMENT '邮箱',
    real_name VARCHAR(50) COMMENT '真实姓名',
    id_card VARCHAR(20) COMMENT '身份证号',
    avatar VARCHAR(255) DEFAULT '/images/default-avatar.png' COMMENT '头像',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-正常 0-禁用',
    user_type TINYINT NOT NULL COMMENT '用户类型: 1-患者 2-医生 3-药师 4-管理员',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted_at DATETIME DEFAULT NULL COMMENT '删除时间',
    INDEX idx_phone (phone),
    INDEX idx_user_type (user_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 患者扩展信息表
CREATE TABLE IF NOT EXISTS patient_profile (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    gender TINYINT COMMENT '性别: 1-男 2-女',
    birth_date DATE COMMENT '出生日期',
    age INT COMMENT '年龄',
    blood_type VARCHAR(5) COMMENT '血型',
    allergy_history TEXT COMMENT '过敏史',
    medical_history TEXT COMMENT '既往病史',
    emergency_contact VARCHAR(100) COMMENT '紧急联系人',
    emergency_phone VARCHAR(20) COMMENT '紧急联系电话',
    address VARCHAR(255) COMMENT '地址',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_user_id (user_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='患者扩展信息表';

-- 医生表
CREATE TABLE IF NOT EXISTS doctor (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '医生ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    doctor_no VARCHAR(50) UNIQUE COMMENT '工号',
    title VARCHAR(50) COMMENT '职称: 主任医师/副主任医师/主治医师/住院医师',
    department_id BIGINT COMMENT '科室ID',
    expertise TEXT COMMENT '擅长领域',
    introduction TEXT COMMENT '个人简介',
    work_hospital VARCHAR(100) COMMENT '工作医院',
    work_experience INT COMMENT '工作年限',
    consultation_fee DECIMAL(10,2) DEFAULT 0.00 COMMENT '图文问诊费',
    video_fee DECIMAL(10,2) DEFAULT 0.00 COMMENT '视频问诊费',
    avatar_verified TINYINT DEFAULT 0 COMMENT '头像认证: 0-未认证 1-已认证',
    certificate_verified TINYINT DEFAULT 0 COMMENT '证书认证: 0-未认证 1-已认证',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-正常 0-禁用',
    rating DECIMAL(3,2) DEFAULT 5.00 COMMENT '评分',
    consultation_count INT DEFAULT 0 COMMENT '问诊次数',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_user_id (user_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='医生表';

-- 科室表
CREATE TABLE IF NOT EXISTS department (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '科室ID',
    parent_id BIGINT DEFAULT 0 COMMENT '父级ID',
    name VARCHAR(50) NOT NULL COMMENT '科室名称',
    code VARCHAR(50) COMMENT '科室编码',
    icon VARCHAR(255) COMMENT '图标',
    sort INT DEFAULT 0 COMMENT '排序',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-启用 0-禁用',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='科室表';

-- ============================================
-- 问诊相关表
-- ============================================

-- 问诊记录表
CREATE TABLE IF NOT EXISTS inquiry (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '问诊ID',
    inquiry_no VARCHAR(50) NOT NULL UNIQUE COMMENT '问诊单号',
    patient_id BIGINT NOT NULL COMMENT '患者ID',
    doctor_id BIGINT NOT NULL COMMENT '医生ID',
    department_id BIGINT COMMENT '科室ID',
    inquiry_type TINYINT NOT NULL COMMENT '问诊类型: 1-图文 2-语音 3-视频',
    disease_type VARCHAR(100) COMMENT '疾病类型',
    symptom_description TEXT COMMENT '症状描述',
    images TEXT COMMENT '症状图片( JSON数组)',
    attachment VARCHAR(255) COMMENT '附件',
    diagnosis TEXT COMMENT '诊断结果',
    medical_advice TEXT COMMENT '医嘱',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-待接诊 2-问诊中 3-已结束 4-已取消 5-已退款',
    start_time DATETIME COMMENT '开始时间',
    end_time DATETIME COMMENT '结束时间',
    total_duration INT DEFAULT 0 COMMENT '总时长(秒)',
    evaluate_status TINYINT DEFAULT 0 COMMENT '评价状态: 0-未评价 1-已评价',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_patient_id (patient_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at),
    FOREIGN KEY (patient_id) REFERENCES sys_user(id),
    FOREIGN KEY (doctor_id) REFERENCES doctor(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问诊记录表';

-- 问诊消息表
CREATE TABLE IF NOT EXISTS inquiry_message (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '消息ID',
    inquiry_id BIGINT NOT NULL COMMENT '问诊ID',
    sender_type TINYINT NOT NULL COMMENT '发送者类型: 1-患者 2-医生 3-系统',
    sender_id BIGINT NOT NULL COMMENT '发送者ID',
    message_type TINYINT NOT NULL COMMENT '消息类型: 1-文本 2-图片 3-语音 4-视频',
    content TEXT COMMENT '消息内容',
    media_url VARCHAR(255) COMMENT '媒体文件URL',
    media_duration INT COMMENT '媒体时长(秒)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (inquiry_id) REFERENCES inquiry(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问诊消息表';

-- 问诊评价表
CREATE TABLE IF NOT EXISTS inquiry_evaluation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '评价ID',
    inquiry_id BIGINT NOT NULL COMMENT '问诊ID',
    patient_id BIGINT NOT NULL COMMENT '患者ID',
    doctor_id BIGINT NOT NULL COMMENT '医生ID',
    rating INT NOT NULL COMMENT '评分(1-5)',
    attitude_rating INT COMMENT '服务态度评分',
    professional_rating INT COMMENT '专业程度评分',
    speed_rating INT COMMENT '响应速度评分',
    content TEXT COMMENT '评价内容',
    images VARCHAR(500) COMMENT '评价图片',
    reply_content TEXT COMMENT '医生回复',
    reply_time DATETIME COMMENT '回复时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    UNIQUE KEY uk_inquiry_id (inquiry_id),
    FOREIGN KEY (inquiry_id) REFERENCES inquiry(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='问诊评价表';

-- ============================================
-- 处方相关表
-- ============================================

-- 处方表
CREATE TABLE IF NOT EXISTS prescription (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '处方ID',
    prescription_no VARCHAR(50) NOT NULL UNIQUE COMMENT '处方单号',
    inquiry_id BIGINT COMMENT '问诊ID',
    doctor_id BIGINT NOT NULL COMMENT '开方医生ID',
    patient_id BIGINT NOT NULL COMMENT '患者ID',
    diagnosis TEXT COMMENT '诊断',
    diagnosis_code VARCHAR(50) COMMENT '诊断编码(ICD-10)',
    disease_name VARCHAR(100) COMMENT '疾病名称',
    total_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT '处方总金额',
    valid_days INT DEFAULT 7 COMMENT '有效期(天)',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-待审核 2-已通过 3-已拒绝 4-已作废 5-已购药',
    audit_remark TEXT COMMENT '审核备注',
    auditor_id BIGINT COMMENT '审核药师ID',
    audit_time DATETIME COMMENT '审核时间',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_inquiry_id (inquiry_id),
    INDEX idx_doctor_id (doctor_id),
    INDEX idx_patient_id (patient_id),
    FOREIGN KEY (inquiry_id) REFERENCES inquiry(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='处方表';

-- 处方药品明细表
CREATE TABLE IF NOT EXISTS prescription_drug (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    prescription_id BIGINT NOT NULL COMMENT '处方ID',
    drug_id BIGINT NOT NULL COMMENT '药品ID',
    drug_name VARCHAR(100) NOT NULL COMMENT '药品名称',
    drug_spec VARCHAR(100) COMMENT '规格',
    manufacturer VARCHAR(200) COMMENT '生产厂家',
    unit VARCHAR(20) COMMENT '单位',
    quantity DECIMAL(10,2) NOT NULL COMMENT '数量',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额',
    usage VARCHAR(200) COMMENT '用法用量',
    frequency VARCHAR(100) COMMENT '用药频率',
    course_days INT COMMENT '疗程(天)',
    remark TEXT COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (prescription_id) REFERENCES prescription(id),
    FOREIGN KEY (drug_id) REFERENCES drug(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='处方药品明细表';

-- 药品表
CREATE TABLE IF NOT EXISTS drug (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '药品ID',
    drug_code VARCHAR(50) COMMENT '药品编码',
    drug_name VARCHAR(100) NOT NULL COMMENT '药品名称',
    common_name VARCHAR(100) COMMENT '通用名',
    drug_spec VARCHAR(100) COMMENT '规格',
    manufacturer VARCHAR(200) COMMENT '生产厂家',
    approval_number VARCHAR(50) COMMENT '批准文号',
    drug_type VARCHAR(20) COMMENT '药品类型',
    unit VARCHAR(20) COMMENT '单位',
    price DECIMAL(10,2) NOT NULL COMMENT '价格',
    stock INT DEFAULT 0 COMMENT '库存',
    image VARCHAR(255) COMMENT '图片',
    instructions TEXT COMMENT '说明书',
    contraindications TEXT COMMENT '禁忌',
    adverse_reaction TEXT COMMENT '不良反应',
    storage_conditions VARCHAR(200) COMMENT '储存条件',
    shelf_life VARCHAR(50) COMMENT '保质期',
    status TINYINT DEFAULT 1 COMMENT '状态: 1-上架 0-下架',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='药品表';

-- ============================================
-- 订单相关表
-- ============================================

-- 订单表
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '订单ID',
    order_no VARCHAR(50) NOT NULL UNIQUE COMMENT '订单号',
    order_type TINYINT NOT NULL COMMENT '订单类型: 1-问诊订单 2-药品订单 3-挂号订单',
    patient_id BIGINT NOT NULL COMMENT '患者ID',
    doctor_id BIGINT COMMENT '医生ID(问诊订单)',
    inquiry_id BIGINT COMMENT '问诊ID',
    total_amount DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
    discount_amount DECIMAL(10,2) DEFAULT 0.00 COMMENT '优惠金额',
    pay_amount DECIMAL(10,2) NOT NULL COMMENT '实付金额',
    pay_status TINYINT DEFAULT 0 COMMENT '支付状态: 0-待支付 1-已支付 2-已退款',
    pay_time DATETIME COMMENT '支付时间',
    pay_method VARCHAR(20) COMMENT '支付方式',
    transaction_id VARCHAR(100) COMMENT '支付流水号',
    remark TEXT COMMENT '订单备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_patient_id (patient_id),
    INDEX idx_order_no (order_no),
    INDEX idx_pay_status (pay_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- 订单明细表
CREATE TABLE IF NOT EXISTS order_item (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '明细ID',
    order_id BIGINT NOT NULL COMMENT '订单ID',
    item_type TINYINT NOT NULL COMMENT '类型: 1-问诊 2-药品',
    item_id BIGINT NOT NULL COMMENT '商品ID(问诊ID或药品ID)',
    item_name VARCHAR(200) NOT NULL COMMENT '商品名称',
    quantity INT DEFAULT 1 COMMENT '数量',
    price DECIMAL(10,2) NOT NULL COMMENT '单价',
    amount DECIMAL(10,2) NOT NULL COMMENT '金额',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- 支付记录表
CREATE TABLE IF NOT EXISTS payment (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '支付ID',
    payment_no VARCHAR(50) NOT NULL UNIQUE COMMENT '支付单号',
    order_id BIGINT NOT NULL COMMENT '订单ID',
    order_no VARCHAR(50) NOT NULL COMMENT '订单号',
    pay_amount DECIMAL(10,2) NOT NULL COMMENT '支付金额',
    pay_method VARCHAR(20) NOT NULL COMMENT '支付方式',
    pay_status TINYINT NOT NULL COMMENT '支付状态: 0-待支付 1-成功 2-失败 3-取消',
    pay_time DATETIME COMMENT '支付时间',
    trade_no VARCHAR(100) COMMENT '第三方交易号',
    channel VARCHAR(20) COMMENT '支付渠道',
    client_ip VARCHAR(50) COMMENT '客户端IP',
    remark TEXT COMMENT '备注',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_order_id (order_id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='支付记录表';

-- ============================================
-- 初始数据
-- ============================================

-- 插入科室数据
INSERT INTO department (name, code, parent_id, sort) VALUES
('内科', 'DEPT_INT', 0, 1),
('外科', 'DEPT_SUR', 0, 2),
('儿科', 'DEPT_PED', 0, 3),
('妇产科', 'DEPT_OBS', 0, 4),
('皮肤科', 'DEPT_DER', 0, 5),
('五官科', 'DEPT_EENT', 0, 6),
('骨科', 'DEPT_ORTH', 0, 7),
('神经科', 'DEPT_NEU', 0, 8),
('心血管科', 'DEPT_CAR', 0, 9),
('消化内科', 'DEPT_GAS', 1, 10),
('呼吸内科', 'DEPT_RES', 1, 11);

-- 插入测试管理员账号 (密码: admin123, BCrypt加密)
INSERT INTO sys_user (username, password, phone, real_name, user_type, status) VALUES
('admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt1yCvo', '13800138000', '系统管理员', 4, 1);

SELECT '数据库 hospital_online 初始化完成!' AS '执行结果';
