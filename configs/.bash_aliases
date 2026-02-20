alias ls='eza'
alias lsla='eza -la --header --group --time-style=long-iso'
alias ll='lsla'
alias bat='batcat'
alias fd='fdfind'

# DOCKER
alias docker_get_cont_ip="sudo docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $1"
alias dockercontls='sudo docker ps -a'
alias docker_remote_image_manifest="sudo docker manifest inspect $1"

