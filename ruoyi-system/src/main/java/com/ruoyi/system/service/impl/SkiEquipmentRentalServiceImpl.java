package com.ruoyi.system.service.impl;

import java.util.List;
import java.util.UUID;
import java.math.BigDecimal;
import java.util.Date;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiEquipmentRentalMapper;
import com.ruoyi.system.mapper.SkiEquipmentMapper;
import com.ruoyi.system.domain.SkiEquipmentRental;
import com.ruoyi.system.domain.SkiEquipment;
import com.ruoyi.system.service.ISkiEquipmentRentalService;

/**
 * 雪具租赁信息Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Service
public class SkiEquipmentRentalServiceImpl implements ISkiEquipmentRentalService 
{
    @Autowired
    private SkiEquipmentRentalMapper skiEquipmentRentalMapper;

    @Autowired
    private SkiEquipmentMapper skiEquipmentMapper;

    /**
     * 查询雪具租赁信息
     * 
     * @param id 雪具租赁信息主键
     * @return 雪具租赁信息
     */
    @Override
    public SkiEquipmentRental selectSkiEquipmentRentalById(Long id)
    {
        return skiEquipmentRentalMapper.selectById(id);
    }

    /**
     * 查询雪具租赁信息列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 雪具租赁信息
     */
    @Override
    public List<SkiEquipmentRental> selectSkiEquipmentRentalList(SkiEquipmentRental skiEquipmentRental)
    {
        LambdaQueryWrapper<SkiEquipmentRental> wrapper = Wrappers.lambdaQuery();
        
        wrapper.like(StringUtils.isNotBlank(skiEquipmentRental.getRentalNo()), SkiEquipmentRental::getRentalNo, skiEquipmentRental.getRentalNo())
               .like(StringUtils.isNotBlank(skiEquipmentRental.getRenterName()), SkiEquipmentRental::getRenterName, skiEquipmentRental.getRenterName())
               .like(StringUtils.isNotBlank(skiEquipmentRental.getRenterPhone()), SkiEquipmentRental::getRenterPhone, skiEquipmentRental.getRenterPhone())
               .eq(skiEquipmentRental.getEquipmentId() != null, SkiEquipmentRental::getEquipmentId, skiEquipmentRental.getEquipmentId())
               .eq(skiEquipmentRental.getStatus() != null, SkiEquipmentRental::getStatus, skiEquipmentRental.getStatus())
               .orderByDesc(SkiEquipmentRental::getCreateTime);
        
        return skiEquipmentRentalMapper.selectList(wrapper);
    }

    /**
     * 新增雪具租赁信息（会检查库存并更新雪具数量）
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiEquipmentRental(SkiEquipmentRental skiEquipmentRental)
    {
        // 1. 检查雪具是否存在
        SkiEquipment equipment = skiEquipmentMapper.selectById(skiEquipmentRental.getEquipmentId());
        if (equipment == null) {
            throw new RuntimeException("雪具不存在");
        }

        // 2. 检查可用数量是否足够
        if (equipment.getAvailableQuantity() == null || equipment.getAvailableQuantity() < skiEquipmentRental.getRentalQuantity()) {
            throw new RuntimeException("可用数量不足，无法租赁");
        }

        // 3. 生成租赁单号
        if (StringUtils.isBlank(skiEquipmentRental.getRentalNo())) {
            skiEquipmentRental.setRentalNo("RENT" + System.currentTimeMillis() + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }

        // 4. 计算租赁天数
        if (skiEquipmentRental.getRentalStartTime() != null && skiEquipmentRental.getExpectedReturnTime() != null) {
            long days = (skiEquipmentRental.getExpectedReturnTime().getTime() - skiEquipmentRental.getRentalStartTime().getTime()) / (1000 * 60 * 60 * 24);
            skiEquipmentRental.setRentalDays((int) Math.max(1, days));
        }

        // 5. 计算总金额
        if (skiEquipmentRental.getUnitPrice() != null && skiEquipmentRental.getRentalQuantity() != null && skiEquipmentRental.getRentalDays() != null) {
            BigDecimal total = skiEquipmentRental.getUnitPrice()
                .multiply(BigDecimal.valueOf(skiEquipmentRental.getRentalQuantity()))
                .multiply(BigDecimal.valueOf(skiEquipmentRental.getRentalDays()));
            skiEquipmentRental.setTotalAmount(total);
        }

        // 6. 设置默认值
        if (skiEquipmentRental.getStatus() == null) {
            skiEquipmentRental.setStatus(1); // 默认租赁中
        }
        if (skiEquipmentRental.getPaidAmount() == null) {
            skiEquipmentRental.setPaidAmount(BigDecimal.ZERO);
        }
        if (skiEquipmentRental.getRentalStartTime() == null) {
            skiEquipmentRental.setRentalStartTime(new Date());
        }

        // 7. 保存租赁记录
        skiEquipmentRental.setCreateTime(DateUtils.getNowDate());
        int result = skiEquipmentRentalMapper.insert(skiEquipmentRental);

        // 8. 更新雪具库存：可用数量减少，已租数量增加
        equipment.setAvailableQuantity(equipment.getAvailableQuantity() - skiEquipmentRental.getRentalQuantity());
        if (equipment.getRentedQuantity() == null) {
            equipment.setRentedQuantity(0);
        }
        equipment.setRentedQuantity(equipment.getRentedQuantity() + skiEquipmentRental.getRentalQuantity());
        
        // 更新状态
        updateEquipmentStatus(equipment);
        equipment.setUpdateTime(DateUtils.getNowDate());
        skiEquipmentMapper.updateById(equipment);

        return result;
    }

    /**
     * 修改雪具租赁信息
     * 
     * @param skiEquipmentRental 雪具租赁信息
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiEquipmentRental(SkiEquipmentRental skiEquipmentRental)
    {
        skiEquipmentRental.setUpdateTime(DateUtils.getNowDate());
        return skiEquipmentRentalMapper.updateById(skiEquipmentRental);
    }

    /**
     * 批量删除雪具租赁信息
     * 
     * @param ids 需要删除的雪具租赁信息主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiEquipmentRentalByIds(Long[] ids)
    {
        // 删除前需要恢复库存
        for (Long id : ids) {
            SkiEquipmentRental rental = skiEquipmentRentalMapper.selectById(id);
            if (rental != null && rental.getStatus() == 1) { // 只有租赁中的才需要恢复库存
                returnEquipment(id);
            }
        }
        return skiEquipmentRentalMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除雪具租赁信息信息
     * 
     * @param id 雪具租赁信息主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiEquipmentRentalById(Long id)
    {
        // 删除前需要恢复库存
        SkiEquipmentRental rental = skiEquipmentRentalMapper.selectById(id);
        if (rental != null && rental.getStatus() == 1) { // 只有租赁中的才需要恢复库存
            returnEquipment(id);
        }
        return skiEquipmentRentalMapper.deleteById(id);
    }

    /**
     * 归还雪具（更新租赁状态并恢复库存）
     * 
     * @param id 租赁ID
     * @return 结果
     */
    @Override
    @Transactional
    public int returnEquipment(Long id)
    {
        SkiEquipmentRental rental = skiEquipmentRentalMapper.selectById(id);
        if (rental == null) {
            return 0;
        }

        if (rental.getStatus() != 1) {
            throw new RuntimeException("只有租赁中的订单才能归还");
        }

        // 更新租赁记录
        rental.setStatus(2); // 已归还
        rental.setActualReturnTime(new Date());
        rental.setRentalEndTime(new Date());
        rental.setUpdateTime(DateUtils.getNowDate());
        skiEquipmentRentalMapper.updateById(rental);

        // 恢复雪具库存：可用数量增加，已租数量减少
        SkiEquipment equipment = skiEquipmentMapper.selectById(rental.getEquipmentId());
        if (equipment != null) {
            equipment.setAvailableQuantity((equipment.getAvailableQuantity() == null ? 0 : equipment.getAvailableQuantity()) + rental.getRentalQuantity());
            equipment.setRentedQuantity((equipment.getRentedQuantity() == null ? 0 : equipment.getRentedQuantity()) - rental.getRentalQuantity());
            if (equipment.getRentedQuantity() < 0) {
                equipment.setRentedQuantity(0);
            }
            
            // 更新状态
            updateEquipmentStatus(equipment);
            equipment.setUpdateTime(DateUtils.getNowDate());
            skiEquipmentMapper.updateById(equipment);
        }

        return 1;
    }

    /**
     * 取消租赁（更新租赁状态并恢复库存）
     * 
     * @param id 租赁ID
     * @return 结果
     */
    @Override
    @Transactional
    public int cancelRental(Long id)
    {
        SkiEquipmentRental rental = skiEquipmentRentalMapper.selectById(id);
        if (rental == null) {
            return 0;
        }

        if (rental.getStatus() != 0 && rental.getStatus() != 1) {
            throw new RuntimeException("只有待支付或租赁中的订单才能取消");
        }

        // 保存原始状态，用于判断是否需要恢复库存
        Integer originalStatus = rental.getStatus();

        // 更新租赁记录
        rental.setStatus(3); // 已取消
        rental.setUpdateTime(DateUtils.getNowDate());
        skiEquipmentRentalMapper.updateById(rental);

        // 如果原始状态是租赁中，需要恢复库存
        if (originalStatus != null && originalStatus == 1) {
            SkiEquipment equipment = skiEquipmentMapper.selectById(rental.getEquipmentId());
            if (equipment != null) {
                equipment.setAvailableQuantity((equipment.getAvailableQuantity() == null ? 0 : equipment.getAvailableQuantity()) + rental.getRentalQuantity());
                equipment.setRentedQuantity((equipment.getRentedQuantity() == null ? 0 : equipment.getRentedQuantity()) - rental.getRentalQuantity());
                if (equipment.getRentedQuantity() < 0) {
                    equipment.setRentedQuantity(0);
                }
                
                // 更新状态
                updateEquipmentStatus(equipment);
                equipment.setUpdateTime(DateUtils.getNowDate());
                skiEquipmentMapper.updateById(equipment);
            }
        }

        return 1;
    }

    /**
     * 自动更新雪具状态
     * 0缺货 1可用 2部分可用 3维修中
     */
    private void updateEquipmentStatus(SkiEquipment equipment) {
        if (equipment.getTotalQuantity() == null || equipment.getTotalQuantity() == 0) {
            equipment.setStatus(0); // 缺货
        } else if (equipment.getAvailableQuantity() == null || equipment.getAvailableQuantity() == 0) {
            if (equipment.getMaintenanceQuantity() != null && equipment.getMaintenanceQuantity() > 0) {
                equipment.setStatus(3); // 维修中
            } else {
                equipment.setStatus(0); // 缺货
            }
        } else if (equipment.getAvailableQuantity().equals(equipment.getTotalQuantity())) {
            equipment.setStatus(1); // 可用
        } else {
            equipment.setStatus(2); // 部分可用
        }
    }
}
