SESSION_NAME="distributor"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
	tmux new-session -d -s $SESSION_NAME -c ~/dev/distributor

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/distributor
	tmux send-keys -t $SESSION_NAME:1 "
if ! docker network inspect traefik_net >/dev/null 2>&1; then
    docker network create traefik_net
fi
dc up -d" C-m
fi

if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION_NAME
else
	tmux attach -t $SESSION_NAME
fi
