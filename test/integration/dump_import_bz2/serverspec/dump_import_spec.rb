require 'spec_helper'

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
    its(:stdout) { should match /app_test/ }
  end
end

describe command('curl --silent --location http://localhost/dbread') do
  its(:stdout) { should match /I am in the db/ }
  
end
