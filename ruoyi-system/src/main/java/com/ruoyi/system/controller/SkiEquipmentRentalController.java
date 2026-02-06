package com.ruoyi.system.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SkiEquipmentRental;
import com.ruoyi.system.service.ISkiEquipmentRentalService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 雪具租赁信息Controller
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Api(tags = "雪具租赁管理")
@RestController
@RequestMapping("/system/equipmentRental")
public class SkiEquipmentRentalController extends BaseController
{
    @Autowired
    private ISkiEquipmentRentalService skiEquipmentRentalService;

    /**
     * 查询雪具租赁信息列表
     */
    @ApiOperation("查询雪具租赁信息列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiEquipmentRental skiEquipmentRental)
    {
        if (skiEquipmentRental == null) {
            skiEquipmentRental = new SkiEquipmentRental();
        }
        startPage();
        List<SkiEquipmentRental> list = skiEquipmentRentalService.selectSkiEquipmentRentalList(skiEquipmentRental);
        return getDataTable(list);
    }

    /**
     * 获取雪具租赁信息详细信息
     */
    @ApiOperation("获取雪具租赁信息详细信息")
    @PostMapping("/getInfo")
    public AjaxResult getInfo(@ApiParam("租赁ID") @RequestBody SkiEquipmentRental skiEquipmentRental)
    {
        return AjaxResult.success(skiEquipmentRentalService.selectSkiEquipmentRentalById(skiEquipmentRental.getId()));
    }

    /**
     * 新增雪具租赁信息
     */
    @ApiOperation("新增雪具租赁信息")
    @Log(title = "雪具租赁信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public AjaxResult add(@ApiParam("租赁信息") @RequestBody SkiEquipmentRental skiEquipmentRental)
    {
        try {
            logger.info("新增雪具租赁信息，接收到的数据：{}", skiEquipmentRental);
            int result = skiEquipmentRentalService.insertSkiEquipmentRental(skiEquipmentRental);
            logger.info("新增雪具租赁信息结果：{}", result);
            return toAjax(result);
        } catch (Exception e) {
            logger.error("新增雪具租赁信息失败", e);
            return AjaxResult.error("租赁失败：" + e.getMessage());
        }
    }

    /**
     * 修改雪具租赁信息
     */
    @ApiOperation("修改雪具租赁信息")
    @Log(title = "雪具租赁信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@ApiParam("租赁信息") @RequestBody SkiEquipmentRental skiEquipmentRental)
    {
        try {
            logger.info("修改雪具租赁信息，接收到的数据：{}", skiEquipmentRental);
            int result = skiEquipmentRentalService.updateSkiEquipmentRental(skiEquipmentRental);
            logger.info("修改雪具租赁信息结果：{}", result);
            return toAjax(result);
        } catch (Exception e) {
            logger.error("修改雪具租赁信息失败", e);
            return AjaxResult.error("修改失败：" + e.getMessage());
        }
    }

    /**
     * 删除雪具租赁信息
     */
    @ApiOperation("删除雪具租赁信息")
    @Log(title = "雪具租赁信息", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    public AjaxResult remove(@ApiParam("租赁ID数组") @RequestBody Long[] ids)
    {
        return toAjax(skiEquipmentRentalService.deleteSkiEquipmentRentalByIds(ids));
    }

    /**
     * 归还雪具
     */
    @ApiOperation("归还雪具")
    @Log(title = "雪具租赁信息", businessType = BusinessType.UPDATE)
    @PostMapping("/return")
    public AjaxResult returnEquipment(@ApiParam("租赁ID") @RequestBody SkiEquipmentRental skiEquipmentRental)
    {
        try {
            int result = skiEquipmentRentalService.returnEquipment(skiEquipmentRental.getId());
            return toAjax(result);
        } catch (Exception e) {
            logger.error("归还雪具失败", e);
            return AjaxResult.error("归还失败：" + e.getMessage());
        }
    }

    /**
     * 取消租赁
     */
    @ApiOperation("取消租赁")
    @Log(title = "雪具租赁信息", businessType = BusinessType.UPDATE)
    @PostMapping("/cancel")
    public AjaxResult cancelRental(@ApiParam("租赁ID") @RequestBody SkiEquipmentRental skiEquipmentRental)
    {
        try {
            int result = skiEquipmentRentalService.cancelRental(skiEquipmentRental.getId());
            return toAjax(result);
        } catch (Exception e) {
            logger.error("取消租赁失败", e);
            return AjaxResult.error("取消失败：" + e.getMessage());
        }
    }
}
