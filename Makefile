all: cflinuxfs2.tar.gz lucid64.tar.gz

cflinuxfs2.cid: cflinuxfs2/Dockerfile
	docker build --no-cache -t cloudfoundry/cflinuxfs2 cflinuxfs2
	docker run --cidfile=cflinuxfs2.cid cloudfoundry/cflinuxfs2 dpkg -l | tee cflinuxfs2/cflinuxfs2_dpkg_l.out

cflinuxfs2.tar: cflinuxfs2.cid
	docker export `cat cflinuxfs2.cid` > /tmp/cflinuxfs2.tar
	# Always remove the cid file in order to grab updated package versions.
	rm cflinuxfs2.cid

cflinuxfs2.tar.gz: cflinuxfs2.tar
	 mkdir -p /tmp/cflinuxfs2/etc
	 cp cflinuxfs2/assets/etc/hosts /tmp/cflinuxfs2/etc/hosts
	 cp cflinuxfs2/assets/etc/timezone /tmp/cflinuxfs2/etc/timezone
	 tar -C /tmp/cflinuxfs2 -xvf /tmp/cflinuxfs2.tar
	 tar -C /tmp/cflinuxfs2 -czvf cflinuxfs2.tar.gz $(ls -a /tmp/cflinuxfs2/ | egrep -v '^.{1,2}$')

lucid64.cid: lucid64/Dockerfile
	docker build --no-cache -t cloudfoundry/lucid64 lucid64
	docker run --cidfile=lucid64.cid cloudfoundry/lucid64 dpkg -l | tee lucid64/lucid64_dpkg_l.out

lucid64.tar: lucid64.cid
	docker export `cat lucid64.cid` > /tmp/lucid64.tar
	# Always remove the cid file in order to grab updated package versions.
	rm lucid64.cid

lucid64.tar.gz: lucid64.tar
	 mkdir -p /tmp/lucid64/etc
	 cp lucid64/assets/etc/hosts /tmp/lucid64/etc/hosts
	 cp lucid64/assets/etc/timezone /tmp/lucid64/etc/timezone
	 tar -C /tmp/lucid64 -xvf /tmp/lucid64.tar
	 tar -C /tmp/lucid64 -czvf lucid64.tar.gz $(ls -a /tmp/lucid64/ | egrep -v '^.{1,2}$')
