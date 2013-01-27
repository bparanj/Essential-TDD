 $rvm use 1.9.3-p286
 $rvm gemset use deploy


require 'fog'

dns = Fog::DNS.new(provider: 'linode',
                   linode_api_key: 'QthP2juHEbXbK7lvP3RYXeMDNbvgUsFYnxB2cnwSAFpZJtzSModWOeKVlZApNuy0')

zone = dns.zones.create(domain: 'clickplan.net',
  						          email: 'admin@clickplan.net')
zone.nameservers
# Create a www version of your site and point to the right IP.
record = zone.records.create(value: '192.155.81.222', name: 'clickplan.net', type: 'A')

# To make www.clickplan.net go to the same place, use a cname record:
record = zone.records.create(value: 'clickplan.net', name: 'www', type: 'CNAME')

# dns.zones.all

# @dns = Fog::DNS.new(:provider => 'Linode', :linode_api_key => LINODE_KEY)
# if @zone = @dns.zones.all.find { |z| z.domain == ZONE }
#   puts "Found zone #{@zone.inspect}"
# else
#   @zone = @dns.zones.create(:domain => ZONE, :email  => ZONE_EMAIL)
#   puts "Creating zone #{@zone.inspect}"
# end
	
