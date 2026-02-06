package com.ruoyi.system.domain.dto;

import java.math.BigDecimal;
import java.util.List;

/**
 * 运营数据统计DTO
 * 
 * @author ruoyi
 */
public class OperationalStatisticsDTO {
    
    /** 门票订单统计 */
    private TicketOrderStatistics ticketOrderStatistics;
    
    /** 雪具租赁统计 */
    private RentalStatistics rentalStatistics;
    
    /** 用户统计 */
    private UserStatistics userStatistics;
    
    /** 订单趋势（日/周/月） */
    private List<TrendDataDTO> orderTrendList;
    
    /** 租赁趋势（日/周/月） */
    private List<TrendDataDTO> rentalTrendList;
    
    /** 热门票种排行 */
    private List<PopularTicketDTO> popularTicketList;
    
    /** 热门设备排行 */
    private List<PopularEquipmentDTO> popularEquipmentList;

    public TicketOrderStatistics getTicketOrderStatistics() {
        return ticketOrderStatistics;
    }

    public void setTicketOrderStatistics(TicketOrderStatistics ticketOrderStatistics) {
        this.ticketOrderStatistics = ticketOrderStatistics;
    }

    public RentalStatistics getRentalStatistics() {
        return rentalStatistics;
    }

    public void setRentalStatistics(RentalStatistics rentalStatistics) {
        this.rentalStatistics = rentalStatistics;
    }

    public UserStatistics getUserStatistics() {
        return userStatistics;
    }

    public void setUserStatistics(UserStatistics userStatistics) {
        this.userStatistics = userStatistics;
    }

    public List<TrendDataDTO> getOrderTrendList() {
        return orderTrendList;
    }

    public void setOrderTrendList(List<TrendDataDTO> orderTrendList) {
        this.orderTrendList = orderTrendList;
    }

    public List<TrendDataDTO> getRentalTrendList() {
        return rentalTrendList;
    }

    public void setRentalTrendList(List<TrendDataDTO> rentalTrendList) {
        this.rentalTrendList = rentalTrendList;
    }

    public List<PopularTicketDTO> getPopularTicketList() {
        return popularTicketList;
    }

    public void setPopularTicketList(List<PopularTicketDTO> popularTicketList) {
        this.popularTicketList = popularTicketList;
    }

    public List<PopularEquipmentDTO> getPopularEquipmentList() {
        return popularEquipmentList;
    }

    public void setPopularEquipmentList(List<PopularEquipmentDTO> popularEquipmentList) {
        this.popularEquipmentList = popularEquipmentList;
    }

    /**
     * 门票订单统计
     */
    public static class TicketOrderStatistics {
        private Integer totalOrders; // 总订单数
        private Integer paidOrders; // 已支付订单数
        private Integer pendingOrders; // 待支付订单数
        private Integer usedOrders; // 已使用订单数
        private Integer cancelledOrders; // 已取消订单数
        private BigDecimal totalRevenue; // 总收入
        private BigDecimal paidRevenue; // 已支付收入
        private Integer totalVisitors; // 总游客数
        private BigDecimal avgOrderAmount; // 平均订单金额
        private Double conversionRate; // 转化率（已支付/总订单）

        public Integer getTotalOrders() {
            return totalOrders;
        }

        public void setTotalOrders(Integer totalOrders) {
            this.totalOrders = totalOrders;
        }

        public Integer getPaidOrders() {
            return paidOrders;
        }

        public void setPaidOrders(Integer paidOrders) {
            this.paidOrders = paidOrders;
        }

        public Integer getPendingOrders() {
            return pendingOrders;
        }

        public void setPendingOrders(Integer pendingOrders) {
            this.pendingOrders = pendingOrders;
        }

        public Integer getUsedOrders() {
            return usedOrders;
        }

        public void setUsedOrders(Integer usedOrders) {
            this.usedOrders = usedOrders;
        }

        public Integer getCancelledOrders() {
            return cancelledOrders;
        }

        public void setCancelledOrders(Integer cancelledOrders) {
            this.cancelledOrders = cancelledOrders;
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

        public Integer getTotalVisitors() {
            return totalVisitors;
        }

        public void setTotalVisitors(Integer totalVisitors) {
            this.totalVisitors = totalVisitors;
        }

        public BigDecimal getAvgOrderAmount() {
            return avgOrderAmount;
        }

        public void setAvgOrderAmount(BigDecimal avgOrderAmount) {
            this.avgOrderAmount = avgOrderAmount;
        }

        public Double getConversionRate() {
            return conversionRate;
        }

        public void setConversionRate(Double conversionRate) {
            this.conversionRate = conversionRate;
        }
    }

