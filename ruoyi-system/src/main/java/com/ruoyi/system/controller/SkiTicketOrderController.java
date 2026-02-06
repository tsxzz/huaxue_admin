package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SkiTicketOrder;
import com.ruoyi.system.service.ISkiTicketOrderService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 门票订单Controller
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@Api(tags = "门票订单管理")
@RestController
@RequestMapping("/system/ticketOrder")
public class SkiTicketOrderController extends BaseController
{
    @Autowired
    private ISkiTicketOrderService skiTicketOrderService;

    /**
     * 查询门票订单列表（支持分页）
     */
    @ApiOperation("查询门票订单列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiTicketOrder skiTicketOrder)
    {
        if (skiTicketOrder == null) {
            skiTicketOrder = new SkiTicketOrder();
        }
        
        // 权限控制：管理员、后勤人员、前台可以查看所有订单；游客只能查看自己的订单
        try {
            if (com.ruoyi.common.utils.SecurityUtils.isAdmin()) {
                // 管理员：清除userId条件，可以查看所有订单
                skiTicketOrder.setUserId(null);
            } else if (com.ruoyi.common.utils.SecurityUtils.hasRole("houqing") || 
                       com.ruoyi.common.utils.SecurityUtils.hasRole("Frontdesk")) {
                // 后勤人员和前台：清除userId条件，可以查看所有订单
                skiTicketOrder.setUserId(null);
            } else {
                // 游客等其他角色：强制设置为当前用户ID，确保只能看到自己的订单
                Long userId = getUserId();
                skiTicketOrder.setUserId(userId);
            }
        } catch (Exception e) {
            // 如果获取用户信息失败，返回空列表
            return getDataTable(new java.util.ArrayList<>());
        }
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiTicketOrder.getParams() != null && !skiTicketOrder.getParams().isEmpty()) {
            Object pageNumObj = skiTicketOrder.getParams().get("pageNum");
            Object pageSizeObj = skiTicketOrder.getParams().get("pageSize");
            if (pageNumObj != null) {
                try {
                    pageNum = Integer.parseInt(pageNumObj.toString());
                } catch (NumberFormatException e) {
                    // 忽略
                }
            }
            if (pageSizeObj != null) {
                try {
                    pageSize = Integer.parseInt(pageSizeObj.toString());
                } catch (NumberFormatException e) {
                    // 忽略
                }
            }
        }
        
        com.github.pagehelper.PageHelper.startPage(pageNum, pageSize);
        List<SkiTicketOrder> list = skiTicketOrderService.selectSkiTicketOrderList(skiTicketOrder);
        return getDataTable(list);
    }

    /**
     * 获取门票订单详细信息
     */
    @ApiOperation("获取门票订单详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("订单ID") @PathVariable("id") Long id)
    {
        SkiTicketOrder order = skiTicketOrderService.selectSkiTicketOrderById(id);
        if (order == null) {
            return error("订单不存在");
        }
        
        // 权限控制：管理员、后勤人员、前台可以查看所有订单；游客只能查看自己的订单
        try {
            if (!com.ruoyi.common.utils.SecurityUtils.isAdmin() && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("houqing") && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("Frontdesk")) {
                // 游客等其他角色：验证订单是否属于当前用户
                Long userId = getUserId();
                if (order.getUserId() == null || !order.getUserId().equals(userId)) {
                    return error("无权访问该订单");
                }
            }
        } catch (Exception e) {
            return error("获取用户信息失败");
        }
        
        return success(order);
    }

    /**
     * 新增门票订单
     */
    @ApiOperation("新增门票订单")
    @Log(title = "门票订单", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiTicketOrder skiTicketOrder)
    {
        int rows = skiTicketOrderService.insertSkiTicketOrder(skiTicketOrder);
        if (rows > 0) {
            // 插入成功后，返回完整的订单对象（包含生成的ID和订单号）
            return success(skiTicketOrder);
        } else {
            return error("订单创建失败");
        }
    }

    /**
     * 修改门票订单
     */
    @ApiOperation("修改门票订单")
    @Log(title = "门票订单", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiTicketOrder skiTicketOrder)
    {
        return toAjax(skiTicketOrderService.updateSkiTicketOrder(skiTicketOrder));
    }

    /**
     * 删除门票订单
     */
    @ApiOperation("删除门票订单")
    @Log(title = "门票订单", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("订单ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiTicketOrderService.deleteSkiTicketOrderByIds(ids));
    }

    /**
     * 处理退票
     */
    @ApiOperation("处理退票")
    @Log(title = "门票订单", businessType = BusinessType.UPDATE)
    @PostMapping("/refund/{id}")
    public AjaxResult refund(@ApiParam("订单ID") @PathVariable("id") Long id, 
                            @ApiParam("退款原因") @RequestBody(required = false) java.util.Map<String, String> params)
    {
        String refundReason = params != null ? params.get("refundReason") : "用户申请退票";
        try {
            return toAjax(skiTicketOrderService.refundTicket(id, refundReason));
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 支付订单
     */
    @ApiOperation("支付订单")
    @Log(title = "门票订单", businessType = BusinessType.UPDATE)
    @PostMapping("/pay/{id}")
    public AjaxResult pay(@ApiParam("订单ID") @PathVariable("id") Long id,
                         @ApiParam("支付方式") @RequestBody(required = false) java.util.Map<String, String> params)
    {
        // 验证订单是否属于当前用户（管理员除外）
        try {
            SkiTicketOrder order = skiTicketOrderService.selectSkiTicketOrderById(id);
            if (order == null) {
                return error("订单不存在");
            }
            
            // 权限控制：管理员、后勤人员、前台可以操作所有订单；游客只能操作自己的订单
            if (!com.ruoyi.common.utils.SecurityUtils.isAdmin() && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("houqing") && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("Frontdesk")) {
                Long userId = getUserId();
                if (order.getUserId() == null || !order.getUserId().equals(userId)) {
                    return error("无权操作该订单");
                }
            }
        } catch (Exception e) {
            return error("获取用户信息失败");
        }
        
        String paymentMethod = params != null ? params.get("paymentMethod") : "2"; // 默认微信支付
        try {
            return toAjax(skiTicketOrderService.payTicketOrder(id, paymentMethod));
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 取消订单
     */
    @ApiOperation("取消订单")
    @Log(title = "门票订单", businessType = BusinessType.UPDATE)
    @PostMapping("/cancel/{id}")
    public AjaxResult cancel(@ApiParam("订单ID") @PathVariable("id") Long id)
    {
        // 验证订单是否属于当前用户（管理员除外）
        try {
            SkiTicketOrder order = skiTicketOrderService.selectSkiTicketOrderById(id);
            if (order == null) {
                return error("订单不存在");
            }
            
            // 权限控制：管理员、后勤人员、前台可以操作所有订单；游客只能操作自己的订单
            if (!com.ruoyi.common.utils.SecurityUtils.isAdmin() && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("houqing") && 
                !com.ruoyi.common.utils.SecurityUtils.hasRole("Frontdesk")) {
                Long userId = getUserId();
                if (order.getUserId() == null || !order.getUserId().equals(userId)) {
                    return error("无权操作该订单");
                }
            }
        } catch (Exception e) {
            return error("获取用户信息失败");
        }
        
        try {
            return toAjax(skiTicketOrderService.cancelTicketOrder(id));
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }
}
