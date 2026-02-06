package com.ruoyi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.system.domain.SkiSlope;
import org.apache.ibatis.annotations.Mapper;

/**
 * 雪道信息Mapper接口
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Mapper
public interface SkiSlopeMapper extends BaseMapper<SkiSlope>
{
    // MyBatis-Plus已经提供了基础的CRUD方法，无需自定义
    // selectById, insert, updateById, deleteById 等方法都可以直接使用
}
