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
import java.util.Date;
import java.util.Map;

/**
 * 领用记录对象 ski_material_usage
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@ApiModel("领用记录实体")
@TableName("ski_material_usage")
public class SkiMaterialUsage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 领用ID */
    @ApiModelProperty("领用ID")
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

    /** 领用数量 */
    @ApiModelProperty(value = "领用数量", required = true)
    @Excel(name = "领用数量")
    @NotNull(message = "领用数量不能为空")
    private Integer quantity;

    /** 领用人ID */
    @ApiModelProperty("领用人ID")
    @Excel(name = "领用人ID")
    private Long userId;

    /** 领用人姓名 */
    @ApiModelProperty("领用人姓名")
    @Excel(name = "领用人姓名")
    private String userName;

    /** 所属部门 */
    @ApiModelProperty("所属部门")
    @Excel(name = "所属部门")
    private String department;

    /** 用途说明 */
    @ApiModelProperty("用途说明")
    @Excel(name = "用途说明")
    private String usagePurpose;

    /** 领用时间 */
    @ApiModelProperty("领用时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "领用时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date usageTime;

    /** 归还时间 */
    @ApiModelProperty("归还时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "归还时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date returnTime;

    /** 归还状态（0未归还 1已归还） */
    @ApiModelProperty("归还状态")
    @Excel(name = "归还状态", readConverterExp = "0=未归还,1=已归还")
    private String returnStatus;

    /** 审批人ID */
    @ApiModelProperty("审批人ID")
    @Excel(name = "审批人ID")
    private Long approverId;

    /** 审批人姓名 */
    @ApiModelProperty("审批人姓名")
    @Excel(name = "审批人姓名")
    private String approverName;

    /** 审批状态（0待审批 1已批准 2已拒绝） */
    @ApiModelProperty("审批状态")
    @Excel(name = "审批状态", readConverterExp = "0=待审批,1=已批准,2=已拒绝")
    private String approvalStatus;

    /** 审批时间 */
    @ApiModelProperty("审批时间")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "审批时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date approvalTime;

    /** 审批意见 */
    @ApiModelProperty("审批意见")
    @Excel(name = "审批意见")
    private String approvalRemark;

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

    public void setQuantity(Integer quantity) 
    {
        this.quantity = quantity;
    }

    public Integer getQuantity() 
    {
        return quantity;
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

    public void setDepartment(String department) 
    {
        this.department = department;
    }

    public String getDepartment() 
    {
        return department;
    }

    public void setUsagePurpose(String usagePurpose) 
    {
        this.usagePurpose = usagePurpose;
    }

    public String getUsagePurpose() 
    {
        return usagePurpose;
    }

    public void setUsageTime(Date usageTime) 
    {
        this.usageTime = usageTime;
    }

    public Date getUsageTime() 
    {
        return usageTime;
    }

    public void setReturnTime(Date returnTime) 
    {
        this.returnTime = returnTime;
    }

    public Date getReturnTime() 
    {
        return returnTime;
    }

    public void setReturnStatus(String returnStatus) 
    {
        this.returnStatus = returnStatus;
    }

    public String getReturnStatus() 
    {
        return returnStatus;
    }

    public void setApproverId(Long approverId) 
    {
        this.approverId = approverId;
    }

    public Long getApproverId() 
    {
        return approverId;
    }

    public void setApproverName(String approverName) 
    {
        this.approverName = approverName;
    }

    public String getApproverName() 
    {
        return approverName;
    }

    public void setApprovalStatus(String approvalStatus) 
    {
        this.approvalStatus = approvalStatus;
    }

    public String getApprovalStatus() 
    {
        return approvalStatus;
    }

    public void setApprovalTime(Date approvalTime) 
    {
        this.approvalTime = approvalTime;
    }

    public Date getApprovalTime() 
    {
        return approvalTime;
    }

    public void setApprovalRemark(String approvalRemark) 
    {
        this.approvalRemark = approvalRemark;
    }

    public String getApprovalRemark() 
    {
        return approvalRemark;
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
            .append("quantity", getQuantity())
            .append("userId", getUserId())
            .append("userName", getUserName())
            .append("department", getDepartment())
            .append("usagePurpose", getUsagePurpose())
            .append("usageTime", getUsageTime())
            .append("returnTime", getReturnTime())
            .append("returnStatus", getReturnStatus())
            .append("approverId", getApproverId())
            .append("approverName", getApproverName())
            .append("approvalStatus", getApprovalStatus())
            .append("approvalTime", getApprovalTime())
            .append("approvalRemark", getApprovalRemark())
            .append("remark", getRemark())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .toString();
    }
}
