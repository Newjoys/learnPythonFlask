USE erp_v2;
-- 部门表：存储公司中不同部门的信息
CREATE TABLE dept (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,   -- 部门ID（主键）
    name VARCHAR(255) NOT NULL,               -- 部门名称
    parent_id INT,                            -- 上级部门ID（外键，指向自身）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (parent_id) REFERENCES dept(dept_id) ON DELETE SET NULL
);

-- 部门角色表：存储公司中部门的角色信息
CREATE TABLE dept_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,  -- 角色ID（主键）
    name VARCHAR(255) NOT NULL,              -- 角色名称
    dept_id INT,                             -- 所属部门ID（外键）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,               -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE SET NULL
);

-- 员工信息表：存储员工的个人信息
CREATE TABLE emp_info (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,      -- 员工ID（主键）
    emp_no VARCHAR(100),                        -- 员工编号
    name VARCHAR(255) NOT NULL,                 -- 员工姓名
    position VARCHAR(255),                      -- 职位
    dept_id INT,                               -- 所属部门ID（外键）
    manager_id INT,                            -- 直接上级ID（外键，指向自身表）
    email VARCHAR(255),                        -- 邮箱
    phone VARCHAR(20),                         -- 联系电话
    hire_date DATE,                            -- 入职日期
    birth_date DATE,                           -- 出生日期
    salary DECIMAL(10, 2),                     -- 薪水
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                 -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE SET NULL,
    FOREIGN KEY (manager_id) REFERENCES emp_info(emp_id) ON DELETE SET NULL
);

-- 部门员工关联表：存储员工与多个部门的关联关系
CREATE TABLE dept_emp (
    record_id INT PRIMARY KEY AUTO_INCREMENT,  -- 记录ID
    emp_id INT NOT NULL,                       -- 员工ID（外键）
    dept_id INT NOT NULL,                      -- 部门ID（外键）
    join_date DATE,                           -- 进入部门日期
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                 -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (emp_id) REFERENCES emp_info(emp_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE CASCADE
);

-- 供应商基础信息表：存储供应商的基本信息
CREATE TABLE supplier_info (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,  -- 供应商ID
    supplier_no VARCHAR(100),                    -- 供应商编号
    company_name VARCHAR(255) NOT NULL,          -- 企业名称
    short_name VARCHAR(100),                     -- 企业简称
    tax_no VARCHAR(50),                          -- 纳税人识别号
    contact VARCHAR(255),                        -- 联系人
    phone VARCHAR(20),                           -- 联系电话
    address VARCHAR(255),                        -- 地址
    bank_acc VARCHAR(50),                        -- 账号
    bank_name VARCHAR(255),                      -- 开户行
    payment_terms TEXT,                          -- 付款条款
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0                   -- 删除标记（0：未删除，1：已删除）
);

-- 物料类型表：存储物料的类型信息
CREATE TABLE material_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,    -- 类型ID
    name VARCHAR(255) NOT NULL,                -- 类型名称
    description TEXT,                          -- 描述
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0                 -- 删除标记（0：未删除，1：已删除）
);

-- 物料信息表：存储物料的详细信息
CREATE TABLE material_info (
    material_id INT PRIMARY KEY AUTO_INCREMENT,  -- 物料ID
    code VARCHAR(100),                          -- 物料编码
    name VARCHAR(255) NOT NULL,                 -- 物料名称
    type_id INT,                               -- 物料类型ID（外键）
    spec VARCHAR(255),                         -- 规格型号
    unit VARCHAR(50),                          -- 单位（如千克、吨等）
    min_stock INT,                             -- 最小库存水位线
    current_stock INT,                         -- 当前库存数量
    avg_price DECIMAL(10, 2),                  -- 平均价格
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                 -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (type_id) REFERENCES material_type(type_id) ON DELETE SET NULL
);

