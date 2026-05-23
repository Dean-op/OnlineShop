package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.example.springboot.common.Result;
import org.example.springboot.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "AI 大模型接口（针对用户）")
@RestController
@RequestMapping("/Ai")
public class AiController {

    @Autowired
    private ProductService productService;

    @Operation(summary = "根据用户行为和问题进行回答")
    @GetMapping("rep")
    public String getAiResponse(@RequestParam String question) throws Exception {
        return productService.getAiResponse(question);
    }
}
