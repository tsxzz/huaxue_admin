package com.ruoyi.web.controller.common;

import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.file.FileUploadUtils;
import com.ruoyi.common.utils.file.FileUtils;
import com.ruoyi.framework.config.ServerConfig;

/**
 * 通用请求处理
 * 
 * @author ruoyi
 */
@RestController
@RequestMapping("/common")
public class CommonController
{
    private static final Logger log = LoggerFactory.getLogger(CommonController.class);

    @Autowired
    private ServerConfig serverConfig;

    private static final String FILE_DELIMITER = ",";

    /**
     * 通用下载请求
     * 
     * @param fileName 文件名称
     * @param delete 是否删除
     */
    @GetMapping("/download")
    public void fileDownload(String fileName, Boolean delete, HttpServletResponse response, HttpServletRequest request)
    {
        try
        {
            if (!FileUtils.checkAllowDownload(fileName))
            {
                throw new Exception(StringUtils.format("文件名称({})非法，不允许下载。 ", fileName));
            }
            String realFileName = System.currentTimeMillis() + fileName.substring(fileName.indexOf("_") + 1);
            String filePath = RuoYiConfig.getDownloadPath() + fileName;

            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, realFileName);
            FileUtils.writeBytes(filePath, response.getOutputStream());
            if (delete)
            {
                FileUtils.deleteFile(filePath);
            }
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }

    /**
     * 通用上传请求（单个）
     */
    @PostMapping("/upload")
    public AjaxResult uploadFile(MultipartFile file) throws Exception
    {
        System.out.println("========== 文件上传开始 ==========");
        System.out.println("原始文件名：" + (file != null ? file.getOriginalFilename() : "null"));
        System.out.println("文件大小：" + (file != null ? file.getSize() : "null"));
        
        try
        {
            // 上传文件路径
            String filePath = RuoYiConfig.getUploadPath();
            System.out.println("上传路径：" + filePath);
            
            // 检查上传目录是否存在，如果不存在则创建
            java.io.File uploadDir = new java.io.File(filePath);
            if (!uploadDir.exists())
            {
                boolean created = uploadDir.mkdirs();
                System.out.println("创建上传目录：" + filePath + "，结果：" + created);
                if (!created && !uploadDir.exists())
                {
                    throw new Exception("无法创建上传目录: " + filePath);
                }
            }
            
            // 上传并返回新文件名称
            String fileName = FileUploadUtils.upload(filePath, file);
            System.out.println("上传成功，返回的文件名：" + fileName);
            
            // 修复URL拼接时的双斜杠问题
            String baseUrl = serverConfig.getUrl();
            if (baseUrl.endsWith("/") && fileName.startsWith("/")) {
                baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
            } else if (!baseUrl.endsWith("/") && !fileName.startsWith("/")) {
                baseUrl = baseUrl + "/";
            }
            String url = baseUrl + fileName;
            System.out.println("完整URL：" + url);
            
            AjaxResult ajax = AjaxResult.success();
            ajax.put("url", url);
            ajax.put("fileName", fileName);
            ajax.put("newFileName", FileUtils.getName(fileName));
            ajax.put("originalFilename", file.getOriginalFilename());
            
            System.out.println("========== 文件上传成功 ==========");
            return ajax;
        }
        catch (Exception e)
        {
            System.out.println("========== 文件上传异常 ==========");
            System.out.println("异常类型：" + e.getClass().getName());
            System.out.println("异常信息：" + e.getMessage());
            e.printStackTrace();
            
            log.error("文件上传失败", e);
            
            // 返回更友好的错误信息，而不是直接返回异常信息（可能包含本地路径）
            String errorMsg = "文件上传失败";
            if (e.getMessage() != null && !e.getMessage().contains("\\") && !e.getMessage().matches("^[A-Za-z]:.*")) {
                // 如果异常信息不包含本地路径，则使用异常信息
                errorMsg = e.getMessage();
            }
            return AjaxResult.error(errorMsg);
        }
    }

    /**
     * 通用上传请求（多个）
     */
    @PostMapping("/uploads")
    public AjaxResult uploadFiles(List<MultipartFile> files) throws Exception
    {
        try
        {
            // 上传文件路径
            String filePath = RuoYiConfig.getUploadPath();
            List<String> urls = new ArrayList<String>();
            List<String> fileNames = new ArrayList<String>();
            List<String> newFileNames = new ArrayList<String>();
            List<String> originalFilenames = new ArrayList<String>();
            for (MultipartFile file : files)
            {
                // 上传并返回新文件名称
                String fileName = FileUploadUtils.upload(filePath, file);
                // 修复URL拼接时的双斜杠问题
                String baseUrl = serverConfig.getUrl();
                if (baseUrl.endsWith("/") && fileName.startsWith("/")) {
                    baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
                } else if (!baseUrl.endsWith("/") && !fileName.startsWith("/")) {
                    baseUrl = baseUrl + "/";
                }
                String url = baseUrl + fileName;
                urls.add(url);
                fileNames.add(fileName);
                newFileNames.add(FileUtils.getName(fileName));
                originalFilenames.add(file.getOriginalFilename());
            }
            AjaxResult ajax = AjaxResult.success();
            ajax.put("urls", StringUtils.join(urls, FILE_DELIMITER));
            ajax.put("fileNames", StringUtils.join(fileNames, FILE_DELIMITER));
            ajax.put("newFileNames", StringUtils.join(newFileNames, FILE_DELIMITER));
            ajax.put("originalFilenames", StringUtils.join(originalFilenames, FILE_DELIMITER));
            return ajax;
        }
        catch (Exception e)
        {
            return AjaxResult.error(e.getMessage());
        }
    }

    /**
     * 本地资源通用下载
     */
    @GetMapping("/download/resource")
    public void resourceDownload(String resource, HttpServletRequest request, HttpServletResponse response)
            throws Exception
    {
        try
        {
            if (!FileUtils.checkAllowDownload(resource))
            {
                throw new Exception(StringUtils.format("资源文件({})非法，不允许下载。 ", resource));
            }
            // 本地资源路径
            String localPath = RuoYiConfig.getProfile();
            // 数据库资源地址
            String downloadPath = localPath + FileUtils.stripPrefix(resource);
            // 下载名称
            String downloadName = StringUtils.substringAfterLast(downloadPath, "/");
            response.setContentType(MediaType.APPLICATION_OCTET_STREAM_VALUE);
            FileUtils.setAttachmentResponseHeader(response, downloadName);
            FileUtils.writeBytes(downloadPath, response.getOutputStream());
        }
        catch (Exception e)
        {
            log.error("下载文件失败", e);
        }
    }
}
