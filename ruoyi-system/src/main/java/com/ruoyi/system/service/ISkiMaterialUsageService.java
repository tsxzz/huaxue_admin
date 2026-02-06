package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiMaterialUsage;

/**
 * 领用记录Service接口
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
public interface ISkiMaterialUsageService 
{
    /**
     * 查询领用记录
     * 
     * @param id 领用记录主键
     * @return 领用记录
     */
    public SkiMaterialUsage selectSkiMaterialUsageById(Long id);

    /**
     * 查询领用记录列表
     * 
     * @param skiMaterialUsage 领用记录
     * @return 领用记录集合
     */
    public List<SkiMaterialUsage> selectSkiMaterialUsageList(SkiMaterialUsage skiMaterialUsage);

    /**
     * 新增领用记录
     * 
     * @param skiMaterialUsage 领用记录
     * @return 结果
     */
    public int insertSkiMaterialUsage(SkiMaterialUsage skiMaterialUsage);

    /**
     * 修改领用记录
     * 
     * @param skiMaterialUsage 领用记录
     * @return 结果
     */
    public int updateSkiMaterialUsage(SkiMaterialUsage skiMaterialUsage);

    /**
     * 批量删除领用记录
     * 
     * @param ids 需要删除的领用记录主键集合
     * @return 结果
     */
    public int deleteSkiMaterialUsageByIds(Long[] ids);

    /**
     * 删除领用记录信息
     * 
     * @param id 领用记录主键
     * @return 结果
     */
    public int deleteSkiMaterialUsageById(Long id);

    /**
     * 审批领用申请
     * 
     * @param id 领用ID
     * @param approvalStatus 审批状态（1已批准 2已拒绝）
     * @param approvalRemark 审批意见
     * @return 结果
     */
    public int approveUsage(Long id, String approvalStatus, String approvalRemark);

    /**
     * 归还物资
     * 
     * @param id 领用ID
     * @return 结果
     */
    public int returnMaterial(Long id);
}
