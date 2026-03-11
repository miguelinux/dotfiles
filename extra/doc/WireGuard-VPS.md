# VPN a casa detrás de NAT

El concepto se llama **VPN con Túnel Inverso (Reverse Tunnel)**.
Usaremos **WireGuard** por su eficiencia y simplicidad.

---

### La Arquitectura

1. **VPS (El "Hub"):** Un servidor pequeño en la nube con IP pública.
2. **Servidor en Casa (El "Peer"):** Un dispositivo (Raspberry Pi, PC viejo, Docker) que siempre está encendido.
3. **El Túnel:** El servidor de casa inicia la conexión hacia el VPS (esto atraviesa el NAT porque es tráfico de salida) y mantiene el túnel abierto.

---

### Guía de Implementación

#### 1. Preparar el VPS (Debian/Ubuntu)

Instala WireGuard y activa el reenvío de paquetes para que el VPS sepa cómo mover el tráfico:

```bash
sudo apt update && sudo apt install wireguard -y
# Habilitar IP Forwarding
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

```

#### 2. Generar llaves (En ambos equipos)

Necesitas un par de llaves (pública y privada) tanto en el VPS como en tu servidor de casa:

```bash
wg genkey | tee privatekey | wg pubkey > publickey

```

#### 3. Configurar el VPS (`/etc/wireguard/wg0.conf`)

El VPS actuará como el punto de encuentro.

```ini
[Interface]
PrivateKey = <Llave_Privada_VPS>
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = <Llave_Publica_CASA>
AllowedIPs = 10.0.0.2/32

```

#### 4. Configurar el Servidor en Casa (`/etc/wireguard/wg0.conf`)

Aquí es donde ocurre la magia para saltar el NAT.

```ini
[Interface]
PrivateKey = <Llave_Privada_CASA>
Address = 10.0.0.2/24

[Peer]
PublicKey = <Llave_Publica_VPS>
Endpoint = <IP_PUBLICA_VPS>:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25

```

> **Nota clave:** El `PersistentKeepalive = 25` es vital. Envía un "ping" cada 25 segundos para que el router de tu ISP no cierre la conexión NAT por inactividad.

---

### ¿Cómo accedes desde fuera?

Para entrar a tu casa desde tu móvil o laptop, tienes dos opciones:

1. **Ruta VPN Directa:** Conecta tu móvil al VPS como un tercer "Peer". Una vez dentro de la red `10.0.0.x`, podrás ver a tu servidor de casa en la `10.0.0.2`.
2. **Port Forwarding en el VPS:** Puedes configurar `iptables` en el VPS para que todo lo que llegue al puerto 80 del VPS se redirija automáticamente al puerto 80 de tu servidor en casa a través del túnel.

---

### Último paso: Encender el túnel

En ambos equipos, ejecuta:

```bash
sudo wg-quick up wg0
# Para que inicie siempre con el sistema:
sudo systemctl enable wg-quick@wg0

```

---

Configurar las reglas de **iptables** en el VPS es el toque final. Esto permitirá que cuando alguien intente entrar a la IP pública de tu VPS en un puerto específico (por ejemplo, el 80 o el 22), el tráfico sea "saltado" automáticamente a través del túnel de WireGuard hacia tu servidor en casa.

Aquí te explico cómo hacerlo paso a paso para que el tráfico fluya correctamente.

---

### 1. Habilitar el Enmascaramiento (NAT) en el VPS

Para que el tráfico regrese correctamente desde tu casa hacia internet pasando por el VPS, necesitas activar el **IP Masquerade**.

Ejecuta estos comandos en tu **VPS**:

```bash
# Define la interfaz de red pública (suele ser eth0 o ens3, verifica con 'ip a')
INTERFACE="eth0"

# Regla para permitir el tráfico de reenvío
sudo iptables -A FORWARD -i $INTERFACE -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wg0 -o $INTERFACE -j ACCEPT

# Regla de NAT (Masquerade)
sudo iptables -t nat -A POSTROUTING -o $INTERFACE -j MASQUERADE

```

---

### 2. Redirigir un Puerto Específico (Port Forwarding)

Supongamos que en tu casa tienes un servicio (ej. un servidor web) en el puerto **8080** de tu máquina local (`10.0.0.2` dentro de la VPN) y quieres acceder a él usando la IP de tu VPS en el puerto **80**.

Ejecuta esto en el **VPS**:

```bash
# Puerto de entrada en el VPS: 80
# Destino en tu casa: 10.0.0.2:8080

sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 10.0.0.2:8080
sudo iptables -A FORWARD -p tcp -d 10.0.0.2 --dport 8080 -j ACCEPT

```

