package com.megamart.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.megamart.common.dao.TagDao;

@Service("tagService")
public class TagService {

	@Resource(name="tagDao")
	private TagDao tagdao;
	
	public List<Map<String, Object>>selectTagList(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);
		return tagdao.selectTagList(map);
	}
}
