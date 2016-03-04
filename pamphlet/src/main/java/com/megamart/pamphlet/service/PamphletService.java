package com.megamart.pamphlet.service;

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
import com.megamart.pamphlet.dao.PamphletDao;
import com.megamart.pamphlet.entity.PamphletEntity;

@Transactional
@Service("pamphletService")
public class PamphletService {
	Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="pamphletDao")
	private PamphletDao pamphletdao;
	
	@Resource(name="tagDao")
	private TagDao tagdao;
	
	@Resource(name="fileDao")
	private FileDao filedao;
	
	public int selectPamphletTotalCnt(String key, String keyword){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("key", key); 
		map.put(key, keyword);
		
		return key.equals("tag") && keyword !=null && keyword.length() > 0 ? pamphletdao.selectPamphletTotalCntbyTag(map) : pamphletdao.selectPamphletTotalCnt(map);
	}
	
	public List<Map<String, Object>> selectPamphletList(String key, String keyword, int limitFrom, int countperpage){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("key", key); 
		map.put(key, keyword);
		map.put("limitFrom", limitFrom);
		map.put("countperpage", countperpage);
		
		return key.equals("tag") && keyword !=null && keyword.length() > 0 ? pamphletdao.selectPamphletListbyTag(map) : pamphletdao.selectPamphletList(map);
	}
	
	public PamphletEntity selectPamphletDetail(int idx){
		return pamphletdao.selectPamphletDetail(idx);
	}

	public int savePamphlet(String irud_flag, PamphletEntity pamphletentity, ArrayList<TagEntity> taglist, ArrayList<AttachFileEntity> filelist){
		try {
			switch (irud_flag) {
			case "NEW":
				int newid = pamphletdao.selectNewId();
				pamphletentity.setIdx(newid);
				
				pamphletdao.insertPamphlet(pamphletentity);
				
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
				tmpentity.setCategory_flag("PP");
				tmpentity.setCategory_idx(pamphletentity.getIdx());
				
				AttachFileEntity tmpfileentity = new AttachFileEntity();
				tmpfileentity.setCategory_flag("PP");
				tmpfileentity.setCategory_idx(pamphletentity.getIdx());
				
				pamphletdao.updatePamphlet(pamphletentity);				
				tagdao.deleteTag(tmpentity);
				filedao.deleteFile(tmpfileentity);
				
				for(int i=0; i<taglist.size(); i++){
					taglist.get(i).setCategory_idx(pamphletentity.getIdx());
					tagdao.insertTag(taglist.get(i));
				}
					
				for(int j=0; j<filelist.size(); j++){
					filelist.get(j).setCategory_idx(pamphletentity.getIdx());
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
	
	public List<Map<String, Object>> selectAllStore(){
				
		return pamphletdao.selectAllStore(); 
	}
}
