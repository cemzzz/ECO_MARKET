package com.example.test1.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.test1.model.Cart;

@Mapper
public interface CartMapper {

	List<Cart> selectCartList(HashMap<String, Object> map);

	
}
