<template>
  <div class="coach-info-form">
    <el-form ref="coachInfoRef" :model="form" :rules="rules" label-width="120px">
      <el-form-item label="教练等级" prop="coachLevel">
        <el-select v-model="form.coachLevel" placeholder="请选择教练等级" style="width: 100%">
          <el-option label="初级" value="初级" />
          <el-option label="中级" value="中级" />
          <el-option label="高级" value="高级" />
          <el-option label="专业" value="专业" />
        </el-select>
      </el-form-item>

      <el-form-item label="教学年限" prop="teachingYears">
        <el-input-number
          v-model="form.teachingYears"
          :min="0"
          :max="50"
          placeholder="请输入教学年限"
          style="width: 100%"
        />
        <span class="form-tip">单位：年</span>
      </el-form-item>

      <el-form-item label="擅长领域" prop="specialty">
        <el-input
          v-model="form.specialty"
          type="textarea"
          :rows="3"
          placeholder="请输入擅长领域，如：单板滑雪、双板滑雪、儿童教学、进阶技巧等"
          maxlength="200"
          show-word-limit
        />
      </el-form-item>

      <el-form-item label="个人简介" prop="introduction">
        <el-input
          v-model="form.introduction"
          type="textarea"
          :rows="5"
          placeholder="请输入个人简介，介绍您的教学理念、经验等"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>

      <el-form-item label="课时费" prop="hourlyRate">
        <el-input-number
          v-model="form.hourlyRate"
          :min="0"
          :precision="2"
          placeholder="请输入课时费"
          style="width: 100%"
        />
        <span class="form-tip">单位：元/小时</span>
      </el-form-item>

      <el-form-item label="专业证书" prop="certificate">
        <el-input
          v-model="form.certificate"
          type="textarea"
          :rows="3"
          placeholder="请输入专业证书信息，如：国家滑雪教练证书、国际滑雪教练认证等（可用JSON格式存储）"
          maxlength="500"
          show-word-limit
        />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="submit">保存</el-button>
        <el-button @click="reset">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 统计信息展示（只读） -->
    <el-divider content-position="left">统计信息</el-divider>
    <el-row :gutter="20" class="stats-row">
      <el-col :span="6">
        <el-statistic title="累计学员数" :value="form.totalStudents || 0">
          <template #suffix>
            <span style="font-size: 14px">人</span>
          </template>
        </el-statistic>
      </el-col>
      <el-col :span="6">
        <el-statistic title="当前学员数" :value="form.currentStudents || 0">
          <template #suffix>
            <span style="font-size: 14px">人</span>
          </template>
        </el-statistic>
      </el-col>
      <el-col :span="6">
        <el-statistic title="累计教学时长" :value="form.totalTeachingHours || 0">
          <template #suffix>
            <span style="font-size: 14px">小时</span>
          </template>
        </el-statistic>
      </el-col>
      <el-col :span="6">
        <el-statistic title="平均评分" :value="form.averageRating || 0" :precision="2">
          <template #suffix>
            <span style="font-size: 14px">分</span>
          </template>
        </el-statistic>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { updateCoachInfo, addCoachInfo } from "@/api/coachInfo";

const props = defineProps({
  coachInfo: {
    type: Object,
    default: null
  }
});

const emit = defineEmits(['refresh']);

const { proxy } = getCurrentInstance();

const form = ref({});
const rules = ref({
  coachLevel: [{ required: true, message: "请选择教练等级", trigger: "change" }],
  teachingYears: [{ required: true, message: "请输入教学年限", trigger: "blur" }],
  hourlyRate: [{ type: "number", min: 0, message: "课时费必须大于等于0", trigger: "blur" }]
});

// 初始化表单数据
watch(() => props.coachInfo, (coachInfo) => {
  if (coachInfo && coachInfo.id) {
    form.value = {
      id: coachInfo.id,
      userId: coachInfo.userId,
      coachLevel: coachInfo.coachLevel || '初级',
      teachingYears: coachInfo.teachingYears || 0,
      specialty: coachInfo.specialty || '',
      introduction: coachInfo.introduction || '',
      hourlyRate: coachInfo.hourlyRate ? parseFloat(coachInfo.hourlyRate) : null,
      certificate: coachInfo.certificate || '',
      totalStudents: coachInfo.totalStudents || 0,
      currentStudents: coachInfo.currentStudents || 0,
      totalTeachingHours: coachInfo.totalTeachingHours || 0,
      averageRating: coachInfo.averageRating ? parseFloat(coachInfo.averageRating) : 0,
      ratingCount: coachInfo.ratingCount || 0
    };
  } else {
    // 如果没有教练信息，初始化默认值
    form.value = {
      coachLevel: '初级',
      teachingYears: 0,
      specialty: '',
      introduction: '',
      hourlyRate: null,
      certificate: '',
      totalStudents: 0,
      currentStudents: 0,
      totalTeachingHours: 0,
      averageRating: 0,
      ratingCount: 0
    };
  }
}, { immediate: true });

/** 提交按钮 */
function submit() {
  proxy.$refs.coachInfoRef.validate(valid => {
    if (valid) {
      // 如果还没有创建教练信息，需要先创建
      if (!form.value.id) {
        addCoachInfo(form.value).then(response => {
          proxy.$modal.msgSuccess("保存成功");
          emit('refresh');
        });
      } else {
        updateCoachInfo(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          emit('refresh');
        });
      }
    }
  });
}

/** 重置按钮 */
function reset() {
  if (props.coachInfo) {
    form.value = {
      id: props.coachInfo.id,
      userId: props.coachInfo.userId,
      coachLevel: props.coachInfo.coachLevel || '初级',
      teachingYears: props.coachInfo.teachingYears || 0,
      specialty: props.coachInfo.specialty || '',
      introduction: props.coachInfo.introduction || '',
      hourlyRate: props.coachInfo.hourlyRate || null,
      certificate: props.coachInfo.certificate || '',
      totalStudents: props.coachInfo.totalStudents || 0,
      currentStudents: props.coachInfo.currentStudents || 0,
      totalTeachingHours: props.coachInfo.totalTeachingHours || 0,
      averageRating: props.coachInfo.averageRating || 0,
      ratingCount: props.coachInfo.ratingCount || 0
    };
  }
}
</script>

<style scoped>
.coach-info-form {
  padding: 20px;
}

.form-tip {
  color: #909399;
  font-size: 12px;
  margin-left: 10px;
}

.stats-row {
  margin-top: 20px;
  padding: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
}
</style>
