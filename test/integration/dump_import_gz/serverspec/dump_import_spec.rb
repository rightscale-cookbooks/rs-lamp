require 'spec_helper'

describe "can run MySQL queries on the server" do
  describe "'app_test' database exists" do
    describe command(
      "echo \"SHOW DATABASES LIKE 'app_test'\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /app_test/ }
    end
  end

  describe "select tables from a database" do
    describe command(
      "echo \"USE app_test; SELECT * FROM app_test\" | mysql --user=root --password=rootpass"
    ) do
      it { should return_stdout /I am in the db/ }
    end
  end
end

describe command('curl --silent --location http://localhost/dbread') do
  it { should return_stdout /I am in the db/ }
end
