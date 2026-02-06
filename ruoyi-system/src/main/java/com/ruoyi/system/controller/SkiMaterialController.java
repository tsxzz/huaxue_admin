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
import com.ruoyi.system.domain.SkiMaterial;
import com.ruoyi.system.service.ISkiMaterialService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 物资管理Controller
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Api(tags = "物资管理")
@RestController
@RequestMapping("/system/material")
public class SkiMaterialController extends BaseController
{
    @Autowired
    private ISkiMaterialService skiMaterialService;

    /**
     * 查询物资管理列表（支持分页）
     */
    @ApiOperation("查询物资管理列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiMaterial skiMaterial)
    {
        if (skiMaterial == null) {
            skiMaterial = new SkiMaterial();
        }
        
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiMaterial.getParams() != null && !skiMaterial.getParams().isEmpty()) {
            Object pageNumObj = skiMaterial.getParams().get("pageNum");
            Object pageSizeObj = skiMaterial.getParams().get("pageSize");
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
        List<SkiMaterial> list = skiMaterialService.selectSkiMaterialList(skiMaterial);
        return getDataTable(list);
    }

    /**
     * 获取物资管理详细信息
     */
    @ApiOperation("获取物资管理详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("物资ID") @PathVariable("id") Long id)
    {
        return success(skiMaterialService.selectSkiMaterialById(id));
    }

    /**
     * 新增物资管理
     */
    @ApiOperation("新增物资管理")
    @Log(title = "物资管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@ApiParam("物资信息") @RequestBody SkiMaterial skiMaterial)
    {
        // 检查物资编码是否唯一
        if (!skiMaterialService.checkMaterialCodeUnique(skiMaterial.getMaterialCode(), null)) {
            return error("物资编码已存在");
        }
        return toAjax(skiMaterialService.insertSkiMaterial(skiMaterial));
    }

    /**
     * 修改物资管理
     */
    @ApiOperation("修改物资管理")
    @Log(title = "物资管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@ApiParam("物资信息") @RequestBody SkiMaterial skiMaterial)
    {
        // 检查物资编码是否唯一
        if (!skiMaterialService.checkMaterialCodeUnique(skiMaterial.getMaterialCode(), skiMaterial.getId())) {
            return error("物资编码已存在");
        }
        return toAjax(skiMaterialService.updateSkiMaterial(skiMaterial));
    }

    /**
     * 删除物资管理
     */
    @ApiOperation("删除物资管理")
    @Log(title = "物资管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("物资ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiMaterialService.deleteSkiMaterialByIds(ids));
    }

    /**
     * 获取即将过期的物资
     */
    @ApiOperation("获取即将过期的物资")
    @GetMapping("/expiringSoon")
    public AjaxResult getExpiringSoon()
    {
        return success(skiMaterialService.getExpiringSoonMaterials());
    }

    /**
     * 获取库存不足的物资
     */
    @ApiOperation("获取库存不足的物资")
    @GetMapping("/lowStock")
    public AjaxResult getLowStock()
    {
        return success(skiMaterialService.getLowStockMaterials());
    }
}
