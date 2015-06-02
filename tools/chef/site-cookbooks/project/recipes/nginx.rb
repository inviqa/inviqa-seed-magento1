include_recipe 'nginx::commons_conf'

cookbook_file "#{node['nginx']['dir']}/cachebuster.conf" do
  source 'nginx/cachebuster.conf'
  owner  'root'
  group  'root'
  mode   '0644'
  notifies :reload, 'service[nginx]'
end