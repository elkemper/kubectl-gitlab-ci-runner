#! /bin/sh
if [ -d "/home/gitlab_ci_multi_runner/ssh-keys" ]; then
    cp /home/gitlab_ci_multi_runner/ssh-keys/* /home/gitlab_ci_multi_runner/.ssh/
fi
entrypoint