FROM alpine:latest

RUN apk update && apk upgrade && apk add bash wget curl git unrar
RUN git clone https://github.com/tarampampam/nod32-update-mirror.git
RUN mkdir -p /root/scripts
RUN mkdir -p /root/nod32mirror
RUN mkdir -p /var/log/nod32-mirror
RUN mv ./nod32-update-mirror/nod32-mirror /root/scripts
RUN mv ./nod32-update-mirror/webroot /root/nod32mirror
COPY settings.conf /root/scripts/nod32-mirror/conf.d/default.conf
COPY bootstrap.sh /root/scripts/nod32-mirror/include/bootstrap.sh
COPY nod32-mirror.sh /root/scripts/nod32-mirror/nod32-mirror.sh
RUN find /root/scripts -type f -name '*.sh' -exec chmod +x {} \;

RUN rm -Rf /nod32-update-mirror/

RUN crontab -l | { cat; echo "0 */3 * * * /root/scripts/nod32-mirror/nod32-mirror.sh -u >> /var/log/nod32-mirror/log.txt"; } | crontab -

CMD ["crond", "-f"]

