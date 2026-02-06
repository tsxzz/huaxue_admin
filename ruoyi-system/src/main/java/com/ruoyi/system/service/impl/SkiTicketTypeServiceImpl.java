package com.ruoyi.system.service.impl;

import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiTicketTypeMapper;
import com.ruoyi.system.domain.SkiTicketType;
import com.ruoyi.system.service.ISkiTicketTypeService;

/**
 * 门票类型Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-01-30
 */
@Service
public class SkiTicketTypeServiceImpl implements ISkiTicketTypeService 
{
    @Autowired
    private SkiTicketTypeMapper skiTicketTypeMapper;

    /**
     * 查询门票类型
     * 
     * @param id 门票类型主键
     * @return 门票类型
     */
    @Override
    public SkiTicketType selectSkiTicketTypeById(Long id)
    {
        return skiTicketTypeMapper.selectById(id);
    }

    /**
     * 查询门票类型列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiTicketType 门票类型
     * @return 门票类型
     */
    @Override
    public List<SkiTicketType> selectSkiTicketTypeList(SkiTicketType skiTicketType)
    {
        LambdaQueryWrapper<SkiTicketType> wrapper = Wrappers.lambdaQuery();
        
        wrapper.like(StringUtils.isNotBlank(skiTicketType.getTicketName()), SkiTicketType::getTicketName, skiTicketType.getTicketName())
               .eq(StringUtils.isNotBlank(skiTicketType.getTicketCode()), SkiTicketType::getTicketCode, skiTicketType.getTicketCode())
               .eq(StringUtils.isNotBlank(skiTicketType.getTicketType()), SkiTicketType::getTicketType, skiTicketType.getTicketType())
               .eq(StringUtils.isNotBlank(skiTicketType.getStatus()), SkiTicketType::getStatus, skiTicketType.getStatus())
               .orderByAsc(SkiTicketType::getSortOrder)
               .orderByDesc(SkiTicketType::getCreateTime);
        
        return skiTicketTypeMapper.selectList(wrapper);
    }

    /**
     * 新增门票类型
     * 
     * @param skiTicketType 门票类型
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiTicketType(SkiTicketType skiTicketType)
    {
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiTicketType.getImageUrl())) {
            skiTicketType.setImageUrl(normalizeImageUrl(skiTicketType.getImageUrl()));
        }
        
        // 设置默认值
        if (skiTicketType.getValidDays() == null) {
            skiTicketType.setValidDays(1);
        }
        if (StringUtils.isBlank(skiTicketType.getStatus())) {
            skiTicketType.setStatus("0");
        }
        if (skiTicketType.getSortOrder() == null) {
            skiTicketType.setSortOrder(0);
        }
        
        return skiTicketTypeMapper.insert(skiTicketType);
    }

    /**
     * 修改门票类型
     * 
     * @param skiTicketType 门票类型
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiTicketType(SkiTicketType skiTicketType)
    {
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiTicketType.getImageUrl())) {
            skiTicketType.setImageUrl(normalizeImageUrl(skiTicketType.getImageUrl()));
        }
        
        return skiTicketTypeMapper.updateById(skiTicketType);
    }

    /**
     * 批量删除门票类型
     * 
     * @param ids 需要删除的门票类型主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiTicketTypeByIds(Long[] ids)
    {
        return skiTicketTypeMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除门票类型信息
     * 
     * @param id 门票类型主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiTicketTypeById(Long id)
    {
        return skiTicketTypeMapper.deleteById(id);
    }

    /**
     * 规范化图片URL：将本地绝对路径转换为相对路径
     * 
     * @param imageUrl 图片URL
     * @return 规范化后的URL
     */
    private String normalizeImageUrl(String imageUrl)
    {
        if (StringUtils.isBlank(imageUrl)) {
            return imageUrl;
        }
        
        // 如果包含uploadPath，提取相对路径
        String uploadPath = "/upload/";
        int index = imageUrl.indexOf(uploadPath);
        if (index >= 0) {
            return imageUrl.substring(index);
        }
        
        // 如果已经是相对路径，直接返回
        if (imageUrl.startsWith("/") || imageUrl.startsWith("http")) {
            return imageUrl;
        }
        
        // 其他情况，添加/upload/前缀
        return uploadPath + imageUrl;
    }
}
