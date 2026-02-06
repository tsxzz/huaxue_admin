<template>
  <div class="user-info-head" @click="editCropper()">
    <img :src="options.img" title="点击上传头像" class="img-circle img-lg" />
    <el-dialog :title="title" v-model="open" width="800px" append-to-body @opened="modalOpened" @close="closeDialog">
      <el-row>
        <el-col :xs="24" :md="12" :style="{ height: '350px' }">
          <vue-cropper
            v-if="visible && options.img"
            ref="cropper"
            :img="options.img"
            :info="true"
            :autoCrop="options.autoCrop"
            :autoCropWidth="options.autoCropWidth"
            :autoCropHeight="options.autoCropHeight"
            :fixedBox="options.fixedBox"
            :outputType="options.outputType"
            @realTime="realTime"
          />
        </el-col>
        <el-col :xs="24" :md="12" :style="{ height: '350px' }">
          <div class="avatar-upload-preview">
            <img :src="options.previews.url" :style="options.previews.img" />
          </div>
        </el-col>
      </el-row>
      <br />
      <el-row>
        <el-col :lg="2" :md="2">
          <el-upload
            action="#"
            :http-request="requestUpload"
            :show-file-list="false"
            :before-upload="beforeUpload"
          >
            <el-button>
              选择
              <el-icon class="el-icon--right"><Upload /></el-icon>
            </el-button>
          </el-upload>
        </el-col>
        <el-col :lg="{ span: 1, offset: 2 }" :md="2">
          <el-button icon="Plus" @click="changeScale(1)"></el-button>
        </el-col>
        <el-col :lg="{ span: 1, offset: 1 }" :md="2">
          <el-button icon="Minus" @click="changeScale(-1)"></el-button>
        </el-col>
        <el-col :lg="{ span: 1, offset: 1 }" :md="2">
          <el-button icon="RefreshLeft" @click="rotateLeft()"></el-button>
        </el-col>
        <el-col :lg="{ span: 1, offset: 1 }" :md="2">
          <el-button icon="RefreshRight" @click="rotateRight()"></el-button>
        </el-col>
        <el-col :lg="{ span: 2, offset: 6 }" :md="2">
          <el-button type="primary" @click="uploadImg()">提 交</el-button>
        </el-col>
      </el-row>
    </el-dialog>
  </div>
</template>

<script setup>
import "vue-cropper/dist/index.css";
import { VueCropper } from "vue-cropper";
import { updateUserProfile } from "@/api/system/user";
import useUserStore from "@/store/modules/user";
import request from "@/utils/request";
import { getToken } from "@/utils/auth";
import defAva from "@/assets/images/profile.jpg";

const userStore = useUserStore();
const { proxy } = getCurrentInstance();

const open = ref(false);
const visible = ref(false);
const title = ref("修改头像");

// 获取有效的头像URL
const getValidAvatar = (avatar) => {
  if (!avatar || avatar === '' || avatar === 'null' || avatar === 'undefined') {
    return defAva;
  }
  // 如果已经是完整URL或base64，直接返回
  if (avatar.startsWith('http://') || avatar.startsWith('https://') || avatar.startsWith('data:')) {
    return avatar;
  }
  // 如果是相对路径，拼接baseUrl（修复双斜杠问题）
  const baseUrl = import.meta.env.VITE_APP_BASE_API || '';
  let cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl;
  let cleanAvatar = avatar;
  
  // 确保 avatar 以 / 开头
  if (!cleanAvatar.startsWith('/')) {
    cleanAvatar = '/' + cleanAvatar;
  }
  
  // 去掉开头的多个斜杠，只保留一个
  cleanAvatar = cleanAvatar.replace(/^\/+/, '/');
  
  // 拼接 URL（确保没有双斜杠）
  return cleanBaseUrl + cleanAvatar;
};

//图片裁剪数据
const options = reactive({
  img: getValidAvatar(userStore.avatar),     // 裁剪图片的地址
  autoCrop: true,            // 是否默认生成截图框
  autoCropWidth: 200,        // 默认生成截图框宽度
  autoCropHeight: 200,       // 默认生成截图框高度
  fixedBox: true,            // 固定截图框大小 不允许改变
  outputType: "png",         // 默认生成截图为PNG格式
  filename: 'avatar',        // 文件名称
  previews: {}               //预览数据
});

/** 编辑头像 */
function editCropper() {
  // 确保图片路径有效
  options.img = getValidAvatar(userStore.avatar);
  open.value = true;
}
/** 打开弹出层结束时的回调 */
function modalOpened() {
  // 确保图片路径有效
  options.img = getValidAvatar(userStore.avatar);
  // 延迟设置visible，确保对话框完全打开后再初始化cropper
  setTimeout(() => {
    visible.value = true;
  }, 100);
}

