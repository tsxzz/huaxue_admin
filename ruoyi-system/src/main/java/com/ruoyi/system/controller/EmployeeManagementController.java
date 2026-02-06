package com.ruoyi.system.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysDept;
import com.ruoyi.common.core.domain.entity.SysRole;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.service.ISysDeptService;
import com.ruoyi.system.service.ISysPostService;
import com.ruoyi.system.service.ISysRoleService;
import com.ruoyi.system.service.ISysUserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * 员工管理Controller
 * 专门管理三个部门的员工：教练、雪场前台、后勤人员
 * 通过部门表来查询和过滤员工
 * 
 * @author ruoyi
 */
@Api(tags = "员工管理")
@RestController
@RequestMapping("/system/employee")
public class EmployeeManagementController extends BaseController {
    
    @Autowired
    private ISysUserService userService;
    
    @Autowired
    private ISysRoleService roleService;
    
    @Autowired
    private ISysPostService postService;
    
    @Autowired
    private ISysDeptService deptService;
    
    // 三个部门的名称
    private static final String DEPT_COACH = "教练";
    private static final String DEPT_FRONTDESK = "前台";
    private static final String DEPT_HOUQING = "后勤";
    
    /**
     * 获取三个部门的ID列表
     */
    private List<Long> getEmployeeDeptIds() {
        List<Long> deptIds = new ArrayList<>();
        List<SysDept> allDepts = deptService.selectDeptList(new SysDept());
        
        for (SysDept dept : allDepts) {
            String deptName = dept.getDeptName();
            if (deptName != null && (
                deptName.contains(DEPT_COACH) || 
                deptName.contains(DEPT_FRONTDESK) || 
                deptName.contains(DEPT_HOUQING)
            )) {
                deptIds.add(dept.getDeptId());
            }
        }
        
        return deptIds;
    }
    
    /**
     * 获取员工列表（只包含三个部门的员工）
     */
    @ApiOperation("获取员工列表")
    @PreAuthorize("@ss.hasPermi('system:employee:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysUser user) {
        startPage();
        // 获取三个部门的ID列表
        List<Long> employeeDeptIds = getEmployeeDeptIds();
        
        if (employeeDeptIds.isEmpty()) {
            return getDataTable(new ArrayList<>());
        }
        
        // 如果用户指定了部门ID，且该部门不在三个部门中，返回空列表
        if (user.getDeptId() != null && !employeeDeptIds.contains(user.getDeptId())) {
            return getDataTable(new ArrayList<>());
        }
        
        // 查询用户列表
        List<SysUser> allUsers = userService.selectUserList(user);
        
        // 过滤出三个部门的员工（通过部门ID）
        List<SysUser> employeeList = allUsers.stream()
            .filter(u -> u.getDeptId() != null && employeeDeptIds.contains(u.getDeptId()))
            .collect(Collectors.toList());
        
        return getDataTable(employeeList);
    }
    
    /**
     * 获取各部门员工统计
     */
    @ApiOperation("获取各部门员工统计")
    @PreAuthorize("@ss.hasPermi('system:employee:list')")
    @GetMapping("/statistics")
    public AjaxResult getStatistics() {
        List<Long> employeeDeptIds = getEmployeeDeptIds();
        Map<String, Integer> stats = new HashMap<>();
        
        for (Long deptId : employeeDeptIds) {
            SysDept dept = deptService.selectDeptById(deptId);
            if (dept != null) {
                SysUser queryUser = new SysUser();
                queryUser.setDeptId(deptId);
                List<SysUser> users = userService.selectUserList(queryUser);
                String deptName = dept.getDeptName();
                
                if (deptName != null) {
                    if (deptName.contains(DEPT_COACH)) {
                        stats.put("coach", users.size());
                    } else if (deptName.contains(DEPT_FRONTDESK) || deptName.contains("雪场前台")) {
                        stats.put("frontdesk", users.size());
                    } else if (deptName.contains(DEPT_HOUQING)) {
                        stats.put("houqing", users.size());
                    }
                }
            }
        }
        
        return success(stats);
    }
    
    /**
     * 获取三个部门的列表
     */
    @ApiOperation("获取员工部门列表")
    @PreAuthorize("@ss.hasPermi('system:employee:list')")
    @GetMapping("/depts")
    public AjaxResult getEmployeeDepts() {
        List<SysDept> allDepts = deptService.selectDeptList(new SysDept());
        List<SysDept> employeeDepts = allDepts.stream()
            .filter(dept -> {
                String deptName = dept.getDeptName();
                if (deptName == null) {
                    return false;
                }
                // 支持多种名称格式：教练、前台、后勤、雪场前台等
                return deptName.contains(DEPT_COACH) || 
                       deptName.contains(DEPT_FRONTDESK) || 
                       deptName.contains("雪场前台") ||
                       deptName.contains(DEPT_HOUQING);
            })
            .collect(Collectors.toList());
        return success(employeeDepts);
    }
    
