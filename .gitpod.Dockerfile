# Creating a Dockerfile for our base container
FROM mysql:8.0
# Implementing the scripts for database/table creation and sample data insertion. 
#COPY 01_create_db.sql /docker-entrypoint-initdb.d/01_create_db.sql
#COPY 02_create_data.sql /docker-entrypoint-initdb.d/02_create_data.sql
# Building our customized MySQL docker image and verifying the container state
ENV MYSQL_ROOT_HOST=%
ENV MYSQL_DATABASE=DeBealeCipherDB
ENV MYSQL_USER=DeBealeCipherUser
ENV MYSQL_PASSWORD=root
ENV MYSQL_ROOT_PASSWORD=root
FROM gitpod/workspace-base

# Install dependencies
RUN sudo apt-get install -y build-essential curl libffi-dev libffi7 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5

# ghcup is a replacement for the haskell platform. It manages the development env easily. 
# We use the official instalation script
RUN sudo curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

# Add ghcup to path
ENV PATH=${PATH}:${HOME}/.ghcup/bin

# Set up the environment. This will install the default versions of every tool.
RUN ghcup install ghc
RUN ghcup install hls
RUN ghcup install stack
RUN ghcup install cabal

# change stack's configuration to use system installed ghc.
# By default, stack tool will download its own version of the compiler,
# Setting up this configuration will avoid downloading haskell compiler twice.
# WARNING! Maybe this is not adecuate for your project! use your project wise stack.yaml to change this
RUN stack config set install-ghc --global false
RUN stack config set system-ghc --global true 

# If you want to use your own cabal / stack file delete from here to the end of the file
# ********* DELETE FROM HERE **********
#  v v v v v v v v v v v v v v v v v v 

# Generate the right cabal file. Using cabal init after ghc installation ensures that the right version of base is used
# Otherwise, the template would become deprecated as long as ghcup decides to pick up a different version of ghc.
RUN cabal init \
    --license=MIT \
    --homepage=https://github.com/gitpod-io/template-haskell \
    --author=Gitpod \
    --category=Example \
    --email=contact@gitpod.io \
    --package-name=gitpod-template \
    --synopsis="See README for more info" \
    --libandexe \
    --tests \
    --test-dir=test \
    --overwrite

# similarly, running stack init --force after cabal init, ensures that stack will chose a snapshot compatible with system's ghc
RUN stack init --force

#install power-line fonts in the terminal
FROM gitpod/workspace-full

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y git fontconfig && \
    apt-get clean && \
    rm -rf /var/cache/apt/*

# Clone the Powerline font repository
RUN git clone https://github.com/powerline/fonts.git --depth=1 && \
    cd fonts && \
    ./install.sh && \
    cd .. && \
    rm -rf fonts

# Set the default font for the terminal
RUN echo 'if [ -f /usr/share/fonts/powerline/PowerlineSymbols.otf ]; then' >> /home/gitpod/.bashrc && \
    echo '    POWERLINE_FONT_DIR="/usr/share/fonts/powerline"' >> /home/gitpod/.bashrc && \
    echo '    POWERLINE_FONT="PowerlineSymbols.otf"' >> /home/gitpod/.bashrc && \
    echo '    if [ -z "$(fc-list | grep -i powerline)" ]; then' >> /home/gitpod/.bashrc && \
    echo '        echo "Installing Powerline font..."' >> /home/gitpod/.bashrc && \
    echo '        fc-cache -vf $POWERLINE_FONT_DIR && \\' >> /home/gitpod/.bashrc && \
    echo '        echo "Done."' >> /home/gitpod/.bashrc && \
    echo '    fi' >> /home/gitpod/.bashrc && \
    echo '    export PS1="\[\033[38;5;245m\]\u@\h \[\033[38;5;129m\]\w\[\033[0m\]\n$ "' >> /home/gitpod/.bashrc && \
    echo '    export TERM="xterm-256color"' >> /home/gitpod/.bashrc && \
    echo '    export LANG="en_US.UTF-8"' >> /home/gitpod/.bashrc && \
    echo '    export LC_ALL="en_US.UTF-8"' >> /home/gitpod/.bashrc && \
    echo '    export POWERLINE_CONFIG_COMMAND="powerline-config"' >> /home/gitpod/.bashrc && \
    echo '    source /usr/share/powerline/bindings/bash/powerline.sh' >> /home/gitpod/.bashrc && \
    echo 'fi' >> /home/gitpod/.bashrc

USER gitpod

CMD ["/bin/bash", "-c", "source /home/gitpod/.bashrc && /bin/bash"]

