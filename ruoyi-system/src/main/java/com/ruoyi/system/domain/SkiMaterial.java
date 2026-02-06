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
 * 物资管理对象 ski_material
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("物资管理实体")
@TableName("ski_material")
public class SkiMaterial extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 物资ID */
    @ApiModelProperty("物资ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 物资编码 */
    @ApiModelProperty(value = "物资编码", required = true)
    @Excel(name = "物资编码")
    @NotBlank(message = "物资编码不能为空")
    private String materialCode;

    /** 物资名称 */
    @ApiModelProperty(value = "物资名称", required = true)
    @Excel(name = "物资名称")
    @NotBlank(message = "物资名称不能为空")
    private String materialName;

    /** 物资类型（1急救药品 2医疗用品 3其他） */
    @ApiModelProperty("物资类型")
    @Excel(name = "物资类型", readConverterExp = "1=急救药品,2=医疗用品,3=其他")
    private String materialType;

    /** 规格型号 */
    @ApiModelProperty("规格型号")
    @Excel(name = "规格型号")
    private String specification;

    /** 单位 */
    @ApiModelProperty("单位")
    @Excel(name = "单位")
    private String unit;

    /** 生产厂家 */
    @ApiModelProperty("生产厂家")
    @Excel(name = "生产厂家")
    private String manufacturer;

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

    /** 安全库存 */
    @ApiModelProperty("安全库存")
    @Excel(name = "安全库存")
    private Integer safetyStock;

    /** 当前库存 */
    @ApiModelProperty("当前库存")
    @Excel(name = "当前库存")
    private Integer currentStock;

    /** 单价 */
    @ApiModelProperty("单价")
    @Excel(name = "单价")
    private BigDecimal unitPrice;

    /** 存放位置 */
    @ApiModelProperty("存放位置")
    @Excel(name = "存放位置")
    private String storageLocation;

    /** 状态（0正常 1停用） */
    @ApiModelProperty("状态")
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 是否即将过期（30天内） */
    @TableField(exist = false)
    private Boolean isExpiringSoon;

    /** 是否库存不足 */
    @TableField(exist = false)
    private Boolean isLowStock;

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

    public void setMaterialType(String materialType) 
    {
        this.materialType = materialType;
    }

    public String getMaterialType() 
    {
        return materialType;
    }

    public void setSpecification(String specification) 
    {
        this.specification = specification;
    }

    public String getSpecification() 
    {
        return specification;
    }

    public void setUnit(String unit) 
    {
        this.unit = unit;
    }

    public String getUnit() 
    {
        return unit;
    }

    public void setManufacturer(String manufacturer) 
    {
        this.manufacturer = manufacturer;
    }

    public String getManufacturer() 
    {
        return manufacturer;
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

    public void setSafetyStock(Integer safetyStock) 
    {
        this.safetyStock = safetyStock;
    }

    public Integer getSafetyStock() 
    {
        return safetyStock;
    }

    public void setCurrentStock(Integer currentStock) 
    {
        this.currentStock = currentStock;
    }

    public Integer getCurrentStock() 
    {
        return currentStock;
    }

    public void setUnitPrice(BigDecimal unitPrice) 
    {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getUnitPrice() 
    {
        return unitPrice;
    }

    public void setStorageLocation(String storageLocation) 
    {
        this.storageLocation = storageLocation;
    }

    public String getStorageLocation() 
    {
        return storageLocation;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public Boolean getIsExpiringSoon() 
    {
        return isExpiringSoon;
    }

    public void setIsExpiringSoon(Boolean isExpiringSoon) 
    {
        this.isExpiringSoon = isExpiringSoon;
    }

    public Boolean getIsLowStock() 
    {
        return isLowStock;
    }

    public void setIsLowStock(Boolean isLowStock) 
    {
        this.isLowStock = isLowStock;
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
            .append("materialCode", getMaterialCode())
            .append("materialName", getMaterialName())
            .append("materialType", getMaterialType())
            .append("specification", getSpecification())
            .append("unit", getUnit())
            .append("manufacturer", getManufacturer())
            .append("batchNumber", getBatchNumber())
            .append("productionDate", getProductionDate())
            .append("expiryDate", getExpiryDate())
            .append("safetyStock", getSafetyStock())
            .append("currentStock", getCurrentStock())
            .append("unitPrice", getUnitPrice())
            .append("storageLocation", getStorageLocation())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
