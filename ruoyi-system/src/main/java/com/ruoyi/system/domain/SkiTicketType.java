package com.ruoyi.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
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
 * 门票类型对象 ski_ticket_type
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@ApiModel("门票类型实体")
@TableName("ski_ticket_type")
public class SkiTicketType extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 票种ID */
    @ApiModelProperty("票种ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 票种编码 */
    @ApiModelProperty(value = "票种编码", required = true)
    @Excel(name = "票种编码")
    @NotBlank(message = "票种编码不能为空")
    private String ticketCode;

    /** 票种名称 */
    @ApiModelProperty(value = "票种名称", required = true)
    @Excel(name = "票种名称")
    @NotBlank(message = "票种名称不能为空")
    private String ticketName;

    /** 票种类型（1全天票 2半天票 3夜场票 4季票 5年票） */
    @ApiModelProperty(value = "票种类型（1全天票 2半天票 3夜场票 4季票 5年票）", required = true)
    @Excel(name = "票种类型", readConverterExp = "1=全天票,2=半天票,3=夜场票,4=季票,5=年票")
    @NotBlank(message = "票种类型不能为空")
    private String ticketType;

    /** 价格 */
    @ApiModelProperty(value = "价格", required = true)
    @Excel(name = "价格")
    @NotNull(message = "价格不能为空")
    private BigDecimal price;

    /** 有效期（天） */
    @ApiModelProperty("有效期（天）")
    @Excel(name = "有效期（天）")
    private Integer validDays;

    /** 票种描述 */
    @ApiModelProperty("票种描述")
    private String description;

    /** 票种图片 */
    @ApiModelProperty("票种图片")
    private String imageUrl;

    /** 状态（0正常 1停用） */
    @ApiModelProperty("状态（0正常 1停用）")
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    private String status;

    /** 排序 */
    @ApiModelProperty("排序")
    @Excel(name = "排序")
    private Integer sortOrder;

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

    public void setTicketCode(String ticketCode) 
    {
        this.ticketCode = ticketCode;
    }

    public String getTicketCode() 
    {
        return ticketCode;
    }

    public void setTicketName(String ticketName) 
    {
        this.ticketName = ticketName;
    }

    public String getTicketName() 
    {
        return ticketName;
    }

    public void setTicketType(String ticketType) 
    {
        this.ticketType = ticketType;
    }

    public String getTicketType() 
    {
        return ticketType;
    }

    public void setPrice(BigDecimal price) 
    {
        this.price = price;
    }

    public BigDecimal getPrice() 
    {
        return price;
    }

    public void setValidDays(Integer validDays) 
    {
        this.validDays = validDays;
    }

    public Integer getValidDays() 
    {
        return validDays;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getDescription() 
    {
        return description;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setSortOrder(Integer sortOrder) 
    {
        this.sortOrder = sortOrder;
    }

    public Integer getSortOrder() 
    {
        return sortOrder;
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
            .append("ticketCode", getTicketCode())
            .append("ticketName", getTicketName())
            .append("ticketType", getTicketType())
            .append("price", getPrice())
            .append("validDays", getValidDays())
            .append("description", getDescription())
            .append("imageUrl", getImageUrl())
            .append("status", getStatus())
            .append("sortOrder", getSortOrder())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
