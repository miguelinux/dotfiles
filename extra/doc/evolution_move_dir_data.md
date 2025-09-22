# Mover los directorios de evolution

evolution --force-shutdown

mkdir /path/to/new/evolution_data

# Example: Move the entire evolution directory to the new location
mv ~/.local/share/evolution /path/to/new/evolution_data/

# Alternatively, copy and then remove the original
cp -r ~/.local/share/evolution /path/to/new/evolution_data/
rm -rf ~/.local/share/evolution

You may also need to copy folders from
~/.config/evolution/ and ~/.cache/evolution/ for a full migration. 

ln -s /path/to/new/evolution_data/evolution ~/.local/share/evolution


<!-- vi: set spl=es spell: -->

