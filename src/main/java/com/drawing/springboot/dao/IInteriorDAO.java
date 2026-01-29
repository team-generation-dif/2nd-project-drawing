package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.InteriorDTO;

@Mapper
public interface IInteriorDAO {
	public int insertDAO(InteriorDTO interiorDTO);
	public int updateDAO(InteriorDTO interiorDTO);
	public int deleteDAO(String i_code);
	public InteriorDTO selectDAOByICode(String i_code);
	public List<InteriorDTO> selectDAOByMCode(String m_code);
}
