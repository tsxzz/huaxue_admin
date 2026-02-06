package com.ruoyi.system.domain.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * 教练业绩DTO
 * 
 * @author ruoyi
 */
public class CoachPerformanceDTO {
    /** 总完成课程数 */
    private Integer totalCompletedCourses;

    /** 总收入 */
    private BigDecimal totalRevenue;

    /** 已支付收入 */
    private BigDecimal paidRevenue;

    /** 待支付收入 */
    private BigDecimal unpaidRevenue;

    /** 按月份统计 */
    private List<MonthlyPerformance> monthlyData;

    /** 按课程类型统计 */
    private List<CourseTypePerformance> courseTypeData;

    /** 最近完成的课程列表 */
    private List<CourseDetail> recentCourses;

    public Integer getTotalCompletedCourses() {
        return totalCompletedCourses;
    }

    public void setTotalCompletedCourses(Integer totalCompletedCourses) {
        this.totalCompletedCourses = totalCompletedCourses;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getPaidRevenue() {
        return paidRevenue;
    }

    public void setPaidRevenue(BigDecimal paidRevenue) {
        this.paidRevenue = paidRevenue;
    }

    public BigDecimal getUnpaidRevenue() {
        return unpaidRevenue;
    }

    public void setUnpaidRevenue(BigDecimal unpaidRevenue) {
        this.unpaidRevenue = unpaidRevenue;
    }

    public List<MonthlyPerformance> getMonthlyData() {
        return monthlyData;
    }

    public void setMonthlyData(List<MonthlyPerformance> monthlyData) {
        this.monthlyData = monthlyData;
    }

    public List<CourseTypePerformance> getCourseTypeData() {
        return courseTypeData;
    }

    public void setCourseTypeData(List<CourseTypePerformance> courseTypeData) {
        this.courseTypeData = courseTypeData;
    }

    public List<CourseDetail> getRecentCourses() {
        return recentCourses;
    }

    public void setRecentCourses(List<CourseDetail> recentCourses) {
        this.recentCourses = recentCourses;
    }

    /**
     * 月度业绩
     */
    public static class MonthlyPerformance {
        private String month;
        private Integer courseCount;
        private BigDecimal revenue;

        public String getMonth() {
            return month;
        }

        public void setMonth(String month) {
            this.month = month;
        }

        public Integer getCourseCount() {
            return courseCount;
        }

        public void setCourseCount(Integer courseCount) {
            this.courseCount = courseCount;
        }

        public BigDecimal getRevenue() {
            return revenue;
        }

        public void setRevenue(BigDecimal revenue) {
            this.revenue = revenue;
        }
    }

    /**
     * 课程类型业绩
     */
    public static class CourseTypePerformance {
        private String courseType;
        private Integer courseCount;
        private BigDecimal revenue;

        public String getCourseType() {
            return courseType;
        }

        public void setCourseType(String courseType) {
            this.courseType = courseType;
        }

        public Integer getCourseCount() {
            return courseCount;
        }

        public void setCourseCount(Integer courseCount) {
            this.courseCount = courseCount;
        }

        public BigDecimal getRevenue() {
            return revenue;
        }

        public void setRevenue(BigDecimal revenue) {
            this.revenue = revenue;
        }
    }

    /**
     * 课程详情
     */
    public static class CourseDetail {
        private Long appointmentId;
        private String courseName;
        private String courseType;
        private String studentName;
        private String appointmentDate;
        private BigDecimal price;
        private String paymentStatus;
        private String status;

        public Long getAppointmentId() {
            return appointmentId;
        }

        public void setAppointmentId(Long appointmentId) {
            this.appointmentId = appointmentId;
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

        public String getStudentName() {
            return studentName;
        }

        public void setStudentName(String studentName) {
            this.studentName = studentName;
        }

        public String getAppointmentDate() {
            return appointmentDate;
        }

        public void setAppointmentDate(String appointmentDate) {
            this.appointmentDate = appointmentDate;
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
    }
}
