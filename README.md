# Gitlab CI Mutlirunner with Kubectl

### [Link on Docker-Hub](https://hub.docker.com/r/elkemper/kubectl-gitlab-ci-runner/)

### Last pushed version: 1.9.5.0
- Based on ubuntu 16.04
- Gitalb-CI-Multirunner 9.5.0
- Kubectl 1.7.1

## How to use this image

### Using Composer 
Download docker-compose.yml into any directory, enter your gitlab-ci URL, and project token (from Settings-Runners).
Delete selenium service, and link on it, if you don't need it. And after just run 
`sudo docker-compose up`

### Without Composer
```
$ sudo docker pull elkemper/kubectl-gitlab-ci-runner
$ sudo docker run -d -e CI_SERVER_URL=#{your gitlab-ci URL} \
      -e RUNNER_TOKEN=#{gitlab's project token} \
      -e RUNNER_DESCRIPTION=#{name for runner} \
      -e RUNNER_EXECUTOR=shell \
      -v  /srv/docker/gitlab-runner:/home/gitlab_ci_multi_runner/data \
      -v $HOME/.kube:/home/gitlab_ci_multi_runner/.kube:ro \
      elkemper/kubectl-gitlab-ci-runner
```
