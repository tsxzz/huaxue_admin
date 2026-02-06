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
import com.ruoyi.system.domain.SkiMaterialStock;
import com.ruoyi.system.service.ISkiMaterialStockService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 出入库记录Controller
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Api(tags = "出入库记录管理")
@RestController
@RequestMapping("/system/materialStock")
public class SkiMaterialStockController extends BaseController
{
    @Autowired
    private ISkiMaterialStockService skiMaterialStockService;

    /**
     * 查询出入库记录列表（支持分页）
     */
    @ApiOperation("查询出入库记录列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiMaterialStock skiMaterialStock)
    {
        if (skiMaterialStock == null) {
            skiMaterialStock = new SkiMaterialStock();
        }
        
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiMaterialStock.getParams() != null && !skiMaterialStock.getParams().isEmpty()) {
            Object pageNumObj = skiMaterialStock.getParams().get("pageNum");
            Object pageSizeObj = skiMaterialStock.getParams().get("pageSize");
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
        List<SkiMaterialStock> list = skiMaterialStockService.selectSkiMaterialStockList(skiMaterialStock);
        return getDataTable(list);
    }

    /**
     * 获取出入库记录详细信息
     */
    @ApiOperation("获取出入库记录详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("记录ID") @PathVariable("id") Long id)
    {
        return success(skiMaterialStockService.selectSkiMaterialStockById(id));
    }

    /**
     * 新增出入库记录
     */
    @ApiOperation("新增出入库记录")
    @Log(title = "出入库记录", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@ApiParam("出入库记录信息") @RequestBody SkiMaterialStock skiMaterialStock)
    {
        return toAjax(skiMaterialStockService.insertSkiMaterialStock(skiMaterialStock));
    }

    /**
     * 修改出入库记录
     */
    @ApiOperation("修改出入库记录")
    @Log(title = "出入库记录", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@ApiParam("出入库记录信息") @RequestBody SkiMaterialStock skiMaterialStock)
    {
        return toAjax(skiMaterialStockService.updateSkiMaterialStock(skiMaterialStock));
    }

    /**
     * 删除出入库记录
     */
    @ApiOperation("删除出入库记录")
    @Log(title = "出入库记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("记录ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiMaterialStockService.deleteSkiMaterialStockByIds(ids));
    }
}
