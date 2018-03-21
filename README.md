# docker-ubuntu-sftp

这个Dockerfile仅仅支持SFTP协议，使用ubuntu16.04的系统，安装和配置SSH/VSFTPD。

# 配置用户名密码和端口

修改`Dockerfile`中的3个参数，来配置登录信息：

```
ENV ftp_user=uftp
ENV ftp_pwd=123456
ENV sftp_port=2222
```

修改`run.sh`中的`-p`参数来保持端口映射与`sftp_port`一致：

```
docker run -t -i -p 2222:2222 -v /var/ftp_data:/home/uftp ubuntu16.04/sftp-ftps
```

# 注意

主机文件目录`/var/ftp_data`中会长期保留FTP用户的数据。