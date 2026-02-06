package com.ruoyi.system.service.impl;

import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.system.mapper.SkiSlopeMapper;
import com.ruoyi.system.domain.SkiSlope;
import com.ruoyi.system.service.ISkiSlopeService;

/**
 * 雪道信息Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2024-01-01
 */
@Service
public class SkiSlopeServiceImpl implements ISkiSlopeService 
{
    @Autowired
    private SkiSlopeMapper skiSlopeMapper;

    /**
     * 查询雪道信息
     * 
     * @param id 雪道信息主键
     * @return 雪道信息
     */
    @Override
    public SkiSlope selectSkiSlopeById(Long id)
    {
        // 使用MyBatis-Plus的selectById方法
        return skiSlopeMapper.selectById(id);
    }

    /**
     * 查询雪道信息列表（使用QueryWrapper构建查询条件）
     * 
     * @param skiSlope 雪道信息
     * @return 雪道信息
     */
    @Override
    public List<SkiSlope> selectSkiSlopeList(SkiSlope skiSlope)
    {
        // 使用LambdaQueryWrapper构建查询条件，类型安全
        LambdaQueryWrapper<SkiSlope> wrapper = Wrappers.lambdaQuery();
        
        // 根据条件动态构建查询
        wrapper.like(StringUtils.isNotBlank(skiSlope.getName()), SkiSlope::getName, skiSlope.getName())
               .like(StringUtils.isNotBlank(skiSlope.getSlopeCode()), SkiSlope::getSlopeCode, skiSlope.getSlopeCode())
               .eq(StringUtils.isNotBlank(skiSlope.getDifficulty()), SkiSlope::getDifficulty, skiSlope.getDifficulty())
               .eq(skiSlope.getStatus() != null, SkiSlope::getStatus, skiSlope.getStatus())
               .orderByDesc(SkiSlope::getCreateTime);
        
        // 使用MyBatis-Plus的selectList方法
        return skiSlopeMapper.selectList(wrapper);
    }

    /**
     * 新增雪道信息
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    @Override
    public int insertSkiSlope(SkiSlope skiSlope)
    {
        System.out.println("========== Service层：insertSkiSlope 开始 ==========");
        System.out.println("原始图片URL：" + skiSlope.getImageUrl());
        
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiSlope.getImageUrl())) {
            String originalUrl = skiSlope.getImageUrl();
            skiSlope.setImageUrl(normalizeImageUrl(skiSlope.getImageUrl()));
            System.out.println("规范化后的图片URL：" + skiSlope.getImageUrl());
        }
        
        skiSlope.setCreateTime(DateUtils.getNowDate());
        
        System.out.println("准备插入数据库，数据：" + skiSlope);
        
        try {
            // 使用MyBatis-Plus的insert方法
            int result = skiSlopeMapper.insert(skiSlope);
            System.out.println("数据库插入结果：" + result);
            return result;
        } catch (Exception e) {
            System.out.println("========== Service层：数据库插入异常 ==========");
            System.out.println("异常类型：" + e.getClass().getName());
            System.out.println("异常信息：" + e.getMessage());
            e.printStackTrace();
            throw e;
        } finally {
            System.out.println("========== Service层：insertSkiSlope 结束 ==========");
        }
    }
    
    /**
     * 规范化图片URL：将本地路径转换为相对路径
     */
    private String normalizeImageUrl(String imageUrl) {
        if (StringUtils.isBlank(imageUrl)) {
            return imageUrl;
        }
        
        // 记录原始路径
        org.slf4j.Logger logger = org.slf4j.LoggerFactory.getLogger(SkiSlopeServiceImpl.class);
        logger.info("规范化图片URL，原始路径：{}", imageUrl);
        
        // 如果已经是相对路径格式（以 /profile/ 开头），直接返回
        if (imageUrl.startsWith("/profile/")) {
            logger.info("已经是相对路径格式，直接返回：{}", imageUrl);
            return imageUrl;
        }
        
        // 如果是本地路径（Windows格式），转换为相对路径
        if (imageUrl.contains("\\") || imageUrl.matches("^[A-Za-z]:.*")) {
            // 查找 upload 目录的位置
            int uploadIndex = imageUrl.toLowerCase().indexOf("upload");
            if (uploadIndex != -1) {
                // 提取 upload 后面的路径，并转换为正斜杠
                String relativePath = imageUrl.substring(uploadIndex).replace("\\", "/");
                // 确保以 / 开头
                if (!relativePath.startsWith("/")) {
                    relativePath = "/" + relativePath;
                }
                // 如果路径中已经包含 /profile/upload/，直接使用
                if (relativePath.contains("/profile/upload/")) {
                    String result = relativePath.substring(relativePath.indexOf("/profile/"));
                    logger.info("转换后的路径：{}", result);
                    return result;
                }
                // 否则添加 /profile/ 前缀
                String result = "/profile/upload" + relativePath.substring("/upload".length());
                logger.info("转换后的路径：{}", result);
                return result;
            }
        }
        
        // 如果以 /upload/ 开头，添加 /profile 前缀
        if (imageUrl.startsWith("/upload/")) {
            String result = "/profile" + imageUrl;
            logger.info("添加 /profile 前缀后的路径：{}", result);
            return result;
        }
        
        // 如果以 / 开头但不是 /profile/，可能是相对路径，添加 /profile/upload 前缀
        if (imageUrl.startsWith("/") && !imageUrl.startsWith("/profile/")) {
            String result = "/profile/upload" + imageUrl;
            logger.info("添加 /profile/upload 前缀后的路径：{}", result);
            return result;
        }
        
        // 默认情况：添加 /profile/upload/ 前缀
        String result = "/profile/upload/" + imageUrl;
        logger.info("默认添加前缀后的路径：{}", result);
        return result;
    }

    /**
     * 修改雪道信息
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    @Override
    public int updateSkiSlope(SkiSlope skiSlope)
    {
        // 处理图片路径：如果是本地路径，转换为相对路径
        if (StringUtils.isNotBlank(skiSlope.getImageUrl())) {
            skiSlope.setImageUrl(normalizeImageUrl(skiSlope.getImageUrl()));
        }
        skiSlope.setUpdateTime(DateUtils.getNowDate());
        // 使用MyBatis-Plus的updateById方法
        return skiSlopeMapper.updateById(skiSlope);
    }

    /**
     * 批量删除雪道信息
     * 
     * @param ids 需要删除的雪道信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiSlopeByIds(Long[] ids)
    {
        // 使用MyBatis-Plus的deleteBatchIds方法
        return skiSlopeMapper.deleteBatchIds(java.util.Arrays.asList(ids));
    }

    /**
     * 删除雪道信息信息
     * 
     * @param id 雪道信息主键
     * @return 结果
     */
    @Override
    public int deleteSkiSlopeById(Long id)
    {
        // 使用MyBatis-Plus的deleteById方法
        return skiSlopeMapper.deleteById(id);
    }

    /**
     * 修改雪道状态
     * 
     * @param skiSlope 雪道信息
     * @return 结果
     */
    @Override
    public int changeStatus(SkiSlope skiSlope)
    {
        skiSlope.setUpdateTime(DateUtils.getNowDate());
        // 使用MyBatis-Plus的updateById方法
        return skiSlopeMapper.updateById(skiSlope);
    }
}
