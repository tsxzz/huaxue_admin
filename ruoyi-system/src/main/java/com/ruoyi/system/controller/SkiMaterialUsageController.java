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
import com.ruoyi.system.domain.SkiMaterialUsage;
import com.ruoyi.system.service.ISkiMaterialUsageService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 领用记录Controller
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Api(tags = "领用记录管理")
@RestController
@RequestMapping("/system/materialUsage")
public class SkiMaterialUsageController extends BaseController
{
    @Autowired
    private ISkiMaterialUsageService skiMaterialUsageService;

    /**
     * 查询领用记录列表（支持分页）
     */
    @ApiOperation("查询领用记录列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiMaterialUsage skiMaterialUsage)
    {
        if (skiMaterialUsage == null) {
            skiMaterialUsage = new SkiMaterialUsage();
        }
        
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiMaterialUsage.getParams() != null && !skiMaterialUsage.getParams().isEmpty()) {
            Object pageNumObj = skiMaterialUsage.getParams().get("pageNum");
            Object pageSizeObj = skiMaterialUsage.getParams().get("pageSize");
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
        List<SkiMaterialUsage> list = skiMaterialUsageService.selectSkiMaterialUsageList(skiMaterialUsage);
        return getDataTable(list);
    }

    /**
     * 获取领用记录详细信息
     */
    @ApiOperation("获取领用记录详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("领用ID") @PathVariable("id") Long id)
    {
        return success(skiMaterialUsageService.selectSkiMaterialUsageById(id));
    }

    /**
     * 新增领用记录
     */
    @ApiOperation("新增领用记录")
    @Log(title = "领用记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@ApiParam("领用记录信息") @RequestBody SkiMaterialUsage skiMaterialUsage)
    {
        return toAjax(skiMaterialUsageService.insertSkiMaterialUsage(skiMaterialUsage));
    }

    /**
     * 修改领用记录
     */
    @ApiOperation("修改领用记录")
    @Log(title = "领用记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@ApiParam("领用记录信息") @RequestBody SkiMaterialUsage skiMaterialUsage)
    {
        return toAjax(skiMaterialUsageService.updateSkiMaterialUsage(skiMaterialUsage));
    }

    /**
     * 删除领用记录
     */
    @ApiOperation("删除领用记录")
    @Log(title = "领用记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("领用ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiMaterialUsageService.deleteSkiMaterialUsageByIds(ids));
    }

    /**
     * 审批领用申请
     */
    @ApiOperation("审批领用申请")
    @Log(title = "领用记录", businessType = BusinessType.UPDATE)
    @PostMapping("/approve/{id}")
    public AjaxResult approve(@ApiParam("领用ID") @PathVariable("id") Long id, 
                             @ApiParam("审批信息") @RequestBody java.util.Map<String, String> params)
    {
        String approvalStatus = params.get("approvalStatus");
        String approvalRemark = params.get("approvalRemark");
        return toAjax(skiMaterialUsageService.approveUsage(id, approvalStatus, approvalRemark));
    }

    /**
     * 归还物资
     */
    @ApiOperation("归还物资")
    @Log(title = "领用记录", businessType = BusinessType.UPDATE)
    @PostMapping("/return/{id}")
    public AjaxResult returnMaterial(@ApiParam("领用ID") @PathVariable("id") Long id)
    {
        return toAjax(skiMaterialUsageService.returnMaterial(id));
    }
}
