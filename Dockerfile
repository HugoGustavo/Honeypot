FROM ubuntu:16.04

# Configurando SSH
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Instalando utilitarios
RUN apt update -y && apt-get install -y vim sudo
RUN apt update -y && apt-get install -y openssh-client

# Configurando o Firewall
RUN apt update -y && apt-get install -y iptables sudo
RUN adduser root sudo
RUN touch /etc/init.d/iptables.sh
RUN chmod 777 /etc/init.d/iptables.sh
RUN echo "iptables -F" >> /etc/init.d/iptables.sh
RUN echo "iptables -A INPUT -p tcp -m tcp -m multiport --dports 22 -j ACCEPT" >> /etc/init.d/iptables.sh
RUN echo "iptables -A INPUT -m conntrack -j ACCEPT  --ctstate RELATED,ESTABLISHED" >> /etc/init.d/iptables.sh
RUN echo "iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/init.d/iptables.sh
RUN echo "iptables -A INPUT -j DROP" >> /etc/init.d/iptables.sh
RUN echo "iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/init.d/iptables.sh
RUN echo "iptables -A OUTPUT -j DROP" >> /etc/init.d/iptables.sh
RUN echo "iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT" >> /etc/init.d/iptables.sh
RUN echo "iptables -A FORWARD -j DROP" >> /etc/init.d/iptables.sh
RUN echo ". /etc/init.d/iptables.sh" >> /root/.bashrc

# Removendo mensagens desnecessarias
RUN sed -i '41d;42d;43d;44d;45d;46d;47d;48d;49d;50d;51d' /etc/bash.bashrc

# Configurando a captura de comandos no terminal
RUN apt update -y && apt-get install -y ttyrec sudo
RUN mkdir /var/log/.session
RUN echo "ttyrec /var/log/.session/log-root-`date +%d-%m-%Y_%H:%M`.rec" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
