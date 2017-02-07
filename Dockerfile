FROM ruby:2.3

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends nodejs postgresql-client \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD rails server -b 0.0.0.0 -p 3000
