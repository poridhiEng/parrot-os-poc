# Use the official ParrotOS Security image
FROM parrotsec/core:latest

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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set up VNC password
RUN mkdir -p ~/.vnc && x11vnc -storepasswd your_vnc_password ~/.vnc/passwd

# Configure SSH
RUN mkdir -p /var/run/sshd && \
    echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Create a script to start LXDE
RUN echo "#!/bin/sh\nstartlxde &" > /usr/bin/start-desktop.sh \
    && chmod +x /usr/bin/start-desktop.sh

# Set correct permissions
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf \
    && chmod 644 /etc/nginx/nginx.conf

# Create an init script
RUN echo '#!/bin/sh\n\
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf &\n\
/usr/sbin/sshd\n\
tail -f /dev/null' > /init.sh && chmod +x /init.sh

# Expose ports
EXPOSE 80 5900 6080 22

# Set the entrypoint to the init script
ENTRYPOINT ["/init.sh"]