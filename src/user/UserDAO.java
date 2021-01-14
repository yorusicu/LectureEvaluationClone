package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import util.DatabaseUtil;

// 데이터 접근 객체
public class UserDAO extends DatabaseUtil{
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	// 회원가입 =======================================================
	public int join(UserDTO user) {
		System.out.println("IN Dao_join");
		String sql = "INSERT INTO USER VALUES(?,?,?,?, false)";
		try {
			System.out.println("Dao_join In_try");
			conn = getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserEmail());
			pstmt.setString(4, user.getUserEmailHash());
//			System.out.println("Dao_join result: "+pstmt.executeUpdate());
			return pstmt.executeUpdate();
		}catch(SQLException e2) {
			e2.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
			close(conn);
		}

		return -1; // 회원가입 실패
	}

	// 로그인 =======================================================
	public int login(String userID, String userPassword) {
		String sql = "SELECT userPassword FROM USER WHERE userID=?";

		try {
			conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				if (rs.getNString(1).equals(userPassword)) {
					return 1; // 로그인 성공
				} else {
					return 0; // 패스워드 실패
				}
			}
			return -1; // 아이디 없음
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
			close(conn);
		}
		
		return -2; // DB 오류
	}

	// 이메일받아오기 =======================================================
	public String getUserEmail(String userID) {
		String sql = "SELECT userEmail FROM USER WHERE userID=?";

		try {
			conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				return rs.getString(1); // 이메일 주소 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
			close(conn);
		}

		return null; // DB 오류
	}

	// 이메일 확인 =======================================================
	public boolean getUserEmailChecked(String userID) {
		String sql = "SELECT userEmailChecked FROM USER WHERE userID=?";
		
		try {
			conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				return rs.getBoolean(1); // 이메일 등록 여부 반환
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
			close(conn);
		}

		return false; // DB 오류
	}

	// 이메일 확인 =======================================================
	public boolean setUserEmailChecked(String userID) {
		String sql = "UPDATE USER SET userEmailChecked = true WHERE userID=?";

		try {
			conn = getConnection();
			PreparedStatement pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			return true;	// 이메일 등록 성공
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
			close(conn);
		}

		return false; // 이메일 등록 설정 실패
	}
}
