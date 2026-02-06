package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.system.domain.SkiEquipmentRental;
import com.ruoyi.system.domain.SkiTicketOrder;
import com.ruoyi.system.domain.dto.OperationalStatisticsDTO;
import com.ruoyi.system.mapper.SkiEquipmentRentalMapper;
import com.ruoyi.system.mapper.SkiTicketOrderMapper;
import com.ruoyi.system.mapper.SysUserMapper;
import com.ruoyi.system.service.IOperationalStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;
import java.util.Calendar;

/**
 * 运营数据统计服务实现类
 * 
 * @author ruoyi
 */
@Service
public class OperationalStatisticsServiceImpl implements IOperationalStatisticsService {
    
    @Autowired
    private SkiTicketOrderMapper ticketOrderMapper;
    
    @Autowired
    private SkiEquipmentRentalMapper equipmentRentalMapper;
    
    @Autowired
    private SysUserMapper userMapper;
    
    @Override
    public OperationalStatisticsDTO getOperationalStatistics(Date startDate, Date endDate, String type) {
        OperationalStatisticsDTO statistics = new OperationalStatisticsDTO();
        
        // 统计门票订单
        OperationalStatisticsDTO.TicketOrderStatistics ticketStats = calculateTicketOrderStatistics(startDate, endDate);
        statistics.setTicketOrderStatistics(ticketStats);
        
        // 统计雪具租赁
        OperationalStatisticsDTO.RentalStatistics rentalStats = calculateRentalStatistics(startDate, endDate);
        statistics.setRentalStatistics(rentalStats);
        
        // 统计用户
        OperationalStatisticsDTO.UserStatistics userStats = calculateUserStatistics(startDate, endDate);
        statistics.setUserStatistics(userStats);
        
        // 订单趋势
        List<OperationalStatisticsDTO.TrendDataDTO> orderTrendList = calculateOrderTrend(startDate, endDate, type);
        statistics.setOrderTrendList(orderTrendList);
        
        // 租赁趋势
        List<OperationalStatisticsDTO.TrendDataDTO> rentalTrendList = calculateRentalTrend(startDate, endDate, type);
        statistics.setRentalTrendList(rentalTrendList);
        
        // 热门票种
        List<OperationalStatisticsDTO.PopularTicketDTO> popularTicketList = calculatePopularTickets(startDate, endDate);
        statistics.setPopularTicketList(popularTicketList);
        
        // 热门设备
        List<OperationalStatisticsDTO.PopularEquipmentDTO> popularEquipmentList = calculatePopularEquipment(startDate, endDate);
        statistics.setPopularEquipmentList(popularEquipmentList);
        
        return statistics;
    }
    
