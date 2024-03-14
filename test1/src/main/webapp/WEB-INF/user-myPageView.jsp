<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <script src="js/jquery.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/lodash@4.17.21/lodash.min.js"></script>
	<script src="https://cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
    <link rel="stylesheet" type="text/css" href="/css/user-myPage.css">
    <title>마이 페이지</title>
</head>
<style>
</style>
<body class="myPagebackground">
    <div id="app">
        <div class="myPageViewContainer">
            <fieldset>
                <ul>
                    <li>
                        <span>아이디: </span>
                        <input type="text" v-model="user.userId" disabled>
                    </li>
                    <li>
                        <span>비밀번호: </span>
                        <input type="password" v-model="user.userPw" maxlength="16" @input="validatePassword($event, 'userPw')" >
                        <div>
                            <span v-if="!checkPasswordMatch" style="color: red;">{{ passwordErrorMessage }}</span>
                        </div>
                    </li>
                    <li>
                        <span>비밀번호 확인 : </span>
                        <input type="password" v-model="user.userPw2" maxlength="16" @input="validatePassword2($event, 'userPw2')">
                        <button  @click="fnPwdCheck">비밀번호 확인</button>
                        <div>
                            <span v-if="!checkPassword2Match" style="color: red;">{{ passwordConfirmErrorMessage }}</span>
                        </div>
                    </li>
                    <li>
                        <span>이름: </span>
						<input type="text" v-model="user.name" maxlength="30" @input="validateName">
                    </li>
                    <li>
                        <span>닉네임: </span>
                        <input type="text" v-model="user.nickName" maxlength="30">
                    </li>
                  	<li>
						<span>성별: </span>
						<div>
							<input type="radio" name="gender" value="남성" v-model="user.gender">남 
							<input type="radio"name="gender" value="여성" v-model="user.gender">여
							<input type="radio" name="gender" value="기타" v-model="user.gender">기타
						</div>
					</li>
					<li>
						<span>핸드폰 번호: </span>
						<div class="inline-input">
						    <input type="text" v-model="user.phone1" maxlength="3" @input="allowOnlyNumbers1($event, 'phone1')">-
						    <input type="text" v-model="user.phone2" maxlength="4" @input="allowOnlyNumbers2($event, 'phone2')">-
						    <input type="text" v-model="user.phone3" maxlength="4" @input="allowOnlyNumbers2($event, 'phone3')">    
						</div>
					</li>
                    <li>
                        <span>이메일: </span>
                        <div class="inline-input email-group">
                            <input type="text" class="join-input email-input" v-model="email1" placeholder="이메일 아이디 입력">
                            <span>@</span>
                            <input type="text" class="join-input email-input" v-model="email2" placeholder="직접 입력">
                            <select v-model="email3" @change="selectEmail">
                                <option value="">직접 입력</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="naver.com">naver.com</option>
                                <option value="kakao.com">kakao.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                            </select>
                        </div>
                    <li>
                        <span>생년월일: </span>
                        <input type="text" v-model="user.birth" placeholder="ex)19910101" @input="formatBirthDate">
                    </li>
                </ul>
                <div>
                    <button @click="fnmodify()">수정하기</button>
                    <button @click="fnUserDelete()">탈퇴하기</button>
                </div>
            </fieldset>
        </div>
    </div>
