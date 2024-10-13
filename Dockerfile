FROM parrotsec/core:latest

RUN apt-get update && apt-get install -y \
    x11vnc \
    xvfb \
    nginx \
    supervisor \
    git \
    python3-pip \
    lxde-core \
    lxterminal \
    openssh-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

RUN mkdir -p ~/.vnc && x11vnc -storepasswd root ~/.vnc/passwd

RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Create a script to start LXDE
RUN echo "#!/bin/sh\nstartlxde &" > /usr/bin/start-desktop.sh \
    && chmod +x /usr/bin/start-desktop.sh

RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf \
    && chmod 644 /etc/nginx/nginx.conf

# Create a startup script that ensures SSH is always running
RUN echo '#!/bin/bash\n\
start_ssh() {\n\
    /usr/sbin/sshd\n\
    echo "Started SSH server"\n\
}\n\
\n\
check_ssh() {\n\
    if ! pgrep sshd > /dev/null\n\
    then\n\
        echo "SSH server is not running. Starting it..."\n\
        start_ssh\n\
    fi\n\
}\n\
\n\
start_ssh\n\
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &\n\
\n\
while true; do\n\
    check_ssh\n\
    sleep 30\n\
done' > /init.sh && chmod +x /init.sh

EXPOSE 80 5900 6080 22

ENTRYPOINT ["/init.sh"]
