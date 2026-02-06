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
import com.ruoyi.system.domain.SkiTicketType;
import com.ruoyi.system.service.ISkiTicketTypeService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 门票类型Controller
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@Api(tags = "门票类型管理")
@RestController
@RequestMapping("/system/ticketType")
public class SkiTicketTypeController extends BaseController
{
    @Autowired
    private ISkiTicketTypeService skiTicketTypeService;

    /**
     * 查询门票类型列表（支持分页）
     */
    @ApiOperation("查询门票类型列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiTicketType skiTicketType)
    {
        if (skiTicketType == null) {
            skiTicketType = new SkiTicketType();
        }
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiTicketType.getParams() != null && !skiTicketType.getParams().isEmpty()) {
            Object pageNumObj = skiTicketType.getParams().get("pageNum");
            Object pageSizeObj = skiTicketType.getParams().get("pageSize");
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
        List<SkiTicketType> list = skiTicketTypeService.selectSkiTicketTypeList(skiTicketType);
        return getDataTable(list);
    }

    /**
     * 获取门票类型详细信息
     */
    @ApiOperation("获取门票类型详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("门票类型ID") @PathVariable("id") Long id)
    {
        return success(skiTicketTypeService.selectSkiTicketTypeById(id));
    }

    /**
     * 新增门票类型
     */
    @ApiOperation("新增门票类型")
    @Log(title = "门票类型", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiTicketType skiTicketType)
    {
        return toAjax(skiTicketTypeService.insertSkiTicketType(skiTicketType));
    }

    /**
     * 修改门票类型
     */
    @ApiOperation("修改门票类型")
    @Log(title = "门票类型", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiTicketType skiTicketType)
    {
        return toAjax(skiTicketTypeService.updateSkiTicketType(skiTicketType));
    }

    /**
     * 删除门票类型
     */
    @ApiOperation("删除门票类型")
    @Log(title = "门票类型", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("门票类型ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiTicketTypeService.deleteSkiTicketTypeByIds(ids));
    }

    /**
     * 公开查询可用门票类型列表（游客预订时使用，无需登录）
     */
    @ApiOperation("公开查询可用门票类型列表")
    @PostMapping("/public/list")
    public TableDataInfo publicList(@ApiParam("查询条件") @RequestBody(required = false) SkiTicketType skiTicketType)
    {
        if (skiTicketType == null) {
            skiTicketType = new SkiTicketType();
        }
        
        // 只查询正常状态的票种
        skiTicketType.setStatus("0");
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 100; // 公开查询默认返回更多数据
        
        if (skiTicketType.getParams() != null && !skiTicketType.getParams().isEmpty()) {
            Object pageNumObj = skiTicketType.getParams().get("pageNum");
            Object pageSizeObj = skiTicketType.getParams().get("pageSize");
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
        List<SkiTicketType> list = skiTicketTypeService.selectSkiTicketTypeList(skiTicketType);
        return getDataTable(list);
    }
}
