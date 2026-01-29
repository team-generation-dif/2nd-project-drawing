package com.drawing.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dto.ProductsDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/products")
public class ProductsController {

    @Autowired
    private IProductsDAO productsDAO;

    // 상품 목록 (게스트도 볼 수 있음)
    @GetMapping("/subcategories/{subcategoryId}")
    public String products(@PathVariable Long subcategoryId, Model model) {
        List<ProductsDTO> products = productsDAO.getProductsBySubcategoryId(subcategoryId);
        model.addAttribute("products", products);
        return "products"; // products.jsp
    }

    // 상품 클릭 → 로그인 여부 확인 후 외부 이케아 URL로 리다이렉트
    @GetMapping("/{productId}")
    public String productDetail(@PathVariable Long productId, HttpSession session) {
        if (session.getAttribute("role") == null) {
            return "redirect:/member/guest/loginForm?redirect=/products/" + productId;
        }

        ProductsDTO product = productsDAO.getProductById(productId);
        String ikeaUrl = "https://www.ikea.com/kr/ko/p/" + product.getP_code() + "/";
        product.setIkeaUrl(ikeaUrl);

        return "redirect:" + product.getIkeaUrl();
    }

    // 관리자용 상품 등록 폼
    @GetMapping("/admin/new")
    public String newProductForm() {
        return "admin/newProduct"; // JSP 폼
    }

    // 관리자용 상품 등록 처리
    @PostMapping("/admin/new")
    public String createProduct(ProductsDTO product) {
        productsDAO.insertProduct(product);
        return "redirect:/products/subcategories/" + product.getSubcategoryId();
    }
}

