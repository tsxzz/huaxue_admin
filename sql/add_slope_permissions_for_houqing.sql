-- 为后勤人员角色添加雪道维护权限
-- 后勤人员角色权限字符：houqing

-- 1. 更新雪道维护主菜单，添加权限标识
UPDATE sys_menu 
SET perms = 'system:slope:list' 
WHERE menu_id = 2011 AND (perms IS NULL OR perms = '');

-- 2. 创建雪道维护的按钮权限菜单（如果不存在）
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '雪道查询', 2011, 1, '', '', 'F', '0', '0', 'system:slope:query', '#', 'admin', NOW(), '雪道查询按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:slope:query');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '雪道新增', 2011, 2, '', '', 'F', '0', '0', 'system:slope:add', '#', 'admin', NOW(), '雪道新增按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:slope:add');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '雪道修改', 2011, 3, '', '', 'F', '0', '0', 'system:slope:edit', '#', 'admin', NOW(), '雪道修改按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:slope:edit');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '雪道删除', 2011, 4, '', '', 'F', '0', '0', 'system:slope:remove', '#', 'admin', NOW(), '雪道删除按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:slope:remove');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, menu_type, visible, status, perms, icon, create_by, create_time, remark)
SELECT '雪道导出', 2011, 5, '', '', 'F', '0', '0', 'system:slope:export', '#', 'admin', NOW(), '雪道导出按钮'
WHERE NOT EXISTS (SELECT 1 FROM sys_menu WHERE perms = 'system:slope:export');

-- 3. 为后勤人员角色分配雪道维护权限
-- 先删除可能存在的旧权限（避免重复）
DELETE rm FROM sys_role_menu rm
INNER JOIN sys_role r ON rm.role_id = r.role_id
INNER JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_key = 'houqing'
  AND (m.menu_id = 2011 OR m.perms LIKE 'system:slope:%');

-- 插入新的权限（主菜单 + 所有按钮权限）
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 
    r.role_id,
    m.menu_id
FROM sys_role r
CROSS JOIN sys_menu m
WHERE r.role_key = 'houqing'
  AND (m.menu_id = 2011 OR m.perms IN ('system:slope:list', 'system:slope:query', 'system:slope:add', 'system:slope:edit', 'system:slope:remove', 'system:slope:export'))
  AND NOT EXISTS (
      SELECT 1 FROM sys_role_menu rm2 
      WHERE rm2.role_id = r.role_id AND rm2.menu_id = m.menu_id
  );

-- 验证：查询后勤人员角色的雪道维护权限
SELECT rm.role_id, r.role_name, r.role_key, m.menu_id, m.menu_name, m.perms
FROM sys_role_menu rm
JOIN sys_role r ON rm.role_id = r.role_id
JOIN sys_menu m ON rm.menu_id = m.menu_id
WHERE r.role_key = 'houqing' 
  AND (m.menu_id = 2011 OR m.perms LIKE 'system:slope:%')
ORDER BY m.menu_id;
