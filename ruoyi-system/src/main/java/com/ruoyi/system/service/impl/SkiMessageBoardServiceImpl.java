package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiMessageBoardMapper;
import com.ruoyi.system.mapper.SkiMessageLikeMapper;
import com.ruoyi.system.domain.SkiMessageBoard;
import com.ruoyi.system.domain.SkiMessageLike;
import com.ruoyi.system.service.ISkiMessageBoardService;

/**
 * 留言板Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Service
public class SkiMessageBoardServiceImpl implements ISkiMessageBoardService 
{
    @Autowired
    private SkiMessageBoardMapper skiMessageBoardMapper;

    @Autowired
    private SkiMessageLikeMapper skiMessageLikeMapper;

    /**
     * 查询留言板
     * 
     * @param id 留言板主键
     * @return 留言板
     */
    @Override
    public SkiMessageBoard selectSkiMessageBoardById(Long id)
    {
        SkiMessageBoard message = skiMessageBoardMapper.selectById(id);
        if (message != null) {
            // 加载回复列表
            loadReplies(message);
            // 检查当前用户是否已点赞
            try {
                Long userId = SecurityUtils.getUserId();
                message.setIsLiked(isLiked(id, userId));
            } catch (Exception e) {
                message.setIsLiked(false);
            }
        }
        return message;
    }

    /**
     * 查询留言板列表（主留言，带回复）
     * 
     * @param skiMessageBoard 留言板
     * @return 留言板集合
     */
    @Override
    public List<SkiMessageBoard> selectSkiMessageBoardList(SkiMessageBoard skiMessageBoard)
    {
        LambdaQueryWrapper<SkiMessageBoard> wrapper = Wrappers.lambdaQuery();
        
        // 只查询主留言（parentId为NULL）
        wrapper.isNull(SkiMessageBoard::getParentId)
               .eq(StringUtils.isNotBlank(skiMessageBoard.getStatus()), SkiMessageBoard::getStatus, skiMessageBoard.getStatus())
               .like(StringUtils.isNotBlank(skiMessageBoard.getUserName()), SkiMessageBoard::getUserName, skiMessageBoard.getUserName())
               .like(StringUtils.isNotBlank(skiMessageBoard.getContent()), SkiMessageBoard::getContent, skiMessageBoard.getContent())
               .orderByDesc(SkiMessageBoard::getCreateTime);
        
        List<SkiMessageBoard> messages = skiMessageBoardMapper.selectList(wrapper);
        
        // 加载每个留言的回复和点赞状态
        Long currentUserId = null;
        try {
            currentUserId = SecurityUtils.getUserId();
        } catch (Exception e) {
            // 未登录用户
        }
        
        for (SkiMessageBoard message : messages) {
            loadReplies(message);
            if (currentUserId != null) {
                message.setIsLiked(isLiked(message.getId(), currentUserId));
            } else {
                message.setIsLiked(false);
            }
        }
        
        return messages;
    }

    /**
     * 加载回复列表
     */
    private void loadReplies(SkiMessageBoard message) {
        LambdaQueryWrapper<SkiMessageBoard> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMessageBoard::getParentId, message.getId())
               .eq(SkiMessageBoard::getStatus, "0")
               .orderByAsc(SkiMessageBoard::getCreateTime);
        
        List<SkiMessageBoard> replies = skiMessageBoardMapper.selectList(wrapper);
        message.setReplies(replies);
        message.setReplyCount(replies.size());
    }

    /**
     * 新增留言板
     * 
     * @param skiMessageBoard 留言板
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiMessageBoard(SkiMessageBoard skiMessageBoard)
    {
        // 设置当前用户ID和用户名
        Long userId = SecurityUtils.getUserId();
        skiMessageBoard.setUserId(userId);
        
        // 获取用户名（从SecurityUtils或用户服务）
        try {
            String userName = SecurityUtils.getUsername();
            skiMessageBoard.setUserName(userName);
        } catch (Exception e) {
            skiMessageBoard.setUserName("匿名用户");
        }
        
        // 设置默认值
        if (skiMessageBoard.getLikeCount() == null) {
            skiMessageBoard.setLikeCount(0);
        }
        if (skiMessageBoard.getReplyCount() == null) {
            skiMessageBoard.setReplyCount(0);
        }
        if (StringUtils.isBlank(skiMessageBoard.getStatus())) {
            skiMessageBoard.setStatus("0"); // 正常
        }
        
        int result = skiMessageBoardMapper.insert(skiMessageBoard);
        
        // 如果是回复，更新父留言的回复数
        if (skiMessageBoard.getParentId() != null) {
            updateParentReplyCount(skiMessageBoard.getParentId());
        }
        
        return result;
    }

    /**
     * 更新父留言的回复数
     */
    private void updateParentReplyCount(Long parentId) {
        LambdaQueryWrapper<SkiMessageBoard> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMessageBoard::getParentId, parentId)
               .eq(SkiMessageBoard::getStatus, "0");
        int count = skiMessageBoardMapper.selectCount(wrapper).intValue();
        
        LambdaUpdateWrapper<SkiMessageBoard> updateWrapper = Wrappers.lambdaUpdate();
        updateWrapper.eq(SkiMessageBoard::getId, parentId)
                     .set(SkiMessageBoard::getReplyCount, count);
        skiMessageBoardMapper.update(null, updateWrapper);
    }

    /**
     * 修改留言板
     * 
     * @param skiMessageBoard 留言板
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiMessageBoard(SkiMessageBoard skiMessageBoard)
    {
        return skiMessageBoardMapper.updateById(skiMessageBoard);
    }

    /**
     * 批量删除留言板
     * 
     * @param ids 需要删除的留言板主键集合
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMessageBoardByIds(Long[] ids)
    {
        // 软删除：更新状态为1
        for (Long id : ids) {
            SkiMessageBoard message = new SkiMessageBoard();
            message.setId(id);
            message.setStatus("1");
            skiMessageBoardMapper.updateById(message);
            
            // 同时删除该留言的所有回复
            LambdaUpdateWrapper<SkiMessageBoard> wrapper = Wrappers.lambdaUpdate();
            wrapper.eq(SkiMessageBoard::getParentId, id)
                   .set(SkiMessageBoard::getStatus, "1");
            skiMessageBoardMapper.update(null, wrapper);
        }
        return ids.length;
    }

    /**
     * 删除留言板信息
     * 
     * @param id 留言板主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMessageBoardById(Long id)
    {
        // 软删除
        SkiMessageBoard message = new SkiMessageBoard();
        message.setId(id);
        message.setStatus("1");
        
        // 同时删除该留言的所有回复
        LambdaUpdateWrapper<SkiMessageBoard> wrapper = Wrappers.lambdaUpdate();
        wrapper.eq(SkiMessageBoard::getParentId, id)
               .set(SkiMessageBoard::getStatus, "1");
        skiMessageBoardMapper.update(null, wrapper);
        
        return skiMessageBoardMapper.updateById(message);
    }

    /**
     * 点赞/取消点赞
     * 
     * @param messageId 留言ID
     * @param userId 用户ID
     * @return 结果（1点赞成功，-1取消点赞成功）
     */
    @Override
    @Transactional
    public int toggleLike(Long messageId, Long userId)
    {
        // 检查是否已点赞
        LambdaQueryWrapper<SkiMessageLike> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMessageLike::getMessageId, messageId)
               .eq(SkiMessageLike::getUserId, userId);
        
        SkiMessageLike like = skiMessageLikeMapper.selectOne(wrapper);
        
        if (like != null) {
            // 已点赞，取消点赞
            skiMessageLikeMapper.deleteById(like.getId());
            
            // 更新留言点赞数
            SkiMessageBoard message = skiMessageBoardMapper.selectById(messageId);
            if (message != null && message.getLikeCount() > 0) {
                message.setLikeCount(message.getLikeCount() - 1);
                skiMessageBoardMapper.updateById(message);
            }
            
            return -1; // 取消点赞
        } else {
            // 未点赞，添加点赞
            SkiMessageLike newLike = new SkiMessageLike();
            newLike.setMessageId(messageId);
            newLike.setUserId(userId);
            newLike.setCreateTime(DateUtils.getNowDate());
            skiMessageLikeMapper.insert(newLike);
            
            // 更新留言点赞数
            SkiMessageBoard message = skiMessageBoardMapper.selectById(messageId);
            if (message != null) {
                message.setLikeCount(message.getLikeCount() == null ? 1 : message.getLikeCount() + 1);
                skiMessageBoardMapper.updateById(message);
            }
            
            return 1; // 点赞成功
        }
    }

    /**
     * 检查用户是否已点赞
     * 
     * @param messageId 留言ID
     * @param userId 用户ID
     * @return 是否已点赞
     */
    @Override
    public boolean isLiked(Long messageId, Long userId)
    {
        LambdaQueryWrapper<SkiMessageLike> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMessageLike::getMessageId, messageId)
               .eq(SkiMessageLike::getUserId, userId);
        
        return skiMessageLikeMapper.selectCount(wrapper) > 0;
    }
}
