
main(){
    # Achando o log mais recente
    LOG="$(ls log -1rt | tail -n1)"
    
    # Entrar no container e executar o log
    docker exec -it securityHost ttyplay "/var/log/.session/$LOG"
}

main


