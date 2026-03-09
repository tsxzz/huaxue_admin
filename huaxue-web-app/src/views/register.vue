<template>
  <div class="register-container">
    <!-- 背景装饰 -->
    <div class="background-decoration">
      <div class="snow-mountain"></div>
      <div class="snow-mountain snow-mountain-2"></div>
      <div class="snowflakes">
        <div class="snowflake" v-for="n in 50" :key="n"></div>
      </div>
    </div>

    <!-- 注册表单 -->
    <div class="register-wrapper">
      <el-form ref="registerRef" :model="registerForm" :rules="registerRules" class="register-form">
        <!-- Logo和标题区域 -->
        <div class="register-header">
          <div class="logo-container">
            <span class="logo-text">⛷</span>
          </div>
          <h1 class="register-title">滑雪场管理系统</h1>
          <p class="register-subtitle">Ski Resort Management System</p>
        </div>

        <!-- 表单内容 -->
        <div class="form-content">
          <el-form-item prop="username">
            <el-input
              v-model="registerForm.username"
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
              v-model="registerForm.password"
              type="password"
              size="large"
              auto-complete="off"
              placeholder="请输入密码"
              class="custom-input"
              @keyup.enter="handleRegister"
            >
              <template #prefix>
                <el-icon class="input-icon"><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="confirmPassword">
            <el-input
              v-model="registerForm.confirmPassword"
              type="password"
              size="large"
              auto-complete="off"
              placeholder="请确认密码"
              class="custom-input"
              @keyup.enter="handleRegister"
            >
              <template #prefix>
                <el-icon class="input-icon"><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="code" v-if="captchaEnabled">
            <el-input
              v-model="registerForm.code"
              size="large"
              auto-complete="off"
              placeholder="验证码"
              class="custom-input code-input"
              @keyup.enter="handleRegister"
            >
              <template #prefix>
                <el-icon class="input-icon"><Key /></el-icon>
              </template>
            </el-input>
            <div class="register-code">
              <img :src="codeUrl" @click="getCode" class="register-code-img" alt="验证码"/>
            </div>
          </el-form-item>

          <el-form-item style="width:100%; margin-top: 20px;">
            <el-button
              :loading="loading"
              size="large"
              type="primary"
              class="register-button"
              @click.prevent="handleRegister"
            >
              <span v-if="!loading">
                <el-icon><Right /></el-icon>
                注 册
              </span>
              <span v-else>注 册 中...</span>
            </el-button>
          </el-form-item>

          <div class="form-options">
            <router-link to="/login" class="login-link">
              使用已有账户登录
            </router-link>
          </div>
        </div>
      </el-form>
    </div>

    <!-- 底部信息 -->
    <div class="register-footer">
      <p>欢迎使用滑雪场管理系统</p>
      <p class="copyright">Copyright © 2024 Ski Resort Management System All Rights Reserved.</p>
    </div>
  </div>
</template>

<script setup>
import { ElMessage, ElMessageBox } from "element-plus";
import { getCodeImg, register } from "@/api/login";
import { User, Lock, Key, Right } from '@element-plus/icons-vue'

const router = useRouter();
const { proxy } = getCurrentInstance();

const registerForm = ref({
  username: "",
  password: "",
  confirmPassword: "",
  code: "",
  uuid: ""
});

const equalToPassword = (rule, value, callback) => {
  if (registerForm.value.password !== value) {
    callback(new Error("两次输入的密码不一致"));
  } else {
    callback();
  }
};

