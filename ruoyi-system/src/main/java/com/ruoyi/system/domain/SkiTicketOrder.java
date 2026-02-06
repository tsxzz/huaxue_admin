package com.ruoyi.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

/**
 * 门票订单对象 ski_ticket_order
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@ApiModel("门票订单实体")
@TableName("ski_ticket_order")
public class SkiTicketOrder extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 订单ID */
    @ApiModelProperty("订单ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 订单号 */
    @ApiModelProperty(value = "订单号", required = true)
    @Excel(name = "订单号")
    @NotBlank(message = "订单号不能为空")
    private String orderNo;

    /** 用户ID（订单所属用户） */
    @ApiModelProperty("用户ID")
    @Excel(name = "用户ID")
    private Long userId;

    /** 票种ID */
    @ApiModelProperty(value = "票种ID", required = true)
    @Excel(name = "票种ID")
    @NotNull(message = "票种ID不能为空")
    private Long ticketTypeId;

    /** 票种名称 */
    @ApiModelProperty("票种名称")
    @Excel(name = "票种名称")
    private String ticketTypeName;

    /** 游客姓名 */
    @ApiModelProperty(value = "游客姓名", required = true)
    @Excel(name = "游客姓名")
    @NotBlank(message = "游客姓名不能为空")
    private String visitorName;

    /** 游客手机号 */
    @ApiModelProperty(value = "游客手机号", required = true)
    @Excel(name = "游客手机号")
    @NotBlank(message = "游客手机号不能为空")
    private String visitorPhone;

    /** 游客身份证号 */
    @ApiModelProperty("游客身份证号")
    @Excel(name = "游客身份证号")
    private String visitorIdCard;

    /** 购票数量 */
    @ApiModelProperty(value = "购票数量", required = true)
    @Excel(name = "购票数量")
    @NotNull(message = "购票数量不能为空")
    private Integer ticketCount;

    /** 单价 */
    @ApiModelProperty(value = "单价", required = true)
    @Excel(name = "单价")
    @NotNull(message = "单价不能为空")
    private BigDecimal unitPrice;

    /** 总金额 */
    @ApiModelProperty(value = "总金额", required = true)
    @Excel(name = "总金额")
    @NotNull(message = "总金额不能为空")
    private BigDecimal totalAmount;

    /** 已支付金额 */
    @ApiModelProperty("已支付金额")
    @Excel(name = "已支付金额")
    private BigDecimal paidAmount;

    /** 预订日期 */
    @ApiModelProperty(value = "预订日期", required = true)
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "预订日期", width = 30, dateFormat = "yyyy-MM-dd")
    @NotNull(message = "预订日期不能为空")
    private Date bookingDate;

    /** 使用日期 */
    @ApiModelProperty("使用日期")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "使用日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date useDate;

    /** 订单状态（0待支付 1已支付 2已使用 3已退票 4已取消） */
    @ApiModelProperty("订单状态（0待支付 1已支付 2已使用 3已退票 4已取消）")
    @Excel(name = "订单状态", readConverterExp = "0=待支付,1=已支付,2=已使用,3=已退票,4=已取消")
    private String orderStatus;

    /** 支付方式（1现金 2微信 3支付宝 4银行卡） */
    @ApiModelProperty("支付方式（1现金 2微信 3支付宝 4银行卡）")
    @Excel(name = "支付方式", readConverterExp = "1=现金,2=微信,3=支付宝,4=银行卡")
    private String paymentMethod;

    /** 支付时间 */
    @ApiModelProperty("支付时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "支付时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date paymentTime;

    /** 退款金额 */
    @ApiModelProperty("退款金额")
    @Excel(name = "退款金额")
    private BigDecimal refundAmount;

    /** 退款原因 */
    @ApiModelProperty("退款原因")
    @Excel(name = "退款原因")
    private String refundReason;

    /** 退款时间 */
    @ApiModelProperty("退款时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "退款时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date refundTime;

    /** 退款状态（0无退款 1退款中 2已退款 3退款失败） */
    @ApiModelProperty("退款状态（0无退款 1退款中 2已退款 3退款失败）")
    @Excel(name = "退款状态", readConverterExp = "0=无退款,1=退款中,2=已退款,3=退款失败")
    private String refundStatus;

    /** 搜索值（不存在于数据库表） */
    @TableField(exist = false)
    private String searchValue;

    /** 请求参数 */
    @TableField(exist = false)
    private Map<String, Object> params;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setOrderNo(String orderNo) 
    {
        this.orderNo = orderNo;
    }

    public String getOrderNo() 
    {
        return orderNo;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setTicketTypeId(Long ticketTypeId) 
    {
        this.ticketTypeId = ticketTypeId;
    }

    public Long getTicketTypeId() 
    {
        return ticketTypeId;
    }

    public void setTicketTypeName(String ticketTypeName) 
    {
        this.ticketTypeName = ticketTypeName;
    }

    public String getTicketTypeName() 
    {
        return ticketTypeName;
    }

    public void setVisitorName(String visitorName) 
    {
        this.visitorName = visitorName;
    }

    public String getVisitorName() 
    {
        return visitorName;
    }

    public void setVisitorPhone(String visitorPhone) 
    {
        this.visitorPhone = visitorPhone;
    }

    public String getVisitorPhone() 
    {
        return visitorPhone;
    }

    public void setVisitorIdCard(String visitorIdCard) 
    {
        this.visitorIdCard = visitorIdCard;
    }

    public String getVisitorIdCard() 
    {
        return visitorIdCard;
    }

    public void setTicketCount(Integer ticketCount) 
    {
        this.ticketCount = ticketCount;
    }

    public Integer getTicketCount() 
    {
        return ticketCount;
    }

    public void setUnitPrice(BigDecimal unitPrice) 
    {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getUnitPrice() 
    {
        return unitPrice;
    }

    public void setTotalAmount(BigDecimal totalAmount) 
    {
        this.totalAmount = totalAmount;
    }

    public BigDecimal getTotalAmount() 
    {
        return totalAmount;
    }

    public void setPaidAmount(BigDecimal paidAmount) 
    {
        this.paidAmount = paidAmount;
    }

    public BigDecimal getPaidAmount() 
    {
        return paidAmount;
    }

    public void setBookingDate(Date bookingDate) 
    {
        this.bookingDate = bookingDate;
    }

    public Date getBookingDate() 
    {
        return bookingDate;
    }

    public void setUseDate(Date useDate) 
    {
        this.useDate = useDate;
    }

    public Date getUseDate() 
    {
        return useDate;
    }

    public void setOrderStatus(String orderStatus) 
    {
        this.orderStatus = orderStatus;
    }

    public String getOrderStatus() 
    {
        return orderStatus;
    }

    public void setPaymentMethod(String paymentMethod) 
    {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentMethod() 
    {
        return paymentMethod;
    }

    public void setPaymentTime(Date paymentTime) 
    {
        this.paymentTime = paymentTime;
    }

    public Date getPaymentTime() 
    {
        return paymentTime;
    }

    public void setRefundAmount(BigDecimal refundAmount) 
    {
        this.refundAmount = refundAmount;
    }

    public BigDecimal getRefundAmount() 
    {
        return refundAmount;
    }

    public void setRefundReason(String refundReason) 
    {
        this.refundReason = refundReason;
    }

    public String getRefundReason() 
    {
        return refundReason;
    }

    public void setRefundTime(Date refundTime) 
    {
        this.refundTime = refundTime;
    }

    public Date getRefundTime() 
    {
        return refundTime;
    }

    public void setRefundStatus(String refundStatus) 
    {
        this.refundStatus = refundStatus;
    }

    public String getRefundStatus() 
    {
        return refundStatus;
    }

    public Map<String, Object> getParams() 
    {
        if (params == null) 
        {
            params = new java.util.HashMap<>();
        }
        return params;
    }

    public void setParams(Map<String, Object> params) 
    {
        this.params = params;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("orderNo", getOrderNo())
            .append("ticketTypeId", getTicketTypeId())
            .append("ticketTypeName", getTicketTypeName())
            .append("visitorName", getVisitorName())
            .append("visitorPhone", getVisitorPhone())
            .append("visitorIdCard", getVisitorIdCard())
            .append("ticketCount", getTicketCount())
            .append("unitPrice", getUnitPrice())
            .append("totalAmount", getTotalAmount())
            .append("paidAmount", getPaidAmount())
            .append("bookingDate", getBookingDate())
            .append("useDate", getUseDate())
            .append("orderStatus", getOrderStatus())
            .append("paymentMethod", getPaymentMethod())
            .append("paymentTime", getPaymentTime())
            .append("refundAmount", getRefundAmount())
            .append("refundReason", getRefundReason())
            .append("refundTime", getRefundTime())
            .append("refundStatus", getRefundStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
