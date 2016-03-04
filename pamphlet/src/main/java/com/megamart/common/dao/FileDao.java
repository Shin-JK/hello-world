package com.megamart.common.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.megamart.common.entity.AttachFileEntity;

@Repository("fileDao")
public class FileDao extends CommonDAO{

	public int insertFile(AttachFileEntity fileentity){
		return (int)super.insert("common.file.insertFile", fileentity);
	}
	
	public int deleteFile(AttachFileEntity fileentity){
		return (int)super.delete("common.file.deleteFile", fileentity);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectImageFileList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.file.selectImageFile", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectPdfFileList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.file.selectPdfFile", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> selectEtcFileList(Map<String, Object> map){
		return (List<Map<String, Object>>)selectList("common.file.selectEtcFile", map);
	}
}
