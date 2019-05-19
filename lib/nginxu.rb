require_relative "nginxu/version"

module Nginxu
  class Error < StandardError;
  end

  class CLI < Thor
    desc "download john@0.0.0.0", "Download nginx configuration from server"

    def download(ssh_string)
      %x(scp -r #{ssh_string}:/etc/nginx/sites-enabled .)
      puts "Downloaded to sites-enabled"
    end
  end
end
