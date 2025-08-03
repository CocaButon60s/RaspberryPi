FROM ubuntu:24.10

COPY <<EOL /etc/sudoers.d/ubuntu
ubuntu ALL=(ALL) NOPASSWD:ALL

EOL

RUN <<EOL
apt-get update

apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 python3-subunit zstd file locales libacl1 lz4

apt-get install -y sudo neovim curl

locale-gen en_US.UTF-8
EOL