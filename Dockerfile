FROM ubuntu:16.04

MAINTAINER Paapa Abdullah Morgan <paapaabdullahm@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
    ANDROID_HOME=/opt/android-sdk-linux \
    NODE_VERSION=6.10.3 \
    NPM_VERSION=5.0.1 \
    IONIC_VERSION=3.3.0 \
    CORDOVA_VERSION=7.x

# Install basics
RUN apt update \
    && apt install -y python-software-properties software-properties-common \
    build-essential git wget curl unzip ruby \

    && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && apt install -y nodejs \
    
    && npm install -g npm@"$NPM_VERSION" \
    && npm install -g cordova@"$CORDOVA_VERSION" ionic@"$IONIC_VERSION" \
    && npm cache clear \

    && gem install sass \

    && ionic start myApp sidemenu \


#JAVA STUFF
    && add-apt-repository ppa:webupd8team/java -y \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/&& debconf-set-selections \
    && apt update && apt -y install oracle-java7-installer \

#ANDROID STUFF
    && echo ANDROID_HOME="${ANDROID_HOME}" >> /etc/environment \
    && dpkg --add-architecture i386 \
    && apt update && \
    && apt install -y --force-yes expect ant wget libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 qemu-kvm kmod \
    && apt clean \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \

# Install Android SDK
    && cd /opt \
    && wget --output-document=android-sdk.tgz --quiet http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz \
    && tar xzf android-sdk.tgz \
    && rm -f android-sdk.tgz \
    && chown -R root. /opt

# Setup environment

ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools:/opt/tools

# Install sdk elements
COPY tools /opt/tools

RUN chmod -R 777 /opt/tools/android-accept-licenses.sh

RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter platform-tools,tools,build-tools-23.0.2,android-23,extra-android-support,extra-android-m2repository,extra-google-m2repository"]
RUN unzip ${ANDROID_HOME}/temp/*.zip -d ${ANDROID_HOME}

WORKDIR myApp
EXPOSE 8100 35729
CMD ["ionic", "lab"]