    /**
     * 计算门票订单统计
     */
    private OperationalStatisticsDTO.TicketOrderStatistics calculateTicketOrderStatistics(Date startDate, Date endDate) {
        LambdaQueryWrapper<SkiTicketOrder> wrapper = Wrappers.lambdaQuery();
        if (startDate != null) {
            // 设置为当天的开始时间 00:00:00
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiTicketOrder::getCreateTime, cal.getTime());
        }
        if (endDate != null) {
            // 设置为当天的结束时间 23:59:59
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiTicketOrder::getCreateTime, cal.getTime());
        }
        List<SkiTicketOrder> orders = ticketOrderMapper.selectList(wrapper);
        
        OperationalStatisticsDTO.TicketOrderStatistics stats = new OperationalStatisticsDTO.TicketOrderStatistics();
        stats.setTotalOrders(orders.size());
        
        int paidCount = 0;
        int pendingCount = 0;
        int usedCount = 0;
        int cancelledCount = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal paidRevenue = BigDecimal.ZERO;
        Set<String> visitors = new HashSet<>();
        
        for (SkiTicketOrder order : orders) {
            String status = order.getOrderStatus();
            if ("1".equals(status)) {
                paidCount++;
                BigDecimal paid = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
                paidRevenue = paidRevenue.add(paid);
            } else if ("0".equals(status)) {
                pendingCount++;
            } else if ("2".equals(status)) {
                usedCount++;
            } else if ("4".equals(status)) {
                cancelledCount++;
            }
            
            BigDecimal total = order.getTotalAmount() != null ? order.getTotalAmount() : BigDecimal.ZERO;
            totalRevenue = totalRevenue.add(total);
            
            if (order.getVisitorPhone() != null) {
                visitors.add(order.getVisitorPhone());
            }
        }
        
        stats.setPaidOrders(paidCount);
        stats.setPendingOrders(pendingCount);
        stats.setUsedOrders(usedCount);
        stats.setCancelledOrders(cancelledCount);
        stats.setTotalRevenue(totalRevenue);
        stats.setPaidRevenue(paidRevenue);
        stats.setTotalVisitors(visitors.size());
        
        if (orders.size() > 0) {
            stats.setAvgOrderAmount(totalRevenue.divide(new BigDecimal(orders.size()), 2, RoundingMode.HALF_UP));
            stats.setConversionRate((double) paidCount / orders.size() * 100);
        } else {
            stats.setAvgOrderAmount(BigDecimal.ZERO);
            stats.setConversionRate(0.0);
        }
        
        return stats;
    }
    
    /**
     * 计算雪具租赁统计
     */
    private OperationalStatisticsDTO.RentalStatistics calculateRentalStatistics(Date startDate, Date endDate) {
        LambdaQueryWrapper<SkiEquipmentRental> wrapper = Wrappers.lambdaQuery();
        if (startDate != null) {
            // 设置为当天的开始时间 00:00:00
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiEquipmentRental::getCreateTime, cal.getTime());
        }
        if (endDate != null) {
            // 设置为当天的结束时间 23:59:59
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiEquipmentRental::getCreateTime, cal.getTime());
        }
        List<SkiEquipmentRental> rentals = equipmentRentalMapper.selectList(wrapper);
        
        OperationalStatisticsDTO.RentalStatistics stats = new OperationalStatisticsDTO.RentalStatistics();
        stats.setTotalRentals(rentals.size());
        
        int activeCount = 0;
        int returnedCount = 0;
        int pendingCount = 0;
        BigDecimal totalRevenue = BigDecimal.ZERO;
        BigDecimal paidRevenue = BigDecimal.ZERO;
        Set<String> renters = new HashSet<>();
        
        for (SkiEquipmentRental rental : rentals) {
            Integer status = rental.getStatus();
            if (status != null) {
                if (status == 1) {
                    activeCount++;
                } else if (status == 2) {
                    returnedCount++;
                } else if (status == 0) {
                    pendingCount++;
                }
            }
            
            BigDecimal paid = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
            paidRevenue = paidRevenue.add(paid);
            
            BigDecimal total = rental.getTotalAmount() != null ? rental.getTotalAmount() : BigDecimal.ZERO;
            totalRevenue = totalRevenue.add(total);
            
            if (rental.getRenterPhone() != null) {
                renters.add(rental.getRenterPhone());
            }
        }
        
        stats.setActiveRentals(activeCount);
        stats.setReturnedRentals(returnedCount);
        stats.setPendingRentals(pendingCount);
        stats.setTotalRevenue(totalRevenue);
        stats.setPaidRevenue(paidRevenue);
        stats.setTotalRenters(renters.size());
        
        if (rentals.size() > 0) {
            stats.setAvgRentalAmount(totalRevenue.divide(new BigDecimal(rentals.size()), 2, RoundingMode.HALF_UP));
            // 设备利用率 = (租赁中 + 已归还) / 总租赁数
            stats.setUtilizationRate((double) (activeCount + returnedCount) / rentals.size() * 100);
        } else {
            stats.setAvgRentalAmount(BigDecimal.ZERO);
            stats.setUtilizationRate(0.0);
        }
        
        return stats;
    }
    
    /**
     * 计算用户统计
     */
    private OperationalStatisticsDTO.UserStatistics calculateUserStatistics(Date startDate, Date endDate) {
        OperationalStatisticsDTO.UserStatistics stats = new OperationalStatisticsDTO.UserStatistics();
        
        // 查询所有用户
        List<SysUser> allUsers = userMapper.selectUserList(new SysUser());
        stats.setTotalUsers(allUsers.size());
        
        // 查询活跃用户（有订单或租赁记录的用户）
        Set<Long> activeUserIds = new HashSet<>();
        
        LambdaQueryWrapper<SkiTicketOrder> ticketWrapper = Wrappers.lambdaQuery();
        if (startDate != null) {
            ticketWrapper.ge(SkiTicketOrder::getCreateTime, startDate);
        }
        if (endDate != null) {
            ticketWrapper.le(SkiTicketOrder::getCreateTime, endDate);
        }
        List<SkiTicketOrder> orders = ticketOrderMapper.selectList(ticketWrapper);
        for (SkiTicketOrder order : orders) {
            if (order.getUserId() != null) {
                activeUserIds.add(order.getUserId());
            }
        }
        
        LambdaQueryWrapper<SkiEquipmentRental> rentalWrapper = Wrappers.lambdaQuery();
        if (startDate != null) {
            rentalWrapper.ge(SkiEquipmentRental::getCreateTime, startDate);
        }
        if (endDate != null) {
            rentalWrapper.le(SkiEquipmentRental::getCreateTime, endDate);
        }
        List<SkiEquipmentRental> rentals = equipmentRentalMapper.selectList(rentalWrapper);
        // 注意：租赁表没有userId字段，这里暂时跳过
        
        stats.setActiveUsers(activeUserIds.size());
        
        // 查询新增用户
        int newUserCount = 0;
        if (startDate != null) {
            for (SysUser user : allUsers) {
                if (user.getCreateTime() != null && user.getCreateTime().compareTo(startDate) >= 0) {
                    if (endDate == null || user.getCreateTime().compareTo(endDate) <= 0) {
                        newUserCount++;
                    }
                }
            }
        }
        stats.setNewUsers(newUserCount);
        
        // 用户增长趋势
        List<OperationalStatisticsDTO.UserGrowthDTO> growthList = calculateUserGrowth(startDate, endDate);
        stats.setUserGrowthList(growthList);
        
        return stats;
    }
    
    /**
     * 计算订单趋势
     */
    private List<OperationalStatisticsDTO.TrendDataDTO> calculateOrderTrend(Date startDate, Date endDate, String type) {
        LambdaQueryWrapper<SkiTicketOrder> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiTicketOrder::getOrderStatus, "1"); // 只统计已支付的订单
        if (startDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiTicketOrder::getPaymentTime, cal.getTime());
        }
        if (endDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiTicketOrder::getPaymentTime, cal.getTime());
        }
        List<SkiTicketOrder> orders = ticketOrderMapper.selectList(wrapper);
        
        SimpleDateFormat sdf = getDateFormat(type);
        Map<String, OperationalStatisticsDTO.TrendDataDTO> trendMap = new LinkedHashMap<>();
        
        for (SkiTicketOrder order : orders) {
            if (order.getPaymentTime() != null) {
                String dateKey = sdf.format(order.getPaymentTime());
                trendMap.computeIfAbsent(dateKey, k -> {
                    OperationalStatisticsDTO.TrendDataDTO dto = new OperationalStatisticsDTO.TrendDataDTO();
                    dto.setDate(k);
                    dto.setCount(0);
                    dto.setAmount(BigDecimal.ZERO);
                    return dto;
                });
                
                OperationalStatisticsDTO.TrendDataDTO dto = trendMap.get(dateKey);
                dto.setCount(dto.getCount() + 1);
                BigDecimal amount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
                dto.setAmount(dto.getAmount().add(amount));
            }
        }
        
        return new ArrayList<>(trendMap.values());
    }
    
    /**
     * 计算租赁趋势
     */
    private List<OperationalStatisticsDTO.TrendDataDTO> calculateRentalTrend(Date startDate, Date endDate, String type) {
        LambdaQueryWrapper<SkiEquipmentRental> wrapper = Wrappers.lambdaQuery();
        wrapper.in(SkiEquipmentRental::getStatus, Arrays.asList(1, 2)); // 租赁中或已归还
        if (startDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiEquipmentRental::getRentalStartTime, cal.getTime());
        }
        if (endDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiEquipmentRental::getRentalStartTime, cal.getTime());
        }
        List<SkiEquipmentRental> rentals = equipmentRentalMapper.selectList(wrapper);
        
        SimpleDateFormat sdf = getDateFormat(type);
        Map<String, OperationalStatisticsDTO.TrendDataDTO> trendMap = new LinkedHashMap<>();
        
        for (SkiEquipmentRental rental : rentals) {
            if (rental.getRentalStartTime() != null) {
                String dateKey = sdf.format(rental.getRentalStartTime());
                trendMap.computeIfAbsent(dateKey, k -> {
                    OperationalStatisticsDTO.TrendDataDTO dto = new OperationalStatisticsDTO.TrendDataDTO();
                    dto.setDate(k);
                    dto.setCount(0);
                    dto.setAmount(BigDecimal.ZERO);
                    return dto;
                });
                
                OperationalStatisticsDTO.TrendDataDTO dto = trendMap.get(dateKey);
                dto.setCount(dto.getCount() + 1);
                BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
                dto.setAmount(dto.getAmount().add(amount));
            }
        }
        
        return new ArrayList<>(trendMap.values());
    }
    
    /**
     * 计算热门票种
     */
    private List<OperationalStatisticsDTO.PopularTicketDTO> calculatePopularTickets(Date startDate, Date endDate) {
        LambdaQueryWrapper<SkiTicketOrder> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiTicketOrder::getOrderStatus, "1"); // 已支付
        if (startDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiTicketOrder::getPaymentTime, cal.getTime());
        }
        if (endDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiTicketOrder::getPaymentTime, cal.getTime());
        }
        List<SkiTicketOrder> orders = ticketOrderMapper.selectList(wrapper);
        
        Map<String, OperationalStatisticsDTO.PopularTicketDTO> ticketMap = new HashMap<>();
        
        for (SkiTicketOrder order : orders) {
            String ticketName = order.getTicketTypeName() != null ? order.getTicketTypeName() : "未知";
            ticketMap.computeIfAbsent(ticketName, k -> {
                OperationalStatisticsDTO.PopularTicketDTO dto = new OperationalStatisticsDTO.PopularTicketDTO();
                dto.setTicketName(k);
                dto.setOrderCount(0);
                dto.setTotalAmount(BigDecimal.ZERO);
                return dto;
            });
            
            OperationalStatisticsDTO.PopularTicketDTO dto = ticketMap.get(ticketName);
            dto.setOrderCount(dto.getOrderCount() + 1);
            BigDecimal amount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
            dto.setTotalAmount(dto.getTotalAmount().add(amount));
        }
        
        return ticketMap.values().stream()
            .sorted((a, b) -> b.getOrderCount().compareTo(a.getOrderCount()))
            .limit(10)
            .collect(Collectors.toList());
    }
    
    /**
     * 计算热门设备
     */
    private List<OperationalStatisticsDTO.PopularEquipmentDTO> calculatePopularEquipment(Date startDate, Date endDate) {
        LambdaQueryWrapper<SkiEquipmentRental> wrapper = Wrappers.lambdaQuery();
        wrapper.in(SkiEquipmentRental::getStatus, Arrays.asList(1, 2)); // 租赁中或已归还
        if (startDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(startDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            wrapper.ge(SkiEquipmentRental::getRentalStartTime, cal.getTime());
        }
        if (endDate != null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(endDate);
            cal.set(Calendar.HOUR_OF_DAY, 23);
            cal.set(Calendar.MINUTE, 59);
            cal.set(Calendar.SECOND, 59);
            cal.set(Calendar.MILLISECOND, 999);
            wrapper.le(SkiEquipmentRental::getRentalStartTime, cal.getTime());
        }
        List<SkiEquipmentRental> rentals = equipmentRentalMapper.selectList(wrapper);
        
        Map<String, OperationalStatisticsDTO.PopularEquipmentDTO> equipmentMap = new HashMap<>();
        
        for (SkiEquipmentRental rental : rentals) {
            String equipmentName = rental.getEquipmentName() != null ? rental.getEquipmentName() : "未知";
            equipmentMap.computeIfAbsent(equipmentName, k -> {
                OperationalStatisticsDTO.PopularEquipmentDTO dto = new OperationalStatisticsDTO.PopularEquipmentDTO();
                dto.setEquipmentName(k);
                dto.setRentalCount(0);
                dto.setTotalAmount(BigDecimal.ZERO);
                return dto;
            });
            
            OperationalStatisticsDTO.PopularEquipmentDTO dto = equipmentMap.get(equipmentName);
            dto.setRentalCount(dto.getRentalCount() + 1);
            BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
            dto.setTotalAmount(dto.getTotalAmount().add(amount));
        }
        
        return equipmentMap.values().stream()
            .sorted((a, b) -> b.getRentalCount().compareTo(a.getRentalCount()))
            .limit(10)
            .collect(Collectors.toList());
    }
    
    /**
     * 计算用户增长趋势
     */
    private List<OperationalStatisticsDTO.UserGrowthDTO> calculateUserGrowth(Date startDate, Date endDate) {
        List<SysUser> allUsers = userMapper.selectUserList(new SysUser());
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, Integer> growthMap = new LinkedHashMap<>();
        
        for (SysUser user : allUsers) {
            if (user.getCreateTime() != null) {
                if (startDate != null && user.getCreateTime().compareTo(startDate) < 0) {
                    continue;
                }
                if (endDate != null && user.getCreateTime().compareTo(endDate) > 0) {
                    continue;
                }
                
                String dateKey = sdf.format(user.getCreateTime());
                growthMap.put(dateKey, growthMap.getOrDefault(dateKey, 0) + 1);
            }
        }
        
        List<OperationalStatisticsDTO.UserGrowthDTO> growthList = new ArrayList<>();
        for (Map.Entry<String, Integer> entry : growthMap.entrySet()) {
            OperationalStatisticsDTO.UserGrowthDTO dto = new OperationalStatisticsDTO.UserGrowthDTO();
            dto.setDate(entry.getKey());
            dto.setCount(entry.getValue());
            growthList.add(dto);
        }
        
        return growthList;
    }
    
    /**
     * 获取日期格式化器
     */
    private SimpleDateFormat getDateFormat(String type) {
        if ("weekly".equals(type)) {
            return new SimpleDateFormat("yyyy-'W'ww");
        } else if ("monthly".equals(type)) {
            return new SimpleDateFormat("yyyy-MM");
        } else {
            return new SimpleDateFormat("yyyy-MM-dd");
        }
    }
}
