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
	
