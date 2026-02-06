package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.system.domain.SkiCoachInfo;
import com.ruoyi.system.mapper.SkiCoachInfoMapper;
import com.ruoyi.system.service.ISkiCoachInfoService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.common.core.domain.entity.SysUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

/**
 * 教练信息Service业务层处理
 * 
 * @author ruoyi
 */
@Service
public class SkiCoachInfoServiceImpl implements ISkiCoachInfoService {
    @Autowired
    private SkiCoachInfoMapper skiCoachInfoMapper;

    @Autowired
    private ISysUserService userService;

    /**
     * 查询教练信息
     * 
     * @param id 教练信息主键
     * @return 教练信息
     */
    @Override
    public SkiCoachInfo selectSkiCoachInfoById(Long id) {
        SkiCoachInfo coachInfo = skiCoachInfoMapper.selectById(id);
        if (coachInfo != null && coachInfo.getUserId() != null) {
            SysUser user = userService.selectUserById(coachInfo.getUserId());
            coachInfo.setUser(user);
        }
        return coachInfo;
    }

    /**
     * 根据用户ID查询教练信息
     * 
     * @param userId 用户ID
     * @return 教练信息
     */
    @Override
    public SkiCoachInfo selectSkiCoachInfoByUserId(Long userId) {
        LambdaQueryWrapper<SkiCoachInfo> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiCoachInfo::getUserId, userId);
        SkiCoachInfo coachInfo = skiCoachInfoMapper.selectOne(wrapper);
        if (coachInfo != null && coachInfo.getUserId() != null) {
            SysUser user = userService.selectUserById(coachInfo.getUserId());
            coachInfo.setUser(user);
        }
        return coachInfo;
    }

    /**
     * 查询教练信息列表
     * 
     * @param skiCoachInfo 教练信息
     * @return 教练信息
     */
    @Override
    public List<SkiCoachInfo> selectSkiCoachInfoList(SkiCoachInfo skiCoachInfo) {
        LambdaQueryWrapper<SkiCoachInfo> wrapper = Wrappers.lambdaQuery();
        if (skiCoachInfo.getCoachLevel() != null && !skiCoachInfo.getCoachLevel().isEmpty()) {
            wrapper.eq(SkiCoachInfo::getCoachLevel, skiCoachInfo.getCoachLevel());
        }
        if (skiCoachInfo.getStatus() != null) {
            wrapper.eq(SkiCoachInfo::getStatus, skiCoachInfo.getStatus());
        } else {
            // 默认只查询正常状态的教练
            wrapper.eq(SkiCoachInfo::getStatus, "0");
        }
        if (skiCoachInfo.getUserId() != null) {
            wrapper.eq(SkiCoachInfo::getUserId, skiCoachInfo.getUserId());
        }
        List<SkiCoachInfo> list = skiCoachInfoMapper.selectList(wrapper);
        
        // 关联用户信息
        if (list != null && !list.isEmpty()) {
            List<Long> userIds = list.stream()
                .map(SkiCoachInfo::getUserId)
                .filter(userId -> userId != null)
                .distinct()
                .collect(Collectors.toList());
            
            if (!userIds.isEmpty()) {
                // 逐个查询用户信息（因为MyBatis-Plus没有批量查询方法）
                for (SkiCoachInfo coach : list) {
                    if (coach.getUserId() != null) {
                        SysUser user = userService.selectUserById(coach.getUserId());
                        if (user != null) {
                            coach.setUser(user);
                        }
                    }
                }
            }
        }
        
        return list;
    }

    /**
     * 新增教练信息
     * 
     * @param skiCoachInfo 教练信息
     * @return 结果
     */
    @Override
    public int insertSkiCoachInfo(SkiCoachInfo skiCoachInfo) {
        if (skiCoachInfo.getUserId() == null) {
            skiCoachInfo.setUserId(SecurityUtils.getUserId());
        }
        if (skiCoachInfo.getStatus() == null) {
            skiCoachInfo.setStatus("0");
        }
        return skiCoachInfoMapper.insert(skiCoachInfo);
    }

    /**
     * 修改教练信息
     * 
     * @param skiCoachInfo 教练信息
     * @return 结果
     */
    @Override
    public int updateSkiCoachInfo(SkiCoachInfo skiCoachInfo) {
        return skiCoachInfoMapper.updateById(skiCoachInfo);
    }

    /**
     * 批量删除教练信息
     * 
     * @param ids 需要删除的教练信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiCoachInfoByIds(Long[] ids) {
        return skiCoachInfoMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除教练信息信息
     * 
     * @param id 教练信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiCoachInfoById(Long id) {
        return skiCoachInfoMapper.deleteById(id);
    }
}
