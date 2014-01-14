site :opscode

metadata

cookbook 'collectd', github: 'EfrainOlivares/chef-collectd', ref: 'ec50609ed6eb193e0411f30aced91befa571940f'
cookbook 'rs-mysql', github: 'rightscale-cookbooks/rs-mysql', branch: 'white_13_07_acu111890_migrate_rs_mysql_application_cookbook'
cookbook 'rs-application_php', github: 'rightscale-cookbooks/rs-application_php', branch: 'white_14_01_acu145262_database_dump_file'
cookbook 'application_php', path: '../application_php'

group :integration do
  cookbook 'apt', '~> 2.3.0'
  cookbook 'yum', '~> 2.4.2'
  cookbook 'curl', '~> 1.1.0'
end
