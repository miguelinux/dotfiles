# Comandos de Windows

Apagar el windows
```
shutdown /s /t 0
```

Mostrar unidades
```
diskpart
> list disk
> list volume
```
```
fsutil fsinfo drives
```
```
wmic logicaldisk get caption, description, size
```

Instalar drivers
```
pnputil /add-driver "C:\Ruta\de\la\carpeta\*.inf" /install
```

Reparar UEFI
```
bcdboot C:\Windows /s S: /f UEFI
```


<!-- vi: set spl=es spell: -->

