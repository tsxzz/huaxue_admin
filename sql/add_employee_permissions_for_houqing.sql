-- 为后勤人员角色添加员工管理权限
-- 后勤人员角色权限字符：houqing

-- 1. 更新员工管理主菜单，添加权限标识
UPDATE sys_menu 
SET perms = 'system:employee:list' 
WHERE menu_id = 2013 AND (perms IS NULL OR perms = '');

-- 2. 创建员工管理的按钮权限菜单（如果不存在）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '员工查询', 2013, 1, '', '', 'F', '0', '0', 'system:employee:query', '#', 'admin', NOW(), '员工查询按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:query');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '员工新增', 2013, 2, '', '', 'F', '0', '0', 'system:employee:add', '#', 'admin', NOW(), '员工新增按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:add');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '员工修改', 2013, 3, '', '', 'F', '0', '0', 'system:employee:edit', '#', 'admin', NOW(), '员工修改按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:edit');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '员工删除', 2013, 4, '', '', 'F', '0', '0', 'system:employee:remove', '#', 'admin', NOW(), '员工删除按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:remove');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '重置密码', 2013, 5, '', '', 'F', '0', '0', 'system:employee:resetPwd', '#', 'admin', NOW(), '重置密码按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:resetPwd');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '员工导出', 2013, 6, '', '', 'F', '0', '0', 'system:employee:export', '#', 'admin', NOW(), '员工导出按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:employee:export');

-- 3. 为后勤人员角色分配员工管理权限
-- 先删除可能存在的旧权限（避免重复）
DELETE rm FROM sys_role_menu rm
INNER JOIN sys_role r ON rm.role_id = r.role_id
INNER JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_key = 'houqing'
  AND (m.menu_id = 2013 OR m.perms LIKE 'system:employee:%');

-- 插入新的权限（主菜单 + 所有按钮权限）
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 
    r.role_id,
    m.menu_id
FROM sys_role r
CROSS JOIN sys_menu m
WHERE r.role_key = 'houqing'
  AND (m.menu_id = 2013 OR m.perms IN ('system:employee:list', 'system:employee:query', 'system:employee:add', 'system:employee:edit', 'system:employee:remove', 'system:employee:resetPwd', 'system:employee:export'))
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu rm2 
      WHERE rm2.role_id = r.role_id AND rm2.menu_id = m.menu_id
  );

-- 验证：查询后勤人员角色的员工管理权限
SELECT rm.role_id, r.role_name, r.role_key, m.menu_id, m.menu_name, m.perms
FROM sys_role_menu rm
JOIN sys_role r ON rm.role_id = r.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_key = 'houqing' 
  AND (m.menu_id = 2013 OR m.perms LIKE 'system:employee:%')
ORDER BY m.menu_id;
