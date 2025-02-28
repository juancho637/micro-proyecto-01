execute 'download hashicorp gpg' do
    command 'wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg'
    action :run
end

execute 'add hashicorp repo' do
    command 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list'
    action :run
end

apt_update 'update' do
    action :update
end
  
package 'consul' do
    action :install
end

# Crea el archivo de unidad systemd para Consul
template '/etc/systemd/system/consul.service' do
    source 'consul.service.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      bind_address: '192.168.100.15',
      client_address: '0.0.0.0'
    )
    notifies :run, 'execute[reload_systemd]', :immediately
end
  
  # Recarga la configuración de systemd
execute 'reload_systemd' do
    command 'systemctl daemon-reload'
    action :nothing
end
  
  # Habilita e inicia el servicio Consul
service 'consul' do
    action [:enable, :start]
end