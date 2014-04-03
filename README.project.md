# {{name}} Setup

Please follow the below steps to get started, if you encounter any issues installing the dependencies or provisioning the vm please check the [Common Issues](#common-issues) section first.

## Clone the project

Clone the project into your local file system:

```bash
git clone {{git_url}}
```

## Install Dependencies

1. Ensure you are using a ruby managed by rbenv / RVM as system rubies can cause issues. Currently [rbenv](https://github.com/sstephenson/rbenv) is the recommended version manager.

2. Install the latest version of Vagrant from [http://www.vagrantup.com/downloads.html](http://www.vagrantup.com/downloads.html)

3. Install/Update hobo:

    ```bash
    gem install hobo-inviqa
    ```

4. Ensure you have AWS keys correctly configured either using `hobo config` or by setting the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables.

## Provision Environment

You can now build the development environment for the first time. In the project directory, execute the following command:

    $ hobo vm up

You should now be able to access the site at [http://{{hostname}}](http://{{hostname}})

## Hobo Usage

With the hobo enabled environment up and running please make use of the following commands for day to day usage.

```bash
hobo vm start  # Starts the vm without the overhead of provisioning
hobo vm stop   # Graceful halt of the vm
hobo vm ssh    # Start an SSH session on the VM
hobo vm mysql  # Connect to the database on the VM
```

## Common Issues

As setup issues are encountered please detail with step by step fix instructions, and where possible update the project itself to provide a more permanent fix.

 - **I do not have a ruby version manager**
   [rbenv-installer](https://github.com/fesplugas/rbenv-installer) will install rbenv for you.

 - **'Unknown command: hobo' even after installing hobo-inviqa**
   Assuming you use rbenv please run the command
   ```bash
   rbenv rehash  # Enables newly installed gem commands
   ```

 - **Installing the 'vagrant-berkshelf' plugin fails with 'minitar conflict'**
   This is a conflict between berkshelf and librarian-chef, to fix this issue please do the following
   ```bash
   # OSX Users
   /Applications/Vagrant/embedded/bin/gem install minitar --install-dir ~/.vagrant.d/gems
   Overwrite the executable? [yN]  y

   # Linux Users
   /opt/vagrant/embedded/bin/gem install minitar --install-dir ~/.vagrant.d/gems
   Overwrite the executable? [yN]  y

   # Windows Users
   C:\HashiCorp\Vagrant\embedded\bin\gem install minitar --install-dir "%HOME%\.vagrant.d\gems"
   Overwrite the executable? [yN]  y
   ```

   If you have customized the install path of vagrant you will need to adjust the path appropriately.

 - **Ruby stacktrace mentioning 'hostsupdater' during 'hobo vm up'**
   Please remove any {{hostname}} entries from your hosts file and retry

# License

Copyright 2014, Inviqa

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
