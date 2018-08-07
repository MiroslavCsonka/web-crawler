FROM ruby:2.5.1

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .