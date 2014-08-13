# Build Hadoop Native Libraries on Ubuntu Trusty Using Docker
=============================================================

## Usage
This repository uses Docker (http://www.docker.io) containers. You can install docker using apt-get or by downloading it directly. See http://docs.docker.com/installation/ubuntulinux/ 
```
sudo apt-get update
sudo apt-get install docker.io
sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker
sudo sed -i '$acomplete -F _docker docker' /etc/bash_completion.d/docker.io
```

### Get this repo
```
git clone https://github.com/trickbooter/docker-devenv.git
```

### To build and tag the container locally
```
cd [repo]/images/hadoop/hadoop-2.4.1/hadoop-build
docker build -t trickbooter/hadoop-build:2.4.1 .
```

### To run the container (and the hadoop build)
```
docker run trickbooter/hadoop-build:2.4.1
```

### To run the container (and the hadoop build) and put the tar on the host
```
docker run -e -v [PATH ON HOST]:/data trickbooter/hadoop-build:2.4.1 /opt/build-native-libs.sh
```
To place the output tar on the host in /home/trickbooter/hnl
```
mkdir /home/trickbooter/hnl
docker run -e /home/trickbooter/hnl:/data trickbooter/hadoop-build:2.4.1 /opt/build-native-libs.sh
```

### To push the native libs to bintray
I use a BinTray package called hadoop-native-libs-x64 and a version labelled 2.4.1.
```
docker run -e BT_USER=[BinTray Username] BT_ACC=[BinTray Username] -e BT_APIKEY=[BinTray API Key] -e BT_REPO=[BinTray Repo] /opt/push-to-bintray.sh
```
Example:
```
docker run -e BT_USER=trickbooter -e BT_ACC=trickbooter -e BT_APIKEY=123456 -e BT_REPO=generic -e BT_PKG=hadoop-native-libs-x64 -e BT_VER=2.4.1 /opt/push-to-bintray.sh
```
