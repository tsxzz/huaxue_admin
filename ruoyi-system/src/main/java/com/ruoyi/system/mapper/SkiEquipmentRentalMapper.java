package com.ruoyi.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.ruoyi.system.domain.SkiEquipmentRental;
import org.apache.ibatis.annotations.Mapper;

/**
 * 雪具租赁信息Mapper接口（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Mapper
public interface SkiEquipmentRentalMapper extends BaseMapper<SkiEquipmentRental>
{
    // 使用MyBatis-Plus的BaseMapper提供的CRUD方法，无需编写XML文件
}
