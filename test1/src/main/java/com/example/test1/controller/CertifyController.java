package com.example.test1.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class CertifyController {

	//@Autowire

	// 본인인증 메인 페이지
	@RequestMapping("/user-certify1.do")
	public String usercertify1(Model model) throws Exception {

		return "/user-certify1";
	}
	
	// 본인인증하기
	@RequestMapping("/user-certify2.do")
	public String usercertify2(Model model) throws Exception {

		return "/user-certify2";
	}

}