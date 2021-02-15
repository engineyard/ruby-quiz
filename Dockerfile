FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs

RUN mkdir -p /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

ARG RAILS_MASTER_KEY
ARG db_yml_password
ARG db_yml_database
ARG db_yml_username
ARG db_yml_host
ENV RAILS_MASTER_KEY=${RAILS_MASTER_KEY}
ENV db_yml_password=${db_yml_password}
ENV db_yml_database=${db_yml_database}
ENV db_yml_username=${db_yml_username}
ENV db_yml_host=${db_yml_host}

RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . /app

RUN bundle exec rake db:migrate RAILS_ENV=development

EXPOSE 3000

CMD ls
