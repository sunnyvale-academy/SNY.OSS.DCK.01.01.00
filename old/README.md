# SNY.OSS.DCK.01.01.00
Docker crash course v. 01.00

## Proxy settings

### For Vagrant

Using the command line (Linux syntax)

```
$ export http_proxy="http://<proxy_host>:<proxy_port>"
$ export https_proxy="https://<proxy_host>:<proxy_port>"
$ export VAGRANT_HTTP_PROXY=${http_proxy}
$ export VAGRANT_NO_PROXY="127.0.0.1"
$ vagrant plugin install vagrant-proxyconf
```

Then into the Vagrantfile

```
if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = "http://<proxy_host>:<proxy_port>"
    config.proxy.https    = "https://<proxy_host>:<proxy_port>"
    config.proxy.no_proxy = "localhost*,127.0.0.1"
end
```

For more info, please refer to [vagrant-proxyconf](http://tmatilai.github.io/vagrant-proxyconf/) plugin

### For Docker


Please refer to [this page](https://docs.docker.com/network/proxy/)

### For apt and yum linux utilities

For **apt** please refer to [this page](https://help.ubuntu.com/community/AptGet/Howto/#Setting_up_apt-get_to_use_a_http-proxy)

For **yum**

```
$ cat /etc/yum.conf

[main]
………………
proxy=http://<Proxy-Server-IP-Address>:<Proxy_Port>
proxy_username=<Proxy-User-Name>
proxy_password=<Proxy-Password> 
………………
```


### For Git

```
$ git config --global http.proxy http://<proxy_host>:<proxy_port>
$ git config --global https.proxy https:///<proxy_host>:<proxy_port>
```
