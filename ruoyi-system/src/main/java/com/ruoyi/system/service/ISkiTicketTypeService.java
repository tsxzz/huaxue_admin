package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiTicketType;

/**
 * 门票类型Service接口
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
public interface ISkiTicketTypeService 
{
    /**
     * 查询门票类型
     * 
     * @param id 门票类型主键
     * @return 门票类型
     */
    public SkiTicketType selectSkiTicketTypeById(Long id);

    /**
     * 查询门票类型列表
     * 
     * @param skiTicketType 门票类型
     * @return 门票类型集合
     */
    public List<SkiTicketType> selectSkiTicketTypeList(SkiTicketType skiTicketType);

    /**
     * 新增门票类型
     * 
     * @param skiTicketType 门票类型
     * @return 结果
     */
    public int insertSkiTicketType(SkiTicketType skiTicketType);

    /**
     * 修改门票类型
     * 
     * @param skiTicketType 门票类型
     * @return 结果
     */
    public int updateSkiTicketType(SkiTicketType skiTicketType);

    /**
     * 批量删除门票类型
     * 
     * @param ids 需要删除的门票类型主键集合
     * @return 结果
     */
    public int deleteSkiTicketTypeByIds(Long[] ids);

    /**
     * 删除门票类型信息
     * 
     * @param id 门票类型主键
     * @return 结果
     */
    public int deleteSkiTicketTypeById(Long id);
}
