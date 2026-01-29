package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

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
    
}