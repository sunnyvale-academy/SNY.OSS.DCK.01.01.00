sudo apt-get update

sudo apt-get install bc
#sudo add-apt-repository -y ppa:jonathonf/python-3.6
#sudo apt-get update


# Python3
#sudo apt-get install -y python3.6
#sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1


# Pip
#sudo apt-get install -y python3-pip
#sudo pip3 install --upgrade pip


# Black 
#sudo pip3 install black


# Dependencies
sudo apt-get -y install dos2unix
#sudo apt-get -y install jq
#sudo apt-get install -y graphviz python-pydot python-pydot-ng python-pyparsing libcdt5 libcgraph6 libgvc6 libgvpr2 jq libpathplan4



# Go
#cd /tmp
#sudo wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz
#sudo tar -xvf go1.13.1.linux-amd64.tar.gz
#sudo mv go /usr/local

# Goimports
#/usr/local/go/bin/go get golang.org/x/tools/cmd/goimports

sudo apt-get install -y wget apt-transport-https gnupg
wget https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public
gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --import public
gpg --no-default-keyring --keyring ./adoptopenjdk-keyring.gpg --export --output adoptopenjdk-archive-keyring.gpg 
rm adoptopenjdk-keyring.gpg
sudo mv adoptopenjdk-archive-keyring.gpg /usr/share/keyrings 
echo "deb [signed-by=/usr/share/keyrings/adoptopenjdk-archive-keyring.gpg] https://adoptopenjdk.jfrog.io/adoptopenjdk/deb xenial main" | sudo tee /etc/apt/sources.list.d/adoptopenjdk.list
sudo apt-get install -y adoptopenjdk-11-hotspot