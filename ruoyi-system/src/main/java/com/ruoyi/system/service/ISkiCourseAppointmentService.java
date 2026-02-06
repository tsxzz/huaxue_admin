package com.ruoyi.system.service;

import com.ruoyi.system.domain.SkiCourseAppointment;
import java.util.List;

/**
 * 课程预约Service接口
 * 
 * @author ruoyi
 */
public interface ISkiCourseAppointmentService {
    /**
     * 查询课程预约
     * 
     * @param id 预约主键
     * @return 课程预约
     */
    public SkiCourseAppointment selectSkiCourseAppointmentById(Long id);

    /**
     * 查询课程预约列表
     * 
     * @param skiCourseAppointment 课程预约
     * @return 课程预约集合
     */
    public List<SkiCourseAppointment> selectSkiCourseAppointmentList(SkiCourseAppointment skiCourseAppointment);

    /**
     * 新增课程预约
     * 
     * @param skiCourseAppointment 课程预约
     * @return 结果
     */
    public int insertSkiCourseAppointment(SkiCourseAppointment skiCourseAppointment);

    /**
     * 修改课程预约
     * 
     * @param skiCourseAppointment 课程预约
     * @return 结果
     */
    public int updateSkiCourseAppointment(SkiCourseAppointment skiCourseAppointment);

    /**
     * 批量删除课程预约
     * 
     * @param ids 需要删除的预约主键集合
     * @return 结果
     */
    public int deleteSkiCourseAppointmentByIds(Long[] ids);

    /**
     * 删除课程预约信息
     * 
     * @param id 预约主键
     * @return 结果
     */
    public int deleteSkiCourseAppointmentById(Long id);

    /**
     * 取消预约（退课）
     * 
     * @param id 预约主键
     * @param cancelReason 取消原因
     * @return 结果
     */
    public int cancelAppointment(Long id, String cancelReason);

    /**
     * 支付预约
     * 
     * @param id 预约主键
     * @param paymentMethod 支付方式（1现金 2微信 3支付宝 4银行卡）
     * @return 结果
     */
    public int payAppointment(Long id, String paymentMethod);

    /**
     * 确认预约
     * 
     * @param id 预约主键
     * @return 结果
     */
    public int confirmAppointment(Long id);

    /**
     * 完成预约
     * 
     * @param id 预约主键
     * @return 结果
     */
    public int completeAppointment(Long id);
}
