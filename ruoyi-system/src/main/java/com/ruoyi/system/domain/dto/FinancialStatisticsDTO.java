package com.ruoyi.system.domain.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * 财务统计DTO
 * 
 * @author ruoyi
 */
public class FinancialStatisticsDTO {
    
    /** 总收入 */
    private BigDecimal totalRevenue;
    
    /** 门票收入 */
    private BigDecimal ticketRevenue;
    
    /** 租赁收入 */
    private BigDecimal rentalRevenue;
    
    /** 教练课程总收入 */
    private BigDecimal courseRevenue;
    
    /** 教练收入（30%） */
    private BigDecimal coachRevenue;
    
    /** 雪场收入（70%） */
    private BigDecimal resortRevenue;
    
    /** 日收入统计列表 */
    private List<DailyRevenueDTO> dailyRevenueList;
    
    /** 月收入统计列表 */
    private List<MonthlyRevenueDTO> monthlyRevenueList;
    
    /** 收入来源占比 */
    private List<RevenueSourceDTO> revenueSourceList;
    
    /** 支付方式统计 */
    private List<PaymentMethodDTO> paymentMethodList;

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getTicketRevenue() {
        return ticketRevenue;
    }

    public void setTicketRevenue(BigDecimal ticketRevenue) {
        this.ticketRevenue = ticketRevenue;
    }

    public BigDecimal getRentalRevenue() {
        return rentalRevenue;
    }

    public void setRentalRevenue(BigDecimal rentalRevenue) {
        this.rentalRevenue = rentalRevenue;
    }

    public BigDecimal getCourseRevenue() {
        return courseRevenue;
    }

    public void setCourseRevenue(BigDecimal courseRevenue) {
        this.courseRevenue = courseRevenue;
    }

    public BigDecimal getCoachRevenue() {
        return coachRevenue;
    }

    public void setCoachRevenue(BigDecimal coachRevenue) {
        this.coachRevenue = coachRevenue;
    }

    public BigDecimal getResortRevenue() {
        return resortRevenue;
    }

    public void setResortRevenue(BigDecimal resortRevenue) {
        this.resortRevenue = resortRevenue;
    }

    public List<DailyRevenueDTO> getDailyRevenueList() {
        return dailyRevenueList;
    }

    public void setDailyRevenueList(List<DailyRevenueDTO> dailyRevenueList) {
        this.dailyRevenueList = dailyRevenueList;
    }

    public List<MonthlyRevenueDTO> getMonthlyRevenueList() {
        return monthlyRevenueList;
    }

    public void setMonthlyRevenueList(List<MonthlyRevenueDTO> monthlyRevenueList) {
        this.monthlyRevenueList = monthlyRevenueList;
    }

    public List<RevenueSourceDTO> getRevenueSourceList() {
        return revenueSourceList;
    }

    public void setRevenueSourceList(List<RevenueSourceDTO> revenueSourceList) {
        this.revenueSourceList = revenueSourceList;
    }

    public List<PaymentMethodDTO> getPaymentMethodList() {
        return paymentMethodList;
    }

    public void setPaymentMethodList(List<PaymentMethodDTO> paymentMethodList) {
        this.paymentMethodList = paymentMethodList;
    }

    /**
     * 日收入统计
     */
    public static class DailyRevenueDTO {
        private String date;
        private BigDecimal ticketAmount;
        private BigDecimal rentalAmount;
        private BigDecimal courseAmount;
        private BigDecimal coachAmount;
        private BigDecimal resortAmount;
        private BigDecimal totalAmount;

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public BigDecimal getTicketAmount() {
            return ticketAmount;
        }

        public void setTicketAmount(BigDecimal ticketAmount) {
            this.ticketAmount = ticketAmount;
        }

        public BigDecimal getRentalAmount() {
            return rentalAmount;
        }

        public void setRentalAmount(BigDecimal rentalAmount) {
            this.rentalAmount = rentalAmount;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }

        public BigDecimal getCourseAmount() {
            return courseAmount;
        }

        public void setCourseAmount(BigDecimal courseAmount) {
            this.courseAmount = courseAmount;
        }

        public BigDecimal getCoachAmount() {
            return coachAmount;
        }

        public void setCoachAmount(BigDecimal coachAmount) {
            this.coachAmount = coachAmount;
        }

        public BigDecimal getResortAmount() {
            return resortAmount;
        }

        public void setResortAmount(BigDecimal resortAmount) {
            this.resortAmount = resortAmount;
        }
    }

    /**
     * 月收入统计
     */
    public static class MonthlyRevenueDTO {
        private String month;
        private BigDecimal ticketAmount;
        private BigDecimal rentalAmount;
        private BigDecimal courseAmount;
        private BigDecimal coachAmount;
        private BigDecimal resortAmount;
        private BigDecimal totalAmount;

        public String getMonth() {
            return month;
        }

        public void setMonth(String month) {
            this.month = month;
        }

        public BigDecimal getTicketAmount() {
            return ticketAmount;
        }

        public void setTicketAmount(BigDecimal ticketAmount) {
            this.ticketAmount = ticketAmount;
        }

        public BigDecimal getRentalAmount() {
            return rentalAmount;
        }

        public void setRentalAmount(BigDecimal rentalAmount) {
            this.rentalAmount = rentalAmount;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }

        public BigDecimal getCourseAmount() {
            return courseAmount;
        }

        public void setCourseAmount(BigDecimal courseAmount) {
            this.courseAmount = courseAmount;
        }

        public BigDecimal getCoachAmount() {
            return coachAmount;
        }

        public void setCoachAmount(BigDecimal coachAmount) {
            this.coachAmount = coachAmount;
        }

        public BigDecimal getResortAmount() {
            return resortAmount;
        }

        public void setResortAmount(BigDecimal resortAmount) {
            this.resortAmount = resortAmount;
        }
    }

    /**
     * 收入来源统计
     */
    public static class RevenueSourceDTO {
        private String source;
        private BigDecimal amount;
        private Double percentage;

        public String getSource() {
            return source;
        }

        public void setSource(String source) {
            this.source = source;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        public Double getPercentage() {
            return percentage;
        }

        public void setPercentage(Double percentage) {
            this.percentage = percentage;
        }
    }

    /**
     * 支付方式统计
     */
    public static class PaymentMethodDTO {
        private String method;
        private String methodName;
        private BigDecimal amount;
        private Integer count;

        public String getMethod() {
            return method;
        }

        public void setMethod(String method) {
            this.method = method;
        }

        public String getMethodName() {
            return methodName;
        }

        public void setMethodName(String methodName) {
            this.methodName = methodName;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }

        public Integer getCount() {
            return count;
        }

        public void setCount(Integer count) {
            this.count = count;
        }
    }
}
