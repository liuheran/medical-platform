// 在线问诊平台 - 模拟数据

// 用户类型
const USER_TYPE = {
    PATIENT: 1,
    DOCTOR: 2,
    PHARMACIST: 3,
    ADMIN: 4
};

// 问诊状态
const INQUIRY_STATUS = {
    PENDING_PAY: 1,      // 待支付
    PENDING_ACCEPT: 2,   // 待接诊
    IN_PROGRESS: 3,      // 问诊中
    PENDING_PICKUP: 4,   // 待取药
    COMPLETED: 5,        // 已完成
    CANCELLED: 6         // 已取消
};

const INQUIRY_STATUS_TEXT = {
    1: '待支付',
    2: '待接诊',
    3: '问诊中',
    4: '待取药',
    5: '已完成',
    6: '已取消'
};

// 问诊类型
const INQUIRY_TYPE = {
    TEXT: 1,     // 图文问诊
    VOICE: 2,    // 语音问诊
    VIDEO: 3     // 视频问诊
};

const INQUIRY_TYPE_TEXT = {
    1: '图文问诊',
    2: '语音问诊',
    3: '视频问诊'
};

// 订单状态
const ORDER_STATUS = {
    PENDING_PAY: 1,
    PENDING_DELIVERY: 2,
    DELIVERING: 3,
    DELIVERED: 4,
    COMPLETED: 5,
    CANCELLED: 6,
    REFUNDING: 7,
    REFUNDED: 8
};

const ORDER_STATUS_TEXT = {
    1: '待支付',
    2: '待发货',
    3: '配送中',
    4: '待收货',
    5: '已完成',
    6: '已取消',
    7: '退款中',
    8: '已退款'
};

// 处方状态
const PRESCRIPTION_STATUS = {
    PENDING_AUDIT: 1,
    AUDIT_PASS: 2,
    AUDIT_REJECT: 3,
    EXPIRED: 4
};

const PRESCRIPTION_STATUS_TEXT = {
    1: '审核中',
    2: '审核通过',
    3: '审核拒绝',
    4: '已过期'
};

// 科室数据
const DEPARTMENTS = [
    {
        id: 1,
        name: '内科',
        icon: 'heart',
        children: [
            { id: 11, name: '心内科' },
            { id: 12, name: '消化内科' },
            { id: 13, name: '神经内科' },
            { id: 14, name: '呼吸内科' }
        ]
    },
    {
        id: 2,
        name: '外科',
        icon: 'scissors',
        children: [
            { id: 21, name: '普外科' },
            { id: 22, name: '骨科' },
            { id: 23, name: '神经外科' }
        ]
    },
    {
        id: 3,
        name: '儿科',
        icon: 'baby',
        children: [
            { id: 31, name: '儿童内科' },
            { id: 32, name: '儿童外科' }
        ]
    },
    {
        id: 4,
        name: '妇科',
        icon: 'woman',
        children: [
            { id: 41, name: '妇科' },
            { id: 42, name: '产科' }
        ]
    },
    {
        id: 5,
        name: '皮肤科',
        icon: 'skin',
        children: [
            { id: 51, name: '皮肤科' }
        ]
    },
    {
        id: 6,
        name: '眼科',
        icon: 'eye',
        children: []
    },
    {
        id: 7,
        name: '耳鼻喉科',
        icon: 'ear',
        children: []
    },
    {
        id: 8,
        name: '口腔科',
        icon: 'tooth',
        children: []
    }
];

