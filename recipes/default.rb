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

Chef::Log "Overriding rs-mysql/server_usage to 'shared'"
node.override['rs-mysql']['server_usage'] = 'shared'

Chef::Log "Overriding mysql/bind_address to 'localhost'"
node.override['mysql']['bind_address'] = 'localhost'

Chef::Log "Overriding rs-application_php/database/host to 'localhost'"
node.override['rs-application_php']['database']['host'] = 'localhost'

Chef::Log "Overriding rs-application_php/listen_php to 80"
node.override['rs-application_php']['listen_port'] = 80
