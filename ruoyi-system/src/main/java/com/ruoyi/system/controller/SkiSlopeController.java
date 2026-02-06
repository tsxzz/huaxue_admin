package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SkiSlope;
import com.ruoyi.system.service.ISkiSlopeService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 雪道信息Controller
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Api(tags = "雪道信息管理")
@RestController
@RequestMapping("/system/slope")
public class SkiSlopeController extends BaseController
{
    @Autowired
    private ISkiSlopeService skiSlopeService;

    /**
     * 查询雪道信息列表
     */
    @ApiOperation("查询雪道信息列表")
    @PreAuthorize("@ss.hasPermi('system:slope:list')")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody SkiSlope skiSlope)
    {
        startPage();
        List<SkiSlope> list = skiSlopeService.selectSkiSlopeList(skiSlope);
        return getDataTable(list);
    }

    /**
     * 导出雪道信息列表
     */
    @ApiOperation("导出雪道信息列表")
    @PreAuthorize("@ss.hasPermi('system:slope:export')")
    @Log(title = "雪道信息", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SkiSlope skiSlope)
    {
        List<SkiSlope> list = skiSlopeService.selectSkiSlopeList(skiSlope);
        // ExcelUtil<SkiSlope> util = new ExcelUtil<SkiSlope>(SkiSlope.class);
        // util.exportExcel(response, list, "雪道信息数据");
    }

    /**
     * 获取雪道信息详细信息
     */
    @ApiOperation("获取雪道信息详细信息")
    @PreAuthorize("@ss.hasPermi('system:slope:query')")
    @PostMapping("/getInfo")
    public AjaxResult getInfo(@ApiParam("雪道ID") @RequestBody SkiSlope skiSlope)
    {
        return AjaxResult.success(skiSlopeService.selectSkiSlopeById(skiSlope.getId()));
    }

    /**
     * 新增雪道信息
     */
    @ApiOperation("新增雪道信息")
    @PreAuthorize("@ss.hasPermi('system:slope:add')")
    @Log(title = "雪道信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public AjaxResult add(@ApiParam("雪道信息") @RequestBody SkiSlope skiSlope)
    {
        // 使用System.out确保日志输出（用于调试）
        System.out.println("========== 新增雪道信息开始 ==========");
        System.out.println("接收到的数据：" + skiSlope);
        System.out.println("图片URL：" + skiSlope.getImageUrl());
        
        try {
            logger.info("========== 新增雪道信息开始 ==========");
            logger.info("新增雪道信息，接收到的数据：{}", skiSlope);
            logger.info("图片URL：{}", skiSlope.getImageUrl());
            
            int result = skiSlopeService.insertSkiSlope(skiSlope);
            
            System.out.println("新增雪道信息结果：" + result);
            logger.info("新增雪道信息结果：{}", result);
            
            return toAjax(result);
        } catch (Exception e) {
            System.out.println("========== 新增雪道信息异常 ==========");
            System.out.println("异常类型：" + e.getClass().getName());
            System.out.println("异常信息：" + e.getMessage());
            e.printStackTrace();
            
            logger.error("新增雪道信息失败", e);
            return AjaxResult.error("新增失败：" + e.getMessage());
        } finally {
            System.out.println("========== 新增雪道信息结束 ==========");
        }
    }

    /**
     * 修改雪道信息
     */
    @ApiOperation("修改雪道信息")
    @PreAuthorize("@ss.hasPermi('system:slope:edit')")
    @Log(title = "雪道信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@ApiParam("雪道信息") @RequestBody SkiSlope skiSlope)
    {
        // 使用System.out确保日志输出（用于调试）
        System.out.println("========== 修改雪道信息开始 ==========");
        System.out.println("接收到的数据：" + skiSlope);
        System.out.println("图片URL：" + skiSlope.getImageUrl());
        
        try {
            logger.info("========== 修改雪道信息开始 ==========");
            logger.info("修改雪道信息，接收到的数据：{}", skiSlope);
            logger.info("图片URL：{}", skiSlope.getImageUrl());
            
            int result = skiSlopeService.updateSkiSlope(skiSlope);
            
            System.out.println("修改雪道信息结果：" + result);
            logger.info("修改雪道信息结果：{}", result);
            
            return toAjax(result);
        } catch (Exception e) {
            System.out.println("========== 修改雪道信息异常 ==========");
            System.out.println("异常类型：" + e.getClass().getName());
            System.out.println("异常信息：" + e.getMessage());
            e.printStackTrace();
            
            logger.error("修改雪道信息失败", e);
            return AjaxResult.error("修改失败：" + e.getMessage());
        } finally {
            System.out.println("========== 修改雪道信息结束 ==========");
        }
    }

    /**
     * 删除雪道信息
     */
    @ApiOperation("删除雪道信息")
    @PreAuthorize("@ss.hasPermi('system:slope:remove')")
    @Log(title = "雪道信息", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    public AjaxResult remove(@ApiParam("雪道ID数组") @RequestBody Long[] ids)
    {
        return toAjax(skiSlopeService.deleteSkiSlopeByIds(ids));
    }

    /**
     * 修改雪道状态
     */
    @ApiOperation("修改雪道状态")
    @PreAuthorize("@ss.hasPermi('system:slope:edit')")
    @Log(title = "雪道信息", businessType = BusinessType.UPDATE)
    @PostMapping("/changeStatus")
    public AjaxResult changeStatus(@ApiParam("雪道信息（包含id和status）") @RequestBody SkiSlope skiSlope)
    {
        return toAjax(skiSlopeService.changeStatus(skiSlope));
    }

    /**
     * 游客查询雪道信息列表（允许匿名访问）
     */
    @ApiOperation("游客查询雪道信息列表")
    @Anonymous
    @PostMapping("/public/list")
    public AjaxResult publicList(@ApiParam("查询条件") @RequestBody SkiSlope skiSlope)
    {
        // 只查询开放的雪道
        skiSlope.setStatus(1);
        List<SkiSlope> list = skiSlopeService.selectSkiSlopeList(skiSlope);
        return AjaxResult.success(list);
    }

    /**
     * 游客查询雪道详细信息（允许匿名访问）
     */
    @ApiOperation("游客查询雪道详细信息")
    @Anonymous
    @PostMapping("/public/getInfo")
    public AjaxResult publicGetInfo(@ApiParam("雪道ID") @RequestBody SkiSlope skiSlope)
    {
        SkiSlope slope = skiSlopeService.selectSkiSlopeById(skiSlope.getId());
        // 只返回开放的雪道信息
        if (slope != null && slope.getStatus() == 1) {
            return AjaxResult.success(slope);
        }
        return AjaxResult.error("雪道不存在或已关闭");
    }
}
