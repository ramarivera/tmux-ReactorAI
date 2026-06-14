set -goq @tmux-reactoria-config "$HOME/.config/tmux-reactoria/config.yml"
set -goq @tmux-reactoria-log "info"
set -goq @tmux-reactoria-auto-install "on"

%if "#{==:#{@tmux-reactoria-auto-install},on}"
run-shell -b 'TMUX_PLUGIN_MANAGER_PATH="${TMUX_PLUGIN_MANAGER_PATH:-}" "#{d:current_file}/scripts/install-binary.sh" >/dev/null 2>&1 || true'
%endif

bind-key R run-shell "tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --target \"#{window_id}\""
bind-key C-r run-shell "tmux-reactoria init-config > \"#{@tmux-reactoria-config}\""

# Hook entrypoints run in the background and honor each rule's configured wait.
# The wait gives panes time to settle after layout/window churn before scrollback
# is captured and redacted for AI.
set-hook -g after-new-window "run-shell -b 'tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --honor-wait --target \"#{window_id}\" >/dev/null 2>&1 || true'"
set-hook -g window-layout-changed "run-shell -b 'tmux-reactoria --config \"#{@tmux-reactoria-config}\" --log \"#{@tmux-reactoria-log}\" run-once --honor-wait --target \"#{window_id}\" >/dev/null 2>&1 || true'"
