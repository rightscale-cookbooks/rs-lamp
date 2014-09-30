site :opscode

metadata

cookbook 'collectd', github: 'EfrainOlivares/chef-collectd', branch: 'generalize_install_for_both_centos_and_ubuntu'
cookbook 'mysql', github: 'david-vo/mysql', branch: 'st_14_13_acu173881_add_rhel7_support'
cookbook 'rs-mysql', github: 'rightscale-cookbooks/rs-mysql'
cookbook 'rs-application_php', github: 'rightscale-cookbooks/rs-application_php'
cookbook 'application_php', github: 'arangamani-cookbooks/application_php', branch: 'template_fix_and_application_cookbook_upgrade'
cookbook 'dns', github: 'lopakadelp/dns', branch: 'rightscale_development_v2'
cookbook 'database', github: 'douglaswth-cookbooks/database', branch: 'rs-fixes'

group :integration do
  cookbook 'apt', '~> 2.3.0'
  cookbook 'yum-epel', '~> 0.4.0'
  cookbook 'curl', '~> 1.1.0'
  cookbook 'fake', path: './test/cookbooks/fake'
  cookbook 'rhsm', github: 'rightscale-cookbooks/rhsm'
end
