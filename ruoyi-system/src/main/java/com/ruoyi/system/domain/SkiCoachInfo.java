package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.util.Map;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;

/**
 * 教练信息对象 ski_coach_info
 * 
 * @author ruoyi
 */
@TableName("ski_coach_info")
public class SkiCoachInfo extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 教练信息ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 用户ID（关联sys_user表） */
    @Excel(name = "用户ID")
    private Long userId;

    /** 教练等级（初级、中级、高级、专业） */
    @Excel(name = "教练等级")
    private String coachLevel;

    /** 教学年限 */
    @Excel(name = "教学年限")
    private Integer teachingYears;

    /** 擅长领域（如：单板、双板、儿童教学等） */
    @Excel(name = "擅长领域")
    private String specialty;

    /** 专业证书（JSON格式存储证书信息） */
    @Excel(name = "专业证书")
    private String certificate;

    /** 个人简介 */
    @Excel(name = "个人简介")
    private String introduction;

    /** 课时费（元/小时） */
    @Excel(name = "课时费")
    private BigDecimal hourlyRate;

    /** 累计学员数 */
    @Excel(name = "累计学员数")
    private Integer totalStudents;

    /** 当前学员数 */
    @Excel(name = "当前学员数")
    private Integer currentStudents;

    /** 累计教学时长（小时） */
    @Excel(name = "累计教学时长")
    private Integer totalTeachingHours;

    /** 平均评分（0-5分） */
    @Excel(name = "平均评分")
    private BigDecimal averageRating;

    /** 评价数量 */
    @Excel(name = "评价数量")
    private Integer ratingCount;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态")
    private String status;

    @TableField(exist = false)
    private String searchValue;

    /** 请求参数 */
    @TableField(exist = false)
    private Map<String, Object> params;

    /** 关联的用户信息 */
    @TableField(exist = false)
    private SysUser user;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getCoachLevel() {
        return coachLevel;
    }

    public void setCoachLevel(String coachLevel) {
        this.coachLevel = coachLevel;
    }

    public Integer getTeachingYears() {
        return teachingYears;
    }

    public void setTeachingYears(Integer teachingYears) {
        this.teachingYears = teachingYears;
    }

    public String getSpecialty() {
        return specialty;
    }

    public void setSpecialty(String specialty) {
        this.specialty = specialty;
    }

    public String getCertificate() {
        return certificate;
    }

    public void setCertificate(String certificate) {
        this.certificate = certificate;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public BigDecimal getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(BigDecimal hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public Integer getTotalStudents() {
        return totalStudents;
    }

    public void setTotalStudents(Integer totalStudents) {
        this.totalStudents = totalStudents;
    }

    public Integer getCurrentStudents() {
        return currentStudents;
    }

    public void setCurrentStudents(Integer currentStudents) {
        this.currentStudents = currentStudents;
    }

    public Integer getTotalTeachingHours() {
        return totalTeachingHours;
    }

    public void setTotalTeachingHours(Integer totalTeachingHours) {
        this.totalTeachingHours = totalTeachingHours;
    }

    public BigDecimal getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(BigDecimal averageRating) {
        this.averageRating = averageRating;
    }

    public Integer getRatingCount() {
        return ratingCount;
    }

    public void setRatingCount(Integer ratingCount) {
        this.ratingCount = ratingCount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public SysUser getUser() {
        return user;
    }

    public void setUser(SysUser user) {
        this.user = user;
    }
}
