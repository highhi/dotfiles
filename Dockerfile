FROM centos:7

RUN yum update -y
RUN yum install -y git make autoconf curl wget vim sudo which less
RUN yum install -y gcc-c++ openssl-devel readline-devel zlib-devel bzip2 gcc sqlite-devel

ARG user=tester

# ユーザーの追加とsudo権限の付与
RUN useradd -d /home/$user $user &&\
  echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$user

# ユーザーの変更とHOMEへの移動
USER $user
WORKDIR /home/$user

# rbenvのインストール
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv &&\
  # `rbenv install`コマンドを使うためにruby-buildをインストール
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc &&\
  echo 'eval "$(rbenv init --no-rehash -)"' >> ~/.bashrc

RUN exec $SHELL -l
RUN rbenv local 2.6.5
