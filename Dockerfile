FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

ARG RAILS_MASTER_KEY

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /app

RUN bundle exec rake db:migrate RAILS_ENV=development
RUN bundle exec rake db:seed

EXPOSE 3000

CMD ls
