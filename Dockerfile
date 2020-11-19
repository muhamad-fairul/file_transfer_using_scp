FROM ubuntu:20.04

RUN apt-get update && apt-get install -y openssh-server
RUN apt-get install -y git build-essential
RUN apt-get install -y software-properties-common
RUN apt-get update
RUN mkdir /var/run/sshd
RUN echo 'root:Intel123!' | chpasswd
RUN sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

ENV NOTVISIBLE="in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

#create file
RUN mkdir /scp
WORKDIR /scp
RUN dd if=/dev/urandom of=random.txt count=1024 bs=10M
RUN ls

#run scp
RUN scp random.txt root@192.168.218.35:/usr/local/mesh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
