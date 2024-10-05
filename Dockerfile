# Use the official ParrotOS Security image
FROM parrotsec/security:latest

# Install required packages
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
    net-tools \
    iproute2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set up VNC password
RUN mkdir -p ~/.vnc && x11vnc -storepasswd root ~/.vnc/passwd

# Set up SSH
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Create a script to start LXDE
RUN echo "#!/bin/sh\nstartlxde &" > /usr/bin/start-desktop.sh \
    && chmod +x /usr/bin/start-desktop.sh

# Create a startup script
RUN echo "#!/bin/sh\n\
    service ssh start\n\
    /usr/sbin/sshd -D &\n\
    supervisord -c /etc/supervisor/conf.d/supervisord.conf\n\
    " > /start.sh && chmod +x /start.sh

# Set correct permissions
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf \
    && chmod 644 /etc/nginx/nginx.conf

# Expose ports
EXPOSE 22 80 5900 6080

# Set the entrypoint to our startup script
ENTRYPOINT ["/start.sh"]