FROM alpine:latest

RUN apk update && apk upgrade && apk add bash wget curl git unrar supervisor

RUN git clone https://github.com/tarampampam/nod32-update-mirror.git
RUN mkdir -p /root/scripts
RUN mkdir -p /root/nod32mirror
RUN mv ./nod32-update-mirror/nod32-mirror /root/scripts
RUN mv ./nod32-update-mirror/webroot /root/nod32mirror
COPY settings.conf /root/scripts/nod32-mirror/conf.d/default.conf
COPY bootstrap.sh /root/scripts/nod32-mirror/include/bootstrap.sh
OPY bootstrap.sh /root/scripts/nod32-mirror/include/nod32-mirror.sh
RUN find /home/scripts -type f -name '*.sh' -exec chmod +x {} \;

RUN rm -Rf /nod32-update-mirror/

RUN echo '0 */3 * * * root /var/log/nod32-mirror/nod32-mirror.sh --update >> /var/log/nod32-mirror/log.txt' > /etc/crontab
RUN touch /var/log/nod32-mirror/log.txt

CMD ["cron", "-f"]
