package com.ruoyi.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.TableField;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import com.fasterxml.jackson.annotation.JsonFormat;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

/**
 * 雪具租赁信息对象 ski_equipment_rental
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@ApiModel("雪具租赁信息实体")
@TableName("ski_equipment_rental")
public class SkiEquipmentRental extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 租赁ID */
    @ApiModelProperty("租赁ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 租赁单号 */
    @ApiModelProperty(value = "租赁单号", required = true)
    @Excel(name = "租赁单号")
    @NotBlank(message = "租赁单号不能为空")
    private String rentalNo;

    /** 雪具ID */
    @ApiModelProperty(value = "雪具ID", required = true)
    @Excel(name = "雪具ID")
    @NotNull(message = "雪具ID不能为空")
    private Long equipmentId;

    /** 雪具名称 */
    @ApiModelProperty("雪具名称")
    @Excel(name = "雪具名称")
    private String equipmentName;

    /** 租赁数量 */
    @ApiModelProperty(value = "租赁数量", required = true)
    @Excel(name = "租赁数量")
    @NotNull(message = "租赁数量不能为空")
    private Integer rentalQuantity;

    /** 租赁人姓名 */
    @ApiModelProperty(value = "租赁人姓名", required = true)
    @Excel(name = "租赁人姓名")
    @NotBlank(message = "租赁人姓名不能为空")
    private String renterName;

    /** 租赁人电话 */
    @ApiModelProperty(value = "租赁人电话", required = true)
    @Excel(name = "租赁人电话")
    @NotBlank(message = "租赁人电话不能为空")
    private String renterPhone;

    /** 租赁人身份证号 */
    @ApiModelProperty("租赁人身份证号")
    @Excel(name = "租赁人身份证号")
    private String renterIdCard;

    /** 租赁开始时间 */
    @ApiModelProperty(value = "租赁开始时间", required = true)
    @Excel(name = "租赁开始时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @NotNull(message = "租赁开始时间不能为空")
    private Date rentalStartTime;

    /** 租赁结束时间 */
    @ApiModelProperty("租赁结束时间")
    @Excel(name = "租赁结束时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date rentalEndTime;

    /** 预计归还时间 */
    @ApiModelProperty(value = "预计归还时间", required = true)
    @Excel(name = "预计归还时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @NotNull(message = "预计归还时间不能为空")
    private Date expectedReturnTime;

    /** 实际归还时间 */
    @ApiModelProperty("实际归还时间")
    @Excel(name = "实际归还时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date actualReturnTime;

    /** 租赁天数 */
    @ApiModelProperty("租赁天数")
    @Excel(name = "租赁天数")
    private Integer rentalDays;

    /** 单价（每天） */
    @ApiModelProperty("单价（每天）")
    @Excel(name = "单价")
    private BigDecimal unitPrice;

    /** 总金额 */
    @ApiModelProperty("总金额")
    @Excel(name = "总金额")
    private BigDecimal totalAmount;

    /** 已付金额 */
    @ApiModelProperty("已付金额")
    @Excel(name = "已付金额")
    private BigDecimal paidAmount;

    /** 押金 */
    @ApiModelProperty("押金")
    @Excel(name = "押金")
    private BigDecimal deposit;

    /** 状态（0待支付 1租赁中 2已归还 3已取消 4逾期） */
    @ApiModelProperty(value = "状态（0待支付 1租赁中 2已归还 3已取消 4逾期）")
    @Excel(name = "状态", readConverterExp = "0=待支付,1=租赁中,2=已归还,3=已取消,4=逾期")
    private Integer status;

    /** 搜索值（不存在于数据库表中） */
    @TableField(exist = false)
    private String searchValue;

    /** 参数（不存在于数据库表中） */
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

    public void setRentalNo(String rentalNo) 
    {
        this.rentalNo = rentalNo;
    }

    public String getRentalNo() 
    {
        return rentalNo;
    }

    public void setEquipmentId(Long equipmentId) 
    {
        this.equipmentId = equipmentId;
    }

    public Long getEquipmentId() 
    {
        return equipmentId;
    }

    public void setEquipmentName(String equipmentName) 
    {
        this.equipmentName = equipmentName;
    }

    public String getEquipmentName() 
    {
        return equipmentName;
    }

    public void setRentalQuantity(Integer rentalQuantity) 
    {
        this.rentalQuantity = rentalQuantity;
    }

    public Integer getRentalQuantity() 
    {
        return rentalQuantity;
    }

    public void setRenterName(String renterName) 
    {
        this.renterName = renterName;
    }

    public String getRenterName() 
    {
        return renterName;
    }

    public void setRenterPhone(String renterPhone) 
    {
        this.renterPhone = renterPhone;
    }

    public String getRenterPhone() 
    {
        return renterPhone;
    }

    public void setRenterIdCard(String renterIdCard) 
    {
        this.renterIdCard = renterIdCard;
    }

    public String getRenterIdCard() 
    {
        return renterIdCard;
    }

    public void setRentalStartTime(Date rentalStartTime) 
    {
        this.rentalStartTime = rentalStartTime;
    }

    public Date getRentalStartTime() 
    {
        return rentalStartTime;
    }

    public void setRentalEndTime(Date rentalEndTime) 
    {
        this.rentalEndTime = rentalEndTime;
    }

    public Date getRentalEndTime() 
    {
        return rentalEndTime;
    }

    public void setExpectedReturnTime(Date expectedReturnTime) 
    {
        this.expectedReturnTime = expectedReturnTime;
    }

    public Date getExpectedReturnTime() 
    {
        return expectedReturnTime;
    }

    public void setActualReturnTime(Date actualReturnTime) 
    {
        this.actualReturnTime = actualReturnTime;
    }

    public Date getActualReturnTime() 
    {
        return actualReturnTime;
    }

    public void setRentalDays(Integer rentalDays) 
    {
        this.rentalDays = rentalDays;
    }

    public Integer getRentalDays() 
    {
        return rentalDays;
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

    public void setDeposit(BigDecimal deposit) 
    {
        this.deposit = deposit;
    }

    public BigDecimal getDeposit() 
    {
        return deposit;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    @Override
    public String getSearchValue() {
        return this.searchValue;
    }

    @Override
    public void setSearchValue(String searchValue) {
        this.searchValue = searchValue;
    }

    @Override
    public Map<String, Object> getParams() {
        return this.params;
    }

    @Override
    public void setParams(Map<String, Object> params) {
        this.params = params;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("rentalNo", getRentalNo())
            .append("equipmentId", getEquipmentId())
            .append("equipmentName", getEquipmentName())
            .append("rentalQuantity", getRentalQuantity())
            .append("renterName", getRenterName())
            .append("renterPhone", getRenterPhone())
            .append("renterIdCard", getRenterIdCard())
            .append("rentalStartTime", getRentalStartTime())
            .append("rentalEndTime", getRentalEndTime())
            .append("expectedReturnTime", getExpectedReturnTime())
            .append("actualReturnTime", getActualReturnTime())
            .append("rentalDays", getRentalDays())
            .append("unitPrice", getUnitPrice())
            .append("totalAmount", getTotalAmount())
            .append("paidAmount", getPaidAmount())
            .append("deposit", getDeposit())
            .append("status", getStatus())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