// 医生数据
const DOCTORS = [
    {
        id: 1001,
        name: '王建国',
        title: '主任医师',
        titleLevel: 1,
        departmentId: 11,
        departmentName: '心内科',
        hospitalName: '北京协和医院',
        hospitalLevel: '三甲',
        specialty: '高血压、冠心病、心律失常',
        avatar: 'https://i.pravatar.cc/150?img=1',
        rating: 4.9,
        reviewCount: 256,
        consultationCount: 2560,
        price: 30.00,
        videoPrice: 80.00,
        voicePrice: 50.00,
        isOnline: true,
        isAccepting: true,
        introduction: '从事心血管内科临床工作30年，擅长高血压、冠心病等疾病的诊治。曾在美国梅奥诊所进修，发表SCI论文20余篇。',
        experienceYears: 30,
        tags: ['态度好', '有耐心', '专业']
    },
    {
        id: 1002,
        name: '李秀芳',
        title: '副主任医师',
        titleLevel: 2,
        departmentId: 12,
        departmentName: '消化内科',
        hospitalName: '北京大学第一医院',
        hospitalLevel: '三甲',
        specialty: '胃炎、胃溃疡、肠炎',
        avatar: 'https://i.pravatar.cc/150?img=5',
        rating: 4.8,
        reviewCount: 189,
        consultationCount: 1890,
        price: 25.00,
        videoPrice: 60.00,
        voicePrice: 40.00,
        isOnline: true,
        isAccepting: true,
        introduction: '专注消化系统疾病诊治20年，擅长胃肠道疾病的诊疗。',
        experienceYears: 20,
        tags: ['经验丰富', '讲解详细']
    },
    {
        id: 1003,
        name: '张明华',
        title: '主治医师',
        titleLevel: 3,
        departmentId: 13,
        departmentName: '神经内科',
        hospitalName: '首都医科大学宣武医院',
        hospitalLevel: '三甲',
        specialty: '头痛、头晕、脑血管病',
        avatar: 'https://i.pravatar.cc/150?img=3',
        rating: 4.7,
        reviewCount: 156,
        consultationCount: 1560,
        price: 20.00,
        videoPrice: 50.00,
        voicePrice: 30.00,
        isOnline: false,
        isAccepting: false,
        introduction: '专注神经系统疾病诊治，擅长头痛、头晕等常见症状的诊断。',
        experienceYears: 12,
        tags: ['年轻有为', '回复快']
    },
    {
        id: 1004,
        name: '陈晓燕',
        title: '主任医师',
        titleLevel: 1,
        departmentId: 31,
        departmentName: '儿童内科',
        hospitalName: '北京儿童医院',
        hospitalLevel: '三甲',
        specialty: '儿童呼吸道疾病、消化系统疾病',
        avatar: 'https://i.pravatar.cc/150?img=9',
        rating: 4.9,
        reviewCount: 320,
        consultationCount: 3200,
        price: 35.00,
        videoPrice: 90.00,
        voicePrice: 60.00,
        isOnline: true,
        isAccepting: true,
        introduction: '从事儿科临床工作25年，对儿童常见病、多发病有丰富的诊治经验。',
        experienceYears: 25,
        tags: ['和蔼可亲', '经验丰富', '专业']
    },
    {
        id: 1005,
        name: '刘国庆',
        title: '副主任医师',
        titleLevel: 2,
        departmentId: 21,
        departmentName: '骨科',
        hospitalName: '北京积水潭医院',
        hospitalLevel: '三甲',
        specialty: '骨折、骨关节炎、运动损伤',
        avatar: 'https://i.pravatar.cc/150?img=8',
        rating: 4.8,
        reviewCount: 210,
        consultationCount: 2100,
        price: 28.00,
        videoPrice: 70.00,
        voicePrice: 45.00,
        isOnline: true,
        isAccepting: false,
        introduction: '专注骨科运动医学，擅长关节疾病的微创治疗。',
        experienceYears: 18,
        tags: ['技术精湛', '耐心解答']
    },
    {
        id: 1006,
        name: '孙丽华',
        title: '主治医师',
        titleLevel: 3,
        departmentId: 41,
        departmentName: '妇科',
        hospitalName: '北京妇产医院',
        hospitalLevel: '三甲',
        specialty: '妇科炎症、月经不调、更年期',
        avatar: 'https://i.pravatar.cc/150?img=16',
        rating: 4.6,
        reviewCount: 145,
        consultationCount: 1450,
        price: 22.00,
        videoPrice: 55.00,
        voicePrice: 35.00,
        isOnline: false,
        isAccepting: false,
        introduction: '专注妇科常见病诊治，擅长妇科炎症和内分泌疾病。',
        experienceYears: 10,
        tags: ['温柔细心', '专业']
    }
];

// 药品数据
const DRUGS = [
    {
        id: 1001,
        name: '硝苯地平缓释片',
        commonName: '硝苯地平缓释片(II)',
        specification: '20mg*30片',
        manufacturer: '拜耳医药保健有限公司',
        price: 35.00,
        originalPrice: 45.00,
        image: 'https://via.placeholder.com/100x100/E6F7FF/1890FF?text=药',
        drugType: 1,
        drugTypeName: '处方药',
        prescriptionRequired: true,
        stock: 100,
        salesCount: 5000,
        isHot: true
    },
    {
        id: 1002,
        name: '缬沙坦胶囊',
        commonName: '缬沙坦胶囊',
        specification: '80mg*7片',
        manufacturer: '诺华制药有限公司',
        price: 40.00,
        originalPrice: 50.00,
        image: 'https://via.placeholder.com/100x100/E6F7FF/1890FF?text=药',
        drugType: 1,
        drugTypeName: '处方药',
        prescriptionRequired: true,
        stock: 80,
        salesCount: 3500,
        isHot: true
    },
    {
        id: 1003,
        name: '奥美拉唑肠溶胶囊',
        commonName: '奥美拉唑肠溶胶囊',
        specification: '20mg*14粒',
        manufacturer: '阿斯利康制药有限公司',
        price: 28.00,
        originalPrice: 35.00,
        image: 'https://via.placeholder.com/100x100/E6F7FF/1890FF?text=药',
        drugType: 1,
        drugTypeName: '处方药',
        prescriptionRequired: true,
        stock: 120,
        salesCount: 2800,
        isHot: false
    },
    {
        id: 1004,
        name: '复方氨酚烷胺片',
        commonName: '复方氨酚烷胺片',
        specification: '12片/盒',
        manufacturer: '海南康力制药有限公司',
        price: 12.00,
        originalPrice: 15.00,
        image: 'https://via.placeholder.com/100x100/E6F7FF/1890FF?text=药',
        drugType: 2,
        drugTypeName: 'OTC',
        prescriptionRequired: false,
        stock: 200,
        salesCount: 8000,
        isHot: true
    },
    {
        id: 1005,
        name: '维生素C片',
        commonName: '维生素C片',
        specification: '100mg*100片',
        manufacturer: '华中药业股份有限公司',
        price: 8.00,
        originalPrice: 10.00,
        image: 'https://via.placeholder.com/100x100/E6F7FF/1890FF?text=药',
        drugType: 2,
        drugTypeName: 'OTC',
        prescriptionRequired: false,
        stock: 500,
        salesCount: 15000,
        isHot: false
    }
];

