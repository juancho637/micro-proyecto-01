apt_update 'update' do
    action :update
end
  
package 'haproxy' do
    action :install
end

execute 'enable haproxy' do
    command 'sudo systemctl enable haproxy'
    action :run
end

cookbook_file '/tmp/haproxy.cfg' do
    source 'haproxy.cfg'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

ruby_block 'modify haproxy.cfg' do
    block do
        target_file = '/etc/haproxy/haproxy.cfg'
        additional_file = '/tmp/haproxy.cfg'
        additional_content = ::File.exist?(additional_file) ? ::File.read(additional_file) : ''
        raise "El archivo #{additional_file} no existe o está vacío" if additional_content.empty?
        current_content = ::File.exist?(target_file) ? ::File.read(target_file) : ''
        unless current_content.include?(additional_content)
            ::File.open(target_file, 'a') do |f|
                f.puts "\n# Inicio de configuración adicional"
                f.puts additional_content
                f.puts "# Fin de configuración adicional"
            end
        end
    end
    action :run
end 

cookbook_file '/etc/haproxy/errors/503.http' do
    source '503.http'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
end

execute 'restart haproxy' do
    command 'sudo systemctl restart haproxy'
    action :run
end
