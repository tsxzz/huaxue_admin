<template>
  <div class="login-container">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="snow-mountain"></div>
      <div class="snow-mountain snow-mountain-2"></div>
      <div class="snowflakes">
        <div class="snowflake" v-for="n in 50" :key="n"></div>
      </div>
    </div>

    <!-- 登录表单 -->
    <div class="login-wrapper">
      <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
        <!-- Logo和标题区域 -->
        <div class="login-header">
          <div class="logo-container">
            <span class="logo-text">⛷</span>
          </div>
          <h1 class="login-title">滑雪场管理系统</h1>
          <p class="login-subtitle">Ski Resort Management System</p>
        </div>

        <!-- 表单内容 -->
        <div class="form-content">
          <el-form-item prop="username">
            <el-input
              v-model="loginForm.username"
              type="text"
              size="large"
              auto-complete="off"
              placeholder="请输入账号"
              class="custom-input"
            >
              <template #prefix>
                <el-icon class="input-icon"><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input
              v-model="loginForm.password"
              type="password"
              size="large"
              auto-complete="off"
              placeholder="请输入密码"
              class="custom-input"
              @keyup.enter="handleLogin"
            >
              <template #prefix>
                <el-icon class="input-icon"><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled">
            <el-input
              v-model="loginForm.code"
              size="large"
              auto-complete="off"
              placeholder="验证码"
              class="custom-input code-input"
              @keyup.enter="handleLogin"
            >
              <template #prefix>
                <el-icon class="input-icon"><Key /></el-icon>
              </template>
            </el-input>
            <div class="login-code">
              <img :src="codeUrl" @click="getCode" class="login-code-img" alt="验证码"/>
            </div>
          </el-form-item>

          <div class="form-options">
            <el-checkbox v-model="loginForm.rememberMe" class="remember-me">
              记住密码
            </el-checkbox>
            <router-link v-if="register" to="/register" class="register-link">
              立即注册
            </router-link>
          </div>

          <el-form-item style="width:100%; margin-top: 20px;">
            <el-button
              :loading="loading"
              size="large"
              type="primary"
              class="login-button"
              @click.prevent="handleLogin"
            >
              <span v-if="!loading">
                <el-icon><Right /></el-icon>
                登 录
              </span>
              <span v-else>登 录 中...</span>
            </el-button>
          </el-form-item>

          <!-- 注册入口 -->
          <div v-if="register" class="register-tip">
            <span style="color: #909399;">还没有账号？</span>
            <router-link to="/register" class="register-link-bold">
              立即注册
            </router-link>
          </div>
        </div>
      </el-form>
    </div>

    <!-- 底部信息 -->
    <div class="login-footer">
      <p>欢迎使用滑雪场管理系统</p>
      <p class="copyright">Copyright © 2024 Ski Resort Management System All Rights Reserved.</p>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, getCurrentInstance, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getCodeImg } from "@/api/login";
import { getConfigKey } from "@/api/system/config";
import Cookies from "js-cookie";
import { encrypt, decrypt } from "@/utils/jsencrypt";
import useUserStore from '@/store/modules/user'
import { User, Lock, Key, Right } from '@element-plus/icons-vue'

// 最开始的调试信息
console.log('=== 登录页面脚本开始执行 ===');
console.log('=== 导入完成 ===');

const userStore = useUserStore()
const route = useRoute();
const router = useRouter();
const { proxy } = getCurrentInstance();

console.log('=== 变量初始化完成 ===');

const loginForm = ref({
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: ""
});

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
};

const codeUrl = ref("");
const loading = ref(false);
// 验证码开关
const captchaEnabled = ref(true);
// 注册开关 - 默认从数据库配置获取，如果接口未返回则使用默认值 true（因为已在数据库中设置为 true）
const register = ref(true);
const redirect = ref(undefined);

watch(route, (newRoute) => {
    redirect.value = newRoute.query && newRoute.query.redirect;
}, { immediate: true });

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true;
      // 勾选了需要记住密码设置在 cookie 中设置记住用户名和密码
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 });
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 });
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 });
      } else {
        // 否则移除
        Cookies.remove("username");
        Cookies.remove("password");
        Cookies.remove("rememberMe");
      }
      // 调用action的登录方法
      userStore.login(loginForm.value).then(() => {
        const query = route.query;
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur];
          }
          return acc;
        }, {});
        router.push({ path: redirect.value || "/", query: otherQueryParams });
      }).catch(() => {
        loading.value = false;
        // 重新获取验证码
        if (captchaEnabled.value) {
          getCode();
        }
      });
    }
  });
}

