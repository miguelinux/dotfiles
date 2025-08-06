# Comandos GPG

gpg --quick-generate-key  "Nombre <correo>" ed25519 cert never

gpg --quick-add-key <fingerprint> ed25519 sign 202X-01-01
gpg --quick-add-key <fingerprint> rsa4096 encr 202X-01-01

gpg --with-keygrip --list-key YOURPRIMARYKEYID
$HOME/.gnupg/private-keys-v1.d/KEYGRIP.key

gpg --edit-key YOURPRIMARYKEYID passwd

* los mocosos.
* yo mero.

https://wiki.debian.org/Subkeys

#  Add new public keys

Add a line to your ~/.gnupg/gpg.conf file such as:

`keyring /usr/share/keyrings/debian-keyring.gpg`
`keyring /usr/share/keyrings/debian-maintainers.gpg`

or

`keyserver keyring.debian.org`

* https://keyserver.ubuntu.com (recommended)

https://wiki.debian.org/Keysigning

# Renew (hacking)

$ ps aux | grep gpg
8246  /usr/bin/gpg-agent --supervised
$ kill 8246

# Send to server

gpg --keyserver keyserver.ubuntu.com --send-key 90A808023328BD4E58143AC5E6CB7939B6C3AAB7

# Backup

* gpg --export-secret-keys --armor --output prk-compaq515.asc miguel.bernal.marin@gmail.com
* gpg -a --export miguel.bernal.marin@gmail.com > mbm-puk.key
* gpg --export-ownertrust > mbm-ownertrust-gpg.txt

# Restore

* gpg --import chrisroos-secret-gpg.key
* gpg --import-ownertrust chrisroos-ownertrust-gpg.txt

<!-- vi: set spl=en spell: -->
