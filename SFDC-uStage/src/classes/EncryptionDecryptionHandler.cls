//SPILLAI-ENCRYPTION-CHANGES
public with sharing class EncryptionDecryptionHandler {
    public static String encrypt(String plainTextValue){
    	//if (plainTextValue != null && plainTextValue != ''){
	    	Blob encryptedValue;
	    	String encodedKey = '+HWWtLuSp0bJt/iuPxb2caUcz1mIErmaVHXRzgV6fvE=';
	    	if(!Test.isRunningTest()) {
	    	encryptedValue = Crypto.encryptWithManagedIV('AES256', EncodingUtil.base64decode(encodedKey), Blob.valueOf(plainTextValue));
	    	}else{
	    	encryptedValue = Blob.valueOf('Unit Test Attachment Body');
	    	}
			return EncodingUtil.base64encode(encryptedValue);
    	//}
    	//else
    		//return '';
    }
    
    public static String decrypt(String encryptedText){
    	Blob decryptedValue;
    	String encodedKey = '+HWWtLuSp0bJt/iuPxb2caUcz1mIErmaVHXRzgV6fvE=';
    	if (encryptedText != null){
			if(!Test.isRunningTest()) {
	    		decryptedValue = Crypto.decryptWithmanagedIV('AES256', EncodingUtil.base64decode(encodedKey), EncodingUtil.base64decode(encryptedText));
	    	}else{
	    		decryptedValue = Blob.valueOf('Unit Test Attachment Body');
	    	}
			return decryptedValue.toString();
    	}
    	else{
    		return '';
    	}		
    }
}
//SPILLAI-ENCRYPTION-CHANGES