// 备用方案：通过配置接口获取注册开关（暂时不使用，直接保持为 true）
function getRegisterConfig() {
  // 直接设置为 true，不调用接口
  register.value = true;
  console.log('保持注册开关为 true');
  
  // 如果需要从接口获取，可以取消下面的注释
  /*
  getConfigKey('sys.account.registerUser').then(res => {
    console.log('从配置接口获取注册开关:', res);
    if (res && (res === 'true' || res === true)) {
      register.value = true;
      console.log('注册功能已开启');
    } else {
      register.value = false;
      console.log('注册功能已关闭');
    }
  }).catch(err => {
    console.warn('无法从配置接口获取注册开关:', err);
    register.value = true;
  });
  */
}

function getCode() {
  console.log('开始调用 getCode 函数');
  // 确保 register 始终保持为 true（因为已在数据库中设置为 true）
  register.value = true;
  console.log('强制设置 register 为 true');
  
  getCodeImg().then(res => {
    // 调试信息
    console.log('验证码接口返回数据:', res);
    console.log('返回数据类型:', typeof res);
    console.log('返回数据的所有键:', Object.keys(res || {}));
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled;
    
    // 获取注册开关
    // 如果后端返回了 register 字段，使用接口的值；否则保持 true
    if (res.register !== undefined) {
      register.value = res.register === true || res.register === 'true';
      console.log('从验证码接口获取到注册开关:', register.value);
    } else {
      // 如果后端没有返回 register 字段，保持默认值 true
      console.log('验证码接口没有返回 register 字段，保持默认值 true');
      register.value = true;
    }
    
    console.log('最终注册开关值:', register.value, '类型:', typeof register.value);
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img;
      loginForm.value.uuid = res.uuid;
    }
  }).catch(err => {
    console.error('获取验证码失败:', err);
    console.error('错误详情:', err.response || err.message || err);
    // 即使出错，也保持 register 为 true
    register.value = true;
  });
}

function getCookie() {
  const username = Cookies.get("username");
  const password = Cookies.get("password");
  const rememberMe = Cookies.get("rememberMe");
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  };
}

// 立即执行的调试 - 确保代码被加载
console.log('=== 登录页面脚本加载完成 ===');
console.log('register 初始值:', register.value);
console.log('register 变量类型:', typeof register.value);
console.log('register 是否为 true:', register.value === true);

// 使用 onMounted 确保组件挂载后再调用
onMounted(() => {
  console.log('=== onMounted 钩子执行 ===');
  console.log('登录页面组件已挂载');
  console.log('准备调用 getCode()');
  try {
    getCode();
    getCookie();
    console.log('=== getCode 和 getCookie 调用完成 ===');
  } catch (error) {
    console.error('=== onMounted 中发生错误 ===', error);
    console.error('错误堆栈:', error.stack);
  }
});

// 测试：直接调用一次看看
console.log('=== 测试：直接调用 getCode ===');
try {
  getCode();
} catch (e) {
  console.error('直接调用 getCode 失败:', e);
}
</script>

<style lang='scss' scoped>
.login-container {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 25%, #f093fb 50%, #4facfe 75%, #00f2fe 100%);
  background-size: 400% 400%;
  animation: gradientShift 15s ease infinite;
  display: flex;
  justify-content: center;
  align-items: center;
}

@keyframes gradientShift {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

// 背景装饰
.background-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  top: 0;
  left: 0;
  z-index: 1;
  overflow: hidden;
}

// 雪山装饰
.snow-mountain {
  position: absolute;
  bottom: 0;
  width: 100%;
  height: 40%;
  background: linear-gradient(to top, rgba(255, 255, 255, 0.9) 0%, rgba(255, 255, 255, 0.6) 50%, transparent 100%);
  clip-path: polygon(0% 100%, 20% 60%, 40% 80%, 60% 50%, 80% 70%, 100% 40%, 100% 100%);
  animation: mountainMove 20s ease-in-out infinite;
}

.snow-mountain-2 {
  height: 30%;
  background: linear-gradient(to top, rgba(255, 255, 255, 0.7) 0%, rgba(255, 255, 255, 0.4) 50%, transparent 100%);
  clip-path: polygon(0% 100%, 15% 70%, 35% 85%, 55% 60%, 75% 75%, 100% 50%, 100% 100%);
  animation: mountainMove 25s ease-in-out infinite reverse;
  opacity: 0.8;
}

