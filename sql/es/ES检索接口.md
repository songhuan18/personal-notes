##### 通过_cat检索
```sh
GET /_cat/nodes    #查看所有节点
GET /_cat/health   #查看es健康状况
GET /_cat/master   #查看主节点
GET /_cat/indices  #查看所有索引
```
##### 保存一个索引文档
保存一个数据，保存在哪个索引哪个类型下，制定用哪个唯一标识
```sh
PUT /customer/external/1 #在customer索引下的external类型保存id为1的数据
{
  "name":"songhuan"
}
```
PUT和POST都可以保存数据。<br/>
POST新增，如果不指定id，会自动生成id。指定id，如果该id下的数据存在则会修改这个数据，并新增版本号。<br/>
PUT可以新增可以修改。PUT必须指定id，由于PUT需要指定id，我们一般用来做修改操作，不指定id会报错

##### 查询索引
```http
GET /customer/external/1 #或者
GET /customer/_doc/1
#查询结果
{
  "_index": "customer", #索引
  "_type": "_doc",      #类型
  "_id": "1",           #id
  "_version": 1,        #版本号
  "_seq_no": 0,         #并发控制字段，每次更新都会+1，用来做乐观锁
  "_primary_term": 1,   #同上，主分片重新分配，如重启，就会发生变化
  "found": true,
  "_source": {          #真正查询的内容
    "name": "songhuan"
  }
}
```
> 如果要控制并发，则更新的时候需要携带参数?if_seq_no=0&if_primary_term=1

如下请求：
```http
PUT /customer/external/1?if_seq_no=0&if_primary_term=1
```
##### 删除文档&索引
```http
DELETE /customer/external/1
DELETE /customer
```
##### 批量新增
```http
POST /customer/external/_bulk
{"index":{"_id":"1"}}
{"name": "zhangsan"}
{"index":{"_id":"2"}}
{"name": "lisi"}
```
##### 查询返回部分字段
```http
GET /bank/_search
{
  "query": {
    "match_all": {}  # 查询所有
  },
  "sort": [
    {
      "balance": {
        "order": "desc"
      }
    }
  ],
  "from": 0,
  "size": 10,
  "_source": ["account_number", "balance"]
}
```
##### multi_match[多字段匹配查询]
```http
GET /bank/_search
{
  "query": {
    "multi_match": {
      "query": "mill movico",
      "fields": ["address", "city"]
    }
  }
}
```
##### bool[复合查询]
```http
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "gender": "M"
          }
        },
        {
          "match": {
            "address": "mill"
          }
        }
      ],
      "must_not": [
        {
          "match": {
            "age": 38
          }
        }
      ],
      "should": [
        {"match": {
          "lastname": "Holland"
        }}
      ]
    }
  }
}
```
##### 聚合查询
搜索address中包含mill的所有人的年龄分布以及平均年龄
```http
GET /bank/_search
{
  "query": {
    "match": {
      "address": "mill"
    }
  },
  "aggs": {
    "ageAgg": {
      "terms": {
        "field": "age",
        "size": 10
      }
    },
    "ageAvg": {
      "avg": {
        "field": "age"
      }
    }
  },
  "size": 0
}
```
按照年龄聚合，并且请求这些年龄段的这些人的平均薪资
```http
GET /bank/_search
{
  "query": {
    "match_all": {}
  },
  "aggs": {
    "ageAgg": {
      "terms": {
        "field": "age",
        "size": 100
      },
      "aggs": {
        "balanceAvg": {
          "avg": {
            "field": "balance"
          }
        }
      }
    }
  }
}
```
查询出所有年龄分布，并且这些年龄段中的M的平均薪资和F的平均薪资以及这个年龄段的总体平均薪资
```http
GET /bank/_search
{
  "query": {
    "match_all": {}
  },
  "aggs": {
    "aggAge": {
      "terms": {
        "field": "age",
        "size": 100
      },
      "aggs": {
        "aggGender": {
          "terms": {
            "field": "gender.keyword",
            "size": 10
          }
        },
        "balanceAvg": {
          "avg": {
            "field": "balance"
          }
        }
      }
    }
  }
}
```
