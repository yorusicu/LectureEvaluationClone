package util;

import java.security.MessageDigest;

public class SHA256 {
	public static String getSHA256(String input) {
		// StringBuffer는 문자열을 추가하거나 변경 할 때 주로 사용하는 자료형
		StringBuffer result = new StringBuffer();
		try {
			// MessageDigest 인스턴스 생성(instance의 알고리즘 적용)
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] salt = "Hello! This is Salt.".getBytes();
			digest.reset();
			digest.update(salt);
			// 해쉬로 변형된 값을 chars에 넣어줌
			byte[] chars = digest.digest(input.getBytes("UTF-8"));
			for (int i = 0; i < chars.length; i++) {
				// 0xff(헥스)과 chars(해쉬값이 적용된 input)의 해당index를 and연산하고
				String hex = Integer.toHexString(0xff & chars[i]);
				// 1자리일 경우 0을 붙여서 총 2자리값을 가지는 16진수값으로 출력하게 만들어 줌
				if (hex.length() == 1)	result.append("0");
				// 헥스값은 연결해 해쉬값을 만듬
				result.append(hex);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
}
