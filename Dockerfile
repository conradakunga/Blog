FROM jekyll/jekyll
COPY Gemfile Gemfile.lock /srv/jekyll/
#RUN apk -U upgrade
RUN apk add rsync
RUN apk add sshpass
RUN apk add openssh 

ARG SSH_PRIVATE_KEY
RUN mkdir /root/.ssh/
RUN echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan hairofthedog.dreamhost.com >> /root/.ssh/known_hosts
chmod 700 /root/.ssh
#chmod 644 /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/id_rsa

RUN bundle config set path vendor/bundle && bundle install