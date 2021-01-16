package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO extends DatabaseUtil {
	private Connection conn;
	private ResultSet rs;

	// 평가 쓰기 =================================================================================
	public int write(EvaluationDTO evalDto) {
		conn=getConnection();
		PreparedStatement pstmt = null;
		
		try {
			String sql = "INSERT INTO EVALUATION VALUES(NULL,?,?,?,?,?,?,?,?,?,?,?,?,0);";
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, evalDto.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(2, evalDto.getLectureName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(3, evalDto.getProfessorName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setInt(4, evalDto.getLectureYear());
			pstmt.setString(5, evalDto.getSemesterDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(6, evalDto.getLectureDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(7, evalDto.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(8, evalDto.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(9, evalDto.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(10, evalDto.getCreditScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(11, evalDto.getComfortableScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(12, evalDto.getLectureScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn);
			close(pstmt);
		}
		return -1;	// 평가 쓰기 실패
	}
	
	// 평가 리스트 =================================================================================
		public ArrayList<EvaluationDTO> getList(String lectureDivide, String searchType, String search, int pageNumber) {
			conn=getConnection();
			PreparedStatement pstmt = null;
			
			if (lectureDivide.equals("전체")) {
				lectureDivide="";
			}
			
			ArrayList<EvaluationDTO> list=null;
			
			String sql="";
			
			try {
				if (searchType.equals("최신순")) {
					sql="SELECT * "
							+ "FROM EVALUATION "
							+ "WHERE lectureDivide "
							+ "LIKE ? "
							+ "AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) "
							+ "LIKE ? "
							+ "ORDER BY evaluationID DESC "
							+ "LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
				}else if(searchType.equals("추천순")) {
					sql="SELECT * "
							+ "FROM EVALUATION "
							+ "WHERE lectureDivide "
							+ "LIKE ? "
							+ "AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) "
							+ "LIKE ? ORDER BY likeCount DESC "
							+ "LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
				}
				pstmt=conn.prepareStatement(sql);
				pstmt.setString(1, "%"+lectureDivide+"%");
				pstmt.setString(2, "%"+search+"%");
				rs=pstmt.executeQuery();
				list=new ArrayList<>();
				while(rs.next()) {
					EvaluationDTO eval=new EvaluationDTO(
					rs.getInt(1),
					rs.getString(2),
					rs.getString(3),
					rs.getString(4),
					rs.getInt(5),
					rs.getString(6),
					rs.getString(7),
					rs.getString(8),
					rs.getString(9),
					rs.getString(10),
					rs.getString(11),
					rs.getString(12),
					rs.getString(13),
					rs.getInt(14)
					);
					list.add(eval);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close(conn);
				close(pstmt);
				close(rs);
			}
			return list;	// list 반환
		}
		
	// 좋아요 =========================================================================
		public int like(String evaluationID) {
			conn=getConnection();
			PreparedStatement pstmt=null;
			try {
				String sql="UPDATE EVALUATION SET likeCount = likeCount + 1 WHERE evaluationID = ?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(evaluationID));
				
				return pstmt.executeUpdate();
			}catch (Exception e) {
				e.printStackTrace();
			}finally {
				close(conn);
				close(pstmt);
			}
			return -1;
		}
		
	// 삭제하기 =========================================================================
	public int delete(String evaluationID) {
		conn=getConnection();
		PreparedStatement pstmt=null;
		try {
			String sql="DELETE FROM EVALUATION WHERE evaluationID = ?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			
			return pstmt.executeUpdate();
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			close(conn);
			close(pstmt);
		}
		return -1;
	}
	
	// 강의 글 작성 유저아이디 불러오기 =========================================================================
		public String getUserID(String evaluationID) {
			conn=getConnection();
			PreparedStatement pstmt=null;
			try {
				String sql="SELECT userID FROM EVALUATION WHERE evaluationID = ?";
				pstmt=conn.prepareStatement(sql);
				pstmt.setInt(1, Integer.parseInt(evaluationID));
				rs=pstmt.executeQuery();
				while(rs.next()) {
					return rs.getString(1);
				}
			}catch (Exception e) {
				e.printStackTrace();
			}finally {
				close(conn);
				close(pstmt);
			}
			return null;	// 존재하지 않는 아이디
		}
}
