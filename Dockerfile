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
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Set up VNC password
RUN mkdir -p ~/.vnc && x11vnc -storepasswd root ~/.vnc/passwd

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

# Set correct permissions
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf \
    && chmod 644 /etc/nginx/nginx.conf

# Expose ports
EXPOSE 80 5900 6080

# Set the entrypoint to supervisord
ENTRYPOINT ["/usr/bin/supervisord"]

# Use CMD to specify the config file
CMD ["-c", "/etc/supervisor/conf.d/supervisord.conf"]