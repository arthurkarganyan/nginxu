class Config
  attr_reader :ip, :user, :password

  def initialize(ip:, user:, password: nil)
    @ip = ip
    @user = user
    @password = password
  end

  def ssh
    @ssh ||= Net::SSH.start(ip, user, password: password, forward_agent: true)
  end

  def sync
    install_nginx
    sync_sites_enabled
  end

  def install_nginx
    unless nginx_installed?
      install('nginx')
    end
  end

  def nginx_installed?
    exec('nginx -v')['version']
  end

  def upload_folder(from, to)
    print "Uploading..."
    puts %x(scp -r #{from} #{user}@#{ip}:#{to})
    puts "finished"
  end

  def sync_sites_enabled
    upload_folder('sites-enabled', '~/sites-enabled')
    sleep 5
    cmds = [
        'sudo -S rm -rf /etc/nginx/sites-enabled',
        'pwd',
        'sudo mkdir -p /etc/nginx/sites-enabled',
        'sudo mv ~/sites-enabled /etc/nginx/',
        'rm -rf ~/sites-enabled',
        'sudo service nginx restart'
    ].join('&&')
    exec("echo #{password} | #{cmds}")
  end

  def install(packages)
    str = Array(packages).join(' ')
    sudo("apt update && sudo apt install #{str} -y")
  end

  def sudo(cmd)
    exec("echo #{password} | sudo -S #{cmd}")
  end

  def exec(cmd)
    puts "[#{user}@#{ip}]: #{cmd}"
    a = ssh.exec!(cmd) do |channel, stream, data|
      print data #if stream == :stdout
    end
    puts a
    a
  end
end
