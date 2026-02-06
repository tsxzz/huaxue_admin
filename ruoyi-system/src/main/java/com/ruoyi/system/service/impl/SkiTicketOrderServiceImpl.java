package com.ruoyi.system.service.impl;

import java.util.Date;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiTicketOrderMapper;
import com.ruoyi.system.domain.SkiTicketOrder;
import com.ruoyi.system.service.ISkiTicketOrderService;

/**
 * 门票订单Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@Service
public class SkiTicketOrderServiceImpl implements ISkiTicketOrderService 
{
    @Autowired
    private SkiTicketOrderMapper skiTicketOrderMapper;

    /**
     * 查询门票订单
     * 
     * @param id 门票订单主键
     * @return 门票订单
     */
    @Override
    public SkiTicketOrder selectSkiTicketOrderById(Long id)
    {
        return skiTicketOrderMapper.selectById(id);
    }

    /**
     * 查询门票订单列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiTicketOrder 门票订单
     * @return 门票订单
     */
    @Override
    public List<SkiTicketOrder> selectSkiTicketOrderList(SkiTicketOrder skiTicketOrder)
    {
        LambdaQueryWrapper<SkiTicketOrder> wrapper = Wrappers.lambdaQuery();
        
        // 用户ID过滤（重要：确保用户只能看到自己的订单）
        wrapper.eq(skiTicketOrder.getUserId() != null, SkiTicketOrder::getUserId, skiTicketOrder.getUserId())
               .eq(skiTicketOrder.getTicketTypeId() != null, SkiTicketOrder::getTicketTypeId, skiTicketOrder.getTicketTypeId())
               .like(StringUtils.isNotBlank(skiTicketOrder.getOrderNo()), SkiTicketOrder::getOrderNo, skiTicketOrder.getOrderNo())
               .like(StringUtils.isNotBlank(skiTicketOrder.getTicketTypeName()), SkiTicketOrder::getTicketTypeName, skiTicketOrder.getTicketTypeName())
               .like(StringUtils.isNotBlank(skiTicketOrder.getVisitorName()), SkiTicketOrder::getVisitorName, skiTicketOrder.getVisitorName())
               .eq(StringUtils.isNotBlank(skiTicketOrder.getVisitorPhone()), SkiTicketOrder::getVisitorPhone, skiTicketOrder.getVisitorPhone())
               .eq(StringUtils.isNotBlank(skiTicketOrder.getOrderStatus()), SkiTicketOrder::getOrderStatus, skiTicketOrder.getOrderStatus())
               .ge(skiTicketOrder.getBookingDate() != null, SkiTicketOrder::getBookingDate, skiTicketOrder.getBookingDate())
               .orderByDesc(SkiTicketOrder::getCreateTime);
        
        return skiTicketOrderMapper.selectList(wrapper);
    }

    /**
     * 新增门票订单
     * 
     * @param skiTicketOrder 门票订单
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiTicketOrder(SkiTicketOrder skiTicketOrder)
    {
        // 生成订单号（如果为空）
        if (StringUtils.isBlank(skiTicketOrder.getOrderNo())) {
            skiTicketOrder.setOrderNo(generateOrderNo());
        }
        
        // 设置当前用户ID（如果为空）
        if (skiTicketOrder.getUserId() == null) {
            try {
                Long userId = com.ruoyi.common.utils.SecurityUtils.getUserId();
                skiTicketOrder.setUserId(userId);
            } catch (Exception e) {
                // 如果获取用户ID失败，可能是未登录，记录日志但不抛出异常
                // 实际场景中应该要求用户登录
            }
        }
        
        // 设置默认值
        if (StringUtils.isBlank(skiTicketOrder.getOrderStatus())) {
            skiTicketOrder.setOrderStatus("0"); // 待支付
        }
        if (skiTicketOrder.getPaidAmount() == null) {
            skiTicketOrder.setPaidAmount(java.math.BigDecimal.ZERO);
        }
        if (StringUtils.isBlank(skiTicketOrder.getRefundStatus())) {
            skiTicketOrder.setRefundStatus("0"); // 无退款
        }
        if (skiTicketOrder.getRefundAmount() == null) {
            skiTicketOrder.setRefundAmount(java.math.BigDecimal.ZERO);
        }
        
        return skiTicketOrderMapper.insert(skiTicketOrder);
    }

    /**
     * 修改门票订单
     * 
     * @param skiTicketOrder 门票订单
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiTicketOrder(SkiTicketOrder skiTicketOrder)
    {
        return skiTicketOrderMapper.updateById(skiTicketOrder);
    }

    /**
     * 批量删除门票订单
     * 
     * @param ids 需要删除的门票订单主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiTicketOrderByIds(Long[] ids)
    {
        return skiTicketOrderMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除门票订单信息
     * 
     * @param id 门票订单主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiTicketOrderById(Long id)
    {
        return skiTicketOrderMapper.deleteById(id);
    }

    /**
     * 处理退票
     * 
     * @param id 订单ID
     * @param refundReason 退款原因
     * @return 结果
     */
    @Override
    @Transactional
    public int refundTicket(Long id, String refundReason)
    {
        SkiTicketOrder order = skiTicketOrderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        
        // 只有已支付的订单才能退票
        if (!"1".equals(order.getOrderStatus())) {
            throw new RuntimeException("只有已支付的订单才能退票");
        }
        
        // 更新订单状态和退款信息
        order.setOrderStatus("3"); // 已退票
        order.setRefundStatus("2"); // 已退款
        order.setRefundAmount(order.getPaidAmount()); // 退款金额等于已支付金额
        order.setRefundReason(refundReason);
        order.setRefundTime(new Date());
        
        return skiTicketOrderMapper.updateById(order);
    }

    /**
     * 支付订单
     * 
     * @param id 订单ID
     * @param paymentMethod 支付方式（1现金 2微信 3支付宝 4银行卡）
     * @return 结果
     */
    @Override
    @Transactional
    public int payTicketOrder(Long id, String paymentMethod)
    {
        SkiTicketOrder order = skiTicketOrderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        
        // 只有待支付的订单才能支付
        if (!"0".equals(order.getOrderStatus())) {
            throw new RuntimeException("只有待支付的订单才能支付");
        }
        
        // 更新订单状态和支付信息
        order.setOrderStatus("1"); // 已支付
        order.setPaymentMethod(paymentMethod);
        order.setPaymentTime(new Date());
        order.setPaidAmount(order.getTotalAmount()); // 已支付金额等于总金额
        
        return skiTicketOrderMapper.updateById(order);
    }

    /**
     * 取消订单
     * 
     * @param id 订单ID
     * @return 结果
     */
    @Override
    @Transactional
    public int cancelTicketOrder(Long id)
    {
        SkiTicketOrder order = skiTicketOrderMapper.selectById(id);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        
        // 只有待支付的订单才能取消
        if (!"0".equals(order.getOrderStatus())) {
            throw new RuntimeException("只有待支付的订单才能取消");
        }
        
        // 更新订单状态
        order.setOrderStatus("4"); // 已取消
        
        return skiTicketOrderMapper.updateById(order);
    }

    /**
     * 生成订单号：T + 年月日 + 6位随机数
     * 
     * @return 订单号
     */
    private String generateOrderNo()
    {
        String dateStr = DateUtils.parseDateToStr("yyyyMMdd", new Date());
        int random = (int)((Math.random() * 9 + 1) * 100000);
        return "T" + dateStr + random;
    }
}
