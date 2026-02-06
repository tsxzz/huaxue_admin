package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.system.domain.SkiNotice;
import com.ruoyi.system.mapper.SkiNoticeMapper;
import com.ruoyi.system.service.ISkiNoticeService;

/**
 * 通知管理Service业务层处理
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Service
public class SkiNoticeServiceImpl implements ISkiNoticeService 
{
    @Autowired
    private SkiNoticeMapper skiNoticeMapper;

    /**
     * 查询通知管理
     * 
     * @param id 通知管理主键
     * @return 通知管理
     */
    @Override
    public SkiNotice selectSkiNoticeById(Long id)
    {
        return skiNoticeMapper.selectById(id);
    }

    /**
     * 查询通知管理列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiNotice 通知管理
     * @return 通知管理
     */
    @Override
    public List<SkiNotice> selectSkiNoticeList(SkiNotice skiNotice)
    {
        LambdaQueryWrapper<SkiNotice> wrapper = Wrappers.lambdaQuery();
        
        wrapper.like(StringUtils.isNotBlank(skiNotice.getNoticeTitle()), SkiNotice::getNoticeTitle, skiNotice.getNoticeTitle())
               .eq(StringUtils.isNotBlank(skiNotice.getNoticeType()), SkiNotice::getNoticeType, skiNotice.getNoticeType())
               .eq(StringUtils.isNotBlank(skiNotice.getStatus()), SkiNotice::getStatus, skiNotice.getStatus())
               .eq(skiNotice.getPriority() != null, SkiNotice::getPriority, skiNotice.getPriority())
               .orderByDesc(SkiNotice::getPriority)
               .orderByDesc(SkiNotice::getCreateTime);
        
        return skiNoticeMapper.selectList(wrapper);
    }

    /**
     * 新增通知管理
     * 
     * @param skiNotice 通知管理
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiNotice(SkiNotice skiNotice)
    {
        // 设置默认值
        if (StringUtils.isBlank(skiNotice.getNoticeType())) {
            skiNotice.setNoticeType("1"); // 默认通知
        }
        if (StringUtils.isBlank(skiNotice.getStatus())) {
            skiNotice.setStatus("0"); // 默认正常
        }
        if (skiNotice.getPriority() == null) {
            skiNotice.setPriority(0); // 默认普通
        }
        if (skiNotice.getReadCount() == null) {
            skiNotice.setReadCount(0); // 默认阅读次数为0
        }
        
        return skiNoticeMapper.insert(skiNotice);
    }

    /**
     * 修改通知管理
     * 
     * @param skiNotice 通知管理
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiNotice(SkiNotice skiNotice)
    {
        return skiNoticeMapper.updateById(skiNotice);
    }

    /**
     * 批量删除通知管理
     * 
     * @param ids 需要删除的通知管理主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiNoticeByIds(Long[] ids)
    {
        return skiNoticeMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除通知管理信息
     * 
     * @param id 通知管理主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiNoticeById(Long id)
    {
        return skiNoticeMapper.deleteById(id);
    }

    /**
     * 发布通知
     * 
     * @param id 通知ID
     * @return 结果
     */
    @Override
    @Transactional
    public int publishNotice(Long id)
    {
        SkiNotice notice = new SkiNotice();
        notice.setId(id);
        notice.setStatus("0"); // 正常状态
        notice.setPublishTime(new Date());
        return skiNoticeMapper.updateById(notice);
    }

    /**
     * 关闭通知
     * 
     * @param id 通知ID
     * @return 结果
     */
    @Override
    @Transactional
    public int closeNotice(Long id)
    {
        SkiNotice notice = new SkiNotice();
        notice.setId(id);
        notice.setStatus("1"); // 关闭状态
        return skiNoticeMapper.updateById(notice);
    }
}
