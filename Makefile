ssh-control:
# to avoid having to SSH every time,
# we make a SSH control port to use with rsync.
	ssh -M -S /tmp/adsb-setup-ssh-control -fnNT root@adsb-feeder.local

sync-py-control:
# check if the SSH control port is open, if not, open it.
	ssh -O check -S /tmp/adsb-setup-ssh-control root@adsb-feeder.local || make ssh-control
	rsync -av \
	--delete --exclude="*.pyc" --progress \
	-e "ssh -S /tmp/adsb-setup-ssh-control" \
	src/modules/adsb-feeder/filesystem/root/opt/adsb/adsb-setup/ \
	root@adsb-feeder.local:/opt/adsb/adsb-setup/

	rsync -av \
	--exclude="*.pyc" --progress \
	-e "ssh -S /tmp/adsb-setup-ssh-control" \
	src/modules/adsb-feeder/filesystem/root/opt/adsb/ \
	root@adsb-feeder.local:/opt/adsb/

	rsync -av \
	--exclude="*.pyc" --progress \
	-e "ssh -S /tmp/adsb-setup-ssh-control" \
	src/modules/adsb-feeder/filesystem/root/usr/bin/ \
	root@adsb-feeder.local:/usr/bin/

	rsync -av \
	--exclude="*.pyc" --progress \
	-e "ssh -S /tmp/adsb-setup-ssh-control" \
	src/modules/adsb-feeder/filesystem/root/etc/ \
	root@adsb-feeder.local:/etc/

# For good measure, copy this Makefile too
	rsync -av \
	-e "ssh -S /tmp/adsb-setup-ssh-control" \
	Makefile \
	root@adsb-feeder.local:/opt/adsb/adsb-setup/Makefile

run-loop:
# python3 app.py in a loop
	while true; do \
		python3 app.py; \
		sleep 1; \
	done