</body>
</html>
<script type="text/javascript">
    var app = new Vue({
        el: '#app',
        data: {
            user: {
                userId: "${userId}",
                userPw: "",
                userPw2: "",
                name: "",
                nickName: "",
                gender: "",
                phone1: "",
                phone2: "",
                phone3: "",
                email: "",
                birth: "",
                userGrade : "",
                authYn : "",
                eventYn : "",
                loginCnt : "",
                point : "",
                totalP : "",
                userType : "",
                cDateTime : "",
                uDateTime : "",
                StartDate : "",
                EndDate : "",
                deleteDate : ""
            },
            email1: "",
        	email2: "",
        	email3: "",
            checkPasswordMatch: true,
            checkPassword2Match: true,
            passwordErrorMessage: "",
            passwordConfirmErrorMessage: ""
        },
        methods: {
        	//기존정보 호출하기
            information: function () {
                var self = this;
                var nparmap = {
                		userId :self.user.userId
                };
                $.ajax({
                    url: "user-mypage.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                    	console.log(data.user);
                    	console.log(data.list);
                        self.user = data.user;
                        var atIdx = data.user.email.indexOf('@');
                        self.email1 = data.user.email.substring(0, atIdx);
                        self.email2 = data.user.email.substring(atIdx + 1);
                    }
                });
            },
            selectEmail : function(){
            	var self = this;
            	self.email2 = self.email3;
            },
            //이름에 입력에 대한 정규식
            validateName: function(event) {
                var inputValue = event.target.value;
                // 한글, 영어, 띄어쓰기만 허용하고 최대 30자까지 입력되도록 처리
                this.user.name = inputValue.replace(/[^가-힣a-zA-Z\s]/g, '').substring(0, 30);
            },
         	// 핸드폰 번호 입력 필드에서 숫자만 허용하는 메소드
            allowOnlyNumbers1: function (event, field) {
			    var inputValue = event.target.value;
			    this.user[field] = inputValue.replace(/\D/g, '').substring(0, 3);
			},
			// 핸드폰 번호 입력 필드에서 숫자만 허용하는 메소드
			allowOnlyNumbers2: function (event, field) {
			    var inputValue = event.target.value;
			    // 숫자가 아닌 문자는 제거하고, 최대 4자리까지만 입력되도록 처리
			    this.user[field] = inputValue.replace(/\D/g, '').substring(0, 4);
			},
            //생일 입력 정규식
          	formatBirthDate: function(event) {
			    var inputValue = event.target.value;
			    // 숫자가 아닌 문자는 제거하고, 최대 8자리까지만 입력되도록 처리
			    this.user.birth = inputValue.replace(/\D/g, '').substring(0, 8);
			},
        	//비밀번호 정규식 유효성 검사
            validatePassword: function (event, field) {
                var self = this;
                var regex =  /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$/;
                self.validateInput(event, field, regex, "비밀번호는 최소 8글자, 최대 16글자이고 하나 이상의 숫자, 영문자 및 특수문자를 각각 포함해야 합니다!");
            },
            //비밀번호 확인 정규식 유효성 검사
            validatePassword2: function (event, field) {
                var self = this;
                var regex =  /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$/;
                self.validateInput2(event, field, regex, "비밀번호는 최소 8글자, 최대 16글자이고 하나 이상의 숫자, 영문자 및 특수문자를 각각 포함해야 합니다!");
            },
            // 비밀번호 입력 필드 정규식 유효성 검사
            validateInput: function (event, field, validationRegex, errorMessage) {
                var self = this;
                var inputValue = event.target.value;
                console.log("validateInput 메소드 호출"); // 디버깅 문
                if (validationRegex.test(inputValue)) {
                    console.log("유효성 검사 성공:", inputValue); // 디버깅 문
                    self.checkPasswordMatch = true;
                    self.passwordErrorMessage = "";
                } 
                else {
                    console.error("유효성 검사 실패:", inputValue); // 디버깅 문
                    self.checkPasswordMatch = false;
                    self.passwordErrorMessage = errorMessage;
                }
            },
            //비밀번호 확인 정규식 유효성 검사
            validatePassword2: function (event, field) {
                var self = this;
                var regex =  /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#$%^&*?_]).{8,16}$/;
                self.validateInput2(event, field, regex, "비밀번호는 최소 8글자, 최대 16글자이고 하나 이상의 숫자, 영문자 및 특수문자를 각각 포함해야 합니다!");
            },
            //비밀번호 확인 입력 필드 정규식 유효성 검사
            validateInput2: function (event, field, validationRegex, errorMessage) {
                var self = this;
                var inputValue = event.target.value;
                console.log("validateInput 메소드 호출"); // 디버깅 문
                if (validationRegex.test(inputValue)) {
                    console.log("유효성 검사 성공:", inputValue); // 디버깅 문
                    self.checkPassword2Match = true;
                    self.passwordConfirmErrorMessage = "";
                }
                else {
                    console.error("유효성 검사 실패:", inputValue); // 디버깅 문
                    self.checkPassword2Match = false;
                    self.passwordConfirmErrorMessage = errorMessage;
                }
            },
			//비밀번호 체크
			fnPwdCheck: function () {
			    var self = this;
			    if (self.user.userPw !== self.user.userPw2) {
			        self.checkPassword2Match = true;
			        self.checkPasswordMatch = true;
			        self.checkPassword = false;
			        self.user.userPw = "";
			        self.user.userPw2 = "";
			        alert("비밀번호랑 비밀번호확인이 다릅니다.");
			        return;
			    } else if (self.user.userPw == "" || self.user.userPw2 == "") {
			        self.user.userPw = "";
			        self.user.userPw2 = "";
			        alert("비밀번호랑 비밀번호확인을 입력해 주세요");
			        return;
			    } else if (self.user.userPw == self.user.userPw2) {
			        alert("비밀번호가 일치합니다.");
			        return;
			    } else {
			        self.checkPassword = true;
			    }
			},
            //정보수정하기
            fnmodify: function () {
                var self = this;
                if ((!self.user.userPw || !self.user.userPw.trim()) && (!self.user.userPw2 || !self.user.userPw2.trim())) {
                	self.user.userPw = "";
		            self.user.userPw2 = "";
                	alert("비밀번호와 비밀번호 확인을 모두 기입해 주세요.");
                    return;
                }
                if (self.user.userPw == "") {
                	self.user.userPw = "";
		            self.user.userPw2 = "";
                	alert("비밀번호를 기입해 주세요.");
                    return;
                }
                if (self.user.userPw2 == "") {
                	self.user.userPw = "";
		            self.user.userPw2 = "";
                	alert("비밀번호 확인 기입해 주세요.");
                    return;
                }
                if (self.user.userPw != self.user.userPw2) {
                	self.user.userPw = "";
		            self.user.userPw2 = "";
                	alert("비밀번호랑 비밀번호 확인이 다릅니다.");
                    return;
                }
         
                if (self.user.name == "") {
                    alert("이름을 입력해 주세요");
                    return;
                }
                if (self.user.nickName == "") {
                    alert("별명을 입력해 주세요");
                    return;
                }
         
                if (self.user.email == "") {
                    alert("이메일을 입력해 주세요");
                    return;
                }
                if (self.user.birth == "") {
                    alert("생년월일을 입력해 주세요");
                    return;
                }
                if(self.user.userId == ""){
            		alert("로그인 후 입장 가능합니다.");
            		window.location.href = "/user-login.do";
            	}
                self.user.email = self.email1 + "@" + self.email2;
                var nparmap = self.user;
                $.ajax({
                    url: "user-modify.dox",
                    dataType: "json",
                    type: "POST",
                    data: nparmap,
                    success: function (data) {
                    	console.log(self.user);
                    	//성공시 부모창 새로고침후 팝업창 닫기
    			    	if (data.result == "success") {
    						alert("사용자 정보가 수정되었습니다.");
                            location.href = "main.do";
    						
    					} else {
    						alert("사용자 정보 수정에 실패했습니다. 다시 시도하세요.");
    						return;
    					}
                    }
                });
            },
            //회원탈퇴하기
            fnUserDelete : function() {
                var self = this;
                if(self.user.userId == ""){
            		alert("로그인 후 입장 가능합니다.");
            		window.location.href = "/user-login.do";
            	}
                var nparmap = self.user;
                $.ajax({
                    url:"user-delete.dox",
                    dataType:"json",
                    type: "POST",
                    data: nparmap,
                    success: function(data) {
                    	console.log(self.user);
                    	if(data.result == "success") {
                    		alert("사용자 정보가 탈퇴하였습니다.");
                    	} else {
                    		alert("사용자 탈퇴에 실패했습니다. 다시 시도하세요.");
    						return;
                    	}
                    }
                });
            }
        },
        created: function () {
            var self = this;
            if(self.user.userId == ""){
        		alert("로그인 후 입장 가능합니다.");
        		window.location.href = "/user-login.do";
        	}
            self.information();
            
        }
    });
</script>