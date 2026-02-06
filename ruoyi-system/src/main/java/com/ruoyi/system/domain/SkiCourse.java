package com.ruoyi.system.domain;

import java.math.BigDecimal;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import java.util.Map;

/**
 * 课程对象 ski_course
 * 
 * @author ruoyi
 */
@TableName("ski_course")
public class SkiCourse extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 课程ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 教练ID（关联sys_user表） */
    @Excel(name = "教练ID")
    private Long coachId;

    /** 课程名称 */
    @Excel(name = "课程名称")
    private String courseName;

    /** 课程类型（如：初级滑雪、中级滑雪、高级技巧等） */
    @Excel(name = "课程类型")
    private String courseType;

    /** 课程描述 */
    @Excel(name = "课程描述")
    private String description;

    /** 课程时长（分钟） */
    @Excel(name = "课程时长")
    private Integer duration;

    /** 课程价格（元） */
    @Excel(name = "课程价格")
    private BigDecimal price;

    /** 最大学员数 */
    @Excel(name = "最大学员数")
    private Integer maxStudents;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态")
    private String status;

    @TableField(exist = false)
    private String searchValue;

    /** 请求参数 */
    @TableField(exist = false)
    private Map<String, Object> params;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getCoachId() {
        return coachId;
    }

    public void setCoachId(Long coachId) {
        this.coachId = coachId;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseType() {
        return courseType;
    }

    public void setCourseType(String courseType) {
        this.courseType = courseType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getDuration() {
        return duration;
    }

    public void setDuration(Integer duration) {
        this.duration = duration;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public Integer getMaxStudents() {
        return maxStudents;
    }

    public void setMaxStudents(Integer maxStudents) {
        this.maxStudents = maxStudents;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
