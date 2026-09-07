FROM ubuntu:24.04
ARG ANSIBLE_CORE=2.16.16
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-venv openssh-server openssh-client sudo passwd ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN python3 -m venv /opt/ansible \
    && /opt/ansible/bin/pip install --no-cache-dir ansible-core==${ANSIBLE_CORE}
ENV PATH="/opt/ansible/bin:${PATH}"
RUN mkdir -p /run/sshd /etc/sudoers.d
CMD ["python3", "/repo/tests/fixtures/contributor/lifecycle.py"]
