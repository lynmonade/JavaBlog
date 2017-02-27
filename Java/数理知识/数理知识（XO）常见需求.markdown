# 数理知识（XO）常见需求
## 生成范围随机数
```java
/**
 * 生成范围是[min,max]的int随机数
 * */
public static int getRangeRandom(int min, int max) {
	Random ran = new Random();
	return ran.nextInt(max-min+1)+min;
}

```

## 四舍五入
