package com.megamart.common.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.megamart.common.aws.AwsMethods;
import com.megamart.common.dao.FileDao;

@Service("fileService")
public class FileService {
	
	@Resource(name="fileDao")
	private FileDao filedao;
	
	public List<Map<String, Object>>selectImageFileList(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);
		
		List<Map<String, Object>> tmplist = filedao.selectImageFileList(map);
		for(int i=0; i<tmplist.size(); i++){
			tmplist.get(i).put("url", AwsMethods.getPreSignedURL(category_flag, tmplist.get(i).get("s3_file_name").toString()));
			tmplist.get(i).put("thumbmurl", AwsMethods.getPreSignedThumbMURL(category_flag, tmplist.get(i).get("s3_file_name").toString()));
			tmplist.get(i).put("thumbsurl", AwsMethods.getPreSignedThumbSURL(category_flag, tmplist.get(i).get("s3_file_name").toString()));
		}
		return tmplist;
	}
	
	public List<Map<String, Object>>selectPdfFileList(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);
		
		List<Map<String, Object>> tmplist = filedao.selectPdfFileList(map);
		for(int i=0; i<tmplist.size(); i++){
			tmplist.get(i).put("url", AwsMethods.getPreSignedURL(category_flag, tmplist.get(i).get("s3_file_name").toString()));
		}
		return tmplist;
	}
	
	public List<Map<String, Object>>selectEtcFileList(String category_flag, int category_idx){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("category_flag", category_flag);
		map.put("category_idx", category_idx);
		
		List<Map<String, Object>> tmplist = filedao.selectEtcFileList(map);
		for(int i=0; i<tmplist.size(); i++){
			tmplist.get(i).put("url", AwsMethods.getPreSignedURL(category_flag, tmplist.get(i).get("s3_file_name").toString()));
		}
		return tmplist;
	}
}
