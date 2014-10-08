site :opscode

metadata

cookbook 'collectd', github: 'EfrainOlivares/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'mysql', github: 'rightscale-cookbooks-contrib/mysql', branch: 'rs-fixes'
cookbook 'rs-mysql', github: 'rightscale-cookbooks/rs-mysql', branch: 'st_14_13_acu173881_update_new_os'
cookbook 'rs-application_php', github: 'rightscale-cookbooks/rs-application_php', branch: 'st_14_13_acu173881_update_new_os'
cookbook 'application_php', github: 'lopakadelp/application_php', branch: 'updates_for_apache_24'
cookbook 'dns', github: 'lopakadelp/dns', branch: 'rightscale_development_v2'
cookbook 'database', github: 'douglaswth-cookbooks/database', branch: 'rs-fixes'

group :integration do
  cookbook 'apt', '~> 2.3.0'
  cookbook 'yum-epel', '~> 0.4.0'
  cookbook 'curl', '~> 1.1.0'
  cookbook 'rhsm', '~> 1.0.0'
end
