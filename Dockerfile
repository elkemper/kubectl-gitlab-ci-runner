FROM ubuntu:16.04
LABEL author="Vlad Belous"

ENV GITLAB_CI_MULTI_RUNNER_VERSION=9.5.0 \
    GITLAB_CI_MULTI_RUNNER_USER=gitlab_ci_multi_runner \
    GITLAB_CI_MULTI_RUNNER_HOME_DIR="/home/gitlab_ci_multi_runner"
ENV GITLAB_CI_MULTI_RUNNER_DATA_DIR="${GITLAB_CI_MULTI_RUNNER_HOME_DIR}/data"

ENV KUBECTL_VERSION=1.7.1

RUN apt-get update \
 && apt-get upgrade -y \ 
 && apt-get install wget sudo jq -y 
 
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      git-core openssh-client curl libapparmor1 \
 && wget -O /usr/local/bin/gitlab-ci-multi-runner \
      https://gitlab-ci-multi-runner-downloads.s3.amazonaws.com/v${GITLAB_CI_MULTI_RUNNER_VERSION}/binaries/gitlab-ci-multi-runner-linux-amd64 \
 && chmod 0755 /usr/local/bin/gitlab-ci-multi-runner \
 && adduser --disabled-login --gecos 'GitLab CI Runner' ${GITLAB_CI_MULTI_RUNNER_USER} \
 && sudo -HEu ${GITLAB_CI_MULTI_RUNNER_USER} ln -sf ${GITLAB_CI_MULTI_RUNNER_DATA_DIR}/.ssh ${GITLAB_CI_MULTI_RUNNER_HOME_DIR}/.ssh \
 && rm -rf /var/lib/apt/lists/*


RUN wget https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl

RUN chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl
RUN mkdir ${GITLAB_CI_MULTI_RUNNER_HOME_DIR}/.kube

COPY rollout-complete.sh /usr/local/bin/rollout-complete
COPY pipeline-track.sh /usr/local/bin/pipeline-track

RUN chmod +x /usr/local/bin/rollout-complete \
    && chmod +x /usr/local/bin/pipeline-track

RUN apt-get clean

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY override-entrypoint.sh /usr/local/bin/override-entrypoint

RUN chmod +x /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/override-entrypoint

VOLUME ["${GITLAB_CI_MULTI_RUNNER_DATA_DIR}"]
WORKDIR "${GITLAB_CI_MULTI_RUNNER_HOME_DIR}"
ENTRYPOINT ["entrypoint"]
