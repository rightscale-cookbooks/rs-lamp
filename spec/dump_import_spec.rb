require_relative 'spec_helper'

describe 'rs-lamp::dump_import' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rs-lamp']['dump_file'] = 'app_test.sql.bz2'
      node.set['rs-application_php']['application_name'] = 'www'
      node.set['rs-mysql']['server_repl_password'] = 'replpass'
      node.set['rs-mysql']['server_root_password'] = 'rootpass'
      node.set['rs-mysql']['application_database_name'] = 'app_test'
    end.converge(described_recipe)
  end

  it 'assures that /var/lib/rightscale directory exists' do
    expect(chef_run).to create_directory('/var/lib/rightscale').with(
      mode: 0755,
      recursive: true
    )
  end

  it 'installs supported compression packages' do
    expect(chef_run).to install_package('gzip')
    expect(chef_run).to install_package('bzip2')
    expect(chef_run).to install_package('xz-utils')
  end

  it 'restores from mysql dump file' do
    expect(chef_run).to query_mysql_database('app_test').with(
      connection: { host: 'localhost', username: 'root', password: 'rootpass' }
    )
  end
end

