# Gestión de mapeos:

`kpartx -a <dispositivo>`: Crea los mapeos de las particiones. 
`kpartx -d <dispositivo>`: Elimina los mapeos de las particiones. 
`kpartx -l <dispositivo>`: Lista las particiones que se encontrarían en el dispositivo. 

# Uso con archivos de imagen:

Se puede usar `kpartx -a -v /ruta/a/imagen.img` para habilitar los mapeos de
las particiones dentro de un archivo .img. 

Una vez que se crean los mapeos (por ejemplo, /dev/mapper/loop0p2), se pueden
montar usando comandos como `sudo mount /dev/mapper/loop0p2 /mnt/punto_de_montaje`. 

