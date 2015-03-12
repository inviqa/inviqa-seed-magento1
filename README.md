# Hobo project seed (magento specific)

This repository contains the common configuration, structure and tooling necessary to kickstart a magento project in a consistent manner.

It is designed for use with the "hobo seed plant" command. Cloning it directly is not recommended as you will need to manually populate placeholders, initialize submodules and fetch magento sample data.

## Goals

The primary goals of this template are to speed up VM related sprint zero tasks, increase predictability of project structure and increase the robustness of project VMs.

## Structure

The folder structure is as follows:

- __features/__ - Behat feature files
- __spec/__ - PHPSpec specs
- __public/__ - Publically accessible files (docroot)
- __tools/capistrano/__ - Cap config
- __tools/chef/__ - Chef config
- __tools/vagrant/__ - Vagrant config

## Technologies

- Packer stack+nginx base box
- Chef 11.8.2 w/ roles for common services
- Capistrano 2 w/ custom helpers
- Vagrant 1.3+
- knife-solo
- composer
- nginx
- php54

## Differences from the old template

- Berkshelf used instead of librarian-chef for speed and circular resolution
- Common chef service roles included
- Hobo files no longer present (it's a gem now)

## Known limitations
- Due to the same naming scheme used for utility and project buckets naming your project `magento` is not recommended.

   Instead of 
   `hobo seed plant magento --seed=magento` 
   try 
   `hobo seed plant myshop --seed=magento`
- Uper case letter in project name causes infinite redirect by Magento.

   Instead of 
   `hobo seed plant testShop --seed=magento` 
   try 
   `hobo seed plant testshop --seed=magento`
