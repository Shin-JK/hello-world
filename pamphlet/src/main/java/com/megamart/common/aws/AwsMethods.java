package com.megamart.common.aws;

import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.util.Date;

import com.amazonaws.AmazonClientException;
import com.amazonaws.AmazonServiceException;
import com.amazonaws.HttpMethod;
import com.amazonaws.auth.AWSCredentials;
import com.amazonaws.auth.BasicAWSCredentials;
import com.amazonaws.regions.Region;
import com.amazonaws.regions.Regions;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3Client;
import com.amazonaws.services.s3.S3ClientOptions;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;

public class AwsMethods {
	//private static final String S3REGION = "ap-northeast-1";
	private static Region S3REGION = Region.getRegion(Regions.AP_NORTHEAST_1);
	private static String S3BUCKET = "mega.contents.db";
	private static String S3BUCKETPAMPHLET = "pamphlet/";
	private static String S3BUCKETPRODUCT = "product/";
	private static String S3THUMBBUCKET = "mega.contents.db.thumbnail";
	private static String S3THUMBPAMPHLET_M = "thumbnail_m/pamphlet/";
	private static String S3THUMBPRODUCT_M = "thumbnail_m/product/";
	private static String S3THUMBPAMPHLET_S = "thumbnail_s/pamphlet/";
	private static String S3THUMBPRODUCT_S = "thumbnail_s/product/";
	private static String S3ACL = "private";
	private static String S3ACCESSKEYID = "AKIAJBADIM27IWW4AXCQ";
	private static String S3SECRETACCESSKEY = "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";
	private static int EXPMinute = 30; //만료시간 30분
	
	private static AmazonS3 s3client;
	private static GeneratePresignedUrlRequest generatePresignedUrlRequest;
	
	private static void initS3client(){
		if (s3client == null){
			s3client = new AmazonS3Client(new BasicAWSCredentials(S3ACCESSKEYID, S3SECRETACCESSKEY));
			s3client.setRegion(S3REGION);
			s3client.setS3ClientOptions(new S3ClientOptions().withPathStyleAccess(true));
		}
	}
	
	//원본 경로
	public static String getPreSignedURL(String category, String s3filename){
	    //AWSCredentials credentials = new BasicAWSCredentials(S3ACCESSKEYID, S3SECRETACCESSKEY);
		//AmazonS3 s3client = new AmazonS3Client(credentials);
		//s3client.setRegion(S3REGION);
		initS3client();		
		URL url = null;
		try {
						
			Date expiration = new Date();
			long milliSeconds = expiration.getTime();
			milliSeconds += 1000 * 60 * EXPMinute; 
			expiration.setTime(milliSeconds);
			
			String objectKey = (category.equals("PP") ? S3BUCKETPAMPHLET : S3BUCKETPRODUCT) + s3filename;
			GeneratePresignedUrlRequest generatePresignedUrlRequest = 
				    new GeneratePresignedUrlRequest(S3BUCKET, objectKey);
			generatePresignedUrlRequest.setMethod(HttpMethod.GET); 
			generatePresignedUrlRequest.setExpiration(expiration);
						
			url = s3client.generatePresignedUrl(generatePresignedUrlRequest); 

			
		} catch (AmazonServiceException exception) {
			System.out.println("Caught an AmazonServiceException, " +
					"which means your request made it " +
					"to Amazon S3, but was rejected with an error response " +
			"for some reason.");
			System.out.println("Error Message: " + exception.getMessage());
			System.out.println("HTTP  Code: "    + exception.getStatusCode());
			System.out.println("AWS Error Code:" + exception.getErrorCode());
			System.out.println("Error Type:    " + exception.getErrorType());
			System.out.println("Request ID:    " + exception.getRequestId());
		} catch (AmazonClientException ace) {
			System.out.println("Caught an AmazonClientException, " +
					"which means the client encountered " +
					"an internal error while trying to communicate" +
					" with S3, " +
			"such as not being able to access the network.");
			System.out.println("Error Message: " + ace.getMessage());
		}
		
		return url.toString();
	}
	
