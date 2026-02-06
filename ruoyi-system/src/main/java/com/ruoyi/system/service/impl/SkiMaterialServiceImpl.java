package com.ruoyi.system.service.impl;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.ruoyi.system.mapper.SkiMaterialMapper;
import com.ruoyi.system.domain.SkiMaterial;
import com.ruoyi.system.service.ISkiMaterialService;

/**
 * 物资管理Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Service
public class SkiMaterialServiceImpl implements ISkiMaterialService 
{
    @Autowired
    private SkiMaterialMapper skiMaterialMapper;

    /**
     * 查询物资管理
     * 
     * @param id 物资管理主键
     * @return 物资管理
     */
    @Override
    public SkiMaterial selectSkiMaterialById(Long id)
    {
        SkiMaterial material = skiMaterialMapper.selectById(id);
        if (material != null) {
            checkExpiringSoon(material);
            checkLowStock(material);
        }
        return material;
    }

    /**
     * 查询物资管理列表
     * 
     * @param skiMaterial 物资管理
     * @return 物资管理集合
     */
    @Override
    public List<SkiMaterial> selectSkiMaterialList(SkiMaterial skiMaterial)
    {
        LambdaQueryWrapper<SkiMaterial> wrapper = Wrappers.lambdaQuery();
        
        wrapper.eq(StringUtils.isNotBlank(skiMaterial.getMaterialCode()), SkiMaterial::getMaterialCode, skiMaterial.getMaterialCode())
               .like(StringUtils.isNotBlank(skiMaterial.getMaterialName()), SkiMaterial::getMaterialName, skiMaterial.getMaterialName())
               .eq(StringUtils.isNotBlank(skiMaterial.getMaterialType()), SkiMaterial::getMaterialType, skiMaterial.getMaterialType())
               .eq(StringUtils.isNotBlank(skiMaterial.getStatus()), SkiMaterial::getStatus, skiMaterial.getStatus())
               .orderByDesc(SkiMaterial::getCreateTime);
        
        List<SkiMaterial> list = skiMaterialMapper.selectList(wrapper);
        
        // 检查过期和库存状态
        for (SkiMaterial material : list) {
            checkExpiringSoon(material);
            checkLowStock(material);
        }
        
        return list;
    }

    /**
     * 检查是否即将过期（30天内）
     */
    private void checkExpiringSoon(SkiMaterial material) {
        if (material.getExpiryDate() != null) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.DAY_OF_MONTH, 30);
            Date thirtyDaysLater = cal.getTime();
            material.setIsExpiringSoon(material.getExpiryDate().before(thirtyDaysLater));
        } else {
            material.setIsExpiringSoon(false);
        }
    }

    /**
     * 检查是否库存不足
     */
    private void checkLowStock(SkiMaterial material) {
        if (material.getSafetyStock() != null && material.getCurrentStock() != null) {
            material.setIsLowStock(material.getCurrentStock() < material.getSafetyStock());
        } else {
            material.setIsLowStock(false);
        }
    }

    /**
     * 新增物资管理
     * 
     * @param skiMaterial 物资管理
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiMaterial(SkiMaterial skiMaterial)
    {
        // 设置默认值
        if (skiMaterial.getSafetyStock() == null) {
            skiMaterial.setSafetyStock(0);
        }
        if (skiMaterial.getCurrentStock() == null) {
            skiMaterial.setCurrentStock(0);
        }
        if (StringUtils.isBlank(skiMaterial.getStatus())) {
            skiMaterial.setStatus("0");
        }
        
        return skiMaterialMapper.insert(skiMaterial);
    }

    /**
     * 修改物资管理
     * 
     * @param skiMaterial 物资管理
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiMaterial(SkiMaterial skiMaterial)
    {
        return skiMaterialMapper.updateById(skiMaterial);
    }

    /**
     * 批量删除物资管理
     * 
     * @param ids 需要删除的物资管理主键集合
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialByIds(Long[] ids)
    {
        // 软删除：更新状态为1
        for (Long id : ids) {
            SkiMaterial material = new SkiMaterial();
            material.setId(id);
            material.setStatus("1");
            skiMaterialMapper.updateById(material);
        }
        return ids.length;
    }

    /**
     * 删除物资管理信息
     * 
     * @param id 物资管理主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialById(Long id)
    {
        // 软删除
        SkiMaterial material = new SkiMaterial();
        material.setId(id);
        material.setStatus("1");
        return skiMaterialMapper.updateById(material);
    }

    /**
     * 检查物资编码是否唯一
     * 
     * @param materialCode 物资编码
     * @param id 物资ID（更新时使用）
     * @return 是否唯一
     */
    @Override
    public boolean checkMaterialCodeUnique(String materialCode, Long id)
    {
        LambdaQueryWrapper<SkiMaterial> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMaterial::getMaterialCode, materialCode);
        if (id != null) {
            wrapper.ne(SkiMaterial::getId, id);
        }
        return skiMaterialMapper.selectCount(wrapper) == 0;
    }

    /**
     * 获取即将过期的物资（30天内）
     * 
     * @return 即将过期的物资列表
     */
    @Override
    public List<SkiMaterial> getExpiringSoonMaterials()
    {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DAY_OF_MONTH, 30);
        Date thirtyDaysLater = cal.getTime();
        
        LambdaQueryWrapper<SkiMaterial> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMaterial::getStatus, "0")
               .le(SkiMaterial::getExpiryDate, thirtyDaysLater)
               .isNotNull(SkiMaterial::getExpiryDate)
               .orderByAsc(SkiMaterial::getExpiryDate);
        
        return skiMaterialMapper.selectList(wrapper);
    }

    /**
     * 获取库存不足的物资
     * 
     * @return 库存不足的物资列表
     */
    @Override
    public List<SkiMaterial> getLowStockMaterials()
    {
        LambdaQueryWrapper<SkiMaterial> wrapper = Wrappers.lambdaQuery();
        wrapper.eq(SkiMaterial::getStatus, "0")
               .apply("current_stock < safety_stock")
               .orderByAsc(SkiMaterial::getCurrentStock);
        
        return skiMaterialMapper.selectList(wrapper);
    }
}
