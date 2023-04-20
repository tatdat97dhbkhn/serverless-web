FROM public.ecr.aws/lambda/ruby:2.7

# Install dependencies needed to run MySQL & Chrome

RUN yum -y install libX11
RUN yum -y install dejavu-sans-fonts
RUN yum -y install procps
RUN yum -y install mysql-devel
RUN yum -y install tree
RUN mkdir /var/task/lib
RUN cp /usr/lib64/mysql/libmysqlclient.so.18 /var/task/lib
RUN gem install bundler
RUN yum -y install wget
RUN yum -y groupinstall 'Development Tools'

# Ruby Gems

ADD Gemfile ${LAMBDA_TASK_ROOT}/
ADD Gemfile.lock ${LAMBDA_TASK_ROOT}/
RUN bundle config set path 'vendor/bundle' && \
    bundle install

# Install chromedriver & chromium
RUN mkdir ${LAMBDA_TASK_ROOT}/bin

# Chromium
RUN wget https://github.com/adieuadieu/serverless-chrome/releases/download/v1.0.0-57/stable-headless-chromium-amazonlinux-2.zip
RUN unzip stable-headless-chromium-amazonlinux-2.zip -d ${LAMBDA_TASK_ROOT}/bin/
RUN rm stable-headless-chromium-amazonlinux-2.zip

# Chromedriver
RUN wget https://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d ${LAMBDA_TASK_ROOT}/bin/
RUN rm chromedriver_linux64.zip

# Copy function code
COPY lambda_function.rb ${LAMBDA_TASK_ROOT}

WORKDIR ${LAMBDA_TASK_ROOT}

RUN tree
RUN ls ${LAMBDA_TASK_ROOT}/bin
# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "lambda_function.lambda_handler" ]
