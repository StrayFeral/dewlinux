# View .md files
alias mdview='pandoc "$1" | lynx -stdin'

# DOCKER
alias docker_get_cont_ip="sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1"
alias dockercontls='sudo docker ps -a'
alias docker_remote_image_manifest="sudo docker manifest inspect $1"

