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
    # Make sure directory /var/lib/rightscale exists which will contain the touch file
    directory '/var/lib/rightscale' do
      mode 0755
      recursive true
      action :create
    end

    # Prepare for creating the touch file after dump has been imported. Once the touch file has
    # been created importing will be skipped if the recipe runs again with the same dump_file name.
    file touch_file do
      action :nothing
    end

    # Install supported file-compression packages
    ['gzip', 'bzip2', platform_family?("debian") ? 'xz-utils' : 'xz'].each do |package_name|
      package package_name
    end

    # Determine by filename extension the command to read in the dump file
    read_command =
      case dump_file
      when /\.gz$/
        "gunzip --stdout '#{dump_file}'"
      when /\.bz2$/
        "bunzip2 --stdout '#{dump_file}'"
      when /\.xz$/
        "xz --decompress --stdout '#{dump_file}'"
      else
        "cat '#{dump_file}'"
      end

    # The connection hash to use to connect to MySQL
    mysql_connection_info = {
      :host => 'localhost',
      :username => 'root',
      :password => node['rs-mysql']['server_root_password']
    }

    # Import from MySQL dump
    mysql_database node['rs-mysql']['application_database_name'] do
      connection mysql_connection_info
      sql do
        streaming_file = Mixlib::ShellOut.new(read_command).run_command
        streaming_file.error!
        streaming_file.stdout
      end
      action :query
      notifies :touch, "file[#{touch_file}]", :immediately
    end

  end
end
