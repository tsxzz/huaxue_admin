package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiMaterialUsageMapper;
import com.ruoyi.system.mapper.SkiMaterialMapper;
import com.ruoyi.system.domain.SkiMaterialUsage;
import com.ruoyi.system.domain.SkiMaterial;
import com.ruoyi.system.service.ISkiMaterialUsageService;

/**
 * 领用记录Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Service
public class SkiMaterialUsageServiceImpl implements ISkiMaterialUsageService 
{
    @Autowired
    private SkiMaterialUsageMapper skiMaterialUsageMapper;

    @Autowired
    private SkiMaterialMapper skiMaterialMapper;

    /**
     * 查询领用记录
     * 
     * @param id 领用记录主键
     * @return 领用记录
     */
    @Override
    public SkiMaterialUsage selectSkiMaterialUsageById(Long id)
    {
        return skiMaterialUsageMapper.selectById(id);
    }

    /**
     * 查询领用记录列表
     * 
     * @param skiMaterialUsage 领用记录
     * @return 领用记录集合
     */
    @Override
    public List<SkiMaterialUsage> selectSkiMaterialUsageList(SkiMaterialUsage skiMaterialUsage)
    {
        LambdaQueryWrapper<SkiMaterialUsage> wrapper = Wrappers.lambdaQuery();
        
        wrapper.eq(skiMaterialUsage.getMaterialId() != null, SkiMaterialUsage::getMaterialId, skiMaterialUsage.getMaterialId())
               .eq(skiMaterialUsage.getUserId() != null, SkiMaterialUsage::getUserId, skiMaterialUsage.getUserId())
               .eq(StringUtils.isNotBlank(skiMaterialUsage.getReturnStatus()), SkiMaterialUsage::getReturnStatus, skiMaterialUsage.getReturnStatus())
               .eq(StringUtils.isNotBlank(skiMaterialUsage.getApprovalStatus()), SkiMaterialUsage::getApprovalStatus, skiMaterialUsage.getApprovalStatus())
               .like(StringUtils.isNotBlank(skiMaterialUsage.getMaterialCode()), SkiMaterialUsage::getMaterialCode, skiMaterialUsage.getMaterialCode())
               .like(StringUtils.isNotBlank(skiMaterialUsage.getMaterialName()), SkiMaterialUsage::getMaterialName, skiMaterialUsage.getMaterialName())
               .orderByDesc(SkiMaterialUsage::getUsageTime);
        
        return skiMaterialUsageMapper.selectList(wrapper);
    }

    /**
     * 新增领用记录
     * 
     * @param skiMaterialUsage 领用记录
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiMaterialUsage(SkiMaterialUsage skiMaterialUsage)
    {
        // 设置领用人和领用时间
        Long userId = SecurityUtils.getUserId();
        String userName = SecurityUtils.getUsername();
        skiMaterialUsage.setUserId(userId);
        skiMaterialUsage.setUserName(userName);
        skiMaterialUsage.setUsageTime(DateUtils.getNowDate());
        
        // 设置默认审批状态
        if (StringUtils.isBlank(skiMaterialUsage.getApprovalStatus())) {
            skiMaterialUsage.setApprovalStatus("0"); // 待审批
        }
        if (StringUtils.isBlank(skiMaterialUsage.getReturnStatus())) {
            skiMaterialUsage.setReturnStatus("0"); // 未归还
        }
        
        // 如果物资信息为空，从物资表获取
        if (skiMaterialUsage.getMaterialId() != null) {
            SkiMaterial material = skiMaterialMapper.selectById(skiMaterialUsage.getMaterialId());
            if (material != null) {
                if (StringUtils.isBlank(skiMaterialUsage.getMaterialCode())) {
                    skiMaterialUsage.setMaterialCode(material.getMaterialCode());
                }
                if (StringUtils.isBlank(skiMaterialUsage.getMaterialName())) {
                    skiMaterialUsage.setMaterialName(material.getMaterialName());
                }
            }
        }
        
        return skiMaterialUsageMapper.insert(skiMaterialUsage);
    }

    /**
     * 修改领用记录
     * 
     * @param skiMaterialUsage 领用记录
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiMaterialUsage(SkiMaterialUsage skiMaterialUsage)
    {
        return skiMaterialUsageMapper.updateById(skiMaterialUsage);
    }

    /**
     * 批量删除领用记录
     * 
     * @param ids 需要删除的领用记录主键集合
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialUsageByIds(Long[] ids)
    {
        for (Long id : ids) {
            skiMaterialUsageMapper.deleteById(id);
        }
        return ids.length;
    }

    /**
     * 删除领用记录信息
     * 
     * @param id 领用记录主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialUsageById(Long id)
    {
        return skiMaterialUsageMapper.deleteById(id);
    }

    /**
     * 审批领用申请
     * 
     * @param id 领用ID
     * @param approvalStatus 审批状态（1已批准 2已拒绝）
     * @param approvalRemark 审批意见
     * @return 结果
     */
    @Override
    @Transactional
    public int approveUsage(Long id, String approvalStatus, String approvalRemark)
    {
        SkiMaterialUsage usage = skiMaterialUsageMapper.selectById(id);
        if (usage == null) {
            return 0;
        }
        
        Long approverId = SecurityUtils.getUserId();
        String approverName = SecurityUtils.getUsername();
        
        LambdaUpdateWrapper<SkiMaterialUsage> wrapper = Wrappers.lambdaUpdate();
        wrapper.eq(SkiMaterialUsage::getId, id)
               .set(SkiMaterialUsage::getApprovalStatus, approvalStatus)
               .set(SkiMaterialUsage::getApprovalRemark, approvalRemark)
               .set(SkiMaterialUsage::getApproverId, approverId)
               .set(SkiMaterialUsage::getApproverName, approverName)
               .set(SkiMaterialUsage::getApprovalTime, DateUtils.getNowDate());
        
        int result = skiMaterialUsageMapper.update(null, wrapper);
        
        // 如果审批通过，减少库存
        if (result > 0 && "1".equals(approvalStatus) && usage.getMaterialId() != null) {
            SkiMaterial material = skiMaterialMapper.selectById(usage.getMaterialId());
            if (material != null) {
                int currentStock = material.getCurrentStock() != null ? material.getCurrentStock() : 0;
                material.setCurrentStock(Math.max(0, currentStock - usage.getQuantity()));
                skiMaterialMapper.updateById(material);
            }
        }
        
        return result;
    }

    /**
     * 归还物资
     * 
     * @param id 领用ID
     * @return 结果
     */
    @Override
    @Transactional
    public int returnMaterial(Long id)
    {
        SkiMaterialUsage usage = skiMaterialUsageMapper.selectById(id);
        if (usage == null || "1".equals(usage.getReturnStatus())) {
            return 0;
        }
        
        LambdaUpdateWrapper<SkiMaterialUsage> wrapper = Wrappers.lambdaUpdate();
        wrapper.eq(SkiMaterialUsage::getId, id)
               .set(SkiMaterialUsage::getReturnStatus, "1")
               .set(SkiMaterialUsage::getReturnTime, DateUtils.getNowDate());
        
        int result = skiMaterialUsageMapper.update(null, wrapper);
        
        // 归还后增加库存
        if (result > 0 && usage.getMaterialId() != null) {
            SkiMaterial material = skiMaterialMapper.selectById(usage.getMaterialId());
            if (material != null) {
                int currentStock = material.getCurrentStock() != null ? material.getCurrentStock() : 0;
                material.setCurrentStock(currentStock + usage.getQuantity());
                skiMaterialMapper.updateById(material);
            }
        }
        
        return result;
    }
}
