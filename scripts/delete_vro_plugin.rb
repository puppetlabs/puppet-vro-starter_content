#!/usr/bin/env ruby
require 'json'
require 'net/https'
require 'net/ssh'

VRO_SERVER  = 'tse-vro2-prod.tse.puppetlabs.net'
VRO_PORT    = '8281'
PACKAGE     = 'com.puppet.o11n.plugin.puppet'
USERNAME    = 'vcoadmin'
PASSWORD    = 'vcoadmin'
PACKAGE_URL = "https://#{VRO_SERVER}:#{VRO_PORT}/vco/api/packages/#{PACKAGE}/"

VRO_SERVER_SSH_USER = 'root'
VRO_SERVER_SSH_PASS = 'Qu@lity!'

def get_url(http, u)
  uri=URI(u)
  request = Net::HTTP::Get.new(uri.request_uri)
  request['Content-Type'] = 'application/json'
  request.basic_auth(USERNAME, PASSWORD)
  response = http.request(request)
end

def delete_url(http, u)
  uri = URI(u)
  delete_request = Net::HTTP::Delete.new(uri.request_uri)
  delete_request['Content-Type'] = 'application/json'
  delete_request.basic_auth(USERNAME, PASSWORD)
  response = http.request(delete_request)
  if response.code == "200" || 
    response.code == "204" 
    puts "#{u} deleted successfully."
  else
    puts "Error while processing url:"
    pp u
    pp delete_request
    pp response
    pp response.body
  end
end

def delete_vro_package(http, package_url=PACKAGE_URL)
  delete_url(http, package_url + '?option=deletePackageWithContent') 
end

def get_categories(http, queries=['Puppet', 'com.puppet.o11n.plugin.puppet', 'com.puppet.o11n.plugin.puppet.node'])
  url = "https://#{VRO_SERVER}/vco/api/categories/"
  response = get_url(http, url)
  json = JSON.parse(response.body)
  return_values = Array.new
  queries.each do |query|
    json['link'].each do |category|
      if category['attributes'][0]['value'] == query 
        return_values.push(category['href'])
      end
    end
  end
  return_values
end

def delete_categories(http, urls)
  urls.each do |u|
    delete_url(http, u + '?deleteNonEmptyContent=true')
  end
end

def sshcmd( host=VRO_SERVER, 
            user=VRO_SERVER_SSH_USER,
            pass=VRO_SERVER_SSH_PASS,
            cmd)
  Net::SSH.start(host, user, :password => pass) do |ssh|
    output = ssh.exec!(cmd)
    puts output
    output.exitstatus
  end
end

# Main - Delete the VRO components
http = Net::HTTP.new(VRO_SERVER, VRO_PORT)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

urls_to_delete = get_categories(http)
delete_categories(http, urls_to_delete)
delete_vro_package(http)

# Perform the bash commands that complete the uninstall
commands = [
  'service vco-server stop',
  'sleep 10',
  'rm -f /usr/lib/vco/app-server/plugins/o11nplugin-puppet.dar',
  'sed -i \'/Puppet/d\' /etc/vco/app-server/plugins/_VSOPluginInstallationVersion.xml',
  'service vco-configurator restart',
  'sleep 5',
  'service vco-server start'
]
commands.each {|c| sshcmd(c)}
