package com.ruoyi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.system.domain.SkiTicketOrder;
import org.apache.ibatis.annotations.Mapper;

/**
 * 门票订单Mapper接口（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@Mapper
public interface SkiTicketOrderMapper extends BaseMapper<SkiTicketOrder>
{
    // 使用MyBatis-Plus的BaseMapper提供的CRUD方法，无需编写XML文件
}
