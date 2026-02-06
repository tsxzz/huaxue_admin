package com.ruoyi.system.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.annotation.Excel;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

import java.util.Date;

/**
 * 留言点赞对象 ski_message_like
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("留言点赞实体")
@TableName("ski_message_like")
public class SkiMessageLike
{
    private static final long serialVersionUID = 1L;

    /** 点赞ID */
    @ApiModelProperty("点赞ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 留言ID */
    @ApiModelProperty(value = "留言ID", required = true)
    @Excel(name = "留言ID")
    private Long messageId;

    /** 用户ID（点赞者） */
    @ApiModelProperty(value = "用户ID", required = true)
    @Excel(name = "用户ID")
    private Long userId;

    /** 创建时间 */
    @ApiModelProperty("创建时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "创建时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date createTime;

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setMessageId(Long messageId) 
    {
        this.messageId = messageId;
    }

    public Long getMessageId() 
    {
        return messageId;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setCreateTime(Date createTime) 
    {
        this.createTime = createTime;
    }

    public Date getCreateTime() 
    {
        return createTime;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("id", getId())
            .append("messageId", getMessageId())
            .append("userId", getUserId())
            .append("createTime", getCreateTime())
            .toString();
    }
}
