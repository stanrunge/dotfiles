SESSION_NAME="hair-ai"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then
	tmux new-session -d -s $SESSION_NAME -c ~/dev/hair-ai

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/hair-ai/packages/web
	tmux send-keys -t $SESSION_NAME:1 "bun run dev" C-m

	tmux new-window -t $SESSION_NAME:2 -c ~/dev/hair-ai/packages/web
	tmux send-keys -t $SESSION_NAME:2 "cloudflared tunnel --url http://localhost:5173" C-m

	tmux new-window -t $SESSION_NAME:3 -c ~/dev/hair-ai/packages/realtime
	tmux send-keys -t $SESSION_NAME:3 "bun run index.ts" C-m
fi

if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION_NAME
else
	tmux attach -t $SESSION_NAME
fi