	public static String getPreSignedThumbMURL(String category, String s3filename){
	    //AWSCredentials credentials = new BasicAWSCredentials(S3ACCESSKEYID, S3SECRETACCESSKEY);
		//AmazonS3 s3client = new AmazonS3Client(credentials);
		//s3client.setRegion(S3REGION);
		initS3client();		
		URL url = null;
		//String strUrl = null;
		try {
						
			Date expiration = new Date();
			long milliSeconds = expiration.getTime();
			milliSeconds += 1000 * 60 * EXPMinute; 
			expiration.setTime(milliSeconds);
			
			String objectKey = (category.equals("PP") ? S3THUMBPAMPHLET_M : S3THUMBPRODUCT_M) + s3filename;
			GeneratePresignedUrlRequest generatePresignedUrlRequest = 
				    new GeneratePresignedUrlRequest(S3THUMBBUCKET, objectKey);
			generatePresignedUrlRequest.setMethod(HttpMethod.GET); 
			generatePresignedUrlRequest.setExpiration(expiration);
						
			url = s3client.generatePresignedUrl(generatePresignedUrlRequest); 
			//byte [] utf8Url = url.toString().getBytes("EUC-KR");
			//System.out.println(url.toString());
			//strUrl = url.toString().replace("+", "%2B");
			//strUrl = URLDecoder.decode(url.toString(), "KSC5601");
			//strUrl = new String(url.toString().getBytes("EUC-KR"), "EUC-KR");
			//System.out.println(strUrl);
		} catch (AmazonServiceException exception) {
			System.out.println("Caught an AmazonServiceException, " +
					"which means your request made it " +
					"to Amazon S3, but was rejected with an error response " +
			"for some reason.");
			System.out.println("Error Message: " + exception.getMessage());
			System.out.println("HTTP  Code: "    + exception.getStatusCode());
			System.out.println("AWS Error Code:" + exception.getErrorCode());
			System.out.println("Error Type:    " + exception.getErrorType());
			System.out.println("Request ID:    " + exception.getRequestId());
		} catch (AmazonClientException ace) {
			System.out.println("Caught an AmazonClientException, " +
					"which means the client encountered " +
					"an internal error while trying to communicate" +
					" with S3, " +
			"such as not being able to access the network.");
			System.out.println("Error Message: " + ace.getMessage());
		} /*catch (UnsupportedEncodingException ex){
			System.out.println("Error Message: " + ex.getMessage());
		}*/
		
		return url.toString();
	}
	
	public static String getPreSignedThumbSURL(String category, String s3filename){
	    //AWSCredentials credentials = new BasicAWSCredentials(S3ACCESSKEYID, S3SECRETACCESSKEY);
		//AmazonS3 s3client = new AmazonS3Client(credentials);
		//s3client.setRegion(S3REGION);
		initS3client();		
		URL url = null;
		try {
						
			Date expiration = new Date();
			long milliSeconds = expiration.getTime();
			milliSeconds += 1000 * 60 * EXPMinute; 
			expiration.setTime(milliSeconds);
			
			String objectKey = (category.equals("PP") ? S3THUMBPAMPHLET_S : S3THUMBPRODUCT_S) + s3filename;
			GeneratePresignedUrlRequest generatePresignedUrlRequest = 
				    new GeneratePresignedUrlRequest(S3THUMBBUCKET, objectKey);
			generatePresignedUrlRequest.setMethod(HttpMethod.GET); 
			generatePresignedUrlRequest.setExpiration(expiration);
						
			url = s3client.generatePresignedUrl(generatePresignedUrlRequest); 

			
		} catch (AmazonServiceException exception) {
			System.out.println("Caught an AmazonServiceException, " +
					"which means your request made it " +
					"to Amazon S3, but was rejected with an error response " +
			"for some reason.");
			System.out.println("Error Message: " + exception.getMessage());
			System.out.println("HTTP  Code: "    + exception.getStatusCode());
			System.out.println("AWS Error Code:" + exception.getErrorCode());
			System.out.println("Error Type:    " + exception.getErrorType());
			System.out.println("Request ID:    " + exception.getRequestId());
		} catch (AmazonClientException ace) {
			System.out.println("Caught an AmazonClientException, " +
					"which means the client encountered " +
					"an internal error while trying to communicate" +
					" with S3, " +
			"such as not being able to access the network.");
			System.out.println("Error Message: " + ace.getMessage());
		}
		
		return url.toString();
	}
}
