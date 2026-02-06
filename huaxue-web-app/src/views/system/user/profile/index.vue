<template>
   <div class="app-container">
      <el-row :gutter="20">
         <el-col :span="6" :xs="24">
            <el-card class="box-card">
               <template v-slot:header>
                 <div class="clearfix">
                   <span>个人信息</span>
                 </div>
               </template>
               <div>
                  <div class="text-center">
                     <userAvatar />
                  </div>
                  <ul class="list-group list-group-striped">
                     <li class="list-group-item">
                        <svg-icon icon-class="user" />用户名称
                        <div class="pull-right">{{ state.user.userName }}</div>
                     </li>
                     <li class="list-group-item">
                        <svg-icon icon-class="phone" />手机号码
                        <div class="pull-right">{{ state.user.phonenumber }}</div>
                     </li>
                     <li class="list-group-item">
                        <svg-icon icon-class="email" />用户邮箱
                        <div class="pull-right">{{ state.user.email }}</div>
                     </li>
                     <li class="list-group-item">
                        <svg-icon icon-class="tree" />所属部门
                        <div class="pull-right" v-if="state.user.dept">{{ state.user.dept.deptName }} / {{ state.postGroup }}</div>
                     </li>
                     <li class="list-group-item">
                        <svg-icon icon-class="peoples" />所属角色
                        <div class="pull-right">{{ state.roleGroup }}</div>
                     </li>
                     <li class="list-group-item">
                        <svg-icon icon-class="date" />创建日期
                        <div class="pull-right">{{ state.user.createTime }}</div>
                     </li>
                     <!-- 教练专属信息 -->
                     <template v-if="isCoach">
                        <li class="list-group-item">
                           <svg-icon icon-class="star" />教练等级
                           <div class="pull-right">
                              <el-tag :type="getCoachLevelType(state.coachInfo?.coachLevel)">
                                 {{ state.coachInfo?.coachLevel || '未设置' }}
                              </el-tag>
                           </div>
                        </li>
                        <li class="list-group-item">
                           <svg-icon icon-class="time" />教学年限
                           <div class="pull-right">{{ state.coachInfo?.teachingYears || 0 }} 年</div>
                        </li>
                        <li class="list-group-item">
                           <svg-icon icon-class="peoples" />累计学员
                           <div class="pull-right">{{ state.coachInfo?.totalStudents || 0 }} 人</div>
                        </li>
                        <li class="list-group-item">
                           <svg-icon icon-class="user" />当前学员
                           <div class="pull-right">{{ state.coachInfo?.currentStudents || 0 }} 人</div>
                        </li>
                        <li class="list-group-item">
                           <svg-icon icon-class="time" />累计教学时长
                           <div class="pull-right">{{ state.coachInfo?.totalTeachingHours || 0 }} 小时</div>
                        </li>
                        <li class="list-group-item">
                           <svg-icon icon-class="star" />平均评分
                           <div class="pull-right">
                              <el-rate
                                 :model-value="coachRating"
                                 disabled
                                 show-score
                                 text-color="#ff9900"
                                 :score-template="`${coachRating.toFixed(1)}`"
                                 style="display: inline-block;"
                              />
                           </div>
                        </li>
                        <li class="list-group-item" v-if="state.coachInfo?.specialty">
                           <svg-icon icon-class="list" />擅长领域
                           <div class="pull-right">{{ state.coachInfo.specialty }}</div>
                        </li>
                        <li class="list-group-item" v-if="state.coachInfo?.hourlyRate">
                           <svg-icon icon-class="money" />课时费
                           <div class="pull-right">¥{{ state.coachInfo.hourlyRate }}/小时</div>
                        </li>
                     </template>
                  </ul>
               </div>
            </el-card>
         </el-col>
         <el-col :span="18" :xs="24">
            <el-card>
               <template v-slot:header>
                 <div class="clearfix">
                   <span>基本资料</span>
                 </div>
               </template>
               <el-tabs v-model="activeTab">
                  <el-tab-pane label="基本资料" name="userinfo">
                     <userInfo :user="state.user" />
                  </el-tab-pane>
                  <el-tab-pane label="教练信息" name="coachInfo" v-if="isCoach">
                     <coachInfo :coach-info="state.coachInfo" @refresh="getCoachInfo" />
                  </el-tab-pane>
                  <el-tab-pane label="修改密码" name="resetPwd">
                     <resetPwd />
                  </el-tab-pane>
               </el-tabs>
            </el-card>
         </el-col>
      </el-row>
   </div>
</template>

<script setup name="Profile">
import userAvatar from "./userAvatar";
import userInfo from "./userInfo";
import resetPwd from "./resetPwd";
import coachInfo from "./coachInfo.vue";
import { getUserProfile } from "@/api/system/user";
import { getCurrentCoachInfo } from "@/api/coachInfo";
import useUserStore from "@/store/modules/user";

const userStore = useUserStore();
const activeTab = ref("userinfo");
const state = reactive({
  user: {},
  roleGroup: {},
  postGroup: {},
  coachInfo: null
});

// 判断是否是教练角色
const isCoach = computed(() => {
  return userStore.roles && userStore.roles.includes('Coach');
});

// 教练评分（用于显示）
const coachRating = computed(() => {
  if (state.coachInfo && state.coachInfo.averageRating) {
    return parseFloat(state.coachInfo.averageRating);
  }
  return 0;
});

// 获取教练等级标签类型
function getCoachLevelType(level) {
  const levelMap = {
    '初级': 'info',
    '中级': 'success',
    '高级': 'warning',
    '专业': 'danger'
  };
  return levelMap[level] || 'info';
}

function getUser() {
  getUserProfile().then(response => {
    state.user = response.data;
    state.roleGroup = response.roleGroup;
    state.postGroup = response.postGroup;
    
    // 如果是教练，获取教练信息
    if (isCoach.value) {
      getCoachInfo();
    }
  });
}

function getCoachInfo() {
  getCurrentCoachInfo().then(response => {
    state.coachInfo = response.data;
  }).catch(() => {
    // 如果获取失败，可能是还没有创建教练信息，设置为null
    state.coachInfo = null;
  });
}

getUser();
</script>

<style scoped>
</style>