    /**
     * 雪具租赁统计
     */
    public static class RentalStatistics {
        private Integer totalRentals; // 总租赁数
        private Integer activeRentals; // 租赁中数量
        private Integer returnedRentals; // 已归还数量
        private Integer pendingRentals; // 待支付数量
        private BigDecimal totalRevenue; // 总收入
        private BigDecimal paidRevenue; // 已支付收入
        private Integer totalRenters; // 总租赁人数
        private BigDecimal avgRentalAmount; // 平均租赁金额
        private Double utilizationRate; // 设备利用率

        public Integer getTotalRentals() {
            return totalRentals;
        }

        public void setTotalRentals(Integer totalRentals) {
            this.totalRentals = totalRentals;
        }

        public Integer getActiveRentals() {
            return activeRentals;
        }

        public void setActiveRentals(Integer activeRentals) {
            this.activeRentals = activeRentals;
        }

        public Integer getReturnedRentals() {
            return returnedRentals;
        }

        public void setReturnedRentals(Integer returnedRentals) {
            this.returnedRentals = returnedRentals;
        }

        public Integer getPendingRentals() {
            return pendingRentals;
        }

        public void setPendingRentals(Integer pendingRentals) {
            this.pendingRentals = pendingRentals;
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

        public Integer getTotalRenters() {
            return totalRenters;
        }

        public void setTotalRenters(Integer totalRenters) {
            this.totalRenters = totalRenters;
        }

        public BigDecimal getAvgRentalAmount() {
            return avgRentalAmount;
        }

        public void setAvgRentalAmount(BigDecimal avgRentalAmount) {
            this.avgRentalAmount = avgRentalAmount;
        }

        public Double getUtilizationRate() {
            return utilizationRate;
        }

        public void setUtilizationRate(Double utilizationRate) {
            this.utilizationRate = utilizationRate;
        }
    }

    /**
     * 用户统计
     */
    public static class UserStatistics {
        private Integer totalUsers; // 总用户数
        private Integer activeUsers; // 活跃用户数（有订单或租赁记录）
        private Integer newUsers; // 新增用户数
        private List<UserGrowthDTO> userGrowthList; // 用户增长趋势

        public Integer getTotalUsers() {
            return totalUsers;
        }

        public void setTotalUsers(Integer totalUsers) {
            this.totalUsers = totalUsers;
        }

        public Integer getActiveUsers() {
            return activeUsers;
        }

        public void setActiveUsers(Integer activeUsers) {
            this.activeUsers = activeUsers;
        }

        public Integer getNewUsers() {
            return newUsers;
        }

        public void setNewUsers(Integer newUsers) {
            this.newUsers = newUsers;
        }

        public List<UserGrowthDTO> getUserGrowthList() {
            return userGrowthList;
        }

        public void setUserGrowthList(List<UserGrowthDTO> userGrowthList) {
            this.userGrowthList = userGrowthList;
        }
    }

    /**
     * 趋势数据
     */
    public static class TrendDataDTO {
        private String date;
        private Integer count;
        private BigDecimal amount;

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public Integer getCount() {
            return count;
        }

        public void setCount(Integer count) {
            this.count = count;
        }

        public BigDecimal getAmount() {
            return amount;
        }

        public void setAmount(BigDecimal amount) {
            this.amount = amount;
        }
    }

    /**
     * 热门票种
     */
    public static class PopularTicketDTO {
        private String ticketName;
        private Integer orderCount;
        private BigDecimal totalAmount;

        public String getTicketName() {
            return ticketName;
        }

        public void setTicketName(String ticketName) {
            this.ticketName = ticketName;
        }

        public Integer getOrderCount() {
            return orderCount;
        }

        public void setOrderCount(Integer orderCount) {
            this.orderCount = orderCount;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }
    }

    /**
     * 热门设备
     */
    public static class PopularEquipmentDTO {
        private String equipmentName;
        private Integer rentalCount;
        private BigDecimal totalAmount;

        public String getEquipmentName() {
            return equipmentName;
        }

        public void setEquipmentName(String equipmentName) {
            this.equipmentName = equipmentName;
        }

        public Integer getRentalCount() {
            return rentalCount;
        }

        public void setRentalCount(Integer rentalCount) {
            this.rentalCount = rentalCount;
        }

        public BigDecimal getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(BigDecimal totalAmount) {
            this.totalAmount = totalAmount;
        }
    }

    /**
     * 用户增长趋势
     */
    public static class UserGrowthDTO {
        private String date;
        private Integer count;

        public String getDate() {
            return date;
        }

        public void setDate(String date) {
            this.date = date;
        }

        public Integer getCount() {
            return count;
        }

        public void setCount(Integer count) {
            this.count = count;
        }
    }
}
