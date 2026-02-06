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
import javax.validation.constraints.Size;
import java.util.Map;

/**
 * 雪道信息对象 ski_slope
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@ApiModel("雪道信息实体")
@TableName("ski_slope")
public class SkiSlope extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 雪道ID */
    @ApiModelProperty("雪道ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 雪道名称 */
    @ApiModelProperty(value = "雪道名称", required = true, example = "初级雪道A")
    @Excel(name = "雪道名称")
    private String name;

    /** 雪道编号 */
    @ApiModelProperty(value = "雪道编号", required = true, example = "SLOPE001")
    @Excel(name = "雪道编号")
    private String slopeCode;

    /** 难度等级（1初级 2中级 3高级） */
    @ApiModelProperty(value = "难度等级（1初级 2中级 3高级）", required = true, example = "1")
    @Excel(name = "难度等级", readConverterExp = "1=初级,2=中级,3=高级")
    private String difficulty;

    /** 长度（米） */
    @ApiModelProperty(value = "长度（米）", required = true, example = "500")
    @Excel(name = "长度")
    private Integer length;

    /** 宽度（米） */
    @ApiModelProperty(value = "宽度（米）", required = true, example = "30")
    @Excel(name = "宽度")
    private Integer width;

    /** 最大容量（人） */
    @ApiModelProperty(value = "最大容量（人）", required = true, example = "100")
    @Excel(name = "最大容量")
    private Integer maxCapacity;

    /** 状态（0关闭 1开放） */
    @ApiModelProperty(value = "状态（0关闭 1开放）", example = "1")
    @Excel(name = "状态", readConverterExp = "0=关闭,1=开放")
    private Integer status;

    /** 描述 */
    @ApiModelProperty("描述")
    @Excel(name = "描述")
    private String description;

    /** 雪道图片 */
    @ApiModelProperty("雪道图片")
    @Excel(name = "雪道图片")
    private String imageUrl;

    /** 搜索值（不存在于数据库表中，用于MyBatis-Plus忽略此字段） */
    @TableField(exist = false)
    private String searchValue;

    /** 请求参数（不存在于数据库表中，用于MyBatis-Plus忽略此字段） */
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

    @NotBlank(message = "雪道名称不能为空")
    @Size(min = 0, max = 100, message = "雪道名称不能超过100个字符")
    public String getName() 
    {
        return name;
    }

    public void setName(String name) 
    {
        this.name = name;
    }

    @NotBlank(message = "雪道编号不能为空")
    @Size(min = 0, max = 50, message = "雪道编号不能超过50个字符")
    public String getSlopeCode() 
    {
        return slopeCode;
    }

    public void setSlopeCode(String slopeCode) 
    {
        this.slopeCode = slopeCode;
    }

    @NotBlank(message = "难度等级不能为空")
    public String getDifficulty() 
    {
        return difficulty;
    }

    public void setDifficulty(String difficulty) 
    {
        this.difficulty = difficulty;
    }

    @NotNull(message = "长度不能为空")
    public Integer getLength() 
    {
        return length;
    }

    public void setLength(Integer length) 
    {
        this.length = length;
    }

    @NotNull(message = "宽度不能为空")
    public Integer getWidth() 
    {
        return width;
    }

    public void setWidth(Integer width) 
    {
        this.width = width;
    }

    @NotNull(message = "最大容量不能为空")
    public Integer getMaxCapacity() 
    {
        return maxCapacity;
    }

    public void setMaxCapacity(Integer maxCapacity) 
    {
        this.maxCapacity = maxCapacity;
    }

    public Integer getStatus() 
    {
        return status;
    }

    public void setStatus(Integer status) 
    {
        this.status = status;
    }

    @Size(min = 0, max = 500, message = "描述不能超过500个字符")
    public String getDescription() 
    {
        return description;
    }

    public void setDescription(String description) 
    {
        this.description = description;
    }

    public String getImageUrl() 
    {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) 
    {
        this.imageUrl = imageUrl;
    }

    // 重写父类方法，使用本地字段
    @Override
    public String getSearchValue()
    {
        return searchValue;
    }

    @Override
    public void setSearchValue(String searchValue)
    {
        this.searchValue = searchValue;
    }

    @Override
    public Map<String, Object> getParams()
    {
        if (params == null)
        {
            params = new java.util.HashMap<>();
        }
        return params;
    }

    @Override
    public void setParams(Map<String, Object> params)
    {
        this.params = params;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("name", getName())
            .append("slopeCode", getSlopeCode())
            .append("difficulty", getDifficulty())
            .append("length", getLength())
            .append("width", getWidth())
            .append("maxCapacity", getMaxCapacity())
            .append("status", getStatus())
            .append("description", getDescription())
            .append("imageUrl", getImageUrl())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
