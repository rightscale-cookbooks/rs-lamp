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

describe "Verify that correct dump import was used by checking touch file" do
  it "touch file exists" do
    expect(File).to exist("/var/lib/rightscale/rs-lamp-app_test.sql.touch")
  end
end

describe "Verify database 'app_test' imported" do
 it "should have database 'app_test' created" do
   expect(db.query("SHOW DATABASES LIKE 'app_test'").entries.first['Database (app_test)']).to eq('app_test')
 end
end

describe "Verify 'app_test.app_test' table exists with imported content" do
  it "should have 3 rows of specific content in table 'app_test.app_test' created" do
    db.query("SELECT * FROM app_test.app_test").entries.each.with_index(1) do |row, index|
      expect(row['id']).to eq(index)
      expect(row['name']).to eq("app_test#{index}")
      expect(row['value']).to eq('I am in the db')
      expect(index).to be >= 1
      expect(index).to be <= 3
    end
  end
end

describe "can run queries on the server via mysql cli" do
  describe command(
    "echo \"SHOW DATABASES LIKE 'app_test'\" | mysql --user=root --password=rootpass"
  ) do
    it { should return_stdout /app_test/ }
  end
end

describe "can create database" do
  it "should have capability to create a database" do
    db.query("DROP DATABASE IF EXISTS create_db_test")
    db.query("CREATE DATABASE IF NOT EXISTS create_db_test")
    expect(db.query("SHOW DATABASES LIKE 'create_db_test'").entries.first['Database (create_db_test)']).to eq('create_db_test')
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
  describe file('/usr/local/www/sites/lamp_application/shared/db.php') do
    it { should be_file }
    it { should contain '$hostname_DB = "localhost";' }
    it { should contain '$username_DB = "appuser";' }
    it { should contain '$password_DB = "apppass";' }
    it { should contain '$database_DB = "app_test";' }
  end
  describe file('/usr/local/www/sites/lamp_application/current/config/db.php') do
    it { should be_linked_to '/usr/local/www/sites/lamp_application/shared/db.php' }
  end
end

describe command('curl --silent --location http://localhost/dbread') do
  it { should return_stdout /I am in the db/ }
end

describe file("/var/lib/rightscale/rs-lamp-app_test.sql.touch") do
  it { should be_file }
end
