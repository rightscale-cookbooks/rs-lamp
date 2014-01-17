require 'spec_helper'

mysql_name = ''
case backend.check_os[:family]
when 'Ubuntu'
  mysql_name = 'mysql'
when 'RedHat'
  mysql_name = 'mysqld'
end

describe service(mysql_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe "can run MySQL queries on the server" do
  describe "'app_test' database exists" do
    describe command(
      "echo \"SHOW DATABASES LIKE 'app_test'\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /app_test/ }
    end
  end

  describe "'appuser' mysql user is created" do
    describe command(
      "echo \"SELECT User FROM mysql.user\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /appuser/ }
    end
  end

  describe "select tables from a database" do
    describe command(
      "echo \"USE app_test; SELECT * FROM app_test\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /I am in the db/ }
    end
  end

  describe "create database" do
    describe command(
      "echo \"CREATE DATABASE IF NOT EXISTS blah; SHOW DATABASES LIKE 'blah'\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /blah/ }
    end
  end
end

describe port(80) do
  it { should be_listening }
end

describe command('curl --silent --location http://localhost') do
  it { should return_stdout /Basic html serving succeeded/ }
end

describe command('curl --silent --location http://localhost/appserver') do
  it { should return_stdout /PHP configuration=succeeded/ }
end

describe 'Database configuration file is created with correct settings' do
  describe file('/usr/local/www/sites/example/shared/db.php') do
    it { should be_file }
    it { should contain '$hostname_DB = "localhost";' }
    it { should contain '$username_DB = "appuser";' }
    it { should contain '$password_DB = "apppass";' }
    it { should contain '$database_DB = "app_test";' }
  end
  describe file('/usr/local/www/sites/example/current/config/db.php') do
    it { should be_linked_to '/usr/local/www/sites/example/shared/db.php' }
  end
end

describe command('curl --silent --location http://localhost/dbread') do
  it { should return_stdout /I am in the db/ }
end

describe file("/var/lib/rightscale/rs-lamp-app_test.sql.touch") do
  it { should be_file }
end
