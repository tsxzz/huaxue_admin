package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiMessageBoard;

/**
 * 留言板Service接口
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
public interface ISkiMessageBoardService 
{
    /**
     * 查询留言板
     * 
     * @param id 留言板主键
     * @return 留言板
     */
    public SkiMessageBoard selectSkiMessageBoardById(Long id);

    /**
     * 查询留言板列表（主留言，带回复）
     * 
     * @param skiMessageBoard 留言板
     * @return 留言板集合
     */
    public List<SkiMessageBoard> selectSkiMessageBoardList(SkiMessageBoard skiMessageBoard);

    /**
     * 新增留言板
     * 
     * @param skiMessageBoard 留言板
     * @return 结果
     */
    public int insertSkiMessageBoard(SkiMessageBoard skiMessageBoard);

    /**
     * 修改留言板
     * 
     * @param skiMessageBoard 留言板
     * @return 结果
     */
    public int updateSkiMessageBoard(SkiMessageBoard skiMessageBoard);

    /**
     * 批量删除留言板
     * 
     * @param ids 需要删除的留言板主键集合
     * @return 结果
     */
    public int deleteSkiMessageBoardByIds(Long[] ids);

    /**
     * 删除留言板信息
     * 
     * @param id 留言板主键
     * @return 结果
     */
    public int deleteSkiMessageBoardById(Long id);

    /**
     * 点赞/取消点赞
     * 
     * @param messageId 留言ID
     * @param userId 用户ID
     * @return 结果（1点赞成功，-1取消点赞成功）
     */
    public int toggleLike(Long messageId, Long userId);

    /**
     * 检查用户是否已点赞
     * 
     * @param messageId 留言ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    public boolean isLiked(Long messageId, Long userId);
}
