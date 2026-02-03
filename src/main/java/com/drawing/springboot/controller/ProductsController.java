package com.drawing.springboot.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.drawing.springboot.dao.ICategoryDAO;
import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dao.ISubcategoryDAO;
import com.drawing.springboot.dto.CategoryDTO;
import com.drawing.springboot.dto.ProductsDTO;
import com.drawing.springboot.dto.SubcategoryDTO;
import com.drawing.springboot.service.ProductsService;

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
    @Autowired
    private ProductsService productsService;

    

    // ✅ 메인 화면: 상위 카테고리 목록
    @GetMapping("/categories")
    public String showCategories(Model model) {
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        model.addAttribute("categories", categories);
        return "guest/main"; // JSP에서 이미지 + 이름 출력
    }

    // 상위 카테고리 → 하위 카테고리 + 상품 목록
    @GetMapping("/categories/{categoryId}")
    public String showCategoryDetail(@PathVariable("categoryId") Long categoryId, Model model) {
        CategoryDTO category = categoryDAO.getCategoryById(categoryId);
        List<SubcategoryDTO> subcategories = subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
        List<ProductsDTO> products = productsDAO.getProductsByCategoryId(categoryId); // 카테고리 기준 상품 조회

        model.addAttribute("category", category);
        model.addAttribute("subcategories", subcategories);
        model.addAttribute("products", products);

        return "guest/products"; // 한 페이지에서 출력
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
    
    // □ CSV 업로드 처리
    @PostMapping("/admin/upload")
    public String uploadCsv(@RequestParam("file") MultipartFile file, Model model) {
        try {
            productsService.importCsv(file);
            model.addAttribute("message", "CSV 업로드 성공!");
        } catch (Exception e) {
            model.addAttribute("message", "CSV 업로드 실패: " + e.getMessage());
        }
        // 업로드 후 다시 admin/products.jsp로 돌아감
        List<ProductsDTO> products = productsDAO.getAllProducts();
        model.addAttribute("products", products);
        return "admin/products";
    }
    
    @GetMapping("/admin/products")
    public String showAllProducts(Model model) {
        List<ProductsDTO> products = productsDAO.getAllProducts();
        model.addAttribute("products", products);
        return "admin/products"; // JSP 파일명
    }

    
    // □ 서브카테고리 상품 조회
    @GetMapping("/subcategories/{subcategoryId}")
    public String showProductsBySubcategory(@PathVariable("subcategoryId") Long subcategoryId, Model model) {
        List<ProductsDTO> products = productsDAO.getProductsBySubcategoryId(subcategoryId);
        SubcategoryDTO subcategory = subcategoryDAO.getSubcategoryById(subcategoryId);
        model.addAttribute("products", products);
        model.addAttribute("subcategory", subcategory);
        return "guest/products"; // 기존 products.jsp 재사용
    }


}