/** 图片加载完成 */
function imgLoad(msg) {
  console.log('图片加载完成', msg);
}

/** Cropper准备就绪 */
function cropperReady() {
  console.log('Cropper准备就绪');
}
/** 覆盖默认上传行为 */
function requestUpload() {}
/** 向左旋转 */
function rotateLeft() {
  proxy.$refs.cropper.rotateLeft();
}
/** 向右旋转 */
function rotateRight() {
  proxy.$refs.cropper.rotateRight();
}
/** 图片缩放 */
function changeScale(num) {
  num = num || 1;
  proxy.$refs.cropper.changeScale(num);
}
/** 上传预处理 */
function beforeUpload(file) {
  if (file.type.indexOf("image/") == -1) {
    proxy.$modal.msgError("文件格式错误，请上传图片类型,如：JPG，PNG后缀的文件。");
  } else {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = () => {
      options.img = reader.result;
      options.filename = file.name;
    };
  }
}
/** 上传图片 */
function uploadImg() {
  proxy.$refs.cropper.getCropBlob(data => {
    proxy.$modal.loading("正在上传头像，请稍候...");
    
    // 使用通用的上传服务
    let formData = new FormData();
    formData.append("file", data, options.filename);
    
    const baseUrl = import.meta.env.VITE_APP_BASE_API || '';
    const uploadUrl = baseUrl.endsWith('/') ? baseUrl + 'common/upload' : baseUrl + '/common/upload';
    
    request({
      url: uploadUrl,
      method: 'post',
      data: formData,
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer ' + getToken()
      }
    }).then(response => {
      if (response.code === 200) {
        // 获取上传后的文件路径
        const avatarPath = response.fileName || response.url;
        
        // 处理路径：确保路径格式正确（去掉双斜杠）
        let cleanPath = avatarPath;
        if (cleanPath && cleanPath.startsWith('/')) {
          cleanPath = cleanPath.replace(/^\/+/, '/'); // 去掉开头的多个斜杠，只保留一个
        }
        
        // 构建完整的URL（修复双斜杠问题）
        let cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.slice(0, -1) : baseUrl;
        let avatarUrl = cleanBaseUrl + cleanPath;
        
        // 更新用户头像（使用相对路径保存到数据库，确保以 / 开头）
        // 后端返回的 fileName 已经是 /profile/upload/... 格式，直接使用
        const avatarToSave = cleanPath;
        updateUserProfile({ avatar: avatarToSave }).then(updateResponse => {
          if (updateResponse.code === 200) {
            // 先更新本地显示
            options.img = avatarUrl;
            userStore.avatar = avatarUrl;
            
            // 然后刷新用户信息，确保从后端获取最新数据
            userStore.getInfo().then(() => {
              proxy.$modal.closeLoading();
              // 使用刷新后的头像URL
              const finalAvatar = getValidAvatar(userStore.avatar);
              userStore.avatar = finalAvatar;
              options.img = finalAvatar;
              
              proxy.$modal.msgSuccess("修改成功");
              open.value = false;
              visible.value = false;
            }).catch(() => {
              proxy.$modal.closeLoading();
              // 即使刷新失败，也使用已上传的头像
              proxy.$modal.msgSuccess("修改成功");
              open.value = false;
              visible.value = false;
            });
          } else {
            proxy.$modal.closeLoading();
            proxy.$modal.msgError(updateResponse.msg || "更新头像失败");
          }
        }).catch(error => {
          proxy.$modal.closeLoading();
          proxy.$modal.msgError("更新头像失败");
        });
      } else {
        proxy.$modal.closeLoading();
        proxy.$modal.msgError(response.msg || "上传失败");
      }
    }).catch(error => {
      proxy.$modal.closeLoading();
      proxy.$modal.msgError("上传失败，请重试");
    });
  });
}
/** 实时预览 */
function realTime(data) {
  options.previews = data;
}
/** 关闭窗口 */
function closeDialog() {
  options.img = getValidAvatar(userStore.avatar);
  visible.value = false;
}
</script>

<style lang='scss' scoped>
.user-info-head {
  position: relative;
  display: inline-block;
  height: 120px;
}

.user-info-head:hover:after {
  content: "+";
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  color: #eee;
  background: rgba(0, 0, 0, 0.5);
  font-size: 24px;
  font-style: normal;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  cursor: pointer;
  line-height: 110px;
  border-radius: 50%;
}
</style>