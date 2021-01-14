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
			pstmt.setString(1, evalDto.getUserID());
			pstmt.setString(2, evalDto.getLectureName());
			pstmt.setString(3, evalDto.getProfessorName());
			pstmt.setInt(4, evalDto.getLectureYear());
			pstmt.setString(5, evalDto.getSemesterDivide());
			pstmt.setString(6, evalDto.getLectureDivide());
			pstmt.setString(7, evalDto.getEvaluationTitle());
			pstmt.setString(8, evalDto.getEvaluationContent());
			pstmt.setString(9, evalDto.getTotalScore());
			pstmt.setString(10, evalDto.getCreditScore());
			pstmt.setString(11, evalDto.getComfortableScore());
			pstmt.setString(12, evalDto.getLectureScore());
			
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
					sql="SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? AND CONCAT(lectureName, "
							+ "professorName, evaluationTitle, evaluationContent) LIKE ? "
							+ "ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
				}else if(searchType.equals("추천순")) {
					sql="SELECT * FROM EVALUATION WHERE lectureDivide LIKE ? "
							+ "AND CONCAT(lectureName, professorName, evaluationTitle, evaluationContent) "
							+ "LIKE ? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
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
}
