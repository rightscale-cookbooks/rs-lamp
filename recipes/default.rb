#
# Cookbook Name:: rs-lamp
# Recipe:: default
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

log "Overriding rs-mysql/server_usage to 'shared'"
node.override['rs-mysql']['server_usage'] = 'shared'

log "Overriding mysql/bind_address to 'localhost'"
node.override['mysql']['bind_address'] = 'localhost'

log 'Overriding rs-mysql/server_root_password to rs-lamp/mysql_root_password'
node.override['rs-mysql']['server_root_password'] = node['rs-lamp']['mysql_root_password']

log 'Overriding rs-mysql/application_username to rs-application_php/database/user'
node.override['rs-mysql']['application_username'] = node['rs-application_php']['database']['user']

log 'Overriding rs-mysql/application_password to rs-application_php/database/password'
node.override['rs-mysql']['application_password'] = node['rs-application_php']['database']['password']

log 'Overriding rs-mysql/application_database_name to rs-application_php/database/schema'
node.override['rs-mysql']['application_database_name'] = node['rs-application_php']['database']['schema']

log 'Overriding rs-mysql/application_user_privileges to rs-lamp/mysql_user_privileges'
node.override['rs-mysql']['application_user_privileges'] = node['rs-lamp']['mysql_user_privileges']

include_recipe 'rs-mysql::server'

log "Overriding rs-application_php/database/host to 'localhost'"
node.override['rs-application_php']['database']['host'] = 'localhost'

log "Overriding rs-application_php/listen_php to 80"
node.override['rs-application_php']['listen_port'] = 80
