FROM ubuntu:16.04

# Environment variables
ENV SSL true
ENV SSL_CN localhost
ENV SSL_C NL
ENV SSL_ST Noord-Holland
ENV SSL_L Amsterdam
ENV MAX_CONCURRENCY 4
ENV NUM_PRESPAWN_CHILDREN 1
ENV LOG_LEVEL warning
ENV MAX_FILE_SIZE 0
ENV HOSTS_ALLOWED localhost
ENV LC_CTYPE en_US.UTF-8

# Setup scripts for LibreOffice Online
ADD /scripts/install-libreoffice.sh /
ADD /scripts/start-libreoffice.sh /
RUN bash install-libreoffice.sh

# Entry point
CMD bash start-libreoffice.sh
