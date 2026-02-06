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
import com.ruoyi.common.annotation.Anonymous;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.system.domain.SkiNotice;
import com.ruoyi.system.service.ISkiNoticeService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 通知管理Controller
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Api(tags = "滑雪场通知管理")
@RestController
@RequestMapping("/system/skiNotice")
public class SkiNoticeController extends BaseController
{
    @Autowired
    private ISkiNoticeService skiNoticeService;

    /**
     * 查询通知管理列表（公开访问，无需认证）
     */
    @Anonymous
    @ApiOperation("查询通知管理列表（公开访问）")
    @PostMapping("/public/list")
    public TableDataInfo publicList(@ApiParam("查询条件") @RequestBody(required = false) SkiNotice skiNotice)
    {
        if (skiNotice == null) {
            skiNotice = new SkiNotice();
        }
        
        // 公开接口只查询正常状态且已发布的通知
        skiNotice.setStatus("0");
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiNotice.getParams() != null && !skiNotice.getParams().isEmpty()) {
            Object pageNumObj = skiNotice.getParams().get("pageNum");
            Object pageSizeObj = skiNotice.getParams().get("pageSize");
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
        List<SkiNotice> list = skiNoticeService.selectSkiNoticeList(skiNotice);
        return getDataTable(list);
    }

    /**
     * 查询通知管理列表（支持分页）
     */
    @ApiOperation("查询通知管理列表")
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiNotice skiNotice)
    {
        if (skiNotice == null) {
            skiNotice = new SkiNotice();
        }
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiNotice.getParams() != null && !skiNotice.getParams().isEmpty()) {
            Object pageNumObj = skiNotice.getParams().get("pageNum");
            Object pageSizeObj = skiNotice.getParams().get("pageSize");
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
        List<SkiNotice> list = skiNoticeService.selectSkiNoticeList(skiNotice);
        return getDataTable(list);
    }

    /**
     * 获取通知管理详细信息
     */
    @ApiOperation("获取通知管理详细信息")
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("通知ID") @PathVariable("id") Long id)
    {
        SkiNotice notice = skiNoticeService.selectSkiNoticeById(id);
        if (notice != null) {
            // 增加阅读次数
            notice.setReadCount((notice.getReadCount() == null ? 0 : notice.getReadCount()) + 1);
            skiNoticeService.updateSkiNotice(notice);
        }
        return success(notice);
    }

    /**
     * 新增通知管理
     */
    @ApiOperation("新增通知管理")
    @Log(title = "通知管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody SkiNotice skiNotice)
    {
        int rows = skiNoticeService.insertSkiNotice(skiNotice);
        if (rows > 0) {
            return success(skiNotice);
        } else {
            return error("通知创建失败");
        }
    }

    /**
     * 修改通知管理
     */
    @ApiOperation("修改通知管理")
    @Log(title = "通知管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody SkiNotice skiNotice)
    {
        return toAjax(skiNoticeService.updateSkiNotice(skiNotice));
    }

    /**
     * 删除通知管理
     */
    @ApiOperation("删除通知管理")
    @Log(title = "通知管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("通知ID数组") @PathVariable Long[] ids)
    {
        return toAjax(skiNoticeService.deleteSkiNoticeByIds(ids));
    }

    /**
     * 发布通知
     */
    @ApiOperation("发布通知")
    @Log(title = "通知管理", businessType = BusinessType.UPDATE)
    @PostMapping("/publish/{id}")
    public AjaxResult publish(@ApiParam("通知ID") @PathVariable("id") Long id)
    {
        try {
            return toAjax(skiNoticeService.publishNotice(id));
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }

    /**
     * 关闭通知
     */
    @ApiOperation("关闭通知")
    @Log(title = "通知管理", businessType = BusinessType.UPDATE)
    @PostMapping("/close/{id}")
    public AjaxResult close(@ApiParam("通知ID") @PathVariable("id") Long id)
    {
        try {
            return toAjax(skiNoticeService.closeNotice(id));
        } catch (Exception e) {
            return error(e.getMessage());
        }
    }
}
