#!/bin/bash
yes | sudo dnf install -y wget make git qubes-gpg-split createrepo rpm-build rpm-sign make python3-sh rpmdevtools rpm-sign dialog perl-open python3-pyyaml perl-Digest-MD5 perl-Digest-SHA 

sudo git clone "https://github.com/QubesOS/qubes-secpack.git"
gpg --import qubes-secpack/keys/*/*
cat<<-EOF|gpg --command-fd 0 --edit-key 36879494
	fpr
	trust
	5
	y
	quit
	EOF

cd qubes-secpack/
git tag -v `git describe`

cd canaries/ 
gpg --verify canary-001-2015.txt.sig.joanna canary-001-2015.txt
gpg --verify canary-001-2015.txt.sig.marmarek canary-001-2015.txt

cd
sudo git clone "https://github.com/QubesOS/qubes-builder.git"

cd qubes-builder/
git tag -v `git describe`

cd
gpg --keyserver pgp.mit.edu --recv-keys 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA
gpg --fingerprint 916B8D99C38EAF5E8ADC7A2A8D66066A2EEACCDA
export GNUPGHOME=~/qubes-builder/keyrings/git
mkdir --parents "$GNUPGHOME"
cp ~/.gnupg/pubring.gpg "$GNUPGHOME"
cp ~/.gnupg/trustdb.gpg "$GNUPGHOME"
chmod --recursive 700 "$GNUPGHOME"

sudo git clone "https://github.com/Bipolairbeer/qubes-builder.git" /home/user/bipolairbeer

cd
cp /home/user/bipolairbeer/builder.conf /home/user/qubes-builder/builder.conf

cd /home/user/qubes-builder
sudo make install-deps
sudo make get-sources
sudo make qubes
sudo make sign-all
sudo make iso



 