// 健康资讯
const HEALTH_NEWS = [
    {
        id: 1,
        title: '高血压患者如何科学饮食',
        cover: 'https://via.placeholder.com/300x200/E6F7FF/1890FF?text=饮食',
        source: '健康指南',
        publishTime: '2026-05-10',
        viewCount: 1256
    },
    {
        id: 2,
        title: '夏季养生：这些习惯要养成',
        cover: 'https://via.placeholder.com/300x200/E6F7FF/52C41A?text=养生',
        source: '中医养生',
        publishTime: '2026-05-09',
        viewCount: 2345
    },
    {
        id: 3,
        title: '如何预防心血管疾病',
        cover: 'https://via.placeholder.com/300x200/E6F7FF/FA8C16?text=预防',
        source: '心脑血管',
        publishTime: '2026-05-08',
        viewCount: 3456
    }
];

// 当前登录用户
let CURRENT_USER = null;

// 获取当前用户
function getCurrentUser() {
    if (CURRENT_USER) return CURRENT_USER;
    
    const userStr = localStorage.getItem('currentUser');
    if (userStr) {
        CURRENT_USER = JSON.parse(userStr);
        return CURRENT_USER;
    }
    return null;
}

// 设置当前用户
function setCurrentUser(user) {
    CURRENT_USER = user;
    localStorage.setItem('currentUser', JSON.stringify(user));
}

// 清除当前用户
function clearCurrentUser() {
    CURRENT_USER = null;
    localStorage.removeItem('currentUser');
}

// 检查是否已登录
function isLoggedIn() {
    return getCurrentUser() !== null;
}

// 模拟登录
function mockLogin(phone, password, userType = USER_TYPE.PATIENT) {
    // 简单模拟：任意手机号和6位以上密码即可登录
    if (phone && password && password.length >= 6) {
        const user = {
            userId: 10001,
            phone: phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2'),
            nickname: '用户' + phone.slice(-4),
            avatar: 'https://i.pravatar.cc/150?img=70',
            userType: userType,
            isRealName: false,
            balance: 100.00,
            integral: 500
        };
        setCurrentUser(user);
        return { success: true, data: user };
    }
    return { success: false, message: '手机号或密码错误' };
}

// 模拟医生登录
function mockDoctorLogin(phone, password) {
    return mockLogin(phone, password, USER_TYPE.DOCTOR);
}

// 模拟管理员登录
function mockAdminLogin(phone, password) {
    return mockLogin(phone, password, USER_TYPE.ADMIN);
}

// 显示提示
function showToast(message, duration = 2000) {
    let toast = document.querySelector('.toast');
    if (!toast) {
        toast = document.createElement('div');
        toast.className = 'toast';
        document.body.appendChild(toast);
    }
    toast.textContent = message;
    toast.classList.add('show');
    setTimeout(() => {
        toast.classList.remove('show');
    }, duration);
}

// 获取URL参数
function getUrlParams() {
    const params = {};
    const searchParams = new URLSearchParams(window.location.search);
    for (const [key, value] of searchParams) {
        params[key] = value;
    }
    return params;
}

// 跳转到页面
function goTo(url) {
    window.location.href = url;
}

// 返回上一页
function goBack() {
    if (window.history.length > 1) {
        window.history.back();
    } else {
        window.location.href = 'index.html';
    }
}

// 格式化金额
function formatMoney(amount) {
    return '¥' + parseFloat(amount).toFixed(2);
}

// 格式化日期
function formatDate(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleDateString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit'
    });
}

// 格式化时间
function formatDateTime(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
}

// 获取相对时间
function getRelativeTime(dateStr) {
    if (!dateStr) return '';
    const date = new Date(dateStr);
    const now = new Date();
    const diff = now - date;
    
    const minutes = Math.floor(diff / 60000);
    const hours = Math.floor(diff / 3600000);
    const days = Math.floor(diff / 86400000);
    
    if (minutes < 1) return '刚刚';
    if (minutes < 60) return minutes + '分钟前';
    if (hours < 24) return hours + '小时前';
    if (days < 7) return days + '天前';
    return formatDate(dateStr);
}
