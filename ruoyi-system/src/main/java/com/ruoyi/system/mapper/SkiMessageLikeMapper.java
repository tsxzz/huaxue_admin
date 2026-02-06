package com.ruoyi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.system.domain.SkiMessageLike;
import org.apache.ibatis.annotations.Mapper;

/**
 * 留言点赞Mapper接口（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Mapper
public interface SkiMessageLikeMapper extends BaseMapper<SkiMessageLike>
{
    // 使用MyBatis-Plus的BaseMapper提供的CRUD方法，无需编写XML文件
}
