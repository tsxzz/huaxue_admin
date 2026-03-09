package com.ruoyi.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.system.domain.SkiEquipmentRental;
import com.ruoyi.system.domain.SkiTicketOrder;
import com.ruoyi.system.domain.SkiCourseAppointment;
import com.ruoyi.system.domain.dto.FinancialStatisticsDTO;
import com.ruoyi.system.mapper.SkiEquipmentRentalMapper;
import com.ruoyi.system.mapper.SkiTicketOrderMapper;
import com.ruoyi.system.mapper.SkiCourseAppointmentMapper;
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
    
    @Autowired
    private SkiCourseAppointmentMapper courseAppointmentMapper;
    
    /** 教练收入比例（30%） */
    private static final BigDecimal COACH_REVENUE_RATIO = new BigDecimal("0.30");
    
    /** 雪场收入比例（70%） */
    private static final BigDecimal RESORT_REVENUE_RATIO = new BigDecimal("0.70");
    
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
        
        // 查询教练课程预约（已支付状态：1）
        LambdaQueryWrapper<SkiCourseAppointment> courseWrapper = Wrappers.lambdaQuery();
        courseWrapper.eq(SkiCourseAppointment::getPaymentStatus, "1"); // 已支付
        if (startDate != null) {
            courseWrapper.ge(SkiCourseAppointment::getPaymentTime, startDate);
        }
        if (endDate != null) {
            courseWrapper.le(SkiCourseAppointment::getPaymentTime, endDate);
        }
        List<SkiCourseAppointment> courseAppointments = courseAppointmentMapper.selectList(courseWrapper);
        
        // 计算门票收入
        BigDecimal ticketRevenue = ticketOrders.stream()
            .map(order -> order.getPaidAmount() != null ? order.getPaidAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // 计算租赁收入
        BigDecimal rentalRevenue = rentals.stream()
            .map(rental -> rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // 计算教练课程总收入
        BigDecimal courseRevenue = courseAppointments.stream()
            .map(appointment -> appointment.getPrice() != null ? appointment.getPrice() : BigDecimal.ZERO)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // 计算教练收入（30%）
        BigDecimal coachRevenue = courseRevenue.multiply(COACH_REVENUE_RATIO)
            .setScale(2, RoundingMode.HALF_UP);
        
        // 计算雪场收入（70%）
        BigDecimal resortRevenue = courseRevenue.multiply(RESORT_REVENUE_RATIO)
            .setScale(2, RoundingMode.HALF_UP);
        
        // 计算总收入（门票 + 租赁 + 雪场收入部分）
        BigDecimal totalRevenue = ticketRevenue.add(rentalRevenue).add(resortRevenue);
        
        statistics.setTotalRevenue(totalRevenue);
        statistics.setTicketRevenue(ticketRevenue);
        statistics.setRentalRevenue(rentalRevenue);
        statistics.setCourseRevenue(courseRevenue);
        statistics.setCoachRevenue(coachRevenue);
        statistics.setResortRevenue(resortRevenue);
        
        // 日收入统计
        List<FinancialStatisticsDTO.DailyRevenueDTO> dailyRevenueList = calculateDailyRevenue(ticketOrders, rentals, courseAppointments);
        statistics.setDailyRevenueList(dailyRevenueList);
        
        // 月收入统计
        List<FinancialStatisticsDTO.MonthlyRevenueDTO> monthlyRevenueList = calculateMonthlyRevenue(ticketOrders, rentals, courseAppointments);
        statistics.setMonthlyRevenueList(monthlyRevenueList);
        
        // 收入来源占比
        List<FinancialStatisticsDTO.RevenueSourceDTO> revenueSourceList = calculateRevenueSource(ticketRevenue, rentalRevenue, resortRevenue);
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
            List<SkiTicketOrder> ticketOrders, List<SkiEquipmentRental> rentals, List<SkiCourseAppointment> courseAppointments) {
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
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
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
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.DailyRevenueDTO dto = dailyMap.get(date);
                BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
                dto.setRentalAmount(dto.getRentalAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        // 统计教练课程收入
        for (SkiCourseAppointment appointment : courseAppointments) {
            if (appointment.getPaymentTime() != null) {
                String date = sdf.format(appointment.getPaymentTime());
                dailyMap.computeIfAbsent(date, k -> {
                    FinancialStatisticsDTO.DailyRevenueDTO dto = new FinancialStatisticsDTO.DailyRevenueDTO();
                    dto.setDate(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.DailyRevenueDTO dto = dailyMap.get(date);
                BigDecimal courseAmount = appointment.getPrice() != null ? appointment.getPrice() : BigDecimal.ZERO;
                BigDecimal coachAmount = courseAmount.multiply(COACH_REVENUE_RATIO).setScale(2, RoundingMode.HALF_UP);
                BigDecimal resortAmount = courseAmount.multiply(RESORT_REVENUE_RATIO).setScale(2, RoundingMode.HALF_UP);
                
                dto.setCourseAmount(dto.getCourseAmount().add(courseAmount));
                dto.setCoachAmount(dto.getCoachAmount().add(coachAmount));
                dto.setResortAmount(dto.getResortAmount().add(resortAmount));
                // 只将雪场收入部分计入总收入
                dto.setTotalAmount(dto.getTotalAmount().add(resortAmount));
            }
        }
        
        return new ArrayList<>(dailyMap.values());
    }
    
    /**
     * 计算月收入
     */
    private List<FinancialStatisticsDTO.MonthlyRevenueDTO> calculateMonthlyRevenue(
            List<SkiTicketOrder> ticketOrders, List<SkiEquipmentRental> rentals, List<SkiCourseAppointment> courseAppointments) {
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
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
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
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.MonthlyRevenueDTO dto = monthlyMap.get(month);
                BigDecimal amount = rental.getPaidAmount() != null ? rental.getPaidAmount() : BigDecimal.ZERO;
                dto.setRentalAmount(dto.getRentalAmount().add(amount));
                dto.setTotalAmount(dto.getTotalAmount().add(amount));
            }
        }
        
        // 统计教练课程收入
        for (SkiCourseAppointment appointment : courseAppointments) {
            if (appointment.getPaymentTime() != null) {
                String month = sdf.format(appointment.getPaymentTime());
                monthlyMap.computeIfAbsent(month, k -> {
                    FinancialStatisticsDTO.MonthlyRevenueDTO dto = new FinancialStatisticsDTO.MonthlyRevenueDTO();
                    dto.setMonth(k);
                    dto.setTicketAmount(BigDecimal.ZERO);
                    dto.setRentalAmount(BigDecimal.ZERO);
                    dto.setCourseAmount(BigDecimal.ZERO);
                    dto.setCoachAmount(BigDecimal.ZERO);
                    dto.setResortAmount(BigDecimal.ZERO);
                    dto.setTotalAmount(BigDecimal.ZERO);
                    return dto;
                });
                FinancialStatisticsDTO.MonthlyRevenueDTO dto = monthlyMap.get(month);
                BigDecimal courseAmount = appointment.getPrice() != null ? appointment.getPrice() : BigDecimal.ZERO;
                BigDecimal coachAmount = courseAmount.multiply(COACH_REVENUE_RATIO).setScale(2, RoundingMode.HALF_UP);
                BigDecimal resortAmount = courseAmount.multiply(RESORT_REVENUE_RATIO).setScale(2, RoundingMode.HALF_UP);
                
                dto.setCourseAmount(dto.getCourseAmount().add(courseAmount));
                dto.setCoachAmount(dto.getCoachAmount().add(coachAmount));
                dto.setResortAmount(dto.getResortAmount().add(resortAmount));
                // 只将雪场收入部分计入总收入
                dto.setTotalAmount(dto.getTotalAmount().add(resortAmount));
            }
        }
        
        return new ArrayList<>(monthlyMap.values());
    }
    
    /**
     * 计算收入来源占比
     */
    private List<FinancialStatisticsDTO.RevenueSourceDTO> calculateRevenueSource(
            BigDecimal ticketRevenue, BigDecimal rentalRevenue, BigDecimal resortRevenue) {
        BigDecimal total = ticketRevenue.add(rentalRevenue).add(resortRevenue);
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
            
            FinancialStatisticsDTO.RevenueSourceDTO course = new FinancialStatisticsDTO.RevenueSourceDTO();
            course.setSource("课程收入（雪场）");
            course.setAmount(resortRevenue);
            course.setPercentage(resortRevenue.divide(total, 4, RoundingMode.HALF_UP).multiply(new BigDecimal("100")).doubleValue());
            list.add(course);
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
