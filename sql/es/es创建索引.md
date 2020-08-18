##### 创建索引
```http
PUT /my-index
{
  "mappings": {
    "properties": {
      "age": {"type": "integer"},
      "email": {"type": "keyword"},
      "name": {"type": "text"}
    }
  }
}
```
##### 新增索引
```http
PUT /my-index/_mapping
{
  "properties": {
    "employee-id": {
      "type": "keyword",
      "index": false  # 标识不能被索引，查询的时候不能通过该字段检索
    }
  }
}
```
##### 更新映射
> 对于已存在的映射是不能更新的，更新必须创建新的索引进行数据迁移
