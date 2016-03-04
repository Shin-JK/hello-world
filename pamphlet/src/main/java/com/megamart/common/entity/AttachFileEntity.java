package com.megamart.common.entity;

public class AttachFileEntity {
	String category_flag;
	int category_idx;
	int seq;
	String file_name;
	String file_size;
	String url;
	String file_type;
	String s3_file_name;
	String thumb1_file_name;
	String thumb2_file_name;
	String thumb1_url;
	String thumb2_url;
	
	public AttachFileEntity() {
	
	}

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

	public int getSeq() {
		return seq;
	}

	public void setSeq(int seq) {
		this.seq = seq;
	}

	public String getFile_name() {
		return file_name;
	}

	public void setFile_name(String file_name) {
		this.file_name = file_name;
	}

	public String getFile_size() {
		return file_size;
	}

	public void setFile_size(String file_size) {
		this.file_size = file_size;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getFile_type() {
		return file_type;
	}

	public void setFile_type(String file_type) {
		this.file_type = file_type;
	}

	public String getS3_file_name() {
		return s3_file_name;
	}

	public void setS3_file_name(String s3_file_name) {
		this.s3_file_name = s3_file_name;
	}

	public String getThumb1_file_name() {
		return thumb1_file_name;
	}

	public void setThumb1_file_name(String thumb1_file_name) {
		this.thumb1_file_name = thumb1_file_name;
	}

	public String getThumb2_file_name() {
		return thumb2_file_name;
	}

	public void setThumb2_file_name(String thumb2_file_name) {
		this.thumb2_file_name = thumb2_file_name;
	}

	public String getThumb1_url() {
		return thumb1_url;
	}

	public void setThumb1_url(String thumb1_url) {
		this.thumb1_url = thumb1_url;
	}

	public String getThumb2_url() {
		return thumb2_url;
	}

	public void setThumb2_url(String thumb2_url) {
		this.thumb2_url = thumb2_url;
	}
}
