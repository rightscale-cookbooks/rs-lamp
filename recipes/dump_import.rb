#
# Cookbook Name:: rs-lamp
# Recipe:: dump_import
#
# Copyright (C) 2014 RightScale, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

marker 'recipe_start_rightscale' do
  template 'rightscale_audit_entry.erb'
end

dump_file = node['rs-lamp']['dump_file']

if dump_file && !dump_file.empty?
  dump_file = "/usr/local/www/sites/#{node['rs-application_php']['application_name']}/current/#{dump_file}"
  touch_file = "/var/lib/rightscale/rs-lamp-#{::File.basename(dump_file)}.touch"

  if ::File.exists?(touch_file)
    log "The dump file was already imported at #{::File.ctime(touch_file)}"
  else
    case dump_file
    when /\.gz$/
      uncompress_command = "gunzip --stdout '#{dump_file}'"
    when /\.bz2$/
      uncompress_command = "bunzip2 --stdout '#{dump_file}'"
    when /\.xz$/
      uncompress_command = "xz --decompress --stdout '#{dump_file}'"
    end

    # The connection hash to use to connect to MySQL
    mysql_connection_info = {
      :host => 'localhost',
      :username => 'root',
      :password => node['rs-mysql']['server_root_password']
    }

    # Import from MySQL dump
    mysql_database node['rs-mysql']['database_name'] do
      connection mysql_connection_info
      sql do
        if uncompress_command
          uncompress = Mixlib::ShellOut.new(uncompress_command).run_command
          uncompress.error!
          uncompress.stdout
        else
          ::File.read(dump_file)
        end
      end
      action :query
    end

    # Make sure directory /var/lib/rightscale exists which will contain the touch file
    directory '/var/lib/rightscale' do
      mode 0755
      action :create
    end

    # Create a touch file containing the name of the dump file so this action can be skipped if the
    # recipe is run with the same input multiple times.
    file touch_file do
      action :touch
    end
  end
end
