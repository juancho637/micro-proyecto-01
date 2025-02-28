apt_update 'update' do
    action :update
end

package 'nodejs' do
    action :install
end

package 'npm' do
    action :install
end

# git '/opt/consulService' do
#     repository 'https://github.com/omondragon/consulService'
#     revision 'master'
#     action :sync
# end

directory '/opt/consulService/app' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    recursive true
end

cookbook_file '/opt/consulService/app/index.js' do
    source 'index.js'
    owner 'root'
    group 'root'
    mode '0664'
    action :create
end

execute 'modify consul ip' do
    command "sed -i \"s/const HOST='ip-server';/const HOST='#{node['ip_server']}';/g\" /opt/consulService/app/index.js"
    action :run
end
  

execute 'npm install consulService' do
    cwd '/opt/consulService/app'
    command 'npm install consul express'
    action :run
end

template '/etc/systemd/system/consulservice.service' do
    source 'consulservice.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      working_directory: '/opt/consulService/app'
    )
    notifies :run, 'execute[reload_systemd]', :immediately
end

# Recarga systemd para aplicar los cambios en los servicios
execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
end

# Habilita e inicia el servicio
service 'consulservice' do
    action [:enable, :start]
end
