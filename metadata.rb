name             'rs-lamp'
maintainer       'RightScale, Inc.'
maintainer_email 'cookbooks@rightscale.com'
license          'Apache 2.0'
description      'Installs/Configures rs-lamp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'marker', '~> 1.0.0'
depends 'rs-mysql'
depends 'rs-application_php'

recipe 'rs-lamp::default', 'Configures attributes for running a standalone LAMP server'
recipe 'rs-lamp::dump_import', 'Imports a database dumpfile'

attribute 'rs-lamp/dump_file',
  :display_name => 'Dump File',
  :description => 'The path relative to the repository root of a MySQL database dump file to be imported. This file can be comressed using gzip, bzip2, xz or a plain text file. Example: mydb.sql.gz',
  :required => 'optional',
  :recipes => ['rs-lamp::dump_import']
