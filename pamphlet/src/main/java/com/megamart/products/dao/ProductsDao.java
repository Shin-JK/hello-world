package com.megamart.products.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.dao.CommonDAO;
import com.megamart.pamphlet.entity.PamphletEntity;
import com.megamart.products.entity.ProductsEntity;

@Repository("productsDao")
public class ProductsDao extends CommonDAO {

	public int insertProducts(ProductsEntity entity){
		return (int)insert("products.insertProduct", entity);
	}
	
	public int updateProducts(ProductsEntity entity){
		return (int)insert("products.updateProduct", entity);
	}
	
	public int deleteProduct(int idx){
		return (int)delete("products.deleteProduct", idx);
	}
	
	public int selectNewId(){
		return (int)selectOne("products.selectNewId");
	}
	
	public int selectProductsTotalCnt(Map<String, Object> map){
		return (int)selectOne("products.selectProductTotalCnt", map);
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectProductsList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("products.selectProductList", map);
	}
	
	public int selectProductsTotalCntbyTag(Map<String, Object> map){
		return (int)selectOne("products.selectProductTotalCntbyTag", map);
	}
	
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectProductsListbyTag(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("products.selectProductListbyTag", map);
	}
	
	public ProductsEntity selectProductsDetail(int idx){
		return (ProductsEntity)selectOne("products.selectProductDetail", idx);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectCategories(Map<String, String> map){
		return (List<Map<String, Object>>)selectList("common.category.selectproduct_hierarchy", map);
	}
}
