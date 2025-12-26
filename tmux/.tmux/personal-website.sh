SESSION_NAME="personal_website"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then

	tmux new-session -d -s $SESSION_NAME -c ~/dev/personal-website

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/personal-website
	tmux send-keys -t $SESSION_NAME:1 "dc up --watch" C-m

	tmux select-window -t $SESSION_NAME:0
fi

if [ -n "$TMUX" ]; then
	tmux switch-client -t $SESSION_NAME
else
	tmux attach -t $SESSION_NAME
fi
