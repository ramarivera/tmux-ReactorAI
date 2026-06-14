set -goq @tmux-reactoria-config "$HOME/.config/tmux-reactoria/config.yml"
set -goq @tmux-reactoria-log "info"

bind-key R run-shell "tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --target \"#{window_id}\""
bind-key C-r run-shell "tmux-reactoria init-config > \"#{@tmux-reactoria-config}\""

# Hook entrypoints run in the background and honor each rule's configured wait.
# The wait gives panes time to settle after layout/window churn before scrollback
# is captured and redacted for AI.
set-hook -g after-new-window "run-shell -b 'tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --honor-wait --target \"#{window_id}\" >/dev/null 2>&1 || true'"
set-hook -g window-layout-changed "run-shell -b 'tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --honor-wait --target \"#{window_id}\" >/dev/null 2>&1 || true'"
