package org.example.springboot.util;

import com.alibaba.fastjson.JSONObject; // 需导入 fastjson 依赖（或用 Jackson）
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;
import java.util.concurrent.TimeUnit;

public class AiUtils {
    // 1. 百度千帆 API 配置（提前定义，避免硬编码）
    private static final String QIANFAN_API_URL = "https://qianfan.baidubce.com/v2/chat/completions";
    private static final String APP_ID = ""; // 替换为真实appid，不能为空
    private static final String AUTHORIZATION = "Bearer bce-v3/ALTAK-ePulGJ1LWcJeJX6IPGRFE/5b57c0ee92c0930ca3a2642a0089f87372ac2050";
    private static final int MAX_INPUT_LENGTH = 500000; // 预留冗余，小于 API 限制的 507904

    // 2. 用 RestTemplate 发送请求（或保留 OkHttpClient，核心是 JSON 生成逻辑）
    private static final RestTemplate restTemplate = new RestTemplate();

    public static String getAiResult(String question) throws Exception {
        // ------------ 关键：参数校验（提前拦截超长问题）------------
        if (question == null || question.trim().isEmpty()) {
            throw new IllegalArgumentException("提问内容不能为空");
        }
        // 计算字符数（注意：API 通常按 UTF-8 字符数计算，直接用 length() 近似判断）
        if (question.length() > MAX_INPUT_LENGTH) {
            throw new IllegalArgumentException("提问内容过长（最大支持50万字），请精简后重试");
        }

        // ------------ 关键：用 JSON 工具生成规范请求体 ------------
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "ernie-speed-pro-128k"); // 模型名确认是否正确

        // 构建 messages 数组（避免字符串拼接错误）
        JSONObject message = new JSONObject();
        message.put("role", "user");
        message.put("content", question.trim()); // 去除首尾空字符，减少无效长度
        requestBody.put("messages", new JSONObject[]{message});

        // ------------ 构建请求头 ------------
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("appid", APP_ID); // 传入真实 appid，不能为空
        headers.set("Authorization", AUTHORIZATION);

        // ------------ 发送请求 ------------
        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody.toString(), headers);
        ResponseEntity<String> response = restTemplate.exchange(
                QIANFAN_API_URL,
                HttpMethod.POST,
                requestEntity,
                String.class
        );

        // 检查响应是否成功
        if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
            return response.getBody();
        } else {
            throw new Exception("百度千帆 API 响应失败：" + response.getStatusCode());
        }
    }
}