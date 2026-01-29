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