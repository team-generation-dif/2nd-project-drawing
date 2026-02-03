package com.drawing.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.drawing.springboot.dto.FloorplanDTO;

@Mapper
public interface IFloorplanDAO {
	public int insertDAO(FloorplanDTO floorplanDTO);
	public int updateDAO(FloorplanDTO floorplanDTO);
	public int deleteDAO(String f_code);
	public FloorplanDTO selectDAOByFCode(String f_code);
	public List<FloorplanDTO> selectDAOByMCode(String m_code);
	public List<FloorplanDTO> selectDAOByMId(String m_id);
}
