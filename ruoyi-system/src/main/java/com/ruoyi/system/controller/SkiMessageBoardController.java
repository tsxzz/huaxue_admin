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
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiMessageBoard;
import com.ruoyi.system.service.ISkiMessageBoardService;
import com.ruoyi.common.core.page.TableDataInfo;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;

/**
 * 留言板Controller
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Api(tags = "留言板管理")
@RestController
@RequestMapping("/system/messageBoard")
public class SkiMessageBoardController extends BaseController
{
    @Autowired
    private ISkiMessageBoardService skiMessageBoardService;

    /**
     * 查询留言板列表（支持分页）
     */
    @ApiOperation("查询留言板列表")
    @Anonymous
    @PostMapping("/list")
    public TableDataInfo list(@ApiParam("查询条件") @RequestBody(required = false) SkiMessageBoard skiMessageBoard)
    {
        if (skiMessageBoard == null) {
            skiMessageBoard = new SkiMessageBoard();
        }
        
        // 只查询正常状态的留言
        skiMessageBoard.setStatus("0");
        
        // 从请求体中读取分页参数
        Integer pageNum = 1;
        Integer pageSize = 10;
        
        if (skiMessageBoard.getParams() != null && !skiMessageBoard.getParams().isEmpty()) {
            Object pageNumObj = skiMessageBoard.getParams().get("pageNum");
            Object pageSizeObj = skiMessageBoard.getParams().get("pageSize");
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
        List<SkiMessageBoard> list = skiMessageBoardService.selectSkiMessageBoardList(skiMessageBoard);
        return getDataTable(list);
    }

    /**
     * 获取留言板详细信息
     */
    @ApiOperation("获取留言板详细信息")
    @Anonymous
    @GetMapping(value = "/{id}")
    public AjaxResult getInfo(@ApiParam("留言ID") @PathVariable("id") Long id)
    {
        return success(skiMessageBoardService.selectSkiMessageBoardById(id));
    }

    /**
     * 新增留言板
     */
    @ApiOperation("新增留言板")
    @Log(title = "留言板", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@ApiParam("留言信息") @RequestBody SkiMessageBoard skiMessageBoard)
    {
        return toAjax(skiMessageBoardService.insertSkiMessageBoard(skiMessageBoard));
    }

    /**
     * 修改留言板
     */
    @ApiOperation("修改留言板")
    @Log(title = "留言板", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@ApiParam("留言信息") @RequestBody SkiMessageBoard skiMessageBoard)
    {
        // 检查权限：只能修改自己的留言，管理员可以修改所有
        SkiMessageBoard existing = skiMessageBoardService.selectSkiMessageBoardById(skiMessageBoard.getId());
        if (existing == null) {
            return error("留言不存在");
        }
        
        Long currentUserId = SecurityUtils.getUserId();
        if (!SecurityUtils.isAdmin() && !existing.getUserId().equals(currentUserId)) {
            return error("无权修改他人的留言");
        }
        
        return toAjax(skiMessageBoardService.updateSkiMessageBoard(skiMessageBoard));
    }

    /**
     * 删除留言板
     */
    @ApiOperation("删除留言板")
    @Log(title = "留言板", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public AjaxResult remove(@ApiParam("留言ID数组") @PathVariable Long[] ids)
    {
        // 检查权限：只能删除自己的留言，管理员可以删除所有
        Long currentUserId = SecurityUtils.getUserId();
        boolean isAdmin = SecurityUtils.isAdmin();
        
        for (Long id : ids) {
            SkiMessageBoard existing = skiMessageBoardService.selectSkiMessageBoardById(id);
            if (existing != null && !isAdmin && !existing.getUserId().equals(currentUserId)) {
                return error("无权删除他人的留言");
            }
        }
        
        return toAjax(skiMessageBoardService.deleteSkiMessageBoardByIds(ids));
    }

    /**
     * 点赞/取消点赞
     */
    @ApiOperation("点赞/取消点赞")
    @PostMapping("/like/{id}")
    public AjaxResult toggleLike(@ApiParam("留言ID") @PathVariable("id") Long id)
    {
        Long userId = SecurityUtils.getUserId();
        int result = skiMessageBoardService.toggleLike(id, userId);
        
        if (result > 0) {
            return success("点赞成功");
        } else {
            return success("取消点赞成功");
        }
    }
}
