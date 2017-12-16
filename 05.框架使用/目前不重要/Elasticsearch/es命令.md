//创建索引
PUT http://192.168.2.103:9200/oracle/
{
  "mappings": {
    "table1": {
      "properties": {
        "dept_id": {
          "type": "string",
          "index": "analyzed",
		  "store":"yes"
        },
        "dept_name": {
          "type": "string",
          "index": "analyzed",
		  "store":"yes"
        },
        "phone": {
          "type": "long",
		  "store":"yes"
        },
        "pubDate": {
          "type": "date",
          "format": "yyy-MM-dd HH:mm:ss",
		  "store":"yes"
        }
      }
    }
  }
}

//插入文档
POST http://192.168.2.103:9200/oracle/table1
{
	"dept_id":"101",
	"dept_name":"南宁供电局", 
	"phone":"131",
	"pubDate":"2017-11-01 09:09:01"
}