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
import java.util.Date;
import java.util.Map;

/**
 * 通知管理对象 ski_notice
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("通知管理实体")
@TableName("ski_notice")
public class SkiNotice extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 通知ID */
    @ApiModelProperty("通知ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 通知标题 */
    @ApiModelProperty(value = "通知标题", required = true)
    @Excel(name = "通知标题")
    @NotBlank(message = "通知标题不能为空")
    private String noticeTitle;

    /** 通知类型（1通知 2公告） */
    @ApiModelProperty("通知类型（1通知 2公告）")
    @Excel(name = "通知类型", readConverterExp = "1=通知,2=公告")
    private String noticeType;

    /** 通知内容 */
    @ApiModelProperty("通知内容")
    @Excel(name = "通知内容")
    private String noticeContent;

    /** 状态（0正常 1关闭） */
    @ApiModelProperty("状态（0正常 1关闭）")
    @Excel(name = "状态", readConverterExp = "0=正常,1=关闭")
    private String status;

    /** 发布时间 */
    @ApiModelProperty("发布时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "发布时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    /** 过期时间 */
    @ApiModelProperty("过期时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "过期时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;

    /** 优先级（0普通 1重要 2紧急） */
    @ApiModelProperty("优先级（0普通 1重要 2紧急）")
    @Excel(name = "优先级", readConverterExp = "0=普通,1=重要,2=紧急")
    private Integer priority;

    /** 阅读次数 */
    @ApiModelProperty("阅读次数")
    @Excel(name = "阅读次数")
    private Integer readCount;

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

    public void setNoticeTitle(String noticeTitle) 
    {
        this.noticeTitle = noticeTitle;
    }

    public String getNoticeTitle() 
    {
        return noticeTitle;
    }

    public void setNoticeType(String noticeType) 
    {
        this.noticeType = noticeType;
    }

    public String getNoticeType() 
    {
        return noticeType;
    }

    public void setNoticeContent(String noticeContent) 
    {
        this.noticeContent = noticeContent;
    }

    public String getNoticeContent() 
    {
        return noticeContent;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public void setPublishTime(Date publishTime) 
    {
        this.publishTime = publishTime;
    }

    public Date getPublishTime() 
    {
        return publishTime;
    }

    public void setExpireTime(Date expireTime) 
    {
        this.expireTime = expireTime;
    }

    public Date getExpireTime() 
    {
        return expireTime;
    }

    public void setPriority(Integer priority) 
    {
        this.priority = priority;
    }

    public Integer getPriority() 
    {
        return priority;
    }

    public void setReadCount(Integer readCount) 
    {
        this.readCount = readCount;
    }

    public Integer getReadCount() 
    {
        return readCount;
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
            .append("noticeTitle", getNoticeTitle())
            .append("noticeType", getNoticeType())
            .append("noticeContent", getNoticeContent())
            .append("status", getStatus())
            .append("publishTime", getPublishTime())
            .append("expireTime", getExpireTime())
            .append("priority", getPriority())
            .append("readCount", getReadCount())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
