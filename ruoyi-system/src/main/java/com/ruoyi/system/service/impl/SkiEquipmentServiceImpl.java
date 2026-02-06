package com.ruoyi.system.service.impl;

import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiEquipmentMapper;
import com.ruoyi.system.domain.SkiEquipment;
import com.ruoyi.system.service.ISkiEquipmentService;

/**
 * 雪具信息Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Service
public class SkiEquipmentServiceImpl implements ISkiEquipmentService 
{
    @Autowired
    private SkiEquipmentMapper skiEquipmentMapper;

    /**
     * 查询雪具信息
     * 
     * @param id 雪具信息主键
     * @return 雪具信息
     */
    @Override
    public SkiEquipment selectSkiEquipmentById(Long id)
    {
        return skiEquipmentMapper.selectById(id);
    }

    /**
     * 查询雪具信息列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiEquipment 雪具信息
     * @return 雪具信息
     */
    @Override
    public List<SkiEquipment> selectSkiEquipmentList(SkiEquipment skiEquipment)
    {
        LambdaQueryWrapper<SkiEquipment> wrapper = Wrappers.lambdaQuery();
        
        wrapper.like(StringUtils.isNotBlank(skiEquipment.getName()), SkiEquipment::getName, skiEquipment.getName())
               .eq(StringUtils.isNotBlank(skiEquipment.getEquipmentCode()), SkiEquipment::getEquipmentCode, skiEquipment.getEquipmentCode())
               .eq(StringUtils.isNotBlank(skiEquipment.getCategory()), SkiEquipment::getCategory, skiEquipment.getCategory())
               .like(StringUtils.isNotBlank(skiEquipment.getBrand()), SkiEquipment::getBrand, skiEquipment.getBrand())
               .eq(skiEquipment.getStatus() != null, SkiEquipment::getStatus, skiEquipment.getStatus())
               .orderByDesc(SkiEquipment::getCreateTime);
        
        return skiEquipmentMapper.selectList(wrapper);
    }

    /**
     * 新增雪具信息
     * 
     * @param skiEquipment 雪具信息
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiEquipment(SkiEquipment skiEquipment)
    {
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiEquipment.getImageUrl())) {
            skiEquipment.setImageUrl(normalizeImageUrl(skiEquipment.getImageUrl()));
        }
        
        // 初始化数量
        if (skiEquipment.getAvailableQuantity() == null) {
            skiEquipment.setAvailableQuantity(skiEquipment.getTotalQuantity());
        }
        if (skiEquipment.getMaintenanceQuantity() == null) {
            skiEquipment.setMaintenanceQuantity(0);
        }
        if (skiEquipment.getScrapQuantity() == null) {
            skiEquipment.setScrapQuantity(0);
        }
        
        // 自动计算状态
        updateStatus(skiEquipment);
        
        skiEquipment.setCreateTime(DateUtils.getNowDate());
        return skiEquipmentMapper.insert(skiEquipment);
    }

    /**
     * 修改雪具信息
     * 
     * @param skiEquipment 雪具信息
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiEquipment(SkiEquipment skiEquipment)
    {
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiEquipment.getImageUrl())) {
            skiEquipment.setImageUrl(normalizeImageUrl(skiEquipment.getImageUrl()));
        }
        
        // 自动计算状态
        updateStatus(skiEquipment);
        
        skiEquipment.setUpdateTime(DateUtils.getNowDate());
        return skiEquipmentMapper.updateById(skiEquipment);
    }

    /**
     * 批量删除雪具信息
     * 
     * @param ids 需要删除的雪具信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiEquipmentByIds(Long[] ids)
    {
        return skiEquipmentMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除雪具信息信息
     * 
     * @param id 雪具信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiEquipmentById(Long id)
    {
        return skiEquipmentMapper.deleteById(id);
    }

    /**
     * 报修雪具（将可用数量转为维修中）
     * 
     * @param id 雪具ID
     * @param quantity 报修数量
     * @return 结果
     */
    @Override
    @Transactional
    public int reportMaintenance(Long id, Integer quantity)
    {
        SkiEquipment equipment = skiEquipmentMapper.selectById(id);
        if (equipment == null) {
            return 0;
        }
        
        // 检查可用数量是否足够
        if (equipment.getAvailableQuantity() < quantity) {
            throw new RuntimeException("可用数量不足，无法报修");
        }
        
        // 更新数量
        equipment.setAvailableQuantity(equipment.getAvailableQuantity() - quantity);
        equipment.setMaintenanceQuantity(equipment.getMaintenanceQuantity() + quantity);
        
        // 更新状态
        updateStatus(equipment);
        equipment.setUpdateTime(DateUtils.getNowDate());
        
        return skiEquipmentMapper.updateById(equipment);
    }

    /**
     * 完成维修（将维修中数量转为可用）
     * 
     * @param id 雪具ID
     * @param quantity 完成维修数量
     * @return 结果
     */
    @Override
    @Transactional
    public int completeMaintenance(Long id, Integer quantity)
    {
        SkiEquipment equipment = skiEquipmentMapper.selectById(id);
        if (equipment == null) {
            return 0;
        }
        
        // 检查维修中数量是否足够
        if (equipment.getMaintenanceQuantity() < quantity) {
            throw new RuntimeException("维修中数量不足");
        }
        
        // 更新数量
        equipment.setMaintenanceQuantity(equipment.getMaintenanceQuantity() - quantity);
        equipment.setAvailableQuantity(equipment.getAvailableQuantity() + quantity);
        
        // 更新状态
        updateStatus(equipment);
        equipment.setUpdateTime(DateUtils.getNowDate());
        
        return skiEquipmentMapper.updateById(equipment);
    }

    /**
     * 报废雪具（将可用或维修中数量转为报废）
     * 
     * @param id 雪具ID
     * @param quantity 报废数量
     * @return 结果
     */
    @Override
    @Transactional
    public int scrapEquipment(Long id, Integer quantity)
    {
        SkiEquipment equipment = skiEquipmentMapper.selectById(id);
        if (equipment == null) {
            return 0;
        }
        
        // 优先从可用数量中报废，不足则从维修中数量报废
        int availableScrap = Math.min(equipment.getAvailableQuantity(), quantity);
        int maintenanceScrap = quantity - availableScrap;
        
        if (maintenanceScrap > equipment.getMaintenanceQuantity()) {
            throw new RuntimeException("报废数量超过可用和维修中数量总和");
        }
        
        // 更新数量
        equipment.setAvailableQuantity(equipment.getAvailableQuantity() - availableScrap);
        equipment.setMaintenanceQuantity(equipment.getMaintenanceQuantity() - maintenanceScrap);
        equipment.setScrapQuantity(equipment.getScrapQuantity() + quantity);
        
        // 更新状态
        updateStatus(equipment);
        equipment.setUpdateTime(DateUtils.getNowDate());
        
        return skiEquipmentMapper.updateById(equipment);
    }

    /**
     * 规范化图片URL：将本地路径转换为相对路径
     */
    private String normalizeImageUrl(String imageUrl) {
        if (StringUtils.isBlank(imageUrl)) {
            return imageUrl;
        }
        
        org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(SkiEquipmentServiceImpl.class);
        logger.info("规范化图片URL，原始路径：{}", imageUrl);
        
        if (imageUrl.startsWith("/profile/")) {
            logger.info("已经是相对路径格式，直接返回：{}", imageUrl);
            return imageUrl;
        }
        
        if (imageUrl.contains("\\") || imageUrl.matches("^[A-Za-z]:.*")) {
            int uploadIndex = imageUrl.toLowerCase().indexOf("upload");
            if (uploadIndex != -1) {
                String relativePath = imageUrl.substring(uploadIndex).replace("\\", "/");
                if (!relativePath.startsWith("/")) {
                    relativePath = "/" + relativePath;
                }
                if (relativePath.contains("/profile/upload/")) {
                    String result = relativePath.substring(relativePath.indexOf("/profile/"));
                    logger.info("转换后的路径：{}", result);
                    return result;
                }
                String result = "/profile/upload" + relativePath.substring("/upload".length());
                logger.info("转换后的路径：{}", result);
                return result;
            }
        }
        
        if (imageUrl.startsWith("/upload/")) {
            String result = "/profile" + imageUrl;
            logger.info("添加 /profile 前缀后的路径：{}", result);
            return result;
        }
        
        if (imageUrl.startsWith("/") && !imageUrl.startsWith("/profile/")) {
            String result = "/profile/upload" + imageUrl;
            logger.info("添加 /profile/upload 前缀后的路径：{}", result);
            return result;
        }
        
        String result = "/profile/upload/" + imageUrl;
        logger.info("默认添加前缀后的路径：{}", result);
        return result;
    }

    /**
     * 自动更新状态
     * 0缺货 1可用 2部分可用 3维修中
     */
    private void updateStatus(SkiEquipment equipment) {
        if (equipment.getTotalQuantity() == null || equipment.getTotalQuantity() == 0) {
            equipment.setStatus(0); // 缺货
        } else if (equipment.getAvailableQuantity() == null || equipment.getAvailableQuantity() == 0) {
            if (equipment.getMaintenanceQuantity() != null && equipment.getMaintenanceQuantity() > 0) {
                equipment.setStatus(3); // 维修中
            } else {
                equipment.setStatus(0); // 缺货
            }
        } else if (equipment.getAvailableQuantity().equals(equipment.getTotalQuantity())) {
            equipment.setStatus(1); // 可用
        } else {
            equipment.setStatus(2); // 部分可用
        }
    }
}
