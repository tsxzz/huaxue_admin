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

import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Date;
import java.util.Map;

/**
 * 出入库记录对象 ski_material_stock
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("出入库记录实体")
@TableName("ski_material_stock")
public class SkiMaterialStock extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 记录ID */
    @ApiModelProperty("记录ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 物资ID */
    @ApiModelProperty(value = "物资ID", required = true)
    @Excel(name = "物资ID")
    @NotNull(message = "物资ID不能为空")
    private Long materialId;

    /** 物资编码 */
    @ApiModelProperty("物资编码")
    @Excel(name = "物资编码")
    private String materialCode;

    /** 物资名称 */
    @ApiModelProperty("物资名称")
    @Excel(name = "物资名称")
    private String materialName;

    /** 操作类型（1入库 2出库） */
    @ApiModelProperty(value = "操作类型", required = true)
    @Excel(name = "操作类型", readConverterExp = "1=入库,2=出库")
    @NotNull(message = "操作类型不能为空")
    private String operationType;

    /** 数量 */
    @ApiModelProperty(value = "数量", required = true)
    @Excel(name = "数量")
    @NotNull(message = "数量不能为空")
    private Integer quantity;

    /** 单价 */
    @ApiModelProperty("单价")
    @Excel(name = "单价")
    private BigDecimal unitPrice;

    /** 总金额 */
    @ApiModelProperty("总金额")
    @Excel(name = "总金额")
    private BigDecimal totalAmount;

    /** 批次号 */
    @ApiModelProperty("批次号")
    @Excel(name = "批次号")
    private String batchNumber;

    /** 生产日期 */
    @ApiModelProperty("生产日期")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "生产日期", width = 30, dateFormat = "yyyy-MM-dd")
    private Date productionDate;

    /** 有效期至 */
    @ApiModelProperty("有效期至")
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "有效期至", width = 30, dateFormat = "yyyy-MM-dd")
    private Date expiryDate;

    /** 操作人ID */
    @ApiModelProperty("操作人ID")
    @Excel(name = "操作人ID")
    private Long operatorId;

    /** 操作人姓名 */
    @ApiModelProperty("操作人姓名")
    @Excel(name = "操作人姓名")
    private String operatorName;

    /** 操作时间 */
    @ApiModelProperty("操作时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date operationTime;

    /** 供应商 */
    @ApiModelProperty("供应商")
    @Excel(name = "供应商")
    private String supplier;

    /** 用途说明 */
    @ApiModelProperty("用途说明")
    @Excel(name = "用途说明")
    private String purpose;

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

    public void setMaterialId(Long materialId) 
    {
        this.materialId = materialId;
    }

    public Long getMaterialId() 
    {
        return materialId;
    }

    public void setMaterialCode(String materialCode) 
    {
        this.materialCode = materialCode;
    }

    public String getMaterialCode() 
    {
        return materialCode;
    }

    public void setMaterialName(String materialName) 
    {
        this.materialName = materialName;
    }

    public String getMaterialName() 
    {
        return materialName;
    }

    public void setOperationType(String operationType) 
    {
        this.operationType = operationType;
    }

    public String getOperationType() 
    {
        return operationType;
    }

    public void setQuantity(Integer quantity) 
    {
        this.quantity = quantity;
    }

    public Integer getQuantity() 
    {
        return quantity;
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

    public void setBatchNumber(String batchNumber) 
    {
        this.batchNumber = batchNumber;
    }

    public String getBatchNumber() 
    {
        return batchNumber;
    }

    public void setProductionDate(Date productionDate) 
    {
        this.productionDate = productionDate;
    }

    public Date getProductionDate() 
    {
        return productionDate;
    }

    public void setExpiryDate(Date expiryDate) 
    {
        this.expiryDate = expiryDate;
    }

    public Date getExpiryDate() 
    {
        return expiryDate;
    }

    public void setOperatorId(Long operatorId) 
    {
        this.operatorId = operatorId;
    }

    public Long getOperatorId() 
    {
        return operatorId;
    }

    public void setOperatorName(String operatorName) 
    {
        this.operatorName = operatorName;
    }

    public String getOperatorName() 
    {
        return operatorName;
    }

    public void setOperationTime(Date operationTime) 
    {
        this.operationTime = operationTime;
    }

    public Date getOperationTime() 
    {
        return operationTime;
    }

    public void setSupplier(String supplier) 
    {
        this.supplier = supplier;
    }

    public String getSupplier() 
    {
        return supplier;
    }

    public void setPurpose(String purpose) 
    {
        this.purpose = purpose;
    }

    public String getPurpose() 
    {
        return purpose;
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
            .append("materialId", getMaterialId())
            .append("materialCode", getMaterialCode())
            .append("materialName", getMaterialName())
            .append("operationType", getOperationType())
            .append("quantity", getQuantity())
            .append("unitPrice", getUnitPrice())
            .append("totalAmount", getTotalAmount())
            .append("batchNumber", getBatchNumber())
            .append("productionDate", getProductionDate())
            .append("expiryDate", getExpiryDate())
            .append("operatorId", getOperatorId())
            .append("operatorName", getOperatorName())
            .append("operationTime", getOperationTime())
            .append("supplier", getSupplier())
            .append("purpose", getPurpose())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
