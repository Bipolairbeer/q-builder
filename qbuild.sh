#!/bin/bash

#################################################################################################################
#                                          Build Qubes in Fedora 32
#
# Open a terminal 
# --> sudo dnf update && sudo dnf upgrade
# --> sudo git clone git://github.com/Bipolairbeer/q-builder q-builder
# --> sudo chmod +x /home/user/q-builder/qbuild.sh
# --> cd q-builder/
# --> sudo ./qbuild.sh
#################################################################################################################

yes | sudo dnf install -y wget make git qubes-gpg-split createrepo rpm-build rpm-sign make python3-sh rpmdevtools rpm-sign dialog perl-open python3-pyyaml perl-Digest-MD5 perl-Digest-SHA 

cd
sudo git clone git://github.com/QubesOS/qubes-builder.git qubes-builder 

cd qubes-builder
sudo git tag -v `git describe`

cd
sudo git clone git://github.com/QubesOS/qubes-secpack.git qubes-secpack

cd
gpg --import qubes-secpack/keys/*/*

cat<<-EOF|gpg --command-fd 0 --edit-key 36879494
	fpr
	trust
	5
	y
	quit
	EOF

cd qubes-secpack
git tag -v `git describe`

cd
sudo rm -rf /home/user/qubes-builder/builder.conf
sudo cp -r /home/user/q-builder/builder.conf /home/user/qubes-builder/builder.conf

cd
gpg --keyserver pgp.mit.edu --recv-keys 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA
gpg --fingerprint 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA
export GNUPGHOME=~/qubes-builder/keyrings/git
mkdir --parents "$GNUPGHOME"
cp ~/.gnupg/pubring.kbx "$GNUPGHOME"
cp ~/.gnupg/trustdb.gpg "$GNUPGHOME"
chmod --recursive 700 "$GNUPGHOME"

cd qubes-builder
sudo make get-sources
sudo make vmm-xen core-admin linux-kernel gui-daemon template desktop-linux-kde installer-qubes-os manager linux-dom0-updates
sudo make install-deps
sudo make qubes
sudo make sign-all
sudo make iso

# READY
