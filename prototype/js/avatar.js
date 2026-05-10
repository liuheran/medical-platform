/**
 * 生成默认头像（SVG格式）
 * @param {string} name - 用户姓名
 * @param {string} bgColor - 背景颜色（可选）
 * @returns {string} - SVG头像的data URI
 */
function generateAvatar(name, bgColor) {
    // 获取姓名的首字母
    const initial = name.charAt(0).toUpperCase();
    
    // 生成颜色（基于姓名）
    const colors = ['#1890ff', '#52c41a', '#fa8c16', '#f5222d', '#722ed1', '#13c2c2', '#eb2f96', '#faad14'];
    const colorIndex = name.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0) % colors.length;
    const color = bgColor || colors[colorIndex];
    
    // 生成SVG
    const svg = `
        <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
            <rect width="100" height="100" fill="${color}" rx="50"/>
            <text x="50" y="50" dy="0.35em" text-anchor="middle" fill="#fff" font-family="Arial, sans-serif" font-size="40" font-weight="bold">${initial}</text>
        </svg>
    `.trim();
    
    return 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svg)));
}

/**
 * 生成患者头像URL
 * @param {string} name - 患者姓名
 * @param {number} id - 患者ID（可选，用于生成固定颜色）
 * @returns {string} - 头像URL或SVG data URI
 */
function getPatientAvatar(name, id) {
    // 尝试使用 pravatar.cc 服务
    const avatarId = id || name.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0) % 70 + 1;
    return `https://i.pravatar.cc/100?img=${avatarId}`;
}

/**
 * 初始化页面上所有的头像
 * @param {string} containerSelector - 容器选择器
 * @param {string} avatarSelector - 头像元素选择器
 * @param {Array} data - 数据数组
 * @param {string} nameField - 姓名字段名
 */
function initAvatars(containerSelector, avatarSelector, data, nameField = 'name') {
    const container = document.querySelector(containerSelector);
    if (!container) return;
    
    const avatars = container.querySelectorAll(avatarSelector);
    avatars.forEach((avatar, index) => {
        if (data[index]) {
            const name = data[index][nameField] || data[index].patient?.name || 'U';
            avatar.src = generateAvatar(name);
            avatar.onerror = function() {
                // 如果SVG也失败，使用纯色背景
                this.src = generateAvatar(name);
            };
        }
    });
}
