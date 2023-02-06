# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.194.0/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="focal"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

SHELL ["/bin/bash", "-c"]

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends gnupg software-properties-common curl git build-essential zlib1g-dev zlibc libssl-dev libffi-dev libsqlite3-dev libbz2-dev \
  && rm -rf /var/lib/apt/lists/*

USER vscode
WORKDIR /home/vscode

# Install asdf (check https://github.com/asdf-vm/asdf/releases for newest release)
ARG ASDF_VERSION="0.8.1"
ENV ASDF_VERSION=${ASDF_VERSION}
RUN git clone --branch "v${ASDF_VERSION}" --depth 1 https://github.com/asdf-vm/asdf.git "${HOME}/.asdf" \
  && echo -e '\nsource $HOME/.asdf/asdf.sh' >> "${HOME}/.bashrc" \
  && echo -e '\nsource $HOME/.asdf/asdf.sh' >> "${HOME}/.profile" \
  && source "${HOME}/.asdf/asdf.sh" \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

ENV PATH=/home/vscode/.asdf/shims:/home/vscode/.asdf/bin:$PATH

# Install python
ARG PYTHON_VERSION="3.8.2"
ENV PYTHON_VERSION=${PYTHON_VERSION}
RUN asdf plugin add python \
  && asdf install python "${PYTHON_VERSION}" \
  && asdf global python "${PYTHON_VERSION}" \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Instal checkov and pre-commit
RUN pip install --no-cache-dir pre-commit checkov \
  && asdf reshim python \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Install awscli
RUN asdf plugin add awscli \
  && asdf install awscli latest \
  && asdf global awscli latest \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Install terraform
RUN asdf plugin add terraform \
  && asdf install terraform latest \
  && asdf global terraform latest \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Install terraform docs
RUN asdf plugin add terraform-docs \
  && asdf install terraform-docs latest \
  && asdf global terraform-docs latest \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Install tflint
RUN asdf plugin add tflint \
  && asdf install tflint latest \
  && asdf global tflint latest \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

# Install tfsec
RUN asdf plugin add tfsec \
  && asdf install tfsec latest \
  && asdf global tfsec latest \
  && rm -rf /var/tmp/* /tmp/* /var/tmp/.???* /tmp/.???*

USER root
ENV ASDF_DATA_DIR=/home/vscode/.asdf
RUN cp /home/vscode/.tool-versions /root/.tool-versions