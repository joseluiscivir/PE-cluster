#! /opt/puppetlabs/puppet/bin/ruby
require 'puppetclassify'

fqdn = ARGV[0]

auth_info = {
  "ca_certificate_path" => "/etc/puppetlabs/puppet/ssl/certs/ca.pem",
  "certificate_path"    => "/etc/puppetlabs/puppet/ssl/certs/#{fqdn}.pem",
  "private_key_path"    => "/etc/puppetlabs/puppet/ssl/private_keys/#{fqdn}.pem",
  "read_timeout"        => 90 # optional timeout, defaults to 90 if this key doesn't exist
}

classifier_url = "https://#{fqdn}:4433/classifier-api"
puppetclassify = PuppetClassify.new(classifier_url, auth_info)

infra_group_id = puppetclassify.groups.get_group_id("PE Infrastructure")

infra_group =  puppetclassify.groups.get_group(infra_group_id)
infra_group['classes']['puppet_enterprise'].delete_if { |k,v| ["puppetdb_host", "puppet_master_host", "pcp_broker_host", "console_host"].include?(k) }

puppetclassify.groups.create_group(infra_group)
