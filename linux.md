# Linux

Anotações gerais sobre Linux: programas e configurações.

Por via de regra, comandos de sistema são exemplificados utilizando abordagens Debian-like, então, caso esteja utilizando outra distribuição, deverá ser feito a adaptação necessária.

## Programas

Anotações gerais sobre ferramentas CLI (comandos).

### `flatpak`

Faça o setup pelo guia do [Flatpak](https://flatpak.org/setup) ou do [Flathub](https://flathub.org/setup).

*Parâmetros usados:*

- `<remote>`: Repositório remoto, ex. `flathub`
- `<app>`: *ID* do aplicativo remota ou localmente, ex. `org.mozilla.firefox`
- `<commit>`: *Hash* do *commit*

Instalar app flatpak:

```sh
flatpak install <remote> <app>
```

Listar apps flatpak:

```sh
flatpak list
```

Executar app flatpak:

```sh
flatpak run <app>
```

Informações app flatpak:

```sh
flatpak infos <app>
```

Desinstalar app flatpak:

```sh
flatpak uninstall <app>
```

Listar flatpak *remotes*:

```sh
flatpak remotes
```

Impedir/Liberar app flatpak de receber atualizações:

```sh
flatpak mask [--remove] <app>
```

#### *Rollback*

Listar as versões do app flatpak:

```sh
flatpak remote-info --log flathub <app>
```

Executa o *rollback* no app flatpak:

```sh
flatpak update --commit=<commit> <app>
```

#### *Games*

Por sugestão do [Eddie](https://github.com/eddiecsilva/debian-post-install?tab=readme-ov-file#configura%C3%A7%C3%B5es-extras-para-jogos), instalação dos pacotes necessários para **Steam** e **Heroic Games Launcher**:

```sh
flatpak install com.valvesoftware.Steam com.valvesoftware.Steam.Utility.MangoHud com.valvesoftware.Steam.Utility.vkBasalt com.valvesoftware.Steam.VulkanLayer.MangoHud com.heroicgameslauncher.hgl
```

> Se for necessário, utilizando o FlatSeal libere as permissões do pacote flatpak do Steam para acessar outras unidades de disco.

### `acpi`

Ver porcentagem da bateria (*notebooks*):

```sh
acpi --battery
```

### `xev`

Mapear teclas e eventos do ambiente:

- `xev`
- `xev -event keyboard`
- `xev | sed -n '/^KeyPress/,/^$/p'`

### `lsusb`

Listar dispositivos USB:

```sh
lsusb
```

### `shutdown`

Em geral, os comandos puros são:

- `halt`: Encerra todos os processos e desliga a CPU (matendo a energia do *hardware*)
- `poweroff`: Como `halt`, mas também envia um comando ACPI para a Placa (cortando toda a energia do *hardware*)
- `reboot`: Como `halt`, mas inicia novamente o sistema

O comando `shutdown` é um *handler* para todos esses comandos mas faz o "encerramento gracioso" dos processos.

*Parâmetros usados:*

- `<time>`: `hh:mm` no padrão 24h ou `+m` onde "m" é a quantidade de minutos a partir de agora, ex. `+5` se refere daqui a 5 minutos (*default*: `+1`)
- `<wall>`: Mensagem de aviso de desligamento do sistema para os usuário "logados"

*Opções usadas:*

- `-H`: Para a máquina
- `-P`: Desliga a máquina (*default*)
- `-r`: Reinicia a máquina
- `-c`: Cancela a operação de *shutdown* pendente
- `--show`: Mostra (se houver) a operação de *shutdown* pendente

```
shutdown [<options>] [<time>|now [wall]]
```

### `fdisk`

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição

Lista informações de todos os discos:

```sh
[sudo] fdisk -l
```

Lista informações de um disco específico:

```sh
[sudo] fdisk -l /dev/sdX
```

Interface interativo para manipulação avançada da tabela de partiçẽos e partiçẽos:

```sh
[sudo] fdisk /dev/sdX
```

*LINKS*:

- [MBR Partitions Types¹](https://en.wikipedia.org/wiki/Partition_type)
- [MBR Partitions Types²](https://tldp.org/HOWTO/Partition-Mass-Storage-Definitions-Naming-HOWTO/x190.html)
- [GPT Partitions Types](https://en.wikipedia.org/wiki/GUID_Partition_Table#Partition_type_GUIDs)
- [fdisk (archwiki)](https://wiki.archlinux.org/title/fdisk)

### `sfdisk`

*Parâmetros usados:*

- `<device>`: Nome do dispositivo
- `<partition>`: Número da partição
- `<sectors>`: Número de setores

*Backup* do esquema de partições do *device*:

```sh
sfdisk -d /dev/sdX > ./layout.dump
```

Restaurar *layout* de partições "backupiado":

```sh
sfdisk /dev/sdX < ./layout.dump
```

Mover partições (alterar o valor de início e fim dos blocos):

```sh
echo '+<sectors>,' | sfdisk --move-data <device> -N <partition>
```

Reordernar partições (caso alguma tenha sido excluida ou tinha sido criada no meio de outras):

```sh
sfdisk -r /dev/sdX
```

*OBSERVAÇÕES*:

- Com o sinal de `+`, move-se o ínicio do setor para o valor de setores passados em `<sectors>`

*LINKS*:

- [Reread/Resort Partitions](https://serverfault.com/questions/36038/reread-partition-table-without-rebooting) (em caso mudança de na ordenação das partições)

### `parted`

Listar os discos na máquina:

```sh
parted -l
```

### `mkfs`

Programas necessários para `fat32`:

```sh
[sudo] apt install mtools
```

Programas necessários para `exfat`:

```sh
[sudo] apt install exfatprogs
```

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição

Formatar **fat32**:

- `-n`: Adiciona *label* na formatação

```sh
[sudo] mkfs.fat -F 32 [-n <label>] /dev/sdXY
```

Formatar **ext4**:

- `-L`: Adiciona label na formatação

```sh
[sudo] mkfs.ext4 [-L <label>] /dev/sdXY
```

Formatar **exfat**:

- `-L`: Adiciona label na formatação

```sh
[sudo] mkfs.exfat [-L <label>] /dev/sdXY
```

Formatar **ntfs**:

- `-Q`: Formatação rapida
- `-L`: Adiciona label na formatação

```sh
[sudo] mkfs.ntfs [-Q] [-L <label>] /dev/sdXY
```

## Configurações

Anotações gerais sobre procedimentos (tutoriais).

### Bash

Variável PS1:

- `\u`: Usuário atual
- `\h`: Nome da máquina (host)
- `\H`: Nome da máquina completo (hostname)
- `\w`: Diretório de trabalho atual
- `\W`: Diretório de trabalho atual com o nome base (último segmento) apenas
- `$(__git_ps1 ["%s"])`: Branch atual caso esteja em um repositório Git, se não, não exibe nada

### Fonts

Configuração de fontes no sistema.

#### Tipos

- `truetype` ou `ttf`
- `opentype` ou `otf`
- `webfonts` ou `woff`

Colocar as pastas de fontes dentro das pastas dos seus respectivos tipos, ex. `<path>/truetype/Monospace`.

#### Diretórios

- Nível de sistema: `/usr/share/fonts/<type>/<family>`
- Nível de usuário: `~/.local/share/fonts/<type>/<family>`

#### Comandos

- Listar todas as fontes: `fc-list`
- Atualizar o cache de fontes: `fc-cache`

### Partições

> If you are growing a partition, you have to first resize the partition and then resize the filesystem on it, while for shrinking the filesystem must be resized before the partition to avoid data loss.

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição
- `<sectors>`: Número de setores
- `<device>`: Nome do dispositivo
- `<partition>`: Número da partição
- `<end>`: Tamanho (*size*) final
- `<new>`: Tamanho (*size*) novo
- `<label>`: Nome da *label* da partição

Formulas de cálculo entre MB/GB e setores:

- *SECTORS > MB*: `<sectors>/2/1024`
- *SECTORS > GB*: `<sectors>/2/1024^2`
- *MB > SECTORS*: `<megas>*1048576/512`
- *GB > SECTORS*: `<gigas>*(1048576*1024)/512`

#### *Growing*

1. Aumente a partição (com `parted` no modo interativo):
	```sh
	(parted) resizepart <partition> <end>
	```
1. Aumente o sistema de arquivos (`ext*`):
	```sh
	resize2fs /dev/sdXY <new>
	```

#### *Shrinking*

1. Diminua o sistema de arquivos (`ext*`):
	```sh
	resize2fs /dev/sdXY <new>
	```
1. Diminua a partição (com `parted` no modo interativo):
	```sh
	(parted) resizepart <partition> <end>
	```
1. Informe ao **kernel** sobre a mudança:
	```sh
	resizepart <device> <partition> <new>
	```

*Observações*:

- Caso a partição seja `exfat` realize somente o passo 2?

#### *Labels*

Programas necessários para `fat32`:

```sh
[sudo] apt install mtools
```

Programas necessários para `exfat`:

```sh
[sudo] apt install exfatlabel
```

##### ext4

Ver:

```sh
[sudo] e2label /dev/sdXY
```

Renomear:

```sh
[sudo] e2label /dev/sdXY <label>
```

##### fat32

Ver:

```sh
[sudo] mlabel -i /dev/sdXY -s ::
```

Renomear:

```sh
[sudo] mlabel -i /dev/sdXY ::<label>
```

##### exfat

Ver:

```sh
[sudo] exfatlabel /dev/sdXY
```

Renomear:

```sh
[sudo] exfatlabel /dev/sdXY <label>
```

##### ntfs

Ver:

```sh
[sudo] ntfslabel /dev/sdXY
```

Renomear:

```sh
[sudo] ntfslabel /dev/sdXY <label>
```
