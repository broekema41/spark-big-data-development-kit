# Spark Big Data Development Kit

Enterprise development kit for big data cloud processing environments. The virtual environment
currently has the following stack:

* spark
* zeppelin
* livy
* flower
* airflow

![stack](/stack.gif)

We assume intermediate level knowledge of [kubernetes](https://minikube.sigs.k8s.io/) with [helm](https://helm.sh/) for you to be comfortable navigating, extending, developing with this setup.

```shell
# Please make sure to clone the repository into the /var/www/ folder.
git clone git@github.com:broekema41/spark-big-data-development-kit.git
```

## Required software
In order to use this Vagrant image, you need to have some software installed. The versions below are known to work:
* Oracle VM VirtualBox 6.X.XX (https://www.virtualbox.org/wiki/Downloads)
* Vagrant 2.X.XX (https://releases.hashicorp.com/vagrant/)
* Java 8.xxxx (advise use of https://sdkman.io/ )
* git

## Required Vagrant plugins
Before starting Vagrant for the first time, you need to install the following Vagrant plugins:
(Note: The command to install the plugins is given below, you are free to choose another version, but the versions listed here are known to work)
* All non-windows OSes: `vagrant plugin install vagrant-vbguest --plugin-version 0.25.0`
* Optional: `vagrant plugin install vagrant-notify-forwarder --plugin-version 0.5.0` (if you want to run frontends in `source` mode with working file change watcher)

## OS specific issues

### Windows
If you are a Windows user, your setup *might* not work immediately using vagrant. The following combination of versions is known to work:
- Vagrant `2.2.14`
- vagrant-list `0.0.6` (`vagrant plugin install vagrant-list`)
- vagrant-vbguest `0.21` (`vagrant plugin install vagrant-vbguest --plugin-version 0.21`)
- vagrant-winnfsd `1.4.0` (`vagrant plugin install vagrant-winnfsd --plugin-version 1.4.0`)

### macOS
If you are running macOS, software that is not from Apple or is signed by Apple, needs to be trusted. For VirtualBox this means that every new installation or update of a previous installation needs to be trusted. Navigate to `System Preferences -> Security & Privacy -> General -> Allow system applications` and make sure you allow system software from developer "Oracle America, Inc" to run. You need to repeat this every time you install a new version of VirtualBox. Then, fully reboot your computer.

### Linux
Yes, It works brilliantly.

## NFS version
By default, the Vagrant will use NFSv3 to mount the git repositories from your host machine. This is a slightly older version of NFS which should work in most places, even though NFSv4 is a newer and more performant version. Should you have problems with NFSv3 because your host OS does not support it anymore, or you know that you have a working NFSv4 server running, you can switch NFS versions by setting an environment variable. Before doing a `vagrant up`, make sure the environment variable `VAGRANT_NFS_VERSION` is set and contains the string `4`. This will set the NFS version your Vagrant image uses to connect to your host to NFSv4.

## Starting the Vagrant
```
vagrant up
```
## Logging into your Vagrant image
```
vagrant ssh
```
## Get list of easy commands
Execute the following command inside your vagrant and you will se shorthand commands to start, stop, show the kubernetes containers in their respective namespace:
```
pleh
``` 
![commands](/commands.png)

## Shutting down the Vagrant
```
vagrant halt
```

## Trust CA certificates
We advise to add the auto generated CA certificate to your
trust store. The certificate wil be located in **/pki/ca.crt** after first startup.

## Browser access
You can access the project's environment via https://[application].sparkdev.ilionx.cloud

## Running, Developing Spark (getting started spark app)

This project contains folder ./getting-started-spark-app/ that can get you going. It contains an intellij Scala based project
that will count and sort the words in this README file. Opening the folder with intellij will give you run configuration (.run folder)
to start building, run/debug against the cluster.

### Running spark job via the command line
```shell
./spark-2.4.6/bin/spark-submit --master spark://172.28.127.137:7077 dags/spark.jar
```
