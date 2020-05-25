FROM jekyll/jekyll
COPY Gemfile Gemfile.lock /srv/jekyll/
RUN bundle config set path vendor/bundle && bundle install