const registerRules = {
  username: [
    { required: true, trigger: "blur", message: "请输入您的账号" },
    { min: 2, max: 20, message: "用户账号长度必须介于 2 和 20 之间", trigger: "blur" }
  ],
  password: [
    { required: true, trigger: "blur", message: "请输入您的密码" },
    { min: 5, max: 20, message: "用户密码长度必须介于 5 和 20 之间", trigger: "blur" },
    { pattern: /^[^<>"'|\\]+$/, message: "不能包含非法字符：< > \" ' \\\ |", trigger: "blur" }
  ],
  confirmPassword: [
    { required: true, trigger: "blur", message: "请再次输入您的密码" },
    { required: true, validator: equalToPassword, trigger: "blur" }
  ],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
};

const codeUrl = ref("");
const loading = ref(false);
const captchaEnabled = ref(true);

function handleRegister() {
  proxy.$refs.registerRef.validate(valid => {
    if (valid) {
      loading.value = true;
      register(registerForm.value).then(res => {
        loading.value = false;
        const username = registerForm.value.username;
        ElMessageBox.alert("恭喜你，您的账号 " + username + " 注册成功！", "系统提示", {
          type: "success",
        }).then(() => {
          router.push("/login");
        }).catch(() => {});
      }).catch((error) => {
        loading.value = false;
        if (captchaEnabled.value) {
          getCode();
        }
      });
    }
  });
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled;
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img;
      registerForm.value.uuid = res.uuid;
    }
  });
}

// 页面加载时获取验证码
getCode();
</script>

<style lang='scss' scoped>
.register-container {
  position: relative;
  width: 100%;
  height: 100vh;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

// 背景装饰
.background-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  z-index: 0;
  
  .snow-mountain {
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 200px;
    background: linear-gradient(to top, rgba(255, 255, 255, 0.3) 0%, transparent 100%);
    clip-path: polygon(0 100%, 20% 60%, 40% 80%, 60% 50%, 80% 70%, 100% 40%, 100% 100%);
    
    &.snow-mountain-2 {
      height: 150px;
      opacity: 0.5;
      clip-path: polygon(0 100%, 15% 70%, 35% 85%, 55% 60%, 75% 75%, 100% 50%, 100% 100%);
    }
  }
  
  .snowflakes {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    overflow: hidden;
    
    .snowflake {
      position: absolute;
      top: -10px;
      color: white;
      font-size: 1em;
      animation: snowfall linear infinite;
      opacity: 0.7;
      
      @for $i from 1 through 50 {
        &:nth-child(#{$i}) {
          left: random(100) * 1%;
          animation-duration: random(10) + 10s;
          animation-delay: random(10) * 0.1s;
          font-size: random(3) + 10px;
        }
      }
    }
  }
}

@keyframes snowfall {
  0% {
    transform: translateY(0) rotate(0deg);
  }
  100% {
    transform: translateY(100vh) rotate(360deg);
  }
}

// 注册表单容器
.register-wrapper {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 450px;
  padding: 20px;
}

.register-form {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  padding: 40px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
}

.register-header {
  text-align: center;
  margin-bottom: 30px;
  
  .logo-container {
    width: 80px;
    height: 80px;
    margin: 0 auto 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 20px;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
    
    .logo-text {
      font-size: 40px;
    }
  }
  
  .register-title {
    margin: 0 0 10px 0;
    font-size: 28px;
    font-weight: 700;
    color: #2c3e50;
  }
  
  .register-subtitle {
    margin: 0;
    font-size: 14px;
    color: #909399;
  }
}

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

.custom-select {
  :deep(.el-input__wrapper) {
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
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

.register-code {
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

.register-code-img {
  width: 100%;
  height: 100%;
  display: block;
}

.form-options {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-top: 20px;
}

.login-link {
  color: #667eea;
  text-decoration: none;
  font-size: 14px;
  transition: all 0.3s ease;
  
  &:hover {
    color: #764ba2;
    text-decoration: underline;
  }
}

.register-button {
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

.register-footer {
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  text-align: center;
  color: rgba(255, 255, 255, 0.8);
  padding: 20px;
  z-index: 1;
  
  p {
    margin: 5px 0;
    font-size: 14px;
  }
  
  .copyright {
    font-size: 12px;
    opacity: 0.7;
  }
}
</style>
