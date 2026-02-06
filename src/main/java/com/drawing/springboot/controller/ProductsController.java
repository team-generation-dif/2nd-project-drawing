package com.drawing.springboot.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.drawing.springboot.dao.ICategoryDAO;
import com.drawing.springboot.dao.IProductsDAO;
import com.drawing.springboot.dao.ISubcategoryDAO;
import com.drawing.springboot.dto.CategoryDTO;
import com.drawing.springboot.dto.ProductsDTO;
import com.drawing.springboot.dto.SubcategoryDTO;
import com.drawing.springboot.service.FavoritesService;
import com.drawing.springboot.service.ProductsESService;
import com.drawing.springboot.service.ProductsService;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/products")
public class ProductsController {

    @Autowired private IProductsDAO productsDAO;
    @Autowired private ICategoryDAO categoryDAO;
    @Autowired private ISubcategoryDAO subcategoryDAO;
    @Autowired private ProductsService productsService;
    @Autowired private FavoritesService favoritesService;
    @Autowired private ProductsESService ESService;

    // 카테고리 목록 (메인)
    @GetMapping("/categories")
    public String showCategories(Model model) {
        List<CategoryDTO> categories = categoryDAO.getAllCategories();
        model.addAttribute("categories", categories);
        return "guest/main";
    }

    // [중요] 카테고리 상세 (페이징 적용)
    @GetMapping("/categories/{categoryId}")
    public String showCategoryDetail(
            @PathVariable("categoryId") Long categoryId, 
            @RequestParam(name = "page", defaultValue = "1") int page, 
            Model model) {
        
        int size = 12; 
        int offset = (page - 1) * size;

        CategoryDTO category = categoryDAO.getCategoryById(categoryId);
        List<SubcategoryDTO> subcategories = subcategoryDAO.getSubcategoriesByCategoryId(categoryId);
        List<ProductsDTO> products = productsDAO.getProductsByCategoryIdPaged(categoryId, size, offset);
        
        int totalCount = productsDAO.countProductsByCategoryId(categoryId);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("category", category);
        model.addAttribute("subcategories", subcategories);
        model.addAttribute("products", products);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);

