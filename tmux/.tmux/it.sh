SESSION_NAME="it"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
	tmux new-session -d -s $SESSION_NAME -c ~/dev/it

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/it/packages/web
	tmux send-keys -t $SESSION_NAME:1 "bun run dev" C-m

	tmux new-window -t $SESSION_NAME:2 -c ~/dev/it/packages/web
	tmux send-keys -t $SESSION_NAME:2 "cloudflared tunnel --url http://localhost:5173" C-m
fi

if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION_NAME
else
	tmux attach -t $SESSION_NAME
fi
