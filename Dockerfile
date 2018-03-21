FROM ubuntu:16.04

LABEL maintainer="Zhou Wei weiofcn@gmail.com"

# 指定sftp登录的相关参数
ENV ftp_user=uftp
ENV ftp_pwd=123456
ENV sftp_port=2222

RUN { \ 
        echo 'deb http://mirrors.163.com/ubuntu/ xenial main restricted universe multiverse'; \
        echo 'deb http://mirrors.163.com/ubuntu/ xenial-updates main restricted universe multiverse'; \
        echo 'deb http://mirrors.163.com/ubuntu/ xenial-backports main restricted universe multiverse'; \
        echo 'deb http://mirrors.163.com/ubuntu/ xenial-security main restricted universe multiverse'; \
        echo 'deb http://mirrors.163.com/ubuntu/ xenial-proposed main restricted universe multiverse'; \
    } > /etc/apt/sources.list

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    openssh-server vsftpd supervisor\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && mkdir -p /var/run/sshd


RUN useradd $ftp_user -m -d /home/$ftp_user/
RUN echo "$ftp_user:$ftp_pwd" |chpasswd 

RUN sed -ri "s/Port 22/Port ${sftp_port}/g" /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN { \ 
        echo 'listen=YES'; \
        echo 'anonymous_enable=NO'; \
        echo 'local_enable=YES'; \
        echo 'write_enable=YES'; \
        echo 'dirmessage_enable=YES'; \
        echo 'use_localtime=YES'; \
        echo 'xferlog_enable=NO'; \
        echo 'connect_from_port_20=YES'; \
        echo 'xferlog_file=/var/log/vsftpd.log'; \
        echo 'chroot_local_user=YES'; \ 
        echo 'secure_chroot_dir=/var/run/vsftpd/empty'; \
        echo 'allow_writeable_chroot=YES'; \
        echo 'pam_service_name=vsftpd'; \
        echo 'rsa_cert_file=/etc/vsftpd.pem'; \
        echo 'rsa_private_key_file=/etc/vsftpd.pem'; \
        echo 'ssl_enable=YES';\
    } > /etc/vsftpd.conf

COPY vsftpd.pem /etc/
RUN chmod a-x /etc/vsftpd.pem && chown uftp:uftp /etc/vsftpd.pem
RUN mkdir -p /var/run/vsftpd/empty

# 2 processes
COPY supervisord.conf /etc/

EXPOSE $sftp_port

VOLUME [ "/var/ftp_data", "/home/uftp" ]

CMD ["supervisord", "-c", "/etc/supervisord.conf"]
