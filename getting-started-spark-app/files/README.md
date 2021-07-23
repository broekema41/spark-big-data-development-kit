# C-CAM Vagrant

## Cloning the repo
This repo should be cloned on the same level as the development repositories. The `Vagrantfile` mounts the required repositories relative to itself. You *absolutely* need to clone this repository in a directory named `ccam-dev-vagrant`. The location on the disk does not matter, but the directory name must be exactly `ccam-dev-vagrant`, that is without the suffix `.git`. This is also the case for any code repositories that you will be cloning later. These must always be cloned using the name of the GitHub repository, without the `.git` suffix.

Vagrant does not require any specific other repositories to be cloned. It will start all by itself, but projects inside Vagrant might require specific repositories to be cloned on disk. These will always need to be cloned next to where you cloned `ccam-dev-vagrant` itself. Refer to the project documentation for details.

## Required software
In order to use this Vagrant image, you need to have some software installed. The versions below are known to work:
* Oracle VM VirtualBox 6.1.22 (https://www.virtualbox.org/wiki/Downloads)
* Vagrant 2.2.16 (https://releases.hashicorp.com/vagrant/)

## Required Vagrant plugins
Before starting Vagrant for the first time, you need to install the following Vagrant plugins:
(Note: The command to install the plugins is given below, you are free to choose another version, but the versions listed here are known to work)
* All non-windows OSes: `vagrant plugin install vagrant-vbguest --plugin-version 0.25.0`
* Optional: `vagrant plugin install vagrant-notify-forwarder --plugin-version 0.5.0` (if you want to run frontends in `source` mode with working file change watcher)

## OS specific issues

### Windows
If you are a pesky Windows user, your setup *might* not work immediately using vagrant. The following combination of versions is known to work:
- Vagrant `2.2.14`
- vagrant-list `0.0.6` (`vagrant plugin install vagrant-list`)
- vagrant-vbguest `0.21` (`vagrant plugin install vagrant-vbguest --plugin-version 0.21`)
- vagrant-winnfsd `1.4.0` (`vagrant plugin install vagrant-winnfsd --plugin-version 1.4.0`)

### macOS
If you are running macOS, make sure the Intel Power Gadget (brew package `intel-power-gadget`) is not installed. This uses a kernel extension `EnergyDriver` which can cause corruption in your VirtualBox VM. Make sure the gadget and the kext is not installed on your system.

Furthermore, on macOS, software that is not from Apple or is signed by Apple, needs to be trusted. For VirtualBox this means that every new installation or update of a previous installation needs to be trusted. Navigate to `System Preferences -> Security & Privacy -> General -> Allow system applications` and make sure you allow system software from developer "Oracle America, Inc" to run. You need to repeat this every time you install a new version of VirtualBox. Then, fully reboot your computer.

### Linux
Running Linux is like driving an Alfa Romeo: it works brilliantly, but occasionally you run into issues. Since every issue is different, just fix it on your own, and then it will work brilliantly again. Tip: use Google.

## NFS version
By default, the Vagrant will use NFSv3 to mount the git repositories from your host machine. This is a slightly older version of NFS which should work in most places, even though NFSv4 is a newer and more performant version. Should you have problems with NFSv3 because your host OS does not support it anymore, or you know that you have a working NFSv4 server running, you can switch NFS versions by setting an environment variable. Before doing a `vagrant up`, make sure the environment variable `VAGRANT_NFS_VERSION` is set and contains the string `4`. This will set the NFS version your Vagrant image uses to connect to your host to NFSv4.

## Required accounts
You need to have a Hawaii Access Proxy non-production account. This is required to access VodafoneZiggo internal resources over the internet. To verify this, open the following page in your browser: https://ap.haw.vodafone.nl/auth/realms/hawaii-factory/account . You will be requested to log in with a username, password, and OTP code. After login, you will be presented with your personal data. You will need this information when starting the Vagrant image for the first time (and when updating your client certificate), so be sure to write it down.

## Starting the Vagrant
```
vagrant up
```

If you are running Windows, you will get a Windows Firewall popup for WinNFSd. Be sure to tick all the boxes (Domain, Private, and Public) and Allow the NFS daemon to pass the firewall. If you forgot this, you will need to go back into the Windows Firewall options, click Advanced Settings, find the winnfsd.exe executable and allow all network types in there, or your NFS mounts in Vagrant will not work.

## First-time startup
The first time you start your Vagrant image, it will be provisioned for you. To do this, you need to have a client certificate generated. Vagrant will prompt you to create this certificate, and will refuse to start until you have done so. Follow the instructions on-screen. This boils down to executing the script `ccam-dev-vagrant/hawaiicert/create_certificate.sh` using a Bash interpreter (use the one from your OS or Git Bash on Windows). Be sure to use the credentials show in the screen from the previous section if you are unsure about your account details, or this will fail.

Once your certificate is generated, the Vagrant startup will continue, and your image will be provisioned for you. This will take a few minutes, and requires a fully capable internet connection.

## Subsequent startups
After your first-time startup, subsequent startups of Vagrant will be much faster, since your image does not need to be provisioned anymore. However, there will be some checks executed every time the image starts. The certificate you created and the account you are using for the Hawaii Access Proxy will be validated every time. If your certificate has expired, or your username or password has changed, this will fail and the startup of Vagrant will generate an error. Follow the instructions on-screen to resolve the situation. Basically, this will boil down to the following:

1. Stop your Vagrant image with `vagrant halt -f`
1. Create a new certificate by running the script `ccam-dev-vagrant/hawaiicert/create_certificate.sh` again in Bash
1. Start your Vagrant image again with `vagrant up`

At this point the checks will be executed again, where they should normally succeed. You image will be updated and you will be good to go.

## Logging into your Vagrant image
```
vagrant ssh
```

## Get help
Execute the following command inside your vagrant:
```
pleh
```

## Configure project
1. Open the file `config/[project]/values.yaml` with a text editor;
1. Edit this file to your own preferences
    1. Change `run_mode` (check the separate paragraph for more details);
    1. Change the docker image (usually required if you're working on a specific project and require custom images)
1. (Re)start the project

## Run mode
Because the Vagrant can be used for multiple purposes we have added a option for local development. That option allows a developer of a backend component (for example) to have the application he is working on, running on his host machine. Because we want our applications to work both from a docker container and from a local instance we have added the option `run_mode` to the `values.yaml` file of every project.

In this file you can change the reverse proxy setup we currently have for all applications, to point to the docker container (inside the Vagrant) or to the instance you started locally.

There are currently two run modes:
1. container - Runs the docker image that is pulled from the docker registry
1. host - Only run's the reverse proxy and will forward requests to your local machine

The value you specified in the variable `run_mode` will also result in different configuration to be loaded.
In that same `values.yaml` file there are two sections that allow custom configuration for eather the `host` or `container` run mode.

For each project (in the `helm` directory) that has the option to re-configure it to your personal wishes, there is also a corresponding `config` directory in the root of the Vagrant git repository. Open this `config` directory and locate the file `values_default.yaml`. This contains the default configuration. If this is fine for your usage, no need to change anything. This file will be used, and you can start the project. If you wish to do something different, copy the file `values_default.yaml` to `values.yaml` and modify it as required. Then, stop the project, and start it again. It will now be deployed with your new configuration options instead of the default options.

Important: The `values.yaml` files are kept outside of git with the `.gitignore` file. This means that you need to keep them up-to-date yourself, should something change in the `values_defaults.yaml`. This is your own responsibility!

## Accessing applications from your local workstation
When working with this Vagrant image and running applications inside the Vagrant image (inside Docker/Kubernetes) you might want to access the application running in there from your local workstation.
To do that (for example for the OracleDB) you can access the image using the IP address `172.28.127.137`. This IP address is specific to this Vagrant image (can be changed in the `Vagrantfile` if needed).
You can then, for example, access the Oracle database instance on port `1521`. Most (if not all) services can be accessed like this.
You can find out the port for a service using the following steps:
1. Open the file `service.yaml` inside a application folder of the `helm` directory;
1. Check that the value of `type` is set to `NodePort`;
1. Check that the `ports` array has a `port` section;
1. For that given `port` check that there is a variable `nodePort`;
1. You can use the value of `nodePort` as the port on your local workstation.

There is a specific wildcard DNS record `*.ccamvagrant.ilionx.cloud` which you can also use for this. So the aforementioned Oracle database can also be reached via `oracle.ccamvagrant.ilionx.cloud` on port `1521`. This works both from inside and outside the Vagrant, so you can use this is any project that needs it, no matter where it is run. It only works on your laptop, of course.!

## Default published applications
There are a few applications published by default, which you can always use. These are the following:

1. Artifactory: You can reach the VodafoneZiggo artifactory server under http://artifactory.ccamvagrant.ilionx.cloud/artifactory/ or https://artifactory.ccamvagrant.ilionx.cloud/artifactory/. This uses the HAP proxy container, which will take care of the 2-factor authentication for you automatically. This requires your password to be up-to-date and your SSL certificate valid. Should there be a problem with this, just issue a `vagrant reload` and the Vagrant will check these again and trigger you to change them if needed. This will also automatically restart your HAP proxy container.
1. Verdaccio: You can reach the VodafoneZiggo verdaccio server under http://verdaccio.ccamvagrant.ilionx.cloud/verdaccio/#/. This uses the same HAP proxy as Artifactory, so the same password requirements hold true here. Please note that due to technical rules, you can only use Verdaccio over http, not https.

## Add the `C-CAM Vagrant CA` to the browser trust store
### Firefox
1. Go to: `Preferences` -> `Certificates` -> `View Certificates...` -> `Authorities`  -> `Import`
1. Browse to the `pki` directory inside the `ccam-dev-vagrant` repository
1. Select the `ca.crt` file
1. Select `Trust this CA to identify websites.`
1. Click `OK`

### Chromium
1. Go to: `Settings` -> `Manage certificates` -> `Authorities` -> `Import`
1. Browse to the `pki` directory inside the `ccam-dev-vagrant` repository
1. Select the `ca.crt` file
1. Select `Trust this certificate for identifying websites`
1. Click `OK`

### Chrome (on macOs)
1. Browse to the `pki` directory inside the `ccam-dev-vagrant` repository
1. Open the `ca.crt` file
1. Select a keychain (for example 'login') and click add to keychain
1. Open the keychain access app on your mac
1. Click on your selected keychain and then the `Certificates` category
1. Look up `C-CAM Vagrant CA` and double click it
1. Open the trust expander and `Always trust` the certificate
1. Close the panel and enter your password
1. You should not need to restart your browser for this to work

### Ubuntu
```
sudo cp /opt/hawaii/ccam-dev-vagrant/pki/ca.crt /usr/local/share/ca-certificates/ccam-vagrant-ca.crt
sudo update-ca-certificates
```

Note: The certificate needs to have extension `.crt`, `.cer` will not work!

### Others
Follow the guidelines to add a CA to the trust store for the OS / software you want to use. Consider adding the method to this readme.

## Browser access
You can access the project's environment via https://[project].ccamvagrant.ilionx.cloud. For example [hawaii-ciam](https://hawaii-ciam.ccamvagrant.ilionx.cloud)

## Default projects
By default, the following projects are installed for everyone and can be reached on the specified URLs:

* Jenkins: https://jenkins.ccamvagrant.ilionx.cloud
* Inbucket: https://inbucket.ccamvagrant.ilionx.cloud

# Ports accessible from the workstation
Because we have multiple applications running in the Vagrant you would like to access them from your local workstation (when developing).
This requires a specific port to be available on the Kubernetes node for it to be accessible from outside Kubernetes.
Below is a list applications and there external ports.

| Application               | External port                                             |
| ------------------------- | --------------------------------------------------------- |
| INBUCKET                  | 22500-SMTP<br>21100-POP3<br>29000-WEB                     |
| KAFKA                     | 22181-ZOOKEEPER<br>28081-SCHEMAREGISTRY<br>29092-BROKER   |
| OPENLDAP                  | 7389-LDAP                                                 |
| ORACLE                    | 1521-TNS<br>28080-WEB                                     |
| POSTGRESQL                | 5432-PSQL                                                 |
| REDIS                     | 6379-SERVER<br>26379-SENTINEL                             |
