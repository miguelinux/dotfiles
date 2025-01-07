# Comandos GPG

gpg --quick-generate-key  "Nombre <correo>" ed25519 cert never

gpg --quick-add-key <fingerprint> ed25519 sign 202X-01-01
gpg --quick-add-key <fingerprint> rsa4096 encr 202X-01-01

gpg2 --with-keygrip --list-key YOURPRIMARYKEYID
$HOME/.gnupg/private-keys-v1.d/KEYGRIP.key

https://wiki.debian.org/Subkeys

# Renew (hacking)

$ ps aux | grep gpg
8246  /usr/bin/gpg-agent --supervised
$ kill 8246

<!-- vi: set spl=es spell: -->
