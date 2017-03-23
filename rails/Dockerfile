FROM ruby:2.4.0

ENV APP_FOLDER /rails_setup

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl sudo mysql-client libmysqlclient-dev && \
    curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash - && sudo apt-get install -y nodejs && \
    mkdir ${APP_FOLDER}
WORKDIR ${APP_FOLDER}
ADD . ${APP_FOLDER}
RUN bundle install

CMD ["/bin/bash"]
