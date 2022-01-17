FROM ruby:3.1

# ================== Install Firefox & Driver ==================
RUN apt-get update && \
    apt-get install -y xvfb build-essential libffi-dev wget firefox-esr && \
    wget https://github.com/mozilla/geckodriver/releases/download/v0.30.0/geckodriver-v0.30.0-linux64.tar.gz && \
    tar -zxvf geckodriver-v0.30.0-linux64.tar.gz && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin && \
    rm geckodriver-v0.30.0-linux64.tar.gz

WORKDIR /usr/src/app
COPY Gemfile* ./

RUN bundle install

COPY . .

CMD DISPLAY=:0
CMD bundle exec cucumber --publish
