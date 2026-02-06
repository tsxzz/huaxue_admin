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

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.Map;

/**
 * 雪具信息对象 ski_equipment
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@ApiModel("雪具信息实体")
@TableName("ski_equipment")
public class SkiEquipment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 雪具ID */
    @ApiModelProperty("雪具ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 雪具编号 */
    @ApiModelProperty(value = "雪具编号", required = true, example = "EQ001")
    @Excel(name = "雪具编号")
    @NotBlank(message = "雪具编号不能为空")
    private String equipmentCode;

    /** 雪具名称 */
    @ApiModelProperty(value = "雪具名称", required = true, example = "专业双板滑雪板")
    @Excel(name = "雪具名称")
    @NotBlank(message = "雪具名称不能为空")
    private String name;

    /** 雪具类型（1双板 2单板 3滑雪杖 4头盔 5护目镜 6滑雪服） */
    @ApiModelProperty(value = "雪具类型（1双板 2单板 3滑雪杖 4头盔 5护目镜 6滑雪服）", required = true, example = "1")
    @Excel(name = "雪具类型", readConverterExp = "1=双板,2=单板,3=滑雪杖,4=头盔,5=护目镜,6=滑雪服")
    @NotBlank(message = "雪具类型不能为空")
    private String category;

    /** 品牌 */
    @ApiModelProperty("品牌")
    @Excel(name = "品牌")
    private String brand;

    /** 型号 */
    @ApiModelProperty("型号")
    @Excel(name = "型号")
    private String model;

    /** 尺寸/规格 */
    @ApiModelProperty("尺寸/规格")
    @Excel(name = "尺寸/规格")
    private String size;

    /** 颜色 */
    @ApiModelProperty("颜色")
    @Excel(name = "颜色")
    private String color;

    /** 购买价格 */
    @ApiModelProperty("购买价格")
    @Excel(name = "购买价格")
    private BigDecimal purchasePrice;

    /** 租赁价格（按天） */
    @ApiModelProperty("租赁价格（按天）")
    @Excel(name = "租赁价格")
    private BigDecimal rentalPrice;

    /** 雪具图片 */
    @ApiModelProperty("雪具图片")
    @Excel(name = "雪具图片")
    private String imageUrl;

    /** 总库存数量 */
    @ApiModelProperty(value = "总库存数量", required = true, example = "100")
    @Excel(name = "总库存数量")
    @NotNull(message = "总库存数量不能为空")
    private Integer totalQuantity;

    /** 可用数量 */
    @ApiModelProperty(value = "可用数量", example = "80")
    @Excel(name = "可用数量")
    private Integer availableQuantity;

    /** 维修中数量 */
    @ApiModelProperty(value = "维修中数量", example = "10")
    @Excel(name = "维修中数量")
    private Integer maintenanceQuantity;

    /** 已租数量 */
    @ApiModelProperty(value = "已租数量", example = "5")
    @Excel(name = "已租数量")
    private Integer rentedQuantity;

    /** 报废数量 */
    @ApiModelProperty(value = "报废数量", example = "5")
    @Excel(name = "报废数量")
    private Integer scrapQuantity;

    /** 状态（0缺货 1可用 2部分可用 3维修中） */
    @ApiModelProperty(value = "状态（0缺货 1可用 2部分可用 3维修中）", example = "1")
    @Excel(name = "状态", readConverterExp = "0=缺货,1=可用,2=部分可用,3=维修中")
    private Integer status;

    /** 描述 */
    @ApiModelProperty("描述")
    @Excel(name = "描述")
    private String description;

    /** 搜索值（不存在于数据库表中，用于MyBatis-Plus忽略此字段） */
    @TableField(exist = false)
    private String searchValue;

    /** 参数（不存在于数据库表中，用于MyBatis-Plus忽略此字段） */
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

    public void setEquipmentCode(String equipmentCode) 
    {
        this.equipmentCode = equipmentCode;
    }

    public String getEquipmentCode() 
    {
        return equipmentCode;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    public String getName() 
    {
        return name;
    }

    public void setCategory(String category) 
    {
        this.category = category;
    }

    public String getCategory() 
    {
        return category;
    }

    public void setBrand(String brand) 
    {
        this.brand = brand;
    }

    public String getBrand() 
    {
        return brand;
    }

    public void setModel(String model) 
    {
        this.model = model;
    }

    public String getModel() 
    {
        return model;
    }

    public void setSize(String size) 
    {
        this.size = size;
    }

    public String getSize() 
    {
        return size;
    }

    public void setColor(String color) 
    {
        this.color = color;
    }

    public String getColor() 
    {
        return color;
    }

    public void setPurchasePrice(BigDecimal purchasePrice) 
    {
        this.purchasePrice = purchasePrice;
    }

    public BigDecimal getPurchasePrice() 
    {
        return purchasePrice;
    }

    public void setRentalPrice(BigDecimal rentalPrice) 
    {
        this.rentalPrice = rentalPrice;
    }

    public BigDecimal getRentalPrice() 
    {
        return rentalPrice;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setTotalQuantity(Integer totalQuantity) 
    {
        this.totalQuantity = totalQuantity;
    }

    public Integer getTotalQuantity() 
    {
        return totalQuantity;
    }

    public void setAvailableQuantity(Integer availableQuantity) 
    {
        this.availableQuantity = availableQuantity;
    }

    public Integer getAvailableQuantity() 
    {
        return availableQuantity;
    }

    public void setMaintenanceQuantity(Integer maintenanceQuantity) 
    {
        this.maintenanceQuantity = maintenanceQuantity;
    }

    public Integer getMaintenanceQuantity() 
    {
        return maintenanceQuantity;
    }

    public void setRentedQuantity(Integer rentedQuantity) 
    {
        this.rentedQuantity = rentedQuantity;
    }

    public Integer getRentedQuantity() 
    {
        return rentedQuantity;
    }

    public void setScrapQuantity(Integer scrapQuantity) 
    {
        this.scrapQuantity = scrapQuantity;
    }

    public Integer getScrapQuantity() 
    {
        return scrapQuantity;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    // 重写父类方法，使用本地字段
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
            .append("equipmentCode", getEquipmentCode())
            .append("name", getName())
            .append("category", getCategory())
            .append("brand", getBrand())
            .append("model", getModel())
            .append("size", getSize())
            .append("color", getColor())
            .append("purchasePrice", getPurchasePrice())
            .append("rentalPrice", getRentalPrice())
            .append("imageUrl", getImageUrl())
            .append("totalQuantity", getTotalQuantity())
            .append("availableQuantity", getAvailableQuantity())
            .append("maintenanceQuantity", getMaintenanceQuantity())
            .append("rentedQuantity", getRentedQuantity())
            .append("scrapQuantity", getScrapQuantity())
            .append("status", getStatus())
            .append("description", getDescription())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
