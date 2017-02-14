FROM ruby:2.3-alpine

WORKDIR /usr/src/app

RUN \
  apk --update --upgrade add --no-cache --virtual .builddeps \
    build-base \
    tzdata \
    libxml2-dev \
    libxslt-dev \
    postgresql-dev \
    curl \
    fontconfig \
    nodejs && \
  gem install bundler

# Copy the Gemfile and install the listed gems.
ADD Gemfile .
RUN bundle install

# Copy the project files.
COPY . .

# Install custom phantomjs build (headless WebKit).
RUN \
  curl -L \
    https://github.com/Overbryd/docker-phantomjs-alpine/releases/download/2.11/phantomjs-alpine-x86_64.tar.bz2 | tar xj && \
  mv phantomjs/ /usr/share/ && \
  ln -s /usr/share/phantomjs/phantomjs /usr/local/bin/phantomjs && \
  phantomjs --version

# Clean up.
RUN \
  find / -type f -iname \*.apk-new -delete && \
  rm -rf /var/cache/apk/* && \
  rm -rf /usr/lib/lib/ruby/gems/*/cache/* && \
  rm -rf ~/.gem

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
