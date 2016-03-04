package com.megamart.products.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.megamart.common.dao.FileDao;
import com.megamart.common.dao.TagDao;
import com.megamart.common.entity.AttachFileEntity;
import com.megamart.common.entity.TagEntity;
import com.megamart.pamphlet.entity.PamphletEntity;
import com.megamart.products.dao.ProductsDao;
import com.megamart.products.entity.ProductsEntity;

@Transactional
@Service("productsService")
public class ProductsService {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="productsDao")
	private ProductsDao productsdao;
	
	@Resource(name="tagDao")
	private TagDao tagdao;
	
	@Resource(name="fileDao")
	private FileDao filedao;
	
	public int selectProductsTotalCnt(String key, String keyword){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("key", key); 
		map.put(key, keyword);
		
		return key.equals("tag") && keyword !=null && keyword.length() > 0 ? productsdao.selectProductsTotalCntbyTag(map) : productsdao.selectProductsTotalCnt(map);
	}
	
	public List<Map<String, Object>> selectProductsList(String key, String keyword, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("key", key); 
		map.put(key, keyword);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		return key.equals("tag") && keyword !=null && keyword.length() > 0 ? productsdao.selectProductsListbyTag(map) : productsdao.selectProductsList(map);
	}
	
	public ProductsEntity selectProductsDetail(int idx){
		return productsdao.selectProductsDetail(idx);
	}

	public int saveProducts(String irud_flag, ProductsEntity productsentity, ArrayList<TagEntity> taglist, ArrayList<AttachFileEntity> filelist){
		try {
			switch (irud_flag) {
			case "NEW":
				int newid = productsdao.selectNewId();
				productsentity.setIdx(newid);
				
				productsdao.insertProducts(productsentity);
				
				for(int i=0; i<taglist.size(); i++){
					taglist.get(i).setCategory_idx(newid);
					tagdao.insertTag(taglist.get(i));
				}
				
				for(int j=0; j<filelist.size(); j++){
					filelist.get(j).setCategory_idx(newid);
					filedao.insertFile(filelist.get(j));
				}
				break;
			case "UPDATE":
				TagEntity tmpentity = new TagEntity();
				tmpentity.setCategory_flag("PD");
				tmpentity.setCategory_idx(productsentity.getIdx());
				
				AttachFileEntity tmpfileentity = new AttachFileEntity();
				tmpfileentity.setCategory_flag("PD");
				tmpfileentity.setCategory_idx(productsentity.getIdx());
				
				productsdao.updateProducts(productsentity);				
				tagdao.deleteTag(tmpentity);
				filedao.deleteFile(tmpfileentity);
				
				for(int i=0; i<taglist.size(); i++){
					taglist.get(i).setCategory_idx(productsentity.getIdx());
					tagdao.insertTag(taglist.get(i));
				}
				
				for(int j=0; j<filelist.size(); j++){
					filelist.get(j).setCategory_idx(productsentity.getIdx());
					filedao.insertFile(filelist.get(j));
				}
				break;
			case "DELETE":
				
				break;
			}
			return 1;	
		} catch (Exception e) {
			log.error("팜플렛 저장 오류 :" + e.getMessage());
			return -1;
		}
	}
	
	public List<Map<String, Object>> selectCategories(String category_group_id){
		Map<String, String> map = new HashMap<String, String>();
		map.put("category_group_id", category_group_id);
		List<Map<String, Object>> list = productsdao.selectCategories(map);
		if(list.size() > 0) {
			Map<String, Object> tmpmap = new HashMap<String, Object>();
			tmpmap.put("category_id", "--");
			tmpmap.put("category_name", "선택");
			list.add(0, tmpmap);
		}
		return  list;
	}
}
