###############################################################
#
# This is migration script that would run flawlessly on an Ubuntu
# machine to install/migrate to hyperledger v1.0
#
# Authored by RapidQube Digital Solutions Pvt. Ltd.
#
###############################################################

#---cleanup----
rm -rfv install.sh
# rm -rfv install.log
rm -rfv get-pip.py

# --------INSTALL GIT------#
echo "Installing Git"
apt-get install git
echo "Installation of Git completed"

# ---INSTALL Go 1.8.3------#
echo "Installing Go 1.8.3Git"
# remove existing versions of Go
rm -rfv /usr/local/go
# download and install
wget https://raw.githubusercontent.com/rapidvikramv/utilities/master/install.sh
bash install.sh --64
source /home/rpqb/.bashrc
echo $GOPATH
echo "Installation of Go completed"

#---INSTALL NODE & NPM-----#
echo "Installing Node & NPM"
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
apt-get install -y nodejs
apt-get install -y build-essential
nodejs --version
npm -version
echo "Installation of Node & NPM completed"

# ----INSTALL DOCKER------#
# remove existing versions of docker
echo "Removing existing versions of Docker"
apt-get remove docker docker-engine docker.io
apt-get purge docker-ce
rm -rf /var/lib/docker
echo "Removal of existing versions of Docker Complete"

echo "Installing Commmunity edition of Docker"
apt-get update
apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
# verify key signature is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88
apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) \ stable"
apt-get update
apt-get install docker-ce
docker --version
echo "Installation of Docker completed"

 #----INSTALL DOCKER COMPOSE----#
 # Install docker compose v1.15.0
 echo "Installing Docker Composer"
 curl -L https://github.com/docker/compose/releases/download/1.15.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
 # Install PIP
 wget https://bootstrap.pypa.io/get-pip.py
 python get-pip.py
 # Install PIP, behave, docker compose..
 pip install --upgrade pip
 pip install behave nose docker-compose
 pip install --user -I flask==0.10.1 python-dateutil==2.2 pytz==2014.3 pyyaml==3.10 couchdb==1.0 flask-cors==2.0.1 requests==2.4.3 pyOpenSSL==16.2.0 pysha3==1.0b1 grpcio==1.0.4
 # Install PIP packages required for some behave tests
 pip install urllib3 ndg-httpsclient pyasn1 ecdsa python-slugify grpcio-tools jinja2 b3j0f.aop six
 docker-compose --version
 echo "Installation of Docker Composer Completed"

 # ----INSTALL FABRICv1.0---------#
 # Setup fabric folder
echo "Installing of Hyperledger Fabric"
mkdir $GOPATH/src
cd $GOPATH/src
mkdir -p github.com/hyperledger
cd github.com/hyperledger
# Download fabric -
# $$$$$replace LFID with your linux foundation id$$$$#
git clone https://github.com/hyperledger/fabric.git
sudo apt install libtool libltdl-dev
# Build fabric
cd $GOPATH/src/github.com/hyperledger/fabric
make dist-clean all
echo "Installation of Hyperledger Fabric Complete"
#-------------------------------------#
# Writing your first application
cd $GOPATH/src/github.com/hyperledger/fabric
git clone https://github.com/hyperledger/fabric-samples.git
cd fabric-samples
curl -sSL https://goo.gl/eYdRbX | bash
export PATH=$GOPATH/src/github.com/hyperledger/fabric/bin:$PATH
cd first-network
./byfn.sh -m generate
./byfn.sh -m up
