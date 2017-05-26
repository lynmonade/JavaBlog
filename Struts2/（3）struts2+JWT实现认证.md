# JWT登录认证

## JWT简介

JWT包含三个部分：

（1）header头部（算法）：用于说明JWT使用哪种算法进行加密。

（2）payload载荷（内容）：用于存放用户信息。JWT的规范预先定义了5个字段，我们也可以加入更多的字段。注意，千万不要在JWT中加入敏感信息，比如用户密码。

* iss：该JWT的签发者，没啥用
* sub：该JWT所面向的用户，很重要一般用来存储用户名
* aud：接收该JWT的一方，没啥用
* exp：该JWT什么时候过期，这是一个Unix时间戳，很重要
* iat：该JWT是在什么时候签发的，很重要

（3）signature签名：signature可看作是JWT的安全保障核心机制，它本质上来说是一串加密过的字符串，加密的方式是使用header中声明的算法，对`encoder.base64(header+payload+秘钥)`得到的字符串进行加密，在服务端只有知道秘钥才能正确地解密。秘钥本质上来说就是密码，比如"abc123"，我们绝不能够让外界知道这个秘钥，不然谁都可以解密了。

## JWT的使用案例

* 在loginAction中调用createToken()创建token，并写入到cookie。
* 在全局拦截器中调用使用parseToken()解析请求的cookie中所带的token，如果匹配，则说明已登录，可以继续访问action。

```java
//JJWT的工具类
public class JWTUtil {
	private static final String secret = "abc123"; //秘钥
	
	//创建JWT的token字符串
	public String createToken(String id, String sub, long ttlMillis) {
		String token = null;
		SignatureAlgorithm signatureAlgorithm = SignatureAlgorithm.HS256;
        long nowMillis = System.currentTimeMillis();
        Date now = new Date(nowMillis);
        SecretKey key = generalKey();
        JwtBuilder builder = Jwts.builder()
            .setId(id)
            .setIssuedAt(now)
            .setSubject(sub)
            .signWith(signatureAlgorithm, key);
        
        if (ttlMillis >= 0) {
            Date exp = new Date(ttlMillis);
            builder.setExpiration(exp);
            
        }
        token = builder.compact();
		return token;
	}
	
	//解析前端传入的JWT字符串
	public Claims parseToken(String token) {
		Claims claims = null;
		try {
			SecretKey key = generalKey();
			claims = Jwts.parser()         
	           .setSigningKey(key)
	           .parseClaimsJws(token).getBody();
	        System.out.println("id="+claims.getId());
	        System.out.println("sub="+claims.getSubject());
	        System.out.println("exp="+claims.getExpiration());
	        //trust this token
		} catch(Exception e) {
			//e.printStackTrace();
			System.out.println("token验证不通过，这不是一个有效的token");
			//don't trust this token
		}
		return claims;
	}
	
	//对秘钥进行简单加密
	private SecretKey generalKey(){
        byte[] encodedKey = Base64.decodeBase64(secret);
        SecretKey key = new SecretKeySpec(encodedKey, 0, encodedKey.length, "AES");
        return key;
    }
	
	//按天设置，token会存活多少天
	//afterDay表示从当前时间开始，往后的afterDay天，token都不会过期。即afterDay是offset量，不是destination量
	public long afterDaysTimeMillis(int afterDay) {
		//该方法表示获取当前时间的毫秒表示
		long current = System.currentTimeMillis();
		long perDay = (long)(1000*60*60*24);
		return current+perDay*afterDay;
		
	}
	
	//按天设置，token会存活多少秒
	//afterSecond表示从当前时间开始，往后的afterSecond秒，token都不会过期。即afterSecond是offset量，不是destination量
	public long afterSecondsTimeMillis(long afterSecond) {
		//该方法表示获取当前时间的毫秒表示
		long current = System.currentTimeMillis();
		long perSecond = 1000L;
		return current+perSecond*afterSecond;
		
	}
}

//在action中调用JWT工具类token字符串
//登录操作
public String userLogin() {
	if(voUser.getUsername().equals("admin") && voUser.getPassword().equals("1")) {
		System.out.println("userLogin:"+voUser.getUsername()+"登录成功");
		
		//从properties文件中获取token过期时间的设置
		JWTUtil jwtUtil = new JWTUtil();
		PropertiesUtil propertiesUtil = new PropertiesUtil();
		String tokenAliveTime = propertiesUtil.getPropertyConfig("tokenAliveTime");
		String isTokenAlive = propertiesUtil.getPropertyConfig("isTokenAlive");
		
		//创建token
		String token = jwtUtil.createToken("01", voUser.getUsername(), 
				jwtUtil.afterSecondsTimeMillis(Long.valueOf(tokenAliveTime).longValue()));
		
		//把token写入到cookie中返回给浏览器
		Cookie cookie = new Cookie("token", token);
		
		//设置浏览器关闭后，cookie是否仍存活
		if(Boolean.valueOf(isTokenAlive)==true) {
			cookie.setMaxAge(Long.valueOf(tokenAliveTime).intValue());
		}
		ServletActionContext.getResponse().addCookie(cookie);
		return null;
	}
	else {
		message.put("error", "账号或密码错误");
		return "fail";
	}
}

//在拦截器中判断cookie中是否有token，并调用JWT工具类解析token
public String intercept(ActionInvocation invocation) throws Exception {
	String token = null;
	HttpServletRequest request = ServletActionContext.getRequest();
	Cookie[] cookies = request.getCookies();
	if(cookies!=null) {
		for(Cookie cookie : cookies)
		{
			if(cookie.getName().equals("token"))
			{
				token = cookie.getValue();
			}
		}
	}
	if(token!=null) { //该请求存在token
		JWTUtil jwtUtil = new JWTUtil();
		Claims claims = jwtUtil.parseToken(token);
		if(claims!=null) {
			//trust this claim
			System.out.println("token验证成功，用户"+claims.getSubject()+"具有访问权限");
			String result = invocation.invoke();
			return result;
		}
	}
	return "noToken";
}
```

