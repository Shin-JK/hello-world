package com.megamart.common.entity;

public class TagEntity {
	String category_flag;
	int category_idx;
	String tag;
	int tag_seq;
	
	public String getCategory_flag() {
		return category_flag;
	}
	public void setCategory_flag(String category_flag) {
		this.category_flag = category_flag;
	}
	public int getCategory_idx() {
		return category_idx;
	}
	public void setCategory_idx(int category_idx) {
		this.category_idx = category_idx;
	}
	public String getTag() {
		return tag;
	}
	public void setTag(String tag) {
		this.tag = tag;
	}
	public int getTag_seq() {
		return tag_seq;
	}
	public void setTag_seq(int tag_seq) {
		this.tag_seq = tag_seq;
	}
}
