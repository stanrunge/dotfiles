SESSION_NAME="stikstof"

tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? != 0 ]; then

	tmux new-session -d -s $SESSION_NAME -c ~/dev/stikstofvrij-bouwen

	tmux send-keys -t $SESSION_NAME:0 "nvim ." C-m

	tmux new-window -t $SESSION_NAME:1 -c ~/dev/stikstofvrij-bouwen
	tmux send-keys -t $SESSION_NAME:1 "dc up --watch" C-m
fi

tmux select-window -t $SESSION_NAME:0

tmux attach -t $SESSION_NAME
