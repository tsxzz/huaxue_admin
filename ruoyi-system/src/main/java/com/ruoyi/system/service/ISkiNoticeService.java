package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiNotice;

/**
 * 通知管理Service接口
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
public interface ISkiNoticeService 
{
    /**
     * 查询通知管理
     * 
     * @param id 通知管理主键
     * @return 通知管理
     */
    public SkiNotice selectSkiNoticeById(Long id);

    /**
     * 查询通知管理列表
     * 
     * @param skiNotice 通知管理
     * @return 通知管理集合
     */
    public List<SkiNotice> selectSkiNoticeList(SkiNotice skiNotice);

    /**
     * 新增通知管理
     * 
     * @param skiNotice 通知管理
     * @return 结果
     */
    public int insertSkiNotice(SkiNotice skiNotice);

    /**
     * 修改通知管理
     * 
     * @param skiNotice 通知管理
     * @return 结果
     */
    public int updateSkiNotice(SkiNotice skiNotice);

    /**
     * 批量删除通知管理
     * 
     * @param ids 需要删除的通知管理主键集合
     * @return 结果
     */
    public int deleteSkiNoticeByIds(Long[] ids);

    /**
     * 删除通知管理信息
     * 
     * @param id 通知管理主键
     * @return 结果
     */
    public int deleteSkiNoticeById(Long id);

    /**
     * 发布通知
     * 
     * @param id 通知ID
     * @return 结果
     */
    public int publishNotice(Long id);

    /**
     * 关闭通知
     * 
     * @param id 通知ID
     * @return 结果
     */
    public int closeNotice(Long id);
}
