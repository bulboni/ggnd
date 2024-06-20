FROM debian
ENV DEBIAN_FRONTEND=noninteractive

# Update, upgrade and install necessary packages
RUN apt update && apt upgrade -y && apt install -y \
    ssh tmate ufw sudo

# Setup `ufw` rules to allow traffic on port 443
# Note: Adding `ufw` setup to the startup script to ensure it runs at container start.
RUN mkdir /run/sshd \
    && echo "sleep 5" >> /openssh.sh \
    && echo "ufw enable" >> /openssh.sh \
    && echo "ufw allow 443" >> /openssh.sh \
    && echo "tmate -F &" >> /openssh.sh \
    && echo '/usr/sbin/sshd -D' >> /openssh.sh \
    && echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config \
    && echo root:147|chpasswd \
    && chmod 755 /openssh.sh

# Expose necessary ports
EXPOSE 80 443 3306 4040 5432 5700 5701 5010 6800 6900 8080 8888 9000

# Define the entrypoint script to run
CMD /openssh.sh
