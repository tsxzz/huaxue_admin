package com.ruoyi.system.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SkiEquipment;
import com.ruoyi.system.service.ISkiEquipmentService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 雪具信息Controller
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Api(tags = "雪具信息管理")
@RestController
@RequestMapping("/system/equipment")
public class SkiEquipmentController extends BaseController
{
    @Autowired
    private ISkiEquipmentService skiEquipmentService;
    
    // 添加初始化日志，确认Controller被加载
    {
        System.out.println("========== SkiEquipmentController 已加载 ==========");
    }

    /**
     * 测试接口 - 验证Controller是否正常工作
     */
    @ApiOperation("测试接口")
    @PostMapping("/test")
    public AjaxResult test()
    {
        logger.info("========== 测试接口被调用 ==========");
        return AjaxResult.success("SkiEquipmentController 工作正常！");
    }

    /**
     * 查询雪具信息列表（支持分页）
     */
    @ApiOperation("查询雪具信息列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiEquipment skiEquipment)
    {
        logger.info("========== 查询雪具列表接口被调用 ==========");
        if (skiEquipment == null) {
            skiEquipment = new SkiEquipment();
        }
        logger.info("接收到的查询条件：{}", skiEquipment);
        logger.info("接收到的params：{}", skiEquipment.getParams());
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10; // 默认值改为10
        
        // 优先从params中读取分页参数
        if (skiEquipment.getParams() != null && !skiEquipment.getParams().isEmpty()) {
            Object pageNumObj = skiEquipment.getParams().get("pageNum");
            Object pageSizeObj = skiEquipment.getParams().get("pageSize");
            
            logger.info("从params中读取分页参数：pageNum={}, pageSize={}", pageNumObj, pageSizeObj);
            
            if (pageNumObj != null) {
                try {
                    pageNum = Integer.parseInt(pageNumObj.toString());
                    logger.info("成功解析pageNum：{}", pageNum);
                } catch (NumberFormatException e) {
                    logger.warn("pageNum格式错误：{}", pageNumObj);
                }
            }
            if (pageSizeObj != null) {
                try {
                    pageSize = Integer.parseInt(pageSizeObj.toString());
                    logger.info("成功解析pageSize：{}", pageSize);
                } catch (NumberFormatException e) {
                    logger.warn("pageSize格式错误：{}", pageSizeObj);
                }
            }
        } else {
            // 如果params为空，尝试从请求参数中读取
            logger.info("params为空，尝试从请求参数中读取分页参数");
            org.springframework.web.context.request.RequestAttributes requestAttributes = org.springframework.web.context.request.RequestContextHolder.getRequestAttributes();
            if (requestAttributes instanceof org.springframework.web.context.request.ServletRequestAttributes) {
                javax.servlet.http.HttpServletRequest request = ((org.springframework.web.context.request.ServletRequestAttributes) requestAttributes).getRequest();
                String pageNumStr = request.getParameter("pageNum");
                String pageSizeStr = request.getParameter("pageSize");
                logger.info("从请求参数中读取：pageNum={}, pageSize={}", pageNumStr, pageSizeStr);
                if (pageNumStr != null) {
                    try {
                        pageNum = Integer.parseInt(pageNumStr);
                    } catch (NumberFormatException e) {
                        logger.warn("pageNum格式错误：{}", pageNumStr);
                    }
                }
                if (pageSizeStr != null) {
                    try {
                        pageSize = Integer.parseInt(pageSizeStr);
                    } catch (NumberFormatException e) {
                        logger.warn("pageSize格式错误：{}", pageSizeStr);
                    }
                }
            }
        }
        
        logger.info("最终使用的分页参数：pageNum={}, pageSize={}", pageNum, pageSize);
        
        try {
            // 直接使用PageHelper.startPage，传入分页参数
            com.github.pagehelper.PageHelper.startPage(pageNum, pageSize);
            List<SkiEquipment> list = skiEquipmentService.selectSkiEquipmentList(skiEquipment);
            logger.info("查询结果数量：{}，分页参数：pageNum={}, pageSize={}", 
                list != null ? list.size() : 0, pageNum, pageSize);
            return getDataTable(list);
        } catch (Exception e) {
            logger.error("查询雪具列表失败", e);
            throw e;
        } finally {
            // 清理分页的线程变量
            com.github.pagehelper.PageHelper.clearPage();
        }
    }

    /**
     * 获取雪具信息详细信息
     */
    @ApiOperation("获取雪具信息详细信息")
    @PostMapping("/getInfo")
    public AjaxResult getInfo(@ApiParam("雪具ID") @RequestBody SkiEquipment skiEquipment)
    {
        logger.info("========== 获取雪具详细信息接口被调用 ==========");
        logger.info("接收到的ID：{}", skiEquipment != null ? skiEquipment.getId() : "null");
        if (skiEquipment == null || skiEquipment.getId() == null) {
            return AjaxResult.error("雪具ID不能为空");
        }
        try {
            SkiEquipment equipment = skiEquipmentService.selectSkiEquipmentById(skiEquipment.getId());
            logger.info("查询到的雪具信息：{}", equipment);
            return AjaxResult.success(equipment);
        } catch (Exception e) {
            logger.error("获取雪具详细信息失败", e);
            return AjaxResult.error("查询失败：" + e.getMessage());
        }
    }

    /**
     * 新增雪具信息
     */
    @ApiOperation("新增雪具信息")
    @Log(title = "雪具信息", businessType = BusinessType.INSERT)
    @PostMapping("/add")
    public AjaxResult add(@ApiParam("雪具信息") @RequestBody SkiEquipment skiEquipment)
    {
        try {
            logger.info("新增雪具信息，接收到的数据：{}", skiEquipment);
            int result = skiEquipmentService.insertSkiEquipment(skiEquipment);
            logger.info("新增雪具信息结果：{}", result);
            return toAjax(result);
        } catch (Exception e) {
            logger.error("新增雪具信息失败", e);
            return AjaxResult.error("新增失败：" + e.getMessage());
        }
    }

    /**
     * 修改雪具信息
     */
    @ApiOperation("修改雪具信息")
    @Log(title = "雪具信息", businessType = BusinessType.UPDATE)
    @PostMapping("/edit")
    public AjaxResult edit(@ApiParam("雪具信息") @RequestBody SkiEquipment skiEquipment)
    {
        try {
            logger.info("修改雪具信息，接收到的数据：{}", skiEquipment);
            int result = skiEquipmentService.updateSkiEquipment(skiEquipment);
            logger.info("修改雪具信息结果：{}", result);
            return toAjax(result);
        } catch (Exception e) {
            logger.error("修改雪具信息失败", e);
            return AjaxResult.error("修改失败：" + e.getMessage());
        }
    }

    /**
     * 删除雪具信息
     */
    @ApiOperation("删除雪具信息")
    @Log(title = "雪具信息", businessType = BusinessType.DELETE)
    @PostMapping("/remove")
    public AjaxResult remove(@ApiParam("雪具ID数组") @RequestBody Long[] ids)
    {
        return toAjax(skiEquipmentService.deleteSkiEquipmentByIds(ids));
    }

    /**
     * 报修雪具
     */
    @ApiOperation("报修雪具")
    @Log(title = "雪具信息", businessType = BusinessType.UPDATE)
    @PostMapping("/reportMaintenance")
    public AjaxResult reportMaintenance(@ApiParam("雪具ID和数量") @RequestBody SkiEquipment skiEquipment)
    {
        try {
            int result = skiEquipmentService.reportMaintenance(skiEquipment.getId(), skiEquipment.getMaintenanceQuantity());
            return toAjax(result);
        } catch (Exception e) {
            logger.error("报修雪具失败", e);
            return AjaxResult.error("报修失败：" + e.getMessage());
        }
    }

    /**
     * 完成维修
     */
    @ApiOperation("完成维修")
    @Log(title = "雪具信息", businessType = BusinessType.UPDATE)
    @PostMapping("/completeMaintenance")
    public AjaxResult completeMaintenance(@ApiParam("雪具ID和数量") @RequestBody SkiEquipment skiEquipment)
    {
        try {
            int result = skiEquipmentService.completeMaintenance(skiEquipment.getId(), skiEquipment.getMaintenanceQuantity());
            return toAjax(result);
        } catch (Exception e) {
            logger.error("完成维修失败", e);
            return AjaxResult.error("完成维修失败：" + e.getMessage());
        }
    }

    /**
     * 报废雪具
     */
    @ApiOperation("报废雪具")
    @Log(title = "雪具信息", businessType = BusinessType.UPDATE)
    @PostMapping("/scrap")
    public AjaxResult scrap(@ApiParam("雪具ID和数量") @RequestBody SkiEquipment skiEquipment)
    {
        try {
            int result = skiEquipmentService.scrapEquipment(skiEquipment.getId(), skiEquipment.getScrapQuantity());
            return toAjax(result);
        } catch (Exception e) {
            logger.error("报废雪具失败", e);
            return AjaxResult.error("报废失败：" + e.getMessage());
        }
    }
}
