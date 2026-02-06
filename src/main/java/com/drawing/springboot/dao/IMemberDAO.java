package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.MemberDTO;

@Mapper
public interface IMemberDAO {
	void insertMember(MemberDTO member);
	MemberDTO findByMid(String m_id);
	MemberDTO findByMnick(String m_nick);
	MemberDTO findByMemail(String m_email);
	MemberDTO findByMtel(String m_tel); // 전화번호 중복 체크용 추가
    void updateMember(MemberDTO member);
    void deleteMember(String m_id);
    List<MemberDTO> findAllMembers();
    String findIdByEmail(String m_email); // 아이디 찾기
    void updatePassword(@Param("m_email") String m_email, @Param("m_passwd") String m_passwd);
int updateMemberInfo(MemberDTO memberDTO);
int getTotalUserCount();
int getNewUsersToday();
    
    // 3. 본인 인증용: ID로 회원 정보 가져오기
    MemberDTO findMemberById(String m_id);
    MemberDTO findByMnickExceptMe(
    	    @Param("m_nick") String m_nick,
    	    @Param("m_id") String m_id
    	);

    	MemberDTO findByMemailExceptMe(
    	    @Param("m_email") String m_email,
    	    @Param("m_id") String m_id
    	);

    	MemberDTO findByMtelExceptMe(
    	    @Param("m_tel") String m_tel,
    	    @Param("m_id") String m_id
    	);

}