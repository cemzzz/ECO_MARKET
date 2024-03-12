package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Addr;
import com.example.test1.model.User;

@Mapper
public interface UserMapper {
	
	User selectUser(HashMap<String, Object> map); // 유저 찾기

	void insertUser(HashMap<String, Object> map); // 유저 회원가입

	void updateUser(HashMap<String, Object> map); // 유저 정보수정

	void insertUserAddr(HashMap<String, Object> map); // 유저 회원가입 (주소)

	List<Addr> selectAddr(HashMap<String, Object> map); // 유저 주소

	void deleteAddr(HashMap<String, Object> map); // 유저 주소 삭제
	
	void insertMyPageAddrAdd(HashMap<String, Object> map); //마이페이지 주소 추가
	
	Addr selectAddrAddNo(HashMap<String, Object> map);	//유저 마이페이지 주소록 가져오기
	
	void updateLoginCnt(HashMap<String, Object> map); // 로그인 실패 시 카운트 증가
	
	void updateLoginCnt2(HashMap<String, Object> map); // 로그인 성공 시 카운트 초기화
}
