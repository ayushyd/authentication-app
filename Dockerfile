# Base image
FROM ruby:3.2

# Set environment variables
ENV RAILS_ENV=development \
    BUNDLE_PATH=/gems \
    BUNDLE_BIN=/gems/bin \
    PATH=/gems/bin:$PATH

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    yarn \
    sqlite3 \
    libsqlite3-dev

# Set working directory
WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock /app/
RUN bundle install

# Copy the application code
COPY . /app

# Precompile assets (for production)
RUN bundle exec rake assets:precompile

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
