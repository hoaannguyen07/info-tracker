FROM ruby:3.0.2

RUN apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
    postgresql-client \
    nodejs \
    && rm -rf /var/lib/apt/lists \
    && rm -rf /ttit/tmp/pids/server.pid

WORKDIR /ttit
COPY Gemfile* ./
RUN bundle install

EXPOSE 3000
RUN rails db:setup
CMD ["rails", "server", "-b", "0.0.0.0"]