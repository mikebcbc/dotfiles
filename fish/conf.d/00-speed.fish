# Soften fisherman/done cost: it shells out to `lsappinfo` on every pre/post-exec.
# Raise the threshold so short commands never pay for a notification path.
set -g __done_min_cmd_duration 10000
