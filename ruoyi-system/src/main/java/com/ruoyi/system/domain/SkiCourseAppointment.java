package com.ruoyi.system.domain;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Date;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.util.Map;

/**
 * 课程预约对象 ski_course_appointment
 * 
 * @author ruoyi
 */
@TableName("ski_course_appointment")
public class SkiCourseAppointment extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 预约ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 课程ID */
    @Excel(name = "课程ID")
    private Long courseId;

    /** 时间表ID */
    @Excel(name = "时间表ID")
    private Long scheduleId;

    /** 学员ID（关联sys_user表） */
    @Excel(name = "学员ID")
    private Long studentId;

    /** 学员姓名 */
    @Excel(name = "学员姓名")
    private String studentName;

    /** 教练ID */
    @Excel(name = "教练ID")
    private Long coachId;

    /** 预约日期 */
    @Excel(name = "预约日期", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private LocalDate appointmentDate;

    /** 开始时间 */
    @Excel(name = "开始时间")
    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime startTime;

    /** 结束时间 */
    @Excel(name = "结束时间")
    @JsonFormat(pattern = "HH:mm:ss")
    private LocalTime endTime;

    /** 预约价格 */
    @Excel(name = "预约价格")
    private BigDecimal price;

    /** 支付状态（0未支付 1已支付 2已退款） */
    @Excel(name = "支付状态")
    private String paymentStatus;

    /** 支付方式（1现金 2微信 3支付宝 4银行卡） */
    @Excel(name = "支付方式")
    private String paymentMethod;

    /** 支付时间 */
    @Excel(name = "支付时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date paymentTime;

    /** 预约状态（0待确认 1已确认 2已完成 3已取消） */
    @Excel(name = "预约状态")
    private String status;

    /** 取消原因 */
    @Excel(name = "取消原因")
    private String cancelReason;

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

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    public Long getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(Long scheduleId) {
        this.scheduleId = scheduleId;
    }

    public Long getStudentId() {
        return studentId;
    }

    public void setStudentId(Long studentId) {
        this.studentId = studentId;
    }

    public String getStudentName() {
        return studentName;
    }

    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public Long getCoachId() {
        return coachId;
    }

    public void setCoachId(Long coachId) {
        this.coachId = coachId;
    }

    public LocalDate getAppointmentDate() {
        return appointmentDate;
    }

    public void setAppointmentDate(LocalDate appointmentDate) {
        this.appointmentDate = appointmentDate;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }
}
