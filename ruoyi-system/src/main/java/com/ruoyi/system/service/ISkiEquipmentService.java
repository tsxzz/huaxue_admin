package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiEquipment;

/**
 * 雪具信息Service接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface ISkiEquipmentService 
{
    /**
     * 查询雪具信息
     * 
     * @param id 雪具信息主键
     * @return 雪具信息
     */
    public SkiEquipment selectSkiEquipmentById(Long id);

    /**
     * 查询雪具信息列表
     * 
     * @param skiEquipment 雪具信息
     * @return 雪具信息集合
     */
    public List<SkiEquipment> selectSkiEquipmentList(SkiEquipment skiEquipment);

    /**
     * 新增雪具信息
     * 
     * @param skiEquipment 雪具信息
     * @return 结果
     */
    public int insertSkiEquipment(SkiEquipment skiEquipment);

    /**
     * 修改雪具信息
     * 
     * @param skiEquipment 雪具信息
     * @return 结果
     */
    public int updateSkiEquipment(SkiEquipment skiEquipment);

    /**
     * 批量删除雪具信息
     * 
     * @param ids 需要删除的雪具信息主键集合
     * @return 结果
     */
    public int deleteSkiEquipmentByIds(Long[] ids);

    /**
     * 删除雪具信息信息
     * 
     * @param id 雪具信息主键
     * @return 结果
     */
    public int deleteSkiEquipmentById(Long id);

    /**
     * 报修雪具（将可用数量转为维修中）
     * 
     * @param id 雪具ID
     * @param quantity 报修数量
     * @return 结果
     */
    public int reportMaintenance(Long id, Integer quantity);

    /**
     * 完成维修（将维修中数量转为可用）
     * 
     * @param id 雪具ID
     * @param quantity 完成维修数量
     * @return 结果
     */
    public int completeMaintenance(Long id, Integer quantity);

    /**
     * 报废雪具（将可用或维修中数量转为报废）
     * 
     * @param id 雪具ID
     * @param quantity 报废数量
     * @return 结果
     */
    public int scrapEquipment(Long id, Integer quantity);
}
