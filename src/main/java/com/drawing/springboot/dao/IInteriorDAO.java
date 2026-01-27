package com.drawing.springboot.dao;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.InteriorDTO;

@Mapper
public interface IInteriorDAO {
	public int insertDAO(InteriorDTO interiorDTO);
	public InteriorDTO selectDAOByICode(String ICode);
}
