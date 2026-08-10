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

# Change expiration date

To change the expiration date of a GPG subkey,
run `gpg --edit-key YOUR-KEY-ID`, use list to view subkeys,
pick the target subkey with key n (where n is the subkey index),
type expire to set the new date, and finish by typing save.

## Step-by-Step InstructionsRun

* `gpg --list-keys` to find your primary key ID or fingerprint.
* Start the edit mode by running `gpg --edit-key YOUR-KEY-ID`.
* Type `list` in the interactive prompt to show all primary keys and subkeys.
* Select the subkey you want to change by typing `key 1`, `key 2`, etc.,
  corresponding to its index number. An asterisk  `*` will appear next to
  the selected subkey.
* Type `expire` and enter the new validity duration (e.g., 1y for one
  year, 6m for six months, or 0 for no expiration).
* Type `save` to write the changes to your key ring.
* Export and upload your updated public key to keyservers or services
  (like GitHub) so others see the new date.

If you prefer a one-line command instead of the interactive menu,
let me know if you want to use gpg --quick-set-expire and I can provide
that syntax.

<!-- vi: set spl=en spell: -->