    /**
     * 根据用户编号获取详细信息
     */
    @ApiOperation("获取员工详细信息")
    @PreAuthorize("@ss.hasPermi('system:employee:query')")
    @GetMapping(value = { "/", "/{userId}" })
    public AjaxResult getInfo(@PathVariable(value = "userId", required = false) Long userId) {
        AjaxResult ajax = AjaxResult.success();
        if (StringUtils.isNotNull(userId)) {
            userService.checkUserDataScope(userId);
            SysUser sysUser = userService.selectUserById(userId);
            ajax.put(AjaxResult.DATA_TAG, sysUser);
            ajax.put("postIds", postService.selectPostListByUserId(userId));
            ajax.put("roleIds", sysUser.getRoles().stream().map(SysRole::getRoleId).collect(Collectors.toList()));
        }
        // 返回所有角色（前端会根据部门来限制）
        List<SysRole> allRoles = roleService.selectRoleAll();
        ajax.put("roles", allRoles);
        ajax.put("posts", postService.selectPostAll());
        return ajax;
    }
    
    /**
     * 新增员工
     */
    @PreAuthorize("@ss.hasPermi('system:employee:add')")
    @Log(title = "员工管理", businessType = BusinessType.INSERT)
    @ApiOperation("新增员工")
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysUser user) {
        // 验证部门是否属于三个部门之一
        List<Long> employeeDeptIds = getEmployeeDeptIds();
        if (user.getDeptId() == null || !employeeDeptIds.contains(user.getDeptId())) {
            return error("员工部门必须是：教练、前台或后勤之一");
        }
        
        if (!userService.checkUserNameUnique(user)) {
            return error("新增员工'" + user.getUserName() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(user)) {
            return error("新增员工'" + user.getUserName() + "'失败，手机号码已存在");
        } else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("新增员工'" + user.getUserName() + "'失败，邮箱账号已存在");
        }
        user.setCreateBy(getUsername());
        user.setPassword(SecurityUtils.encryptPassword(user.getPassword()));
        return toAjax(userService.insertUser(user));
    }
    
    /**
     * 修改员工
     */
    @PreAuthorize("@ss.hasPermi('system:employee:edit')")
    @Log(title = "员工管理", businessType = BusinessType.UPDATE)
    @ApiOperation("修改员工")
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        userService.checkUserDataScope(user.getUserId());
        
        // 验证部门是否属于三个部门之一
        List<Long> employeeDeptIds = getEmployeeDeptIds();
        if (user.getDeptId() != null && !employeeDeptIds.contains(user.getDeptId())) {
            return error("员工部门必须是：教练、前台或后勤之一");
        }
        
        if (!userService.checkUserNameUnique(user)) {
            return error("修改员工'" + user.getUserName() + "'失败，登录账号已存在");
        } else if (StringUtils.isNotEmpty(user.getPhonenumber()) && !userService.checkPhoneUnique(user)) {
            return error("修改员工'" + user.getUserName() + "'失败，手机号码已存在");
        } else if (StringUtils.isNotEmpty(user.getEmail()) && !userService.checkEmailUnique(user)) {
            return error("修改员工'" + user.getUserName() + "'失败，邮箱账号已存在");
        }
        user.setUpdateBy(getUsername());
        return toAjax(userService.updateUser(user));
    }
    
    /**
     * 删除员工
     */
    @PreAuthorize("@ss.hasPermi('system:employee:remove')")
    @Log(title = "员工管理", businessType = BusinessType.DELETE)
    @ApiOperation("删除员工")
    @DeleteMapping("/{userIds}")
    public AjaxResult remove(@PathVariable Long[] userIds) {
        for (Long userId : userIds) {
            userService.checkUserAllowed(new SysUser(userId));
            userService.checkUserDataScope(userId);
        }
        return toAjax(userService.deleteUserByIds(userIds));
    }
    
    /**
     * 重置密码
     */
    @PreAuthorize("@ss.hasPermi('system:employee:resetPwd')")
    @Log(title = "员工管理", businessType = BusinessType.UPDATE)
    @ApiOperation("重置员工密码")
    @PutMapping("/resetPwd")
    public AjaxResult resetPwd(@RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        userService.checkUserDataScope(user.getUserId());
        String encryptedPassword = SecurityUtils.encryptPassword(user.getPassword());
        return toAjax(userService.resetUserPwd(user.getUserId(), encryptedPassword));
    }
    
    /**
     * 状态修改
     */
    @PreAuthorize("@ss.hasPermi('system:employee:edit')")
    @Log(title = "员工管理", businessType = BusinessType.UPDATE)
    @ApiOperation("修改员工状态")
    @PutMapping("/changeStatus")
    public AjaxResult changeStatus(@RequestBody SysUser user) {
        userService.checkUserAllowed(user);
        userService.checkUserDataScope(user.getUserId());
        user.setUpdateBy(getUsername());
        return toAjax(userService.updateUserStatus(user));
    }
    
}
