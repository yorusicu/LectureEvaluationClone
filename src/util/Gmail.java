package util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class Gmail extends Authenticator{
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		// 메일을 보내는 아이디와 비밀번호
		return new PasswordAuthentication("yorusicu@gmail.com", "332Qndrk");
	}
}
