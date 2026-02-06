package com.ruoyi.system.service;

import java.util.List;
import com.ruoyi.system.domain.SkiTicketOrder;

/**
 * 门票订单Service接口
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
public interface ISkiTicketOrderService 
{
    /**
     * 查询门票订单
     * 
     * @param id 门票订单主键
     * @return 门票订单
     */
    public SkiTicketOrder selectSkiTicketOrderById(Long id);

    /**
     * 查询门票订单列表
     * 
     * @param skiTicketOrder 门票订单
     * @return 门票订单集合
     */
    public List<SkiTicketOrder> selectSkiTicketOrderList(SkiTicketOrder skiTicketOrder);

    /**
     * 新增门票订单
     * 
     * @param skiTicketOrder 门票订单
     * @return 结果
     */
    public int insertSkiTicketOrder(SkiTicketOrder skiTicketOrder);

    /**
     * 修改门票订单
     * 
     * @param skiTicketOrder 门票订单
     * @return 结果
     */
    public int updateSkiTicketOrder(SkiTicketOrder skiTicketOrder);

    /**
     * 批量删除门票订单
     * 
     * @param ids 需要删除的门票订单主键集合
     * @return 结果
     */
    public int deleteSkiTicketOrderByIds(Long[] ids);

    /**
     * 删除门票订单信息
     * 
     * @param id 门票订单主键
     * @return 结果
     */
    public int deleteSkiTicketOrderById(Long id);

    /**
     * 处理退票
     * 
     * @param id 订单ID
     * @param refundReason 退款原因
     * @return 结果
     */
    public int refundTicket(Long id, String refundReason);

    /**
     * 支付订单
     * 
     * @param id 订单ID
     * @param paymentMethod 支付方式（1现金 2微信 3支付宝 4银行卡）
     * @return 结果
     */
    public int payTicketOrder(Long id, String paymentMethod);

    /**
     * 取消订单
     * 
     * @param id 订单ID
     * @return 结果
     */
    public int cancelTicketOrder(Long id);
}