        return "guest/products";
    }

    // [중요] 서브카테고리 상세 (페이징 적용 - 중복 제거됨)
    @GetMapping("/subcategories/{subcategoryId}")
    public String showProductsBySubcategory(
            @PathVariable("subcategoryId") Long subcategoryId, 
            @RequestParam(name = "page", defaultValue = "1") int page, 
            Model model) {
        
        int size = 12; 
        int offset = (page - 1) * size;

        SubcategoryDTO subcategory = subcategoryDAO.getSubcategoryById(subcategoryId);
        List<ProductsDTO> products = productsDAO.getProductsBySubcategoryIdPaged(subcategoryId, size, offset);
        
        int totalCount = productsDAO.countProductsBySubcategoryId(subcategoryId);
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("products", products);
        model.addAttribute("subcategory", subcategory);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        
        return "guest/products";
    }

    // 검색 (엘라스틱서치)
    @RequestMapping("/search")
    public String searchbox(@RequestParam("keyword") String keyword, Model model) throws Exception {
        List<ProductsDTO> products = ESService.search(keyword);
        model.addAttribute("products", products);
        return "guest/products";
    }
    
    // 상품 상세 리다이렉트
    @GetMapping("/{productId}")
    public String productDetail(@PathVariable("productId") Long p_code, HttpSession session) {
        if (session.getAttribute("role") == null) {
            return "redirect:/guest/loginForm?redirect=/products/" + p_code;
        }
        ProductsDTO productsDTO = productsDAO.getProductById(p_code);
        String ikeaUrl = "https://www.ikea.com/kr/ko/p/" + productsDTO.getP_code() + "/";
        return "redirect:" + ikeaUrl;
    }

    // --- 관리자 기능 ---
    @GetMapping("/admin/new")
    public String newProductForm(Model model) {
        model.addAttribute("product", new ProductsDTO());
        model.addAttribute("categories", categoryDAO.getAllCategories());
        model.addAttribute("subcategories", subcategoryDAO.getAllSubcategories());
        return "admin/newproducts";
    }

    @PostMapping("/admin/new")
    public String createProduct(ProductsDTO product, Model model) {
        if (productsService.existsByName(product.getP_name())) {
            model.addAttribute("errorMessage", "이미 존재하는 상품명입니다.");
            return "admin/newproducts";
        }
        productsService.insertProduct(product);
        return "redirect:/products/admin/list";
    }

    @GetMapping("/admin/edit/{p_code}")
    public String editProductForm(@PathVariable("p_code") int p_code, Model model) {
        ProductsDTO product = productsDAO.getProductById((long)p_code);
        model.addAttribute("product", product);
        model.addAttribute("categories", categoryDAO.getAllCategories());
        model.addAttribute("subcategories", subcategoryDAO.getAllSubcategories());
        return "admin/editproduct";
    }

    @PostMapping("/admin/update")
    public String updateProduct(ProductsDTO product) {
        productsDAO.updateProduct(product);
        return "redirect:/products/admin/list";
    }

    @GetMapping("/admin/delete/{p_code}")
    public String deleteProduct(@PathVariable("p_code") int p_code) {
        productsDAO.deleteProduct(p_code);
        return "redirect:/products/admin/list";
    }

    @PostMapping("/admin/upload")
    public String uploadCsv(@RequestParam("file") MultipartFile file, Model model) {
        try {
            productsService.importCsv(file);
            model.addAttribute("message", "CSV 업로드 성공!");
        } catch (Exception e) {
            model.addAttribute("errorMessage", "CSV 업로드 실패: " + e.getMessage());
        }
        return "admin/products";
    }

    @GetMapping("/admin/upload-page")
    public String showUploadPage() {
        return "admin/products";
    }

    @GetMapping("/admin/list")
    public String listProducts(@RequestParam(name = "page", defaultValue = "1") int page,
                               @RequestParam(name = "size", defaultValue = "10") int size,
                               Model model) {
        int offset = (page - 1) * size;
        List<ProductsDTO> products = productsDAO.getProductsPaged(size, offset);
        int totalCount = productsDAO.countProducts();
        int totalPages = (int) Math.ceil((double) totalCount / size);

        model.addAttribute("products", products);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("size", size);

        return "admin/products_list";
    }

    // --- 찜 기능 ---
    @PostMapping("/favorites/add")
    public String addFavorite(@RequestParam("p_code") int p_code, HttpSession session) {
        String m_code = (String) session.getAttribute("m_code");
        if (m_code == null) return "redirect:/guest/loginForm";
        favoritesService.addFavorite(m_code, p_code);
        return "redirect:/products/favorites";
    }

    @PostMapping("/favorites/remove")
    public String removeFavorite(@RequestParam("p_code") int p_code, HttpSession session) {
        String m_code = (String) session.getAttribute("m_code");
        if (m_code == null) return "redirect:/guest/loginForm";
        favoritesService.removeFavorite(m_code, p_code);
        return "redirect:/products/favorites";
    }

    @GetMapping("/favorites")
    public String favoritesPage(@RequestParam(value = "subcategoryId", required = false) Integer subcategoryId,
                                HttpSession session, Model model) {
        String m_code = (String) session.getAttribute("m_code");
        if (m_code == null) return "redirect:/guest/loginForm";

        List<ProductsDTO> favorites;
        if (subcategoryId != null) {
            favorites = favoritesService.getFavoritesByCategory(m_code, subcategoryId);
        } else {
            favorites = favoritesService.getFavoritesByMember(m_code);
        }

        model.addAttribute("favorites", favorites);
        return "user/favorites";
    }
}