package com.drawing.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.drawing.springboot.dao.ICategoryDAO;
import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dao.ISubcategoryDAO;
import com.drawing.springboot.dto.CategoryDTO;
import com.drawing.springboot.dto.ProductsDTO;
import com.drawing.springboot.dto.SubcategoryDTO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/products")
public class ProductsController {

    @Autowired
    private IProductsDAO productsDAO;
    @Autowired
    private ICategoryDAO categoryDAO;
    @Autowired
    private ISubcategoryDAO subcategoryDAO;

    // ✅ 메인 화면: 상위 카테고리 목록
    @GetMapping("/categories")
    public String showCategories(Model model) {
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        model.addAttribute("categories", categories);
        return "guest/main"; // JSP에서 이미지 + 이름 출력
    }

    // ✅ 상위 카테고리 클릭 → 하위 서브카테고리 목록
    @GetMapping("/categories/{categoryId}")
    public String showSubcategories(@PathVariable Long categoryId, Model model) {
        CategoryDTO category = categoryDAO.getCategoryById(categoryId);
        model.addAttribute("category", category);

        List<SubcategoryDTO> subcategories = subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
        model.addAttribute("subcategories", subcategories);

        return "guest/subcategories"; // JSP에서 서브카테고리 출력
    }

    // ✅ 서브카테고리 클릭 → 상품 목록
    @GetMapping("/subcategories/{subcategoryId}")
    public String products(@PathVariable Long subcategoryId, Model model) {
        List<ProductsDTO> products = productsDAO.getProductsBySubcategoryId(subcategoryId);
        model.addAttribute("products", products);
        return "guest/products"; // JSP에서 상품 목록 출력
    }

    // ✅ 상품 클릭 → 로그인 여부 확인 후 IKEA URL로 리다이렉트
    @GetMapping("/{productId}")
    public String productDetail(@PathVariable Long productId, HttpSession session) {
        if (session.getAttribute("role") == null) {
            return "redirect:/guest/loginForm?redirect=/products/" + productId;
        }

        ProductsDTO product = productsDAO.getProductById(productId);
        String ikeaUrl = "https://www.ikea.com/kr/ko/p/" + product.getP_code() + "/";
        return "redirect:" + ikeaUrl;
    }

    // ✅ 관리자 상품 등록 폼
    @GetMapping("/admin/new")
    public String newProductForm() {
        return "admin/newproducts";
    }

    // ✅ 관리자 상품 등록 처리
    @PostMapping("/admin/new")
    public String createProduct(ProductsDTO product) {
        productsDAO.insertProduct(product);
        return "redirect:/products/subcategories/" + product.getSubcategoryId();
    }
}
