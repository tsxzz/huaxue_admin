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
import java.util.List;
import java.util.Map;

/**
 * 留言板对象 ski_message_board
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("留言板实体")
@TableName("ski_message_board")
public class SkiMessageBoard extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 留言ID */
    @ApiModelProperty("留言ID")
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户ID（发布者） */
    @ApiModelProperty(value = "用户ID", required = true)
    @Excel(name = "用户ID")
    @NotNull(message = "用户ID不能为空")
    private Long userId;

    /** 用户名（冗余字段） */
    @ApiModelProperty("用户名")
    @Excel(name = "用户名")
    private String userName;

    /** 留言内容 */
    @ApiModelProperty(value = "留言内容", required = true)
    @Excel(name = "留言内容")
    @NotBlank(message = "留言内容不能为空")
    private String content;

    /** 父留言ID（用于回复，NULL表示主留言） */
    @ApiModelProperty("父留言ID")
    @Excel(name = "父留言ID")
    private Long parentId;

    /** 点赞数 */
    @ApiModelProperty("点赞数")
    @Excel(name = "点赞数")
    private Integer likeCount;

    /** 回复数 */
    @ApiModelProperty("回复数")
    @Excel(name = "回复数")
    private Integer replyCount;

    /** 状态（0正常 1删除） */
    @ApiModelProperty("状态（0正常 1删除）")
    @Excel(name = "状态", readConverterExp = "0=正常,1=删除")
    private String status;

    /** 是否已点赞（当前用户） */
    @TableField(exist = false)
    private Boolean isLiked;

    /** 回复列表 */
    @TableField(exist = false)
    private List<SkiMessageBoard> replies;

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

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setUserName(String userName) 
    {
        this.userName = userName;
    }

    public String getUserName() 
    {
        return userName;
    }

    public void setContent(String content) 
    {
        this.content = content;
    }

    public String getContent() 
    {
        return content;
    }

    public void setParentId(Long parentId) 
    {
        this.parentId = parentId;
    }

    public Long getParentId() 
    {
        return parentId;
    }

    public void setLikeCount(Integer likeCount) 
    {
        this.likeCount = likeCount;
    }

    public Integer getLikeCount() 
    {
        return likeCount;
    }

    public void setReplyCount(Integer replyCount) 
    {
        this.replyCount = replyCount;
    }

    public Integer getReplyCount() 
    {
        return replyCount;
    }

    public void setStatus(String status) 
    {
        this.status = status;
    }

    public String getStatus() 
    {
        return status;
    }

    public Boolean getIsLiked() 
    {
        return isLiked;
    }

    public void setIsLiked(Boolean isLiked) 
    {
        this.isLiked = isLiked;
    }

    public List<SkiMessageBoard> getReplies() 
    {
        return replies;
    }

    public void setReplies(List<SkiMessageBoard> replies) 
    {
        this.replies = replies;
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
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("content", getContent())
            .append("parentId", getParentId())
            .append("likeCount", getLikeCount())
            .append("replyCount", getReplyCount())
            .append("status", getStatus())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
