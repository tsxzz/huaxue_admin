package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiMaterialStock;

/**
 * 出入库记录Service接口
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
public interface ISkiMaterialStockService 
{
    /**
     * 查询出入库记录
     * 
     * @param id 出入库记录主键
     * @return 出入库记录
     */
    public SkiMaterialStock selectSkiMaterialStockById(Long id);

    /**
     * 查询出入库记录列表
     * 
     * @param skiMaterialStock 出入库记录
     * @return 出入库记录集合
     */
    public List<SkiMaterialStock> selectSkiMaterialStockList(SkiMaterialStock skiMaterialStock);

    /**
     * 新增出入库记录
     * 
     * @param skiMaterialStock 出入库记录
     * @return 结果
     */
    public int insertSkiMaterialStock(SkiMaterialStock skiMaterialStock);

    /**
     * 修改出入库记录
     * 
     * @param skiMaterialStock 出入库记录
     * @return 结果
     */
    public int updateSkiMaterialStock(SkiMaterialStock skiMaterialStock);

    /**
     * 批量删除出入库记录
     * 
     * @param ids 需要删除的出入库记录主键集合
     * @return 结果
     */
    public int deleteSkiMaterialStockByIds(Long[] ids);

    /**
     * 删除出入库记录信息
     * 
     * @param id 出入库记录主键
     * @return 结果
     */
    public int deleteSkiMaterialStockById(Long id);
}
