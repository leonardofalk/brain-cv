FROM ruby:2.4.1

# CONFIG START

  ENV OPENCV_HOME /usr/local/
  ENV PROJECT_NAME brain-cv

# CONFIG END

ENV PROJECT_PATH /usr/src/$PROJECT_NAME

# INSTALL DEPENDENCIES
RUN apt-get update -qq && \
    apt-get install -y wget zip build-essential && \
    apt-get install -y cmake libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev && \
    apt-get install -y python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev

# INSTALL OPENCV
# v2.4.13.2 compatible with ruby-opencv gem
# Pull opencv cmake files to a tmp directory, extract and compile, then install
RUN mkdir -p /usr/tmp/
WORKDIR /usr/tmp/
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/2.4.13.2.zip && \
    unzip opencv.zip && \
    mv -f opencv-2.4.13.2 opencv && \
    mkdir -p opencv/release/
WORKDIR opencv/release/
RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=$OPENCV_HOME ..
RUN make
RUN make install
# Change current directory so we can remove temporary install files
WORKDIR ~
RUN rm -rf /usr/tmp/opencv/ /usr/tmp/opencv.zip
RUN gem i ruby-opencv -- --with-opencv-dir=$OPENCV_HOME
