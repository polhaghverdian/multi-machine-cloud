# example: vagrant --arg1 up

# vagrant --cloud up --provider=virtualbox
# vagrant --local destroy -f
# vagrant --local ssh database_server


# vagrant --cloud up --provider=digital_ocean
# vagrant --cloud destroy -f
# vagrant --cloud ssh database_server

arg = ARGV[0]
puts "Argument is: #{arg}"

Vagrant.configure("2") do |config|

        config.puppet_install.puppet_version = '6.24.0'
        ####### Provision with puppet #######
        config.vm.provision "puppet" do |puppet|
           puppet.options = "--verbose --debug"
           puppet.environment_path = "./environments"
           puppet.environment = "cloud"
        end

	NODES = [
		{ :hostname => "appserver", :name => "application_server"},
		{ :hostname => "dbserver", :name => "database_server"}
	]

	NODES.each do |node|
		config.vm.define node[:name] do |config|
			config.vm.hostname = node[:hostname]

			case arg
			when "--local"
				puts "Provisioning for local"
				config.vm.box = "bento/ubuntu-18.04"

			when "--cloud"
				puts "Provisioning for cloud"
                                config.vm.provider :digital_ocean do |provider, override|
                                    override.ssh.private_key_path = '~/.ssh/digitalocean'
                                    override.vm.box = 'digital_ocean'
                                    override.vm.box_url = "https://github.com/devopsgroup-io/vagrant-digitalocean/raw/master/box/digital_ocean.box"
                                    override.nfs.functional = false
                                    override.vm.allowed_synced_folder_types = :rsync
                                    provider.token = ENV['DIGITALOCEAN_TOKEN'] # Located in /etc/environment
                                    provider.image = 'ubuntu-18-04-x64'
                                    provider.region = 'nyc1'
                                    provider.size = 's-1vcpu-1gb'
                                    provider.backups_enabled = false
                                    provider.private_networking = false
                                    provider.ipv6 = false
                                    provider.monitoring = false


                                end
			end
		end
	end
end
