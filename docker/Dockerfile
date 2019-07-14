FROM ruby:2.2 
MAINTAINER marko@codeship.com

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs \
  git \
  vim

# Set up Git
ADD .ssh/* /root/.ssh/
# RUN ssh-agent /root/.ssh
RUN git clone git@github.com:m3dw3/vagato.git

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
WORKDIR /vagato

# Install bonmin and ampl
RUN cp bin/bonmin /bin/
RUN cp bin/ampl /bin/

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
RUN gem install bundler && bundle install --jobs 20 --retry 5

ADD database.yml /vagato/config/database.yml

# Expose port 3000 to the Docker host, so we can access it 
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]