package com.megamart.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.entity.TagEntity;

@Repository("tagDao")
public class TagDao extends CommonDAO {

	public int deleteTag(TagEntity tagentity){
		return (int)super.delete("common.tag.deleteTag", tagentity);
	}
	
	public int insertTag(TagEntity tagentity){
		return (int)super.insert("common.tag.insertTag", tagentity);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectTagList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.tag.selectTag", map);
	}
}
