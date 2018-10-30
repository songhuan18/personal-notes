## HDFS客户端操作-Java

##### 导入相应依赖包
```xml
<dependencies>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-common</artifactId>
        <version>2.7.2</version>
    </dependency>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-client</artifactId>
        <version>2.7.2</version>
    </dependency>
    <dependency>
        <groupId>org.apache.hadoop</groupId>
        <artifactId>hadoop-hdfs</artifactId>
        <version>2.7.2</version>
    </dependency>
    <dependency>
        <groupId>junit</groupId>
        <artifactId>junit</artifactId>
        <version>RELEASE</version>
   </dependency>
   <dependency>
        <groupId>org.apache.logging.log4j</groupId>
        <artifactId>log4j-core</artifactId>
        <version>2.8.2</version>
   </dependency>
</dependencies>
```
##### HDFS文件上传
```java
/**
 * HDFS文件上传
 */
@Test
public void testCopyFromLocalFile() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // 源路径根据自己操作系统而定
    fs.copyFromLocalFile(new Path("/Users/songhuan/test.txt"), new Path("/test.txt"));
}
```
##### 测试参数优先级
```java
/**
 * HDFS文件上传
 */
@Test
public void testCopyFromLocalFile() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    // 设置副本数
    configuration.set("dfs.replication", "1");
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // 源路径根据自己操作系统而定
    fs.copyFromLocalFile(new Path("/Users/songhuan/test.txt"), new Path("/test1.txt"));
    fs.close();
}
```
将hdfs-site.xml拷贝至resource目录下
```xml
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>

<configuration>
    <property>
        <name>dfs.replication</name>
        <value>2</value>
    </property>
</configuration>
```
参数优先级：客户端代码设置的副本数的值 > ClassPath(resource)下用户自定义配置文件的副本数 > 服务器设置的副本数

##### HDFS文件下载
```java
/**
 * HDFS文件下载
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void testCopyToLocalFile() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // boolean delSrc 是否将源文件删除
    // Path src 指定要下载的文件路径
    // Path dst 指定将文件下载到的路径
    // boolean useRawLocalFileSystem 是否开启文件校验
    fs.copyToLocalFile(false, new Path("/test1.txt"), new Path("/Users/songhuan"), true);
    fs.close();
}
```
##### HDFS文件删除
```java
/**
 * HDFS文件删除
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void testDelete() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // Path f 删除的源文件路径
    // boolean recursive 如果删除的是文件夹，那么recursive必须设置为true，否则会抛异常
    fs.delete(new Path("/user"), false);
    fs.close();
}
```
##### HDFS文件更名
```java
/**
 * HDFS文件名更改
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void testRename() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    fs.rename(new Path("/text.txt"), new Path("/test.txt"));
    fs.close();
}
```
##### HDFS文件详情查看
```java
/**
 * HDFS文件详情查看
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void testListFiles() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    RemoteIterator<LocatedFileStatus> listFiles = fs.listFiles(new Path("/"), true);
    while (listFiles.hasNext()) {
        System.out.println("================================================================");
        LocatedFileStatus status = listFiles.next();
        // 文件名称
        System.out.println("文件名称：" + status.getPath().getName());
        // 长度
        System.out.println("文件长度：" + status.getLen());
        // 权限
        System.out.println("文件权限：" + status.getPermission());
        // 分组
        System.out.println("文件分组：" + status.getGroup());
        // 副本数量
        System.out.println("副本数：" + status.getReplication());

        // 获取存储块的信息
        BlockLocation[] blockLocations = status.getBlockLocations();
        for (BlockLocation blockLocation : blockLocations) {
            String[] hosts = blockLocation.getHosts();
            for (String host : hosts) {
                System.out.println("host is：" + host);
            }
        }
        System.out.println("================================================================");
    }
    fs.close();
}
```
##### HDFS文件和文件夹判断
```java
/**
 * HDFS文件和文件夹判断
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void testListStatus() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    FileStatus[] fileStatuses = fs.listStatus(new Path("/"));
    for (FileStatus fileStatus : fileStatuses) {
        if (fileStatus.isFile()) {
            System.out.println("f: " + fileStatus.getPath().getName());
        } else {
            System.out.println("d: " + fileStatus.getPath().getName());
        }
        System.out.println("================================================================");
    }
}
```
### HDFS的I/O流操作

##### HDFS文件上传
```java
/**
 * HDFS文件上传
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void putFileToHDFS() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // 创建输入流
    FileInputStream fis = new FileInputStream(new File("/Users/songhuan/io_test.txt"));
    // 创建输出流
    FSDataOutputStream fos = fs.create(new Path("/io_test.txt"));
    // 流拷贝
    IOUtils.copyBytes(fis, fos, configuration);
    // 关闭资源
    IOUtils.closeStream(fos);
    IOUtils.closeStream(fis);
    fs.close();
}
```
##### HDFS文件下载
```java
/**
 * HDFS文件下载
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void getFileFromHDFS() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // 获取输入流
    FSDataInputStream fis = fs.open(new Path("/io_test.txt"));
    // 获取输出流
    FileOutputStream fos = new FileOutputStream(new File("/Users/songhuan/io_test.txt"));
    // 流拷贝
    IOUtils.copyBytes(fis, fos, configuration);
    // 关闭资源
    IOUtils.closeStream(fos);
    IOUtils.closeStream(fis);
    fs.close();
}
```
##### 定位文件读取
> 分块读取HDFS上的大文件

下载第0块
```java
/**
* 定位文件读取
* 下载第0块
*
* @throws URISyntaxException
* @throws IOException
* @throws InterruptedException
*/
@Test
public void readFileSeek0() throws URISyntaxException, IOException, InterruptedException {
   Configuration configuration = new Configuration();
   FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
   // 获取输入流
   FSDataInputStream fis = fs.open(new Path("/hadoop-2.7.7.tar.gz"));
   // 获取输出流
   FileOutputStream fos = new FileOutputStream(new File("/Users/songhuan/hadoop-2.7.7.tar.gz.part0"));
   // 流的拷贝
   byte[] buf = new byte[1024];
   for (int i = 0; i< 1024 * 128; i++) {
       fis.read(buf);
       fos.write(buf);
   }
   // 关闭资源
   IOUtils.closeStream(fos);
   IOUtils.closeStream(fis);
   fs.close();
}
```
下载第1块
```java
/**
 * 定位文件读取
 * 下载第1块
 *
 * @throws URISyntaxException
 * @throws IOException
 * @throws InterruptedException
 */
@Test
public void readFileSeek1() throws URISyntaxException, IOException, InterruptedException {
    Configuration configuration = new Configuration();
    FileSystem fs = FileSystem.get(new URI("hdfs://192.168.10.235:9000"), configuration, "hadoop");
    // 获取输入流
    FSDataInputStream fis = fs.open(new Path("/hadoop-2.7.7.tar.gz"));
    // 定位输入数据的位置
    fis.seek(1024 * 1024 * 128);
    // 获取输出流
    FileOutputStream fos = new FileOutputStream(new File("/Users/songhuan/hadoop-2.7.7.tar.gz.part1"));
    // 流拷贝
    IOUtils.copyBytes(fis, fos, configuration);
    // 关闭资源
    IOUtils.closeStream(fos);
    IOUtils.closeStream(fis);
    fis.close();
}
```
Linux文件合并：cat hadoop-2.7.7.tar.gz.part1 >> hadoop-2.7.7.tar.gz.part0
windows文件合并:type hadoop-2.7.2.tar.gz.part1 >> hadoop-2.7.2.tar.gz.part0
