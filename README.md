# rs-lamp cookbook

[![Build Status](https://travis-ci.org/rightscale-cookbooks/rs-lamp.png?branch=master)](https://travis-ci.org/rightscale-cookbooks/rs-lamp)

Sets up an all-in-one LAMP server with Apache with PHP using MySQL database.

Github Repository: [https://github.com/rightscale-cookbooks/rs-lamp](https://github.com/rightscale-cookbooks/rs-lamp)

# Requirements

* Chef 11 or higher
* Cookbook requirements
  * [marker](http://community.opscode.com/cookbooks/marker)
  * [rs-mysql](https://github.com/rightscale-cookbooks/rs-mysql)
  * [rs-application_php](https://github.com/rightscale-cookbooks/rs-application_php)
* Platform
  * Ubuntu 12.04
  * CentOS 6

# Usage

To setup an all-in-one LAMP server, place the `rs-lamp::default` in the runlist. This recipe will simply setup
some attributes of `rs-mysql` and `rs-application_php` cookbooks. So the runlist must include `rs-mysql::server`
and `rs-application_php::default` recipes in that order.

Example runlist: `["rs-lamp::default", "rs-mysql::server", "rs-application_php::default"]`

To import a MySQL database dump after the setup, place the `rs-lamp::dump_import` recipe in the runlist after the recipes
mentioned above and set the `rs-lamp/dump_file` input. This input should be the location of the dump file relative
to the root of the repository.

# Attributes

* `node['rs-lamp']['dump_file']` - The path of the dump file relative to the root of the repository. This file can be
  compressed using gzip, bzip2, xz, or a plain text file. Example: `'mydb.sql.gz'`

# Recipes

## `rs-lamp::default`

This recipe simply sets up some attributes of `rs-mysql` and `rs-application_php` cookbooks to setup an all-in-one
LAMP server. These attributes will be used by `rs-mysql::server` and `rs-application_php::default` recipes.

## `rs-lamp::dump_import`

This recipe imports a dump file given the location of the dump file relative to the root of the repository in the
`rs-lamp/dump_file` attribute.

# Author

Author:: RightScale, Inc. (<cookbooks@rightscale.com>)
