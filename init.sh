#Para todos os containers
docker stop $(docker ps -aq)

#Remove todos os containers
docker rm $(docker ps -aq)

# Criar ambiente de analise
docker run -v /home/hugocunha/Documentos/docker/teste:/var/log/session --cap-add=NET_ADMIN -d --name securityHost honeypot

# Criar honeypot
docker run -v /home/hugocunha/Documentos/docker/teste:/var/log/session --cap-add=NET_ADMIN -d -p 22:22 --name honeypot honeypot

# Lista Containers Docker
docker ps