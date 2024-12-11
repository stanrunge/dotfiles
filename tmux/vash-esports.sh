SESSION_NAME="vash_esports"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then

	tmux new-session -d -s $SESSION_NAME -c ~/dev/vash-esports

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/vash-esports/packages/web
	tmux send-keys -t $SESSION_NAME:1 "sail up -d; sail bun run dev" C-m

	tmux new-window -t $SESSION_NAME:2 -c ~/dev/vash-esports/packages/web
	tmux send-keys -t $SESSION_NAME:2 "sail up -d; sail artisan queue:work" C-m

	tmux new-window -t $SESSION_NAME:3 -c ~/dev/vash-esports/packages/web
fi

tmux select-window -t $SESSION_NAME:0

tmux attach -t $SESSION_NAME
