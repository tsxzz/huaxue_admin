package com.ruoyi.system.service.impl;

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
import com.ruoyi.system.mapper.SkiMaterialStockMapper;
import com.ruoyi.system.mapper.SkiMaterialMapper;
import com.ruoyi.system.domain.SkiMaterialStock;
import com.ruoyi.system.domain.SkiMaterial;
import com.ruoyi.system.service.ISkiMaterialStockService;

/**
 * 出入库记录Service业务层处理（使用MyBatis-Plus）
 * 
 * @author ruoyi
 * @date 2026-02-05
 */
@Service
public class SkiMaterialStockServiceImpl implements ISkiMaterialStockService 
{
    @Autowired
    private SkiMaterialStockMapper skiMaterialStockMapper;

    @Autowired
    private SkiMaterialMapper skiMaterialMapper;

    /**
     * 查询出入库记录
     * 
     * @param id 出入库记录主键
     * @return 出入库记录
     */
    @Override
    public SkiMaterialStock selectSkiMaterialStockById(Long id)
    {
        return skiMaterialStockMapper.selectById(id);
    }

    /**
     * 查询出入库记录列表
     * 
     * @param skiMaterialStock 出入库记录
     * @return 出入库记录集合
     */
    @Override
    public List<SkiMaterialStock> selectSkiMaterialStockList(SkiMaterialStock skiMaterialStock)
    {
        LambdaQueryWrapper<SkiMaterialStock> wrapper = Wrappers.lambdaQuery();
        
        wrapper.eq(skiMaterialStock.getMaterialId() != null, SkiMaterialStock::getMaterialId, skiMaterialStock.getMaterialId())
               .eq(StringUtils.isNotBlank(skiMaterialStock.getOperationType()), SkiMaterialStock::getOperationType, skiMaterialStock.getOperationType())
               .like(StringUtils.isNotBlank(skiMaterialStock.getMaterialCode()), SkiMaterialStock::getMaterialCode, skiMaterialStock.getMaterialCode())
               .like(StringUtils.isNotBlank(skiMaterialStock.getMaterialName()), SkiMaterialStock::getMaterialName, skiMaterialStock.getMaterialName())
               .orderByDesc(SkiMaterialStock::getOperationTime);
        
        return skiMaterialStockMapper.selectList(wrapper);
    }

    /**
     * 新增出入库记录
     * 
     * @param skiMaterialStock 出入库记录
     * @return 结果
     */
    @Override
    @Transactional
    public int insertSkiMaterialStock(SkiMaterialStock skiMaterialStock)
    {
        // 设置操作人和操作时间
        Long userId = SecurityUtils.getUserId();
        String userName = SecurityUtils.getUsername();
        skiMaterialStock.setOperatorId(userId);
        skiMaterialStock.setOperatorName(userName);
        skiMaterialStock.setOperationTime(DateUtils.getNowDate());
        
        // 如果物资信息为空，从物资表获取
        if (skiMaterialStock.getMaterialId() != null) {
            SkiMaterial material = skiMaterialMapper.selectById(skiMaterialStock.getMaterialId());
            if (material != null) {
                if (StringUtils.isBlank(skiMaterialStock.getMaterialCode())) {
                    skiMaterialStock.setMaterialCode(material.getMaterialCode());
                }
                if (StringUtils.isBlank(skiMaterialStock.getMaterialName())) {
                    skiMaterialStock.setMaterialName(material.getMaterialName());
                }
            }
        }
        
        // 计算总金额
        if (skiMaterialStock.getUnitPrice() != null && skiMaterialStock.getQuantity() != null) {
            skiMaterialStock.setTotalAmount(skiMaterialStock.getUnitPrice().multiply(
                new java.math.BigDecimal(skiMaterialStock.getQuantity())));
        }
        
        int result = skiMaterialStockMapper.insert(skiMaterialStock);
        
        // 更新物资库存
        if (result > 0 && skiMaterialStock.getMaterialId() != null) {
            updateMaterialStock(skiMaterialStock.getMaterialId(), 
                               skiMaterialStock.getOperationType(), 
                               skiMaterialStock.getQuantity());
        }
        
        return result;
    }

    /**
     * 更新物资库存
     */
    private void updateMaterialStock(Long materialId, String operationType, Integer quantity) {
        SkiMaterial material = skiMaterialMapper.selectById(materialId);
        if (material != null) {
            int currentStock = material.getCurrentStock() != null ? material.getCurrentStock() : 0;
            if ("1".equals(operationType)) {
                // 入库：增加库存
                material.setCurrentStock(currentStock + quantity);
            } else if ("2".equals(operationType)) {
                // 出库：减少库存
                material.setCurrentStock(Math.max(0, currentStock - quantity));
            }
            skiMaterialMapper.updateById(material);
        }
    }

    /**
     * 修改出入库记录
     * 
     * @param skiMaterialStock 出入库记录
     * @return 结果
     */
    @Override
    @Transactional
    public int updateSkiMaterialStock(SkiMaterialStock skiMaterialStock)
    {
        return skiMaterialStockMapper.updateById(skiMaterialStock);
    }

    /**
     * 批量删除出入库记录
     * 
     * @param ids 需要删除的出入库记录主键集合
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialStockByIds(Long[] ids)
    {
        for (Long id : ids) {
            skiMaterialStockMapper.deleteById(id);
        }
        return ids.length;
    }

    /**
     * 删除出入库记录信息
     * 
     * @param id 出入库记录主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteSkiMaterialStockById(Long id)
    {
        return skiMaterialStockMapper.deleteById(id);
    }
}