---

### 3. Hacer las reglas persistentes

Por defecto, las reglas de `iptables` se borran al reiniciar el servidor. Para que se guarden para siempre:

1. Instala el paquete de persistencia:
```bash
sudo apt install iptables-persistent -y

```


2. Cuando te pregunte si quieres guardar las reglas actuales (IPv4), dile que **Sí**.
3. Si haces cambios después, puedes guardarlos con:
```bash
sudo iptables-save | sudo tee /etc/iptables/rules.v4

```

---

### 4. Configuración en el Servidor de Casa

Para que esto funcione, el servidor en tu casa debe saber que el tráfico que viene de la VPN debe ser aceptado. Asegúrate de que el firewall local (como `ufw`) no esté bloqueando el puerto de destino.

```bash
# Ejemplo en el servidor de casa (si usas UFW)
sudo ufw allow 8080/tcp

```

---

### Resumen de flujo de datos

* **Usuario externo** → IP_VPS:80
* **VPS** → Recibe en 80, traduce a 10.0.0.2:8080 y lo envía por el túnel `wg0`.
* **Casa** → Recibe en 8080, procesa y responde de vuelta por el túnel.

---

Es una excelente decisión. **nftables** es el sucesor moderno de `iptables`; es más limpio, eficiente y permite agrupar reglas de forma mucho más lógica.

Para que esto funcione en tu VPS, vamos a crear una "tabla" específica para nuestra VPN. Esto mantendrá tus reglas de red organizadas y fáciles de depurar.

---

### 1. Configuración del Archivo `/etc/nftables.conf`

En tu **VPS**, edita el archivo de configuración principal. Vamos a añadir una tabla llamada `nat_vpn` que se encargará del reenvío de puertos y del enmascaramiento.

```nftables
table ip nat_vpn {
    # Cadena para procesar paquetes que entran al VPS
    chain prerouting {
        type nat hook prerouting priority dstnat; policy accept;

        # REDIRECCIÓN DE PUERTO (DNAT)
        # Ejemplo: Lo que llegue al puerto 80 del VPS va al 10.0.0.2:8080 en tu casa
        tcp dport 80 dnat to 10.0.0.2:8080
    }

    # Cadena para procesar paquetes que salen del VPS hacia Internet
    chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;

        # ENMASCARAMIENTO (Masquerade)
        # Esto hace que el tráfico de tu casa salga a Internet con la IP del VPS
        oifname "eth0" masquerade
    }

    # Cadena para permitir el paso de paquetes entre interfaces
    chain forward {
        type filter hook forward priority filter; policy accept;

        # Permitir tráfico entre la interfaz de internet (eth0) y la VPN (wg0)
        iifname "eth0" oifname "wg0" ct state established,related accept
        iifname "wg0" oifname "eth0" accept
    }
}

```

---

### 2. Aplicar y Activar los Cambios

Una vez que hayas editado el archivo, aplica la configuración para que entre en vigor inmediatamente:

1. **Carga el archivo:**
```bash
sudo nft -f /etc/nftables.conf

```


2. **Habilita el servicio** para que persista tras reinicios:
```bash
sudo systemctl enable nftables
sudo systemctl start nftables

```



---

### 3. Comandos Útiles de nftables

A diferencia de `iptables -L`, con nftables puedes ver tus reglas de forma muy legible:

* **Ver todas las reglas activas:**
```bash
sudo nft list ruleset

```


* **Ver solo tu tabla de VPN:**
```bash
sudo nft list table ip nat_vpn

```


* **Borrar todas las reglas de esa tabla si te equivocas:**
```bash
sudo nft delete table ip nat_vpn

```



---

### 4. Ajuste en WireGuard (Opcional pero recomendado)

Para que no tengas que cargar las reglas de nftables manualmente cada vez, puedes integrarlas directamente en el archivo `wg0.conf` del VPS usando los hooks `PostUp` y `PostDown`.

Añade esto a la sección `[Interface]` de tu **VPS**:

```ini
PostUp = nft -f /etc/nftables.conf
PostDown = nft delete table ip nat_vpn

```

### Un detalle importante sobre el MTU

Al estar detrás de un NAT y usar un túnel (WireGuard) sobre otro protocolo, a veces los paquetes grandes se fragmentan y las webs no cargan. Si notas lentitud, añade esto a la interfaz `wg0` en **ambos lados**:

`MTU = 1380`


<!-- vi: set spl=es spell: -->

