# *Network*

Anotações gerais sobre *Network*: programas e configurações.

## `ip`

Verificar as interfaces de redes com saida formatada e "highlightada" (*pretty*):

```sh
ip -br -c a
```

Verificar qual interface de rede está se comunicando com a *internet*:

```sh
ip route
```

*OBSERVAÇÕES:*

- Caso esteja conectado a *internet* em mais de uma interface de rede ao mesmo tempo, pode ser que tenha mais de uma definida como `default`, nesse caso, a interface com **menor** valor de `metric` é a saída real

## `lsof`

Listar portas abertas no sistema:

```sh
[sudo] lsof -nPi | grep -F LISTEN
```

Listar porta específica:

```sh
[sudo] lsof -i :<port>
```

## `ss`

Verificar portas sendo usadas no sistema:

```sh
[sudo] ss -ntpl
```

## `tcpdump`

*Parâmetros usados:*

- `<interface>`: Nome da interface de rede
- `<seconds>`: Valor em segundos
- `<count>`: Quantidade de iterações
- `<host>`: Domínio ou IP

*Opções usadas:*

- `-i <interface>`: Interface de rede a ser monitorada
- `-G <seconds>`: Quanto tempo ficará capturando
- `-W <count>`: Quantas vezes capturará
- `-w /path/tcpdump-%F_%T.pcap`: Arquivo de saída do tipo *packet capture*
- `host <host> [or <host>...]`: IP ou domínio a ser monitorado

Programas necessários:

```sh
[sudo] apt install tcpdump
```

Monitorar tráfego de rede:

```sh
[sudo] tcpdump -i <interface> -G <seconds> -W <count> -w 'tcpdump_%F-%T.pcap' host <host> or host <host>
```

## `mtr`

*Parâmetros usados:*

- `<cycles>`: Quantidade de repetição
- `<seconds>`: Quantidade de segundos
- `<size>`: Tamanho em *bytes*

*Opções usadas:*

- `-4`: Somente IPv4
- `-6`: Somente IPv6
- `-w`: Não resume os nomes de domínios
- `-t`: Ao invés de chamar GUI ou TUI, reporta diretamente no console
- `-g`: Força usar GTK
- `-C`: Saída como CSV
- `-j`: Saída como JSON
- `-r`: Entra em *report mode* (não mostra *output* e no final dos ciclos mostra o resumo) em conjunto de `-c`
- `-c <cycles>`: Contagem de ciclos
- `-i <seconds>`: *Delay* entre cada *ICMP Echo*
- `-s <size>`: Tamanho do pacote

Monitorar o TTR de todos os *hopes*:

```sh
mtr [<options>] example.com
```

## `nslookup`

*Parâmetros usados:*

- `<host>`: Domínio ou IP

Resolver *hostnames*/domínios:

```sh
nslookup [-type=PTR] <host>
```

## `dig`

*Parâmetros usados:*

- `<dns>`: IP do DNS (*e.g.* `8.8.8.8`, `1.1.1.1`)
- `<domain>`: IP do servidor (*e.g.* `123.456.789.10`)
- `<domain>`: Nome de domínio (*e.g.* `kernel.org`)
- `<type>`: Tipo de domínio (*e.g.* `A`, `MX`)

Programas necessários:

```sh
[sudo] apt install dnsutils
```

Resolver domínio:

```sh
dig [+short] [@<dns>] <domain> [<type>]
```

Verificar *nameservers* do domínio:

```sh
dig +trace [@<dns>] <domain>
```

Encontrar domínio pelo IP:

```sh
dig [+short] [@<dns>] -x <ip>
```

*OBSERVAÇÕES:*

- O comando `dig` aceita os tipos de domínio `A`, `MX` e `SOA`

*LINKS:*

- [Content Base](<https://www.certificacaolinux.com.br/comando-linux-dig/>)
- [Record Types](<https://www.cloudflare.com/pt-br/learning/dns/dns-records/>)

## `nmap`

*Parâmetros usados:*

- `<ip>`: Endereço IP do dispositivo (local ou externo)

Programas necessários:

```sh
[sudo] apt install nmap
```

Descobrir IPs conectados na minha rede:

1. Saiba primeiro meu próprio ID:
	```sh
	ip address
	```
1. Coloque no `nmap`:
	```sh
	[sudo] nmap -sA <ip>/24
	```

Descobrir quais portas estão sendo usadas por qual serviço no *host*:

```sh
[sudo] nmap -sV <ip>
```

## `arp-scan`

Programas necessários:

```sh
[sudo] apt install arp-scan
```

Descobrir *ips* conectados na rede local:

```sh
[sudo] arp-scan --localnet
```

## `nmcli`

*Parâmetros usados:*

- `<ifname>`: Nome da interface de rede (*e.g.* `eth0`, `wlan0`)
- `<ssid>`: Nome da rede WiFi (SSID/ESSID)
- `<usernam>`: Usuário da rede WiFi
- `<password>`: Senha da rede WiFi
- `<connection>`: Nome da conexão (geralmente mesmo nome do `<ssid>` para *wireless* ou qualquer outro nome que faça sentido para *wired*)
- `<certificate>`: Certificado da conexão (se aplicável)
- `<anonymous>`: Identificação anônima da conexão (se aplicável)
- `<vpn>`: Tipo da VPN

Listar redes WiFi dispníveis:

```sh
nmcli device wifi list [ifname <ifname>]
```

Conectar em rede simples (`WPA*`):

```sh
nmcli device wifi connect <ssid> password <password> [ifname <ifname>]
```

Conectar em rede empresarial (*enterprise* `WPA*-EAP`):

```sh
nmcli connection add type wifi connection-name <connection> ssid <ssid> [ifname <ifname>]
nmcli connection edit id <connection>
nmcli> set ipv4.method auto
nmcli> set wifi-sec.key-mgmt wpa-eap
nmcli> set 802-1x.eap peap
nmcli> set 802-1x.phase2-auth mschapv2
nmcli> set 802-1x.identity <username>
nmcli> set 802-1x.password <password>
nmcli> set 802-1x.ca-cert <certificate>
nmcli> set 802-1x.anonymous-identity <anonymous>
nmcli> save
nmcli> activate
```

*OBSERVAÇÕES:*

- `<connection>` pode ser literalmente qualquer nome e serve somente para referenciar a configuração de alguma conexão. Acontece que os gerenciadores de rede geralmente definir esse valor o mesmo nome do **SSID** (que é o nome da rede *WiFi*) de forma automática, porém, `<connection>` pode ser qualquer coisa

Simplesmente trocar de rede:

```sh
nmcli device wifi connect <ssid>
```

### VPN

Adicionar (configurar) conexão VPN:

```sh
nmcli connection import type <vpn> file /path/vpn.conf
```

*OBSERVAÇÕES:*

- Depois de configurado, basta se conectar com `nmtui-connect`
- Para algumas VPNs será necessário instaler pacote eespecíficos (`network-manager-*`)
