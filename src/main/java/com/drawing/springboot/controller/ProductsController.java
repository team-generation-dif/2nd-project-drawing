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
import com.drawing.springboot.service.FavoritesService;
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
    @Autowired
    private FavoritesService favoritesService;
    

    // 카테고리 목록
    @GetMapping("/categories")
    public String showCategories(Model model) {
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        model.addAttribute("categories", categories);
        return "guest/main";
    }

    // 카테고리 상세
    @GetMapping("/categories/{categoryId}")
    public String showCategoryDetail(@PathVariable("categoryId") Long categoryId, Model model) {
        CategoryDTO category = categoryDAO.getCategoryById(categoryId);
        List<SubcategoryDTO> subcategories = subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
        List<ProductsDTO> products = productsDAO.getProductsByCategoryId(categoryId);

        model.addAttribute("category", category);
        model.addAttribute("subcategories", subcategories);
        model.addAttribute("products", products);

        return "guest/products";
    }

    // 상품 상세 (로그인 체크 후 IKEA URL로 리다이렉트)
    @GetMapping("/{productId}")
    public String productDetail(@PathVariable Long p_code, HttpSession session) {
        if (session.getAttribute("role") == null) {
            return "redirect:/guest/loginForm?redirect=/products/" + p_code;
        }
        ProductsDTO productsDTO = productsDAO.getProductById(p_code);
        String ikeaUrl = "https://www.ikea.com/kr/ko/p/" + productsDTO.getP_code() + "/";
        return "redirect:" + ikeaUrl;
    }

    // 관리자 상품 등록 폼
    @GetMapping("/admin/new")
    public String newProductForm(Model model) {
    	model.addAttribute("product", new ProductsDTO());
    	model.addAttribute("categories", categoryDAO.getAllCategories()); // ✅ 상위 카테고리
    	model.addAttribute("subcategories", subcategoryDAO.getAllSubcategories()); // ✅ 서브카테고리
    	return "admin/newproducts";
    }

    // 관리자 상품 등록 처리
    @PostMapping("/admin/new")
    public String createProduct(ProductsDTO product) {
        productsDAO.insertProduct(product);
        return "redirect:/products/admin/products";
    }


    // 관리자 상품 수정 폼
    @GetMapping("/admin/edit/{p_code}")
    public String editProductForm(@PathVariable("p_code") int p_code, Model model) {
        ProductsDTO product = productsDAO.getProductById((long)p_code);
        model.addAttribute("product", product);
        return "admin/editproduct";
    }

    // 관리자 상품 수정 처리
    @PostMapping("/admin/edit")
    public String updateProduct(ProductsDTO product) {
        productsDAO.updateProduct(product);
        return "redirect:/products/admin/products";
    }

    // 관리자 상품 삭제
    @GetMapping("/admin/delete/{p_code}")
    public String deleteProduct(@PathVariable("p_code") int p_code) {
        productsDAO.deleteProduct(p_code);
        return "redirect:/products/admin/products";
    }

    // CSV 업로드 처리
    @PostMapping("/admin/upload")
    public String uploadCsv(@RequestParam("file") MultipartFile file, Model model) {
        try {
            productsService.importCsv(file);
            model.addAttribute("message", "CSV 업로드 성공!");
        } catch (Exception e) {
            model.addAttribute("message", "CSV 업로드 실패: " + e.getMessage());
        }
        List<ProductsDTO> products = productsDAO.getAllProducts();
        model.addAttribute("products", products);
        return "admin/products";
    }

    // 관리자 상품 전체 조회
    @GetMapping("/admin/products")
    public String showAllProducts(Model model) {
        List<ProductsDTO> products = productsDAO.getAllProducts();
        model.addAttribute("products", products);
        return "admin/products";
    }

    // 서브카테고리 상품 조회
    @GetMapping("/subcategories/{subcategoryId}")
    public String showProductsBySubcategory(@PathVariable("subcategoryId") Long subcategoryId, Model model) {
        List<ProductsDTO> products = productsDAO.getProductsBySubcategoryId(subcategoryId);
        SubcategoryDTO subcategory = subcategoryDAO.getSubcategoryById(subcategoryId);
        model.addAttribute("products", products);
        model.addAttribute("subcategory", subcategory);
        return "guest/products";
    }
    
    // 찜 추가
    @PostMapping("/favorites/add")
    public String addFavorite(@RequestParam("p_code") int p_code, HttpSession session) {
        String m_code = (String) session.getAttribute("m_code");
        System.out.println("찜 추가 요청 - 세션 m_code = " + m_code); // ✅ 로그 찍기
        System.out.println("찜 추가 요청 - 상품 코드 = " + p_code);

        if (m_code == null) {
            return "redirect:/guest/loginForm";
        }
        favoritesService.addFavorite(m_code, p_code);
        return "redirect:/products/favorites";
    }

    // 찜 삭제
    @PostMapping("/favorites/remove")
    public String removeFavorite(@RequestParam("p_code") int p_code, HttpSession session) {
        String m_code = (String) session.getAttribute("m_code");
        System.out.println("찜 삭제 요청 - 세션 m_code = " + m_code); // ✅ 로그 찍기
        System.out.println("찜 삭제 요청 - 상품 코드 = " + p_code);

        if (m_code == null) {
            return "redirect:/guest/loginForm";
        }
        favoritesService.removeFavorite(m_code, p_code);
        return "redirect:/products/favorites";
    }

    // 찜 목록 조회
    @GetMapping("/favorites")
    public String favoritesPage(HttpSession session, Model model) {
        String m_code = (String) session.getAttribute("m_code");
        System.out.println("찜 목록 조회 - 세션 m_code = " + m_code); // ✅ 로그 찍기

        if (m_code == null) {
        	return "redirect:/products/favorites"; // 앞에 /products/ 가 반드시 붙어있어야 함
        }

        List<ProductsDTO> favorites = favoritesService.getFavoritesByMember(m_code);
        System.out.println("찜 목록 조회 - 결과 개수 = " + favorites.size()); // ✅ 로그 찍기
        for (ProductsDTO product : favorites) {
            System.out.println("찜 상품: " + product.getP_code() + " / " + product.getP_name());
        }

        model.addAttribute("favorites", favorites);
        return "user/favorites";
    }





}

