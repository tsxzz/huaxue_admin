package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.system.domain.SkiEquipmentRental;
import com.ruoyi.system.domain.SkiTicketOrder;
import com.ruoyi.system.domain.dto.FinancialStatisticsDTO;
import com.ruoyi.system.mapper.SkiEquipmentRentalMapper;
import com.ruoyi.system.mapper.SkiTicketOrderMapper;
import com.ruoyi.system.service.IFinancialStatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 财务统计服务实现类
 * 
 * @author ruoyi
 */
@Service
public class FinancialStatisticsServiceImpl implements IFinancialStatisticsService {
    
    @Autowired
    private SkiTicketOrderMapper ticketOrderMapper;
    
    @Autowired
    private SkiEquipmentRentalMapper equipmentRentalMapper;
    
    @Override
    public FinancialStatisticsDTO getFinancialStatistics(Date startDate, Date endDate) {
        FinancialStatisticsDTO statistics = new FinancialStatisticsDTO();
        
        // 查询门票订单（已支付状态：1）
        LambdaQueryWrapper<SkiTicketOrder> ticketWrapper = Wrappers.lambdaQuery();
        ticketWrapper.eq(SkiTicketOrder::getOrderStatus, "1"); // 已支付
        if (startDate != null) {
            ticketWrapper.ge(SkiTicketOrder::getPaymentTime, startDate);
        }
        if (endDate != null) {
            ticketWrapper.le(SkiTicketOrder::getPaymentTime, endDate);
        }
        List<SkiTicketOrder> ticketOrders = ticketOrderMapper.selectList(ticketWrapper);
        
        // 查询租赁订单（已支付状态：1租赁中 或 2已归还）
        LambdaQueryWrapper<SkiEquipmentRental> rentalWrapper = Wrappers.lambdaQuery();
        rentalWrapper.in(SkiEquipmentRental::getStatus, Arrays.asList(1, 2)); // 租赁中或已归还
        if (startDate != null) {
            rentalWrapper.ge(SkiEquipmentRental::getRentalStartTime, startDate);
        }
        if (endDate != null) {
            rentalWrapper.le(SkiEquipmentRental::getRentalStartTime, endDate);
        }
        List<SkiEquipmentRental> rentals = equipmentRentalMapper.selectList(rentalWrapper);
        
        // 计算总收入
        BigDecimal ticketRevenue = ticketOrders.stream()
            .map(order -> order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        BigDecimal rentalRevenue = rentals.stream()
            .map(rental -> rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        BigDecimal totalRevenue = ticketRevenue.add(rentalRevenue);
        
        statistics.setTotalRevenue(totalRevenue);
        statistics.setTicketRevenue(ticketRevenue);
        statistics.setRentalRevenue(rentalRevenue);
        
        // 日收入统计
        List<FinancialStatisticsDTO.DailyRevenueDTO> dailyRevenueList = calculateDailyRevenue(ticketOrders, rentals);
        statistics.setDailyRevenueList(dailyRevenueList);
        
        // 月收入统计
        List<FinancialStatisticsDTO.MonthlyRevenueDTO> monthlyRevenueList = calculateMonthlyRevenue(ticketOrders, rentals);
        statistics.setMonthlyRevenueList(monthlyRevenueList);
        
        // 收入来源占比
        List<FinancialStatisticsDTO.RevenueSourceDTO> revenueSourceList = calculateRevenueSource(ticketRevenue, rentalRevenue);
        statistics.setRevenueSourceList(revenueSourceList);
        
        // 支付方式统计
        List<FinancialStatisticsDTO.PaymentMethodDTO> paymentMethodList = calculatePaymentMethod(ticketOrders);
        statistics.setPaymentMethodList(paymentMethodList);
        
        return statistics;
    }
    
    /**
     * 计算日收入
     */
    private List<FinancialStatisticsDTO.DailyRevenueDTO> calculateDailyRevenue(
            List<SkiTicketOrder> ticketOrders, List<SkiEquipmentRental> rentals) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Map<String, FinancialStatisticsDTO.DailyRevenueDTO> dailyMap = new LinkedHashMap<>();
        
        // 统计门票收入
        for (SkiTicketOrder order : ticketOrders) {
            if (order.getPaymentTime() != null) {
                String date = sdf.format(order.getPaymentTime());
                dailyMap.computeIfAbsent(date, k -> {
                    FinancialStatisticsDTO.DailyRevenueDTO dto = new FinancialStatisticsDTO.DailyRevenueDTO();
                    dto.setDate(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.DailyRevenueDTO dto = dailyMap.get(date);
                BigDecimal amount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
                dto.setTicketAmount(dto.getTicketAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        // 统计租赁收入
        for (SkiEquipmentRental rental : rentals) {
            if (rental.getRentalStartTime() != null) {
                String date = sdf.format(rental.getRentalStartTime());
                dailyMap.computeIfAbsent(date, k -> {
                    FinancialStatisticsDTO.DailyRevenueDTO dto = new FinancialStatisticsDTO.DailyRevenueDTO();
                    dto.setDate(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.DailyRevenueDTO dto = dailyMap.get(date);
                BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
                dto.setRentalAmount(dto.getRentalAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        return new ArrayList<>(dailyMap.values());
    }
    
    /**
     * 计算月收入
     */
    private List<FinancialStatisticsDTO.MonthlyRevenueDTO> calculateMonthlyRevenue(
            List<SkiTicketOrder> ticketOrders, List<SkiEquipmentRental> rentals) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
        Map<String, FinancialStatisticsDTO.MonthlyRevenueDTO> monthlyMap = new LinkedHashMap<>();
        
        // 统计门票收入
        for (SkiTicketOrder order : ticketOrders) {
            if (order.getPaymentTime() != null) {
                String month = sdf.format(order.getPaymentTime());
                monthlyMap.computeIfAbsent(month, k -> {
                    FinancialStatisticsDTO.MonthlyRevenueDTO dto = new FinancialStatisticsDTO.MonthlyRevenueDTO();
                    dto.setMonth(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.MonthlyRevenueDTO dto = monthlyMap.get(month);
                BigDecimal amount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
                dto.setTicketAmount(dto.getTicketAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        // 统计租赁收入
        for (SkiEquipmentRental rental : rentals) {
            if (rental.getRentalStartTime() != null) {
                String month = sdf.format(rental.getRentalStartTime());
                monthlyMap.computeIfAbsent(month, k -> {
                    FinancialStatisticsDTO.MonthlyRevenueDTO dto = new FinancialStatisticsDTO.MonthlyRevenueDTO();
                    dto.setMonth(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.MonthlyRevenueDTO dto = monthlyMap.get(month);
                BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
                dto.setRentalAmount(dto.getRentalAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        return new ArrayList<>(monthlyMap.values());
    }
    
    /**
     * 计算收入来源占比
     */
    private List<FinancialStatisticsDTO.RevenueSourceDTO> calculateRevenueSource(
            BigDecimal ticketRevenue, BigDecimal rentalRevenue) {
        BigDecimal total = ticketRevenue.add(rentalRevenue);
        List<FinancialStatisticsDTO.RevenueSourceDTO> list = new ArrayList<>();
        
        if (total.compareTo(BigDecimal.ZERO) > 0) {
            FinancialStatisticsDTO.RevenueSourceDTO ticket = new FinancialStatisticsDTO.RevenueSourceDTO();
            ticket.setSource("门票收入");
            ticket.setAmount(ticketRevenue);
            ticket.setPercentage(ticketRevenue.divide(total, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100")).doubleValue());
            list.add(ticket);
            
            FinancialStatisticsDTO.RevenueSourceDTO rental = new FinancialStatisticsDTO.RevenueSourceDTO();
            rental.setSource("租赁收入");
            rental.setAmount(rentalRevenue);
            rental.setPercentage(rentalRevenue.divide(total, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100")).doubleValue());
            list.add(rental);
        }
        
        return list;
    }
    
    /**
     * 计算支付方式统计
     */
    private List<FinancialStatisticsDTO.PaymentMethodDTO> calculatePaymentMethod(List<SkiTicketOrder> ticketOrders) {
        Map<String, FinancialStatisticsDTO.PaymentMethodDTO> methodMap = new HashMap<>();
        
        Map<String, String> methodNameMap = new HashMap<>();
        methodNameMap.put("1", "现金");
        methodNameMap.put("2", "微信");
        methodNameMap.put("3", "支付宝");
        methodNameMap.put("4", "银行卡");
        
        for (SkiTicketOrder order : ticketOrders) {
            String method = order.getPaymentMethod() != null ? order.getPaymentMethod() : "未知";
            methodMap.computeIfAbsent(method, k -> {
                FinancialStatisticsDTO.PaymentMethodDTO dto = new FinancialStatisticsDTO.PaymentMethodDTO();
                dto.setMethod(k);
                dto.setMethodName(methodNameMap.getOrDefault(k, "未知"));
                dto.setAmount(BigDecimal.ZERO);
                dto.setCount(0);
                return dto;
            });
            
            FinancialStatisticsDTO.PaymentMethodDTO dto = methodMap.get(method);
            BigDecimal amount = order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO;
            dto.setAmount(dto.getAmount().add(amount));
            dto.setCount(dto.getCount() + 1);
        }
        
        return new ArrayList<>(methodMap.values());
    }
}
