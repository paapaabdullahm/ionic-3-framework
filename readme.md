# **Dockerized Ionic 3 Framework**

> After going through this tutorial, you can follow the [**ionic tutorial**](https://ionicframework.com/docs/intro/tutorial/) (except for the ios part...) without having to install ionic nor cordova nor nodejs on your computer.

&nbsp;  
# Starting a Project with this Framework
&nbsp;   

## Using 'docker run'

**To start a container:**  

```shell
$ docker run -it --rm \
  -p 8100:8100 \
  -p 35729:35729 \
  -v /path/to/your/ionic-project/:/myApp:z \
   pam79/ionic-framework
```

&nbsp;  
**To speed up things, let's create an alias:**

-- First open your '.bashrc' file.

`$ vim ~/.bashrc`

&nbsp;  
-- Add the following at the bottom of the file and save it.

```shell
alias ionic="docker run -ti --rm -p 8100:8100 -p 35729:35729 --privileged -v /dev/bus/usb:/dev/bus/usb -v ~/.gradle:/root/.gradle -v \$PWD:/myApp:rw pam79/ionic-3-framework ionic"
```

&nbsp;  
-- Source the file to reload changes

`$ source ~/.bashrc`

&nbsp;  
-- Finally use the alias to create new projects:

```shell
$ ionic start myApp tabs
$ cd myApp
$ ionic lab
```

&nbsp;  
**To preview your app while you code, visit any of the following links in your web browser:**

`http://localhost:8100`  
`http://localhost:8100/ionic-lab`  
`http://localhost:35729`
  
>Your docker host **ip address** can also be used in place of **localhost**

&nbsp;  
**To use the alias to test your app on your android device, just make sure that debugging is enabled**

```shell
$ cd myApp
$ ionic platform add android
$ ionic build android
$ ionic run android
```

&nbsp;  

## Using 'docker-compose.yml' file

**Let’s start by making a local directory for gradle, so you don’t have to install it each time you run your ionic docker container**

`$ mkdir ~/.gradle`

&nbsp;  
**Create compose file in your project root**

```shell
$ mkdir -p Projects/my-app
$ cd Projects/my-app
$ sudo vim docker-compose.yml
```

&nbsp;    
**Add the following content to it:**

```yml
version: '2.1'

services:

  my-app:
    image: pam79/ionic-3-framework
    container_name: my-app
    privileged: true
    volumes:
      - ./:/myApp:z
      - ~/.gradle:/root/.gradle
      - /dev/bus/usb:/dev/bus/usb
    tty: true
    stdin_open: true
```

&nbsp;  
**Initialise a new ionic project in your Projects directory**

`$ docker-compose run --rm my-app ionic start my-app blank`  

&nbsp;  
**Move the contents of the installation directory to the parent working directory and remove the folder now because it's empty**

$ sudo mv my-app/{.,}* . && sudo rm -r my-app

&nbsp;  
**Run the project in detached mode with the `-d` flag**

`$ docker-compose up -d`

&nbsp;  
**To preview your app while you code, visit any of the following links in your web browser:**

`http://localhost:8100`  
`http://localhost:8100/ionic-lab`  
`http://localhost:35729` **<--------live-reload--------:**
 
>Your docker host **ip address** can also be used in place of **localhost**

&nbsp;
**Publish your App when done coding**

`$ docker-compose run my-app ionic build android --release`

&nbsp;    
**If you haven’t already done this, you’ll need to create a private key. You’ll only need to do this one time.**

```shell
$ keytool -genkey -v \
  -keystore my-release-key.keystore \
  -alias alias_name \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

&nbsp;  
**Sign the apk with Jarsigner**

```shell
$ docker-compose run my-app jarsigner \
  -verbose \
  -sigalg SHA1withRSA \
  -digestalg SHA1 \
  -keystore my-release-key.keystore \
  platforms/android/build/outputs/apk/android-release-unsigned.apk alias_name
```

&nbsp;  
**Now we need to run Zipalign**

> In this example we’re creating our 2.1.4 release (android-2.1.4-release.apk). In yours, you’ll replace the output at the end with the name of your own release.

```shell
$ docker-compose run my-app \
  /opt/android-sdk-linux/build-tools/23.0.2/zipalign -v 4 \
  /myApp/platforms/android/build/outputs/apk/android-release-unsigned.apk \
  /myApp/platforms/android/build/outputs/apk/android-2.1.4-release.apk
```

&nbsp;  
**Now you can upload the APK `android-2.1.4-release.apk` to the Google Play store and start getting downloads:**

&nbsp;  

## Coming Up Next


**Support for android emulation with X11 forwarding**

&nbsp;                        
-- With docker run via `ionic` alias 

`$ ionic platform emulate android`  

&nbsp;  
-- With docker-ompose  

`$ docker-compose run my-app ionic platform emulate android`
