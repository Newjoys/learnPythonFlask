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
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE SET NULL,
    INDEX idx_dept_role_name (name)    -- 查询角色
);

-- 员工信息表：存储员工的个人信息
CREATE TABLE emp_info (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,      -- 员工ID（主键）
    emp_no VARCHAR(100) NOT NULL,                        -- 员工编号
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
    FOREIGN KEY (manager_id) REFERENCES emp_info(emp_id) ON DELETE SET NULL,
    INDEX idx_emp_info_emp_no (emp_no),
    INDEX idx_emp_info_dept_id (dept_id),
    INDEX idx_emp_info_phone (phone)
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
    FOREIGN KEY (dept_id) REFERENCES dept(dept_id) ON DELETE CASCADE,
    INDEX idx_dept_emp_emp_id (emp_id),
    INDEX idx_dept_emp_dept_id (dept_id),
    INDEX idx_dept_emp_join_date (join_date) -- ?关联表和信息表建立索引？
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
    del_flag BOOLEAN DEFAULT 0,                   -- 删除标记（0：未删除，1：已删除）
    INDEX idx_supplier_info_company_name (company_name),  -- 按名称查找供应商
    INDEX idx_supplier_info_supplier_no (supplier_no)
);

-- 物料类型表：存储物料的类型信息
CREATE TABLE material_type (
    type_id INT PRIMARY KEY AUTO_INCREMENT,    -- 类型ID
    name VARCHAR(255) NOT NULL,                -- 类型名称
    description TEXT,                          -- 描述
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                 -- 删除标记（0：未删除，1：已删除）
    INDEX idx_material_type_name (name)         -- 物料分类
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
    FOREIGN KEY (type_id) REFERENCES material_type(type_id) ON DELETE SET NULL,
    INDEX idx_material_info_code (code),
    INDEX idx_material_info_name (name),
    INDEX idx_material_info_type_id (type_id),
    INDEX idx_material_info_current_stock (current_stock)     -- 找低库存或高库存物
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
    FOREIGN KEY (material_id) REFERENCES material_info(material_id) ON DELETE CASCADE,
    INDEX idx_supplier_material_supplier_id (supplier_id),
    INDEX idx_supplier_material_material_id (material_id)    -- 找某物料的供应商

);

-- 采购单业务表：存储采购单的业务信息
CREATE TABLE purchase_order (
    order_id INT PRIMARY KEY AUTO_INCREMENT,    -- 采购单唯一标识
    supplier_id INT NOT NULL,                   -- 供应商ID（外键）
    status TINYINT NOT NULL,                   -- 订单状态（枚举：已审批、已签订、部分入库、全部入库）
    complete_date DATE,                        -- 订单完成日期
    emp_id INT,                            -- 负责人ID（外键）
    create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 创建时间
    update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 更新时间
    del_flag BOOLEAN DEFAULT 0,                  -- 删除标记（0：未删除，1：已删除）
    FOREIGN KEY (supplier_id) REFERENCES supplier_info(supplier_id) ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES emp_info(emp_id) ON DELETE SET NULL,
    INDEX idx_purchase_order_supplier_id (supplier_id),
    INDEX idx_purchase_order_manager_id (emp_id),
    INDEX idx_purchase_order_status (status)
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
    FOREIGN KEY (material_id) REFERENCES material_info(material_id) ON DELETE CASCADE,
    INDEX idx_purchase_order_detail_order_id (order_id),
    INDEX idx_purchase_order_detail_material_id (material_id)
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
    FOREIGN KEY (manager_id) REFERENCES emp_info(emp_id) ON DELETE CASCADE,
    INDEX idx_inventory_record_material_id (material_id),     -- 物料和库存变动记录
    INDEX idx_inventory_record_manager_id (manager_id),       -- 库存变动-管理员
    INDEX idx_inventory_record_change_date (change_date)
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