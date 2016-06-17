require 'net/ssh'
ssh_key = '~/.ssh/privyvri.id_rsa'
username = 'root'
fw_jump = 'sanbarasan@support-jump.meraki.com'
ip = 'fd0a:9b09:1f7:0:8a15:44ff:fe9e:168'

Net::SSH.start(ip,username, :forward_agent => fw_jump, :keys => ssh_key, :timeout => 5) do |ssh|

	puts 'i ssh-ed'

    #-- bypass consistency maintainer---#
=begin
    ssh.exec!('echo 0 > /click/nat/uplink_consistency_sw0/switch')
	ssh.exec!('echo 0 > /click/nat/uplink_consistency_sw1/switch')
	ssh.exec!('echo 0 > /click/nat/uplink_consistency_sw2/switch')
=end

	ssh.exec!('echo 0 > /click/nat/uplink_prefs_cl/uplink_consistency_sw0/switch')
	ssh.exec!('echo 0 > /click/nat/uplink_prefs_cl/uplink_consistency_sw1/switch')
	ssh.exec!('echo 0 > /click/nat/uplink_prefs_cl/uplink_consistency_sw2/switch')
	puts "Cleared consitency maintainers"

	#-- clear flow mapings--#
	#ssh.exec!('echo 1 > /click/nat/from_client_nat_rw/clear')
	#puts "done clearing NAT"

	# -- check bonding -- #
	puts 'Bonding ratio'
	puts ssh.exec!('cat /storage/config | grep wan_bonding')

	#Generating Traffic
	`ab -n 500 http://google.com/`

	#-- check TCP mappings and flows--#
	#puts "TCP mappings\n" + ssh.exec!("cat /click/nat/from_client_nat_rw/tcp_mappings | grep from_inet | sed 's/.*\(from_inet[01> ]_nat_rw\).*/\1/' | sort | uniq -c")
	puts "Wan Flows\n" + ssh.exec!('cat /click/nat/wan*_flowcounter/count')

end