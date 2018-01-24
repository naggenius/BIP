/*
* Créée le 27/11/2015 par SEL
* Cette classe permet de chiffrer une chaine de caracteres en utilisant la methode AES
* 
* */

package com.socgen.bip.util;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import com.socgen.bip.commun.action.BipAction;

public class BipCrypto {

	
	
	private static byte[] key ={
            0x74, 0x62, 0x69, 0x73, 0x49, 0x73, 0x33, 0x53, 0x65, 0x69, 0x75, 0x65, 0x7e, 0x4b, 0x65, 0x79
    };

	
	
	
	public static String encrypter(String clair)
	{
	
		try {
			
			Cipher eCipher = Cipher.getInstance("AES");
			
			final SecretKeySpec secretKey = new SecretKeySpec(key,"AES");
			
			eCipher.init(Cipher.ENCRYPT_MODE, secretKey);
			
			final byte[] code = eCipher.doFinal(clair.getBytes());
			
			
			return new String(code);
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		}
		
		
		
	}
	
	public static String decrypter(String code)
	{
	
		try {
			
			Cipher dCipher = Cipher.getInstance("AES");
			
			final SecretKeySpec secretKey = new SecretKeySpec(key,"AES");
			
			dCipher.init(Cipher.DECRYPT_MODE, secretKey);
			
			final byte[] clair = dCipher.doFinal(code.getBytes());
			
			
			return new String(clair);
			
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			BipAction.logBipUser.error("Error. Check the code", e);
			return null;
		}
		
		
		
	}
	
	
	
}