@keyframes mountainMove {
  0%, 100% {
    transform: translateX(0);
  }
  50% {
    transform: translateX(-20px);
  }
}

// 雪花动画
.snowflakes {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.snowflake {
  position: absolute;
  top: -10px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 1em;
  font-family: Arial;
  text-shadow: 0 0 5px rgba(255, 255, 255, 0.8);
  animation: snowfall linear infinite;
  
  &:before {
    content: "❄";
  }
}

@keyframes snowfall {
  0% {
    transform: translateY(0) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(360deg);
    opacity: 0;
  }
}

// 生成50个雪花，随机位置和速度
@for $i from 1 through 50 {
  .snowflake:nth-child(#{$i}) {
    left: random(100) * 1%;
    animation-duration: (random(20) + 10) * 1s;
    animation-delay: random(10) * 0.1s;
    font-size: (random(10) + 10) * 0.1em;
  }
}

// 登录表单容器
.login-wrapper {
  position: relative;
  z-index: 10;
  width: 100%;
  max-width: 450px;
  padding: 20px;
}

.login-form {
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  padding: 40px 35px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  border: 1px solid rgba(255, 255, 255, 0.3);
  animation: formFadeIn 0.8s ease-out;
}

@keyframes formFadeIn {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

// Logo和标题
.login-header {
  text-align: center;
  margin-bottom: 35px;
}

.logo-container {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 80px;
  height: 80px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 20px;
  margin-bottom: 20px;
  box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
  animation: logoFloat 3s ease-in-out infinite;
}

@keyframes logoFloat {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.logo-text {
  font-size: 50px;
  display: block;
  line-height: 1;
}

.login-title {
  margin: 0 0 8px 0;
  font-size: 28px;
  font-weight: 700;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  letter-spacing: 1px;
}

.login-subtitle {
  margin: 0;
  font-size: 14px;
  color: #909399;
  font-weight: 400;
  letter-spacing: 2px;
}

// 表单内容
.form-content {
  margin-top: 10px;
}

.custom-input {
  :deep(.el-input__wrapper) {
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;
    
    &:hover {
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    }
    
    &.is-focus {
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }
  }
  
  :deep(.el-input__inner) {
    height: 48px;
    font-size: 15px;
  }
}

.input-icon {
  font-size: 18px;
  color: #909399;
}

.code-input {
  width: 63%;
  display: inline-block;
}

.login-code {
  width: 35%;
  height: 48px;
  float: right;
  border-radius: 10px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
    transform: translateY(-2px);
  }
}

.login-code-img {
  width: 100%;
  height: 100%;
  display: block;
}

// 表单选项
.form-options {
  display: flex !important;
  justify-content: space-between !important;
  align-items: center !important;
  margin-bottom: 10px !important;
  width: 100% !important;
  visibility: visible !important;
  opacity: 1 !important;
}

.remember-me {
  :deep(.el-checkbox__label) {
    color: #606266;
    font-size: 14px;
  }
}

.register-link {
  color: #667eea !important;
  text-decoration: none !important;
  font-size: 14px !important;
  display: inline-block !important;
  visibility: visible !important;
  opacity: 1 !important;
  transition: all 0.3s ease;
  
  &:hover {
    color: #764ba2 !important;
    text-decoration: underline !important;
  }
}

.register-tip {
  text-align: center;
  margin-top: 20px;
  font-size: 14px;
}

.register-link-bold {
  color: #667eea !important;
  text-decoration: none !important;
  font-size: 14px !important;
  font-weight: 600 !important;
  margin-left: 5px;
  transition: all 0.3s ease;
  
  &:hover {
    color: #764ba2 !important;
    text-decoration: underline !important;
  }
}

// 登录按钮
.login-button {
  width: 100%;
  height: 50px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 10px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
  }
  
  &:active {
    transform: translateY(0);
  }
  
  :deep(.el-icon) {
    margin-right: 5px;
  }
}

// 底部信息
.login-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 10;
  text-align: center;
  padding: 20px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;
  
  p {
    margin: 5px 0;
  }
  
  .copyright {
    font-size: 12px;
    opacity: 0.8;
  }
}

// 响应式设计
@media (max-width: 768px) {
  .login-wrapper {
    max-width: 90%;
    padding: 15px;
  }
  
  .login-form {
    padding: 30px 25px;
  }
  
  .login-title {
    font-size: 24px;
  }
  
  .code-input {
    width: 100%;
    margin-bottom: 10px;
  }
  
  .login-code {
    width: 100%;
    float: none;
  }
}
</style>
