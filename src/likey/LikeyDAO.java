package likey;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class LikeyDAO extends DatabaseUtil{
	private Connection conn;
	
	public int like(String userID, String evaluationID, String userIP) {
		conn=getConnection();
		PreparedStatement pstmt=null;
		String sql="INSERT INTO LIKEY VALUES(?,?,?)";
		try {
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			pstmt.setString(2, evaluationID);
			pstmt.setString(3, userIP);
			
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
		}
		return -1;	// 추천 중복 오류
	}
}
