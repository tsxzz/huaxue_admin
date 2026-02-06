package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiSlope;

/**
 * 雪道信息Service接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
public interface ISkiSlopeService 
{
    /**
     * 查询雪道信息
     * 
     * @param id 雪道信息主键
     * @return 雪道信息
     */
    SkiSlope selectSkiSlopeById(Long id);

    /**
     * 查询雪道信息列表
     * 
     * @param skiSlope 雪道信息
     * @return 雪道信息集合
     */
    List<SkiSlope> selectSkiSlopeList(SkiSlope skiSlope);

    /**
     * 新增雪道信息
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    int insertSkiSlope(SkiSlope skiSlope);

    /**
     * 修改雪道信息
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    int updateSkiSlope(SkiSlope skiSlope);

    /**
     * 批量删除雪道信息
     * 
     * @param ids 需要删除的雪道信息主键集合
     * @return 结果
     */
    int deleteSkiSlopeByIds(Long[] ids);

    /**
     * 删除雪道信息信息
     * 
     * @param id 雪道信息主键
     * @return 结果
     */
    int deleteSkiSlopeById(Long id);

    /**
     * 修改雪道状态
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    int changeStatus(SkiSlope skiSlope);
}
