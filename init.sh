showBanner(){
    cat conf/banner-init.txt
    echo ""
    sleep 3
}


#Para todos os containers
stopContainers(){
    echo "> Parando todos os ambientes"
    sleep 2
    docker stop $(docker ps -aq)
    echo ""
}

#Remove todos os containers
removeContainers(){
    echo "> Removendo todos os ambientes"
    sleep 2
    docker rm $(docker ps -aq)
    echo ""
    
}

buildDockerImage(){
    echo "> Criando todos os ambientes"
    sleep 2
    docker build -t honeypot .
    echo "" 
}

# Criar ambiente de analise
initializationAnalysisEnvironment(){
    echo "> Inicializando ambiente de analise"
    sleep 2 
    docker run -v /home/hugocunha/Documentos/docker/log:/var/log/session --cap-add=NET_ADMIN -d --name securityHost honeypot
    echo "" 
}

# Criar honeypot
initializationHoneypot(){
    echo "> Inicializando Honeypot"
    sleep 2 
    docker run -v /home/hugocunha/Documentos/docker/log:/var/log/session --cap-add=NET_ADMIN -d -p 22:22 --name honeypot honeypot
    echo ""
}

# Lista Containers Docker
listContainers(){
    echo "> Listando ambientes "
    sleep 2
    docker ps
    echo ""    
}

main(){
    showBanner
    stopContainers
    removeContainers
    buildDockerImage
    initializationAnalysisEnvironment
    initializationHoneypot
    listContainers
}

main