-- 供应商物料关联表：存储供应商与物料的关联关系
CREATE TABLE supplier_material (
    record_id INT PRIMARY KEY AUTO_INCREMENT,   -- 记录ID
    supplier_id INT NOT NULL,                   -- 供应商ID（外键）
    material_id INT NOT NULL,                   -- 物料ID（外键）
    avg_delivery_days INT,                      -- 平均交货期（天数）
    avg_price DECIMAL(10, 2),                   -- 平均价格
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                   -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (supplier_id) REFERENCES supplier_info(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES material_info(material_id) ON DELETE CASCADE
);

-- 采购单业务表：存储采购单的业务信息
CREATE TABLE purchase_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,    -- 采购单唯一标识
    supplier_id INT NOT NULL,                   -- 供应商ID（外键）
    status TINYINT NOT NULL,                   -- 订单状态（枚举：已审批、已签订、部分入库、全部入库）
    complete_date DATE,                        -- 订单完成日期
    manager_id INT,                            -- 负责人ID（外键）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                  -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (supplier_id) REFERENCES supplier_info(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES emp_info(emp_id) ON DELETE SET NULL
);

-- 采购单明细表：存储采购单的详细信息
CREATE TABLE purchase_order_detail (
    detail_id INT PRIMARY KEY AUTO_INCREMENT,   -- 明细唯一标识
    order_id INT NOT NULL,                      -- 采购单ID（外键）
    material_id INT NOT NULL,                   -- 物料ID（外键）
    quantity INT NOT NULL,                      -- 采购数量
    detail_status TINYINT NOT NULL,             -- 明细状态（枚举：0未入库、1全部入库）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                  -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (order_id) REFERENCES purchase_order(order_id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES material_info(material_id) ON DELETE CASCADE
);

-- 库存记录表：存储库存变更记录
CREATE TABLE inventory_record (
    record_id INT PRIMARY KEY AUTO_INCREMENT,   -- 库存记录唯一标识
    material_id INT NOT NULL,                   -- 物料ID
    change_qty INT NOT NULL,                    -- 库存变更数量
    change_type TINYINT NOT NULL,               -- 变更类型（枚举：0入库、1出库、2报损）
    change_date DATE NOT NULL,                  -- 变更日期
    manager_id INT NOT NULL,                    -- 变更操作员ID（外键）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                   -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (material_id) REFERENCES material_info(material_id) ON DELETE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES emp_info(emp_id) ON DELETE CASCADE
);

-- Role-Based Access Control系统权限管理
-- 系统用户表
CREATE TABLE sys_user (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,  -- 加密存储
    role_id INT,  -- 外键，指向角色表
    dept_id INT,  -- 部门ID，外键指向部门表
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    delete_flag BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (role_id) REFERENCES sys_role(role_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE CASCADE
);

-- 系统角色表
CREATE TABLE sys_role (
    -- 请购员”、“部门经理”、“采购员”、“总经理”
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL UNIQUE,  -- 角色名称，如"请购员"
    description TEXT,  -- 角色描述，如"负责创建请购单并提交审批"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    delete_flag BOOLEAN DEFAULT FALSE
);

-- 权限表
CREATE TABLE sys_permission (
    permission_id INT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(50) NOT NULL UNIQUE,  -- 权限名称，如"CREATE_REQUISITION_ORDER"
    description TEXT,  -- 权限描述，如"创建请购单的权限"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    delete_flag BOOLEAN DEFAULT FALSE
);
-- 系统用户权限表
CREATE TABLE role_permission_relation (
    role_permission_id INT PRIMARY KEY AUTO_INCREMENT,  -- 自增的主键
    role_id INT NOT NULL,  -- 外键，指向角色表（role表）
    permission_id INT NOT NULL,  -- 外键，指向权限表（permission表）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    delete_flag BOOLEAN DEFAULT FALSE,
    UNIQUE (role_id, permission_id),  -- 确保每个角色和权限的组合是唯一的
    FOREIGN KEY (role_id) REFERENCES sys_role(role_id),
    FOREIGN KEY (permission_id) REFERENCES sys_permission(permission_id)
);


-- 插入部门数据
INSERT INTO dept (name, parent_id, create_at, update_at, del_flag) VALUES
('技术部', NULL, NOW(), NOW(), 0),
('市场部', NULL, NOW(), NOW(), 0),
('财务部', NULL, NOW(), NOW(), 0),
('人事部', NULL, NOW(), NOW(), 0);

-- 插入部门角色数据
INSERT INTO dept_role (name, dept_id, create_at, update_at, del_flag) VALUES
('开发工程师', 1, NOW(), NOW(), 0),
('测试工程师', 1, NOW(), NOW(), 0),
('市场经理', 2, NOW(), NOW(), 0),
('财务主管', 3, NOW(), NOW(), 0),
('人事专员', 4, NOW(), NOW(), 0);

-- 插入员工信息数据
INSERT INTO emp_info (emp_no, name, position, dept_id, manager_id, email, phone, hire_date, birth_date, salary, create_at, update_at, del_flag) VALUES
('E001', '张三', '开发工程师', 1, NULL, 'zhangsan@example.com', '13800000001', '2023-01-01', '1990-01-01', 10000.00, NOW(), NOW(), 0),
('E002', '李四', '测试工程师', 1, 1, 'lisi@example.com', '13800000002', '2023-01-02', '1992-02-02', 9000.00, NOW(), NOW(), 0),
('E003', '王五', '市场经理', 2, NULL, 'wangwu@example.com', '13800000003', '2023-01-03', '1991-03-03', 12000.00, NOW(), NOW(), 0),
('E004', '赵六', '财务主管', 3, NULL, 'zhaoliu@example.com', '13800000004', '2023-01-04', '1989-04-04', 11000.00, NOW(), NOW(), 0),
('E005', '钱七', '人事专员', 4, 4, 'qianqi@example.com', '13800000005', '2023-01-05', '1993-05-05', 8000.00, NOW(), NOW(), 0);

-- 插入供应商数据
INSERT INTO supplier_info (supplier_no, company_name, short_name, tax_no, contact, phone, address, bank_acc, bank_name, payment_terms, create_at, update_at, del_flag) VALUES
('S001', '华为技术有限公司', '华为', '1234567890', '张经理', '13900000001', '深圳市华为大厦', '123456789', '华夏银行', '30天内付款', NOW(), NOW(), 0),
('S002', '阿里巴巴集团', '阿里', '0987654321', '李经理', '13900000002', '杭州市阿里大厦', '987654321', '招商银行', '30天内付款', NOW(), NOW(), 0);

-- 插入物料类型数据
INSERT INTO material_type (name, description, create_at, update_at, del_flag) VALUES
('电子元件', '用于电子设备的元件', NOW(), NOW(), 0),
('机械配件', '用于机械设备的配件', NOW(), NOW(), 0),
('办公用品', '日常办公所需用品', NOW(), NOW(), 0);

-- 插入物料信息数据
INSERT INTO material_info (code, name, type_id, spec, unit, min_stock, current_stock, avg_price, create_at, update_at, del_flag) VALUES
('M001', '电阻', 1, '1KΩ', '个', 100, 500, 0.1, NOW(), NOW(), 0),
('M002', '电容', 1, '100μF', '个', 50, 200, 0.5, NOW(), NOW(), 0),
('M003', '齿轮', 2, '标准', '个', 20, 100, 5.0, NOW(), NOW(), 0),
('M004', '打印纸', 3, 'A4', '包', 10, 50, 20.0, NOW(), NOW(), 0);

-- 插入采购单数据
INSERT INTO purchase_order (supplier_id, status, complete_date, manager_id, create_at, update_at, del_flag) VALUES
(1, 1, '2023-02-01', 4, NOW(), NOW(), 0),
(2, 0, NULL, 3, NOW(), NOW(), 0);

-- 插入采购单明细数据
INSERT INTO purchase_order_detail (order_id, material_id, quantity, detail_status, create_at, update_at, del_flag) VALUES
(1, 1, 100, 0, NOW(), NOW(), 0),
(1, 2, 200, 0, NOW(), NOW(), 0),
(2, 3, 50, 0, NOW(), NOW(), 0),
(2, 4, 20, 0, NOW(), NOW(), 0);

-- 插入库存记录数据
INSERT INTO inventory_record (material_id, change_qty, change_type, change_date, manager_id, create_at, update_at, del_flag) VALUES
(1, 100, 0, '2023-02-02', 4, NOW(), NOW(), 0),
(2, -50, 1, '2023-02-03', 4, NOW(), NOW(), 0),
(3, 30, 0, '2023-02-04', 3, NOW(), NOW(), 0);


-- 插入部门与员工的关联数据（dept_emp）
INSERT INTO dept_emp (emp_id, dept_id, join_date, create_at, update_at, del_flag) VALUES
(1, 1, '2024-01-10', NOW(), NOW(), 0),  -- 员工ID 1 加入部门ID 1
(2, 1, '2024-01-15', NOW(), NOW(), 0),  -- 员工ID 2 加入部门ID 1
(3, 2, '2024-01-20', NOW(), NOW(), 0),  -- 员工ID 3 加入部门ID 2
(4, 3, '2024-01-25', NOW(), NOW(), 0),  -- 员工ID 4 加入部门ID 3
(5, 4, '2024-02-01', NOW(), NOW(), 0);  -- 员工ID 5 加入部门ID 4

-- 插入供应商与物料的关联数据（supplier_material）
INSERT INTO supplier_material (supplier_id, material_id, avg_delivery_days, avg_price, create_at, update_at, del_flag) VALUES
(1, 1, 3, 0.10, NOW(), NOW(), 0),  -- 供应商ID 1 供应物料ID 1
(1, 2, 5, 0.50, NOW(), NOW(), 0),  -- 供应商ID 1 供应物料ID 2
(1, 3, 2, 5.00, NOW(), NOW(), 0),  -- 供应商ID 1 供应物料ID 3
(2, 4, 7, 20.00, NOW(), NOW(), 0); -- 供应商ID 2 供应物料ID 4
