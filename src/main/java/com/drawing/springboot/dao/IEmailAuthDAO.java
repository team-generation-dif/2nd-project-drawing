package com.drawing.springboot.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.drawing.springboot.dto.EmailAuthDTO;

@Mapper
public interface IEmailAuthDAO {

    void insertAuth(EmailAuthDTO dto);

    EmailAuthDTO findLatestByEmail(@Param("m_email") String m_email);

    void verifyAuth(@Param("e_code") String e_code);

    void deleteExpired();
}

