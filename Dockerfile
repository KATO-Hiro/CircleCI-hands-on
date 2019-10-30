FROM ruby:2.6.3

# Run updates
RUN apt-get update -qq && apt-get install -y build-essential node.js

# Set root dir for app
ENV HOME /root
ENV APP_ROOT /usr/local/app

RUN mkdir $APP_ROOT
WORKDIR $APP_ROOT

# from file path in host to file path in Docker image
COPY Gemfile* $APP_ROOT/

# Install gems
RUN bundle install && bundle clean

# Upload source
COPY . $APP_ROOT
