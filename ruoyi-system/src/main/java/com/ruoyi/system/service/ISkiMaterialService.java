package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiMaterial;

/**
 * 物资管理Service接口
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
public interface ISkiMaterialService 
{
    /**
     * 查询物资管理
     * 
     * @param id 物资管理主键
     * @return 物资管理
     */
    public SkiMaterial selectSkiMaterialById(Long id);

    /**
     * 查询物资管理列表
     * 
     * @param skiMaterial 物资管理
     * @return 物资管理集合
     */
    public List<SkiMaterial> selectSkiMaterialList(SkiMaterial skiMaterial);

    /**
     * 新增物资管理
     * 
     * @param skiMaterial 物资管理
     * @return 结果
     */
    public int insertSkiMaterial(SkiMaterial skiMaterial);

    /**
     * 修改物资管理
     * 
     * @param skiMaterial 物资管理
     * @return 结果
     */
    public int updateSkiMaterial(SkiMaterial skiMaterial);

    /**
     * 批量删除物资管理
     * 
     * @param ids 需要删除的物资管理主键集合
     * @return 结果
     */
    public int deleteSkiMaterialByIds(Long[] ids);

    /**
     * 删除物资管理信息
     * 
     * @param id 物资管理主键
     * @return 结果
     */
    public int deleteSkiMaterialById(Long id);

    /**
     * 检查物资编码是否唯一
     * 
     * @param materialCode 物资编码
     * @param id 物资ID（更新时使用）
     * @return 是否唯一
     */
    public boolean checkMaterialCodeUnique(String materialCode, Long id);

    /**
     * 获取即将过期的物资（30天内）
     * 
     * @return 即将过期的物资列表
     */
    public List<SkiMaterial> getExpiringSoonMaterials();

    /**
     * 获取库存不足的物资
     * 
     * @return 库存不足的物资列表
     */
    public List<SkiMaterial> getLowStockMaterials();
}
