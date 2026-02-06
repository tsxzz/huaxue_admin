package com.ruoyi.system.service;

import com.ruoyi.system.domain.SkiCoachInfo;
import java.util.List;

/**
 * 教练信息Service接口
 * 
 * @author ruoyi
 */
public interface ISkiCoachInfoService {
    /**
     * 查询教练信息
     * 
     * @param id 教练信息主键
     * @return 教练信息
     */
    public SkiCoachInfo selectSkiCoachInfoById(Long id);

    /**
     * 根据用户ID查询教练信息
     * 
     * @param userId 用户ID
     * @return 教练信息
     */
    public SkiCoachInfo selectSkiCoachInfoByUserId(Long userId);

    /**
     * 查询教练信息列表
     * 
     * @param skiCoachInfo 教练信息
     * @return 教练信息集合
     */
    public List<SkiCoachInfo> selectSkiCoachInfoList(SkiCoachInfo skiCoachInfo);

    /**
     * 新增教练信息
     * 
     * @param skiCoachInfo 教练信息
     * @return 结果
     */
    public int insertSkiCoachInfo(SkiCoachInfo skiCoachInfo);

    /**
     * 修改教练信息
     * 
     * @param skiCoachInfo 教练信息
     * @return 结果
     */
    public int updateSkiCoachInfo(SkiCoachInfo skiCoachInfo);

    /**
     * 批量删除教练信息
     * 
     * @param ids 需要删除的教练信息主键集合
     * @return 结果
     */
    public int deleteSkiCoachInfoByIds(Long[] ids);

    /**
     * 删除教练信息信息
     * 
     * @param id 教练信息主键
     * @return 结果
     */
    public int deleteSkiCoachInfoById(Long id);
}
