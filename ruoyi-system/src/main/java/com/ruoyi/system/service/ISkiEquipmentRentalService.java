package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiEquipmentRental;

/**
 * 雪具租赁信息Service接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface ISkiEquipmentRentalService 
{
    /**
     * 查询雪具租赁信息
     * 
     * @param id 雪具租赁信息主键
     * @return 雪具租赁信息
     */
    public SkiEquipmentRental selectSkiEquipmentRentalById(Long id);

    /**
     * 查询雪具租赁信息列表
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 雪具租赁信息集合
     */
    public List<SkiEquipmentRental> selectSkiEquipmentRentalList(SkiEquipmentRental skiEquipmentRental);

    /**
     * 新增雪具租赁信息（会检查库存并更新雪具数量）
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 结果
     */
    public int insertSkiEquipmentRental(SkiEquipmentRental skiEquipmentRental);

    /**
     * 修改雪具租赁信息
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 结果
     */
    public int updateSkiEquipmentRental(SkiEquipmentRental skiEquipmentRental);

    /**
     * 批量删除雪具租赁信息
     * 
     * @param ids 需要删除的雪具租赁信息主键集合
     * @return 结果
     */
    public int deleteSkiEquipmentRentalByIds(Long[] ids);

    /**
     * 删除雪具租赁信息信息
     * 
     * @param id 雪具租赁信息主键
     * @return 结果
     */
    public int deleteSkiEquipmentRentalById(Long id);

    /**
     * 归还雪具（更新租赁状态并恢复库存）
     * 
     * @param id 租赁ID
     * @return 结果
     */
    public int returnEquipment(Long id);

    /**
     * 取消租赁（更新租赁状态并恢复库存）
     * 
     * @param id 租赁ID
     * @return 结果
     */
    public int cancelRental(Long id);
}
