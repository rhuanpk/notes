# Linux

Anotações gerais sobre Linux: programas e configurações.

Por via de regra, comandos de sistema são exemplificados utilizando abordagens Debian-like, então, caso esteja utilizando outra distribuição, deverá ser feito a adaptação necessária.

## Programas

Anotações gerais sobre ferramentas CLI (comandos).

### `sudo`

*Parâmetros usados:*

- `<password>`: Senha do usuário
- `<command>`: Comando fina completo

*Opções usadas:*

- `-S`: Aceita receber entrada via *pipe* (STDIN) e *new line* como delimitador
- `-k`: Reseta ou não salva a senha no *cache*
- `-v`: Valida ou atualiza o tempo de *cache* da senha

Passar senha via *pipe*:

```sh
echo -e "<password>\n" | sudo -S <command>
```

Renovar tempo de *cache* da senha:

```sh
sudo -v
```

Resetar tempo de *cache* da senha:

```sh
sudo -k
```

Executar sem guardar a senha em *cache*:

```sh
sudo -k <command>
```

### `su`

*Parâmetros usados:*

- `<shell>`: Nome do *shell* (*e.g.* `sh`, `bash`)
- `<user>`: Nome do usuário para *login*
- `<command>`: Comando final completo
- `<args>`: Parâmetros de opções

*Opções usadas:*

- `-c <command>`: Executa o comando no usuário especificado
- `-s <shell>`: Especifica o *shell* de login
- `-p`: Preserva o ambiente, como variáveis (não usado com `--login`)
- `-`, `-l`: Faz o *full login* no usuário, resetando todo o ambiente (recomendado)

"Logar" num *shell* interativo de outro usuário; Diretório de origem é preservado; Somente a variável `$HOME` é trocada (também `$USER` e `$LOGNAME` se usuário não for ***root***); Caso não especifique usuário, `root` é o padrão; Pode haver conflitos de ambiente por não ser um *full login*:

```sh
su [<user>]
```

"Logar" num *shell* interativo de outro usuário; Muda para a `$HOME` do usuário; Evita conflitos de ambiente:

```sh
su - [<user>]
```

Caso especificado o usuário, é possível passar opções do seu shell de login, por exemplo, se for `bash`, pode-se passar `-x` para o *trace*:

```sh
su [-] <user> [<args>]
```

*OBSERVAÇÕES:*

- Caso queira executar comandos em múltiplas linhas (*heredoc*), não é possível, utilize *line breaks* (`\` no final da linha)

### `id`

*Parâmetros usados:*

- `<uid>`: ID do usuário no sistema

Lista UID, GID e os grupos do usuário corrente:

```sh
id
```

Retorna somente o UID do usuário corrente:

```sh
id -u
```

Retorna somente o GID do usuário corrente:

```sh
id -g
```

Retorna o nome do usuário corrente:

```sh
id -un
```

Retorna o nome do usuário pelo UID passado:

```sh
id -un <uid>
```

### `ip`

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

### `ss`

Verificar portas sendo usadas no sistema:

```sh
[sudo] ss -ntpl
```

### `hostname`

Saber hostname:

```sh
hostname
```

IP interno:

```sh
hostname -I
```

### `flatpak`

Faça o setup pelo guia do [Flatpak](https://flatpak.org/setup) ou do [Flathub](https://flathub.org/setup).

*Parâmetros usados:*

- `<remote>`: Repositório remoto (*e.g.* `flathub`)
- `<app>`: *ID* do aplicativo remota ou localmente (*e.g.* `org.mozilla.firefox`)
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
[sudo] lsusb
```

### `lsof`

Listar portas abertas no sistema:

```sh
[sudo] lsof -nPi | grep -F LISTEN
```

Listar porta específica:

```sh
[sudo] lsof -i :<port>
```

### `shutdown`

Em geral, os comandos puros são:

- `halt`: Encerra todos os processos e desliga a CPU (matendo a energia do *hardware*)
- `poweroff`: Como `halt`, mas também envia um comando ACPI para a Placa (cortando toda a energia do *hardware*)
- `reboot`: Como `halt`, mas inicia novamente o sistema

O comando `shutdown` é um *handler* para todos esses comandos mas faz o "encerramento gracioso" dos processos.

*Parâmetros usados:*

- `<time>`: `hh:mm` no padrão 24h ou `+m` onde "m" é a quantidade de minutos a partir de agora, *e.g.* `+5` se refere daqui a 5 minutos (*default*: `+1`)
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

### `efibootmgr`

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição
- `<boot>`: ID da entrada de *boot*
- `<shim>`: Nome do binário de inicialização
- `<label>`: Nome da *label* da entrada de *boot*

*Opções usadas:*

- `-v`: Aumenta verbosidade da saída

Programas necessários:

```sh
[sudo] apt install efibootmgr
```

Listagem das entradas de *boot*:

```sh
efibootmgr [-v]
```

Remover entrada de *boot*:

```sh
efibootmgr -b <boot> -B
```

Adicionar nova entrada de *boot*:

```sh
efibootmgr -c -d /dev/sdX -p Y -l '\path\<shim>x64.efi' -L '<label>'
```

### `dd`

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição

Criar pendrive "bootavel":

```sh
[sudo] dd if=/path/image.iso of=/dev/sdX bs=32M conv=fsync status=progress
```

Criar pendrive "bootavel" (ISO compactada):

```sh
gzip -dc /path/image.iso.gz | [sudo] dd of=/dev/sdX bs=32M conv=fsync status=progress
```

Criar *backup* de partição/HD:

```sh
[sudo] dd if=/dev/sdX[Y] of=/tmp/backup.hd bs=32M
```

Criando um *virtual disk* (VD):

1. `dd if=/dev/zero of=/tmp/vd.img bs=4M count=8`
1. `mkfs.vfat -F 32 /tmp/vd.img`
1. *`hexdump -C /tmp/vd.img | more`*
1. `mount -o loop,rw [-t vfat] /tmp/vd.img /mnt/`
1. `cd /mnt/ && touch file.txt; cd -`
1. `umount /mnt/`

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

*LINKS:*

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

*OBSERVAÇÕES:*

- Com o sinal de `+`, move-se o ínicio do setor para o valor de setores passados em `<sectors>`

*LINKS:*

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

### `losetup`

Listar todos os *loop devices*:

```sh
[sudo] losetup -a
```

Desmontar e remover um *loop device*:

1. Desmontar o *device*:
	```sh
	[sudo] umount /dev/loop9
	```
1. Desanexar os arquivos referentes a esse *device*:
	```sh
	[sudo] losetup -d /dev/loop9
	```
1. Remover o *device*:
	```sh
	[sudo] rm /dev/loop9
	```

### `mount`

*Parâmetros usados:*

- `X`: Letra do disco
- `Y`: Número da partição

Montar arquivo *iso*:

```sh
[sudo] mount -o ro -t iso9660 /path/img.iso /mnt
```

Montar partição *ext4* e manipular com usuário regular:

```sh
[sudo] mount -o user /dev/sdXY /mnt
bindfs -u `id -u` -g `id -g` /mnt /media/disk

# or

[sudo] mount /dev/sdXY /media/disk
chown -Rv `id -un`:`id -gn` /media/disk
```

*OBSERVAÇÕES:*

- **FAT32** e **EXFAT** não armazenam permissões POSIX nem proprietário/grupo. O Linux **simula** essas informações via opções de montagem (`uid`, `gid`, `umask`, `fmask`, `dmask`), fazendo todos os arquivos aparecerem com os mesmos atributos, sem essas opções, o padrão costuma ser `root`
- **EXT4** armazena *uid*, *gid* e permissões POSIX diretamente no *inode* de cada arquivo/diretório. Por isso opções de montagem como `uid` e `gid` não são suportadas ou necessárias, o dono real já está gravado no disco
- **NTFS** usa ACLs do Windows, não o modelo POSIX. No Linux, o driver `ntfs-3g` traduz ou simula proprietário e permissões via opções de montagem (`uid`, `gid`, `umask`), portanto o resultado depende da configuração de montagem e das ACLs originais do arquivo

### `modprobe`

*Parâmetros usados:*

- `<module>`: Nome do módulo

Verificar se um módolo já está carregado:

```sh
modprobe --dry-run --first-time <module> && echo "not loaded" || echo "loaded"
```

### `systemctl`

*Parâmetros usados:*

- `<unit>`: Nome do serviço/*daemon*

*Opções usadas:*

- `--type`: Filtra pelo tipo de unidade
- `--state`: Filtra pelo estado da unidade
- `--reverse`: Mostra as dependências reversas (quais serviços dependem deste)

Listar todas as unidades do sistema:

```sh
systemctl list-units [--type service] [--state running]
```

Listar todas as dependências de uma unidade:

```sh
systemctl list-dependencies [--reverse] <unit>.service
```

Caso o sistema não tenha voltado do congelamento:

```sh
systemctl thaw '*'
```

### `journalctl`

*Parâmetros usados:*

- `<unit>`: Nome do serviço/*daemon*
- `<boot>`: Número sequêncial do *boot* (decrescente)

*Opções usadas:*

- `-x`: Deixa a saída visualmente mais legível (*pretty*)
- `-f`: Fica seguindo/escutando o *log* (equivalente ao `tail -f`)
- `-u <unit>`: Especifique o nome do serviço (aceita múltiplos `-u`)
- `-b [<boot>]`: Nulo ou `-0` = *boot* atual, `-1` = último *boot* e etc
- `-n <lines>`: Imprime as última *n* linhas
- `--no-pager`: Não use um paginador e imprime tudo diretamente no terminal
- `--list-boots`: List o histórico de *boots*
- `--disk-usage`: Mostra quanto de disco os *logs* estão consumindo

*Opções usadas:*

- <details>
    <summary><code>-p {&lt;priority&gt;|&lt;code&gt;}</code>: Filtra por prioridade</summary>

    - `emerg` (`0`): O sistema está inutilizável
    - `alert` (`1`): Medidas devem ser tomadas imediatamente
    - `crit` (`2`): Condições críticas
    - `error` (`3`): Condições de erro
    - `warning` (`4`): Condições de aviso
    - `notice` (`5`): Condição normal, mas significativa
    - `info` (`6`): Mensagem informativa
    - `debug` (`7`): Mensagens que são úteis para depuração
- <details>
    <summary><code>-o &lt;format&gt;</code>: Formata a saída</summary>

    - `cat`: Inclua apenas mensagens dos *logs*
    - `short`: Forma padrão
    - `json`: JSON *raw*
    - `json-pretty`: JSON indentado
    - `verbose`: *Log* completo
- <details>
    <summary><code>--since &lt;time&gt; [--until &lt;time&gt;]</code>: Filtra desde alguma data ou por um <i>range</i> de data</summary>

    - `2021-11-23 23:02:15`
    - `2021-05-04`
    - `12:00`
    - `5 hour ago, or 32 min ago`
    - `yesterday`, `today`, `now`
</details>
</details>
</details>

Seguir os *logs* de um serviço:

```sh
[sudo] journalctl -xfeu <unit>[.service]
```

Remover/Limpar os *logs*:
```sh
[sudo] journalctl --rotate --vacuum-size <size> [--unit <unit>.service]
```

### `sysctl`

Trocar a porcentagem de uso (que está sobrando) para que a *swap* seja ativada:

```sh
[sudo] sysctl vm.swappiness=90
```

*OBSERVAÇÕES:*

- 60 é o padrão, quanto maior, "menos" *swap* será usado. No caso, se quiser que a *swap* seja ativa com 90% de uso, defina o valor para 10

Aumentar o "desejo" de manter o *cache* da RAM:

```sh
[sudo] sysctl vm.vfs_cache_pressure=75
```

*OBSERVAÇÕES:*

- 100 é o padrão, quanto menor o valor, mais tempo mantem o cache

Caso atualize o arquivos de configuração do usuário como `/etc/sysctl.d/99-sysctl.conf`, utilize o comando para aplicar de imediato os parâmetros ao invés de esperar reiniciar o SO:

```sh
[sudo] sysctl --system
```

### `passwd`

*Parâmetros usados:*

- `<user>`: Nome de usuário no sistema

Alterar a senha de um usuário:

```sh
[sudo] passwd <user>
```

Limpar a senha de um usuário:

```sh
[sudo] passwd -d <user>
```

Bloquear a senha de um usuário:

```sh
[sudo] passwd -l <user>
```

Desbloquear a senha de um usuário:

```sh
[sudo] passwd -u <user>
```

*OBSERVAÇÕES:*

- Simplesmente limpar a senha do usuário o fara ficar sem senha, ou seja, ele ficará sem este meio de autenticação, *e.g.* se tentar "logar" na conta do usuário, não pedirá a senha
- Bloquear e desbloquear a senha de uma usuário implica somente na senha do mesmo, ou seja, caso bloqueamos a senha de um usuário, ele poderá fazer login por outro meio (algum tipo de chave por exemplo)
- Caso queira bloquear/desativar a conta do usuário, poderá limpar a sua senha (`-d`) e depois bloquea-la (`-l`), após isso, só podera "logar" pelo usuário de forma direta criando uma nova senha para o mesmo

### `firejail`

*Parâmetros usados:*

- `<binary>`: Nome do executáve
- `<sandbox>`: Nome dado ao *sandbox*
- `<command>`: Comando final completo

Programas necessários:

```sh
[sudo] apt install firejail
```

Executar o *shell* padrão em *sandbox*:

```sh
firejail
```

Executar a aplicação em *sandbox*:

```sh
firejail [--noprofile] [--nodbus] [--private] <binary>
```

Lista os processos executando sob *firejail*:

```sh
firejail --list
```

Executar o programa o impedindo de se conectar com a *internet* (o aplicativo não vê interfaces de rede):

```sh
firejail --protocol=unix <binary>
```

Executa o firejail criando uma nova e vazia pasta pessoal para o ***root*** e para o **usuário regular**:

```sh
firejail [--name=<sandbox>] --private
```

Listagem de diretórios dentro do *sandbox*:

```sh
firejail --ls=<sandbox> /path/[file.txt]
```

Copiar arquivo de dentro do *sandbox*:

```sh
firejail --get=<sandbox> /path/[file.txt]
```

Entrar no *sandbox* ou executar algum comando nela:

```sh
firejail --join=<sandbox> [<command>]
```

Copiar algo do *host* para o *sandbox*:

```sh
firejail --put=<sandbox> /path/host/file.txt /path/sandbox/file.txt
```

*OBSERVAÇÕES:*

- O *firejail* isola a aplicação da sua *home*, porém, não do restante do sistema de arquivos (porque em tese já pertence ao *root*)
- Por padrão, caso o *firejail* não tenha um perfil específico para a aplicação que executará, ele usurá um perfil genérico (o que pode causar problemas)

*LINKS:*

- <https://easylinuxtipsproject.blogspot.com/p/sandbox.html>

#### Troubleshooting

Problemas com áudio usando `pulseauido` como driver:

1. `mkdir -pv ~/.config/pulse`
1. `cp -v /etc/pulse/client.conf ~/.config/pulse`
1. `echo 'enable-shm = no' >> ~/.config/pulse/client.conf`

Para executar Google Chrome:

```sh
firejail --private google-chrome --no-sandbox --no-first-run
```

Caso ainda tenha problemas com Google Chrome e esteja no Wayland:

```sh
firejail --noprofile --private --env=MOZ_ENABLE_WAYLAND=1 --dns=1.1.1.1 google-chrome --no-sandbox --ozone-platform=wayland --disable-vulkan --no-first-run
```

### *Runlevels*

Runlevels são os níveis de execução do sistema criados no *System V* (*SysV*). Cada Runlevel diz ao sistema em qual "camada" o sistema deve operar (qual o seu estado atual).

> Como também é um recurso de segurança do Linux, um dos critérios para saber se um devido processo deve ser executado ou não são os *Runlevels*?

Eles variam de `0-6`:

| Runlevel | Mode               | Action                                                     |
| :------- | :----------------- | :--------------------------------------------------------- |
| 0        | *Halt*             | Poweroff the system.                                       |
| 1        | *Mono-User*        | Recovery mode, does not configure network, only root user. |
| 2        | -                  | -                                                          |
| 3        | *Multi-User*       | Start the system without GUI.                              |
| 4        | -                  | -                                                          |
| 5        | *Graphical Server* | Start the system with GUI.                                 |
| 6        | *Reboot*           | Reboot the system.                                         |

Verificar o *runlevel* atual:

```sh
runlevel
```

Chamar (mudar para) *runlevel*:

```sh
telinit <runlevel>
```

*LINKS:*

- [Runlevels & Targets](https://access.redhat.com/articles/754933)

### *Targets*

Targets são equivalentes aos Runlevels, porém, foram criados no *Systemd*, com o mesmo conceito e com outra conveção.

Num sistema com `systemd` os Runlevels são convertidos para Targets:

| Traditional Runlevel | New Target Name    | Symbolic Link       |
| :------------------- | :----------------- | :------------------ |
| Runlevel 0           | *runlevel0.target* | `poweroff.target`   |
| Runlevel 1           | *runlevel1.target* | `rescue.target`     |
| Runlevel 2           | *runlevel2.target* | `multi-user.target` |
| Runlevel 3           | *runlevel3.target* | `multi-user.target` |
| Runlevel 4           | *runlevel4.target* | `multi-user.target` |
| Runlevel 5           | *runlevel5.target* | `graphical.target`  |
| Runlevel 6           | *runlevel6.target* | `reboot.target`     |

O diretório dos *targets* está localizado em `/lib/systemd/system/`.

Verificar qual *target* padrão está definido para o `systemd`:

```sh
systemctl get-default
```

Listar todos os *targets* disponíveis no sistema:

```sh
systemctl list-units --type=target --all
```

Mudar o *target* padrão:

```sh
systemctl set-default <target>.target
```

Mudar o *target* somente para o próximo *boot*:

```sh
systemctl isolate <target>.target
```

*LINKS:*

- [Runlevels & Targets](https://access.redhat.com/articles/754933)

### SSH

*Parâmetros usados:*

- `<user>`: Usuário para conexão (*default*: usuário atual)
- `<host>`: Domínio ou IP para conexão (*default*: *host* atual)
- `<port>`: Porta do serviço SSH
- `<key>`: Caminho da chave privada
- `<comment>`: Geralmente algo que identifique o proprietário da chave

#### `ssh`

*Opções usadas:*

- `-p <port>`: Especifica a porta de conexão (*default*: `22`)
- `-i <key>`: Especifica a privada para conexão

Realizar conexão:

```sh
ssh [<options>] [-p <port>] [<user>][@][<host>]
```

#### `ssh-keygen`

Criar ssh key:

```sh
ssh-keygen [-t rsa [-b 4096]] [-t ed25519 [-a 32]] [/path/key]
```

Trocar senha da chave:

```sh
ssh-keygen -pf /path/key
```

Trocar comentário da chave:

```sh
ssh-keygen -cC "<comment>" -f /path/key
```

Gerar chave pública a partir da privada:

```sh
ssh-keygen -yf /path/key > /path/key.pub
```

Saber *fingerprint* da chave:

```sh
ssh-keygen -lf /path/key[.pub]
```

Remover *fingerprint* depreciado:

```sh
ssh-keygen [-f ~/.ssh/known_hosts] -R <host>
```

#### `ssh-agent`

Iniciar um agente *ssh* (quando algo buscar por uma chave é o *ssh-agent* que irá fornecer):

```sh
eval `ssh-agent -s`
```

*OBSERVAÇÕES:*

- Essa é a forma oficial descrita no manual do *ssh*
- Outra forma de iniciar o *ssh-agent* seria:
	`exec ssh-agent bash`
- Para ver o *pid* e o *socket* do agente:
	`printenv SSH_AGENT_PID SSH_AUTH_SOCK`

#### `ssh-add`

*Opções usadas:*

- `-k`: Processa chaves em validar certificados

Adicionar chave ao agente:

```sh
ssh-add /path/key
```

Verificar as chaves publicas adicionadas no agente:

```sh
ssh-add -l
```

Remover todas as chave do agente:

```sh
ssh-add -D
```

Remover chave específica do agente:

```sh
ssh-add -d /path/key
```

#### `ssh-copy-id`

Adicionar sua chave num servidor:

```sh
ssh-copy-id -i <key> [-p <port>] [<user>][@][<host>]
```

#### `ssh-keyscan`

Pegar a chave pública de um servidor:

```sh
ssh-keyscan [-p <port>] [-t {rsa|dsa|ecdsa|ed25519}[,...]] <host> >> ~/.ssh/know_hosts
```

*OBSERVAÇÕES:*

- Este comando lista as chaves pública do próprio servidor SSH (**sshd**) que são as credenciais validadas na hora de se conectar em um novo *host* e que precisamos responder se confiamos ou não (*yes/no*)

### `date`

Imprime o formato padrão de hora com o *timezone* definido pelo seu sistema:

```sh
date
```

Imprime saida formatada (`yyyy-mm-dd hh:mm:ss`):

```sh
date '+%Y-%m-%d %H:%M:%S'
```

Imprime os segundos desde a **Época** (`1970-01-01 00:00:00 UTC`)

```sh
date '+%s'
```

Converter segundos (desde a **Época**) em data:

```sh
date --date='@<seconds>' '+%F %T'
```

Retorna a data adiantada:

```sh
date --date="TZ=\"$(date +%Z)\" +1 hour"
```

Passar fuso horário específico:

```sh
# timezone
TZ='Asia/Tokyo' date

# abbreviation
TZ='EST' date
```

### `tree`

*Parâmetros usados:*

- `<depth>`: Inteiro de profundidade
- `<pattern>`: *String* de RegEx

*Opções usadas:*

- `-a`: Lista arquivos ocultos
- `-F`: Sufixa diretórios com `/`
- `-C`: Define *color always*
- `-p`: Exibe permissões
- `-L <depth>`: Limita a quantidade de níveis de diretórios na busca
- `-P <pattern>`: Retorna somente o que casar com o padrão
- `-I <pattern>`: Exclui os arquivos e pastas do padrão

Listar estrutura de diretórios em formato de árvore:

```sh
tree [<options>]
```

Busca o caminho de somente um arquivo:

```sh
tree /path/folder --matchdirs --prune -P <pattern>
```

### `cut`

Pegar a coluna 1 e 7 do arquivo `/etc/passwd` pelo delimitador `:`:

```sh
cut -d ':' -f 1,7 /etc/passwd
```

Pegar do 1º até o 3º caractere de cada linha:

```sh
cut -c 1-3 /etc/passwd
```

Mudar o delimitador de saída padrão:

```sh
cut -d ' ' -f 3,4 --output-delimiter=',' /path/file.txt
```

### `du`

*Opções usadas:*

- `-s`: Simplifica a saída mostrando somente os arquivos na raiz
- `-c`: Mostra a somatória total de todos os arquivos contados
- `-h`: Unidades de medida mais legíveis

Mostra o tamanho dos arquivos e pastas:

```sh
du -sch /path/folder/*
```

### `df`

*Opções usadas:*

- `-h`: Unidades de medida mais legíveis

Mostra partições e tamanho dos discos:

```sh
df -h
```

### `ncdu`

*Parâmetros usados:*

- `<folder>`: Caminho do diretórios raiz a ser analisa (*default*: diretório atual)

Gerenciar graficamente via terminal (TUI) arquivos por tamanho:

```sh
ncdu [<folder>]
```

### `ln`

*Hard Link* (Conexão Física):

- Não podem ser feitos por arquivos que estão em outros pontos de montagem
- O *link* tem o mesmo *inode* do original
- Se o original for corrompido o *link* fica independente

Symbolic Link (Conexão Simbólica):

- Tem que passar o *path* completo para este tipo de conexão
- O *link* terá um *inode* diferente do arquivo original
- Se arquivo original for corrompido o *link* quebrará

*Opções usadas:*

- `-s`: Cria um *link* simbólico
- `-f`: Força a criação do *link*
- `-v`: Aumenta verbosidade da saída

Criar *link* físico:

```sh
ln /path/original/file.txt /path/hardlink
```

Criar *link* simbólico:

```sh
ln -s /path/original/file.txt /path/symlink
```

### `shuf`

Embaralhar linhas do arquivo:

```sh
shuf /path/file.txt
```

Embaralhar, pegar a última linha e exclui-la:

```sh
line=$(shuf /path/file.txt | tail -1); echo $line; sed -ni "/$line/d" /path/file.txt
```

### `ls`

- `-a`: Exibe arquivos ocultos
- `-A`: Exibe arquivos ocultos exceto `.` e `..`
- `-i`: Exibe *inode* dos arquivos
- `-l`: Saída longa (tipo de arquivo, dono, grupo, tamanho e `mtime`)
- `-h`: Saída humana (unidade de medida legível para humanos)
- `-t`: Ordena por `mtime`
- `-d`: Não expande diretórios (quando usando *globs*)
- `-F`: Sufixa diretórios com `/`
- `--color={auto|never|always}`: Definir modo de cor da saída (*default*: `auto`)

Sintaxe base:

```sh
ls [<options>] [<path>]
```

### `cd`

Voltar para o diretorio anterior:

- Utilizando `-`:
	```sh
	cd -
	```
- Utilizando `$OLDPWD`:
	```sh
	cd $OLDPWD
	```

### `read`

*Parâmetros usados:*

- `<text>`: *String* qualquer conforme necessidade
- `<chars>`: Contagem de quantidade de caracteres

*Opções usadas:*

- `-r`: Retorna o texto *raw*, não interpreta caracteres de escape (*e.g.* `\n`)
- `-e`: Na prática, não interpreta teclas de movimentação, ou seja, consegue andar pelo texto com as setas (consequentemente, estes não são capturas pelo *read*)
- `-t`: Define um *timeout* para cancelamento do comando
- `-a`: A entrada será um *array*, ou seja, a cada espaço, um novo índice
- `-p`: Imprime uma mensagem antes do cursor
- `-i <text>`: Caso utilizando *ReadLine* (opção `-e`), define um *input* padrão
- `-n <chars>`: Retorna depois de *n* caracteres e, caso receba o delemitador de linha (tecla *return*) antes, não o inclui no *input*
- `-N <chars>`: Igual ao `-n`, porém, inclui o delimitador de linha caso retorne antes

Exemplo base:

```sh
read -re -t 5 -a ARRAY -p 'Your name: ' -i 'Tux'
```

*OBSERVAÇÕES:*

- Caso você precise "printar" algum caracter de escape ou algum tipo de formatação de texto para pedir a entrada do usuário e queira utilizar a técnica `echo -ne "\nInput: "; read -e`, pode ter comportamento inesperado pois, o texto "printado" (na mesma linha) antes da execução do `read`, será literalemente apagado caso você use o `backspace` até o final. Para contornar isso, é necessário a presença da opção `-p` do `read`, nem que seja para simplesmente printar o ": " final: `echo -ne "\nInput"; read -e -p ': '`

### `less`

*Parâmetros usados:*

- `<mark>`: Nome da marca, geralmente uma letra (*e.g.* `a`, `b`, `c`)
- `<line>`: Número da linha designada

*Comandos usados:*

- `:-i`: *Case insensitive* para buscas simples
- `:-I`: *Case insensitive* para buscas também com padrões
- `:m`: Define uma marca para a página atual
- `'<mark>`: Vai para a marca
- `<line>g`: Vai para a linha

### `grep`

*Parâmetros usados:*

- `<count>`: Inteiro de quantidade de vezes
- `<lines>`: Inteiro de quantidade de linhas
- `<pattern>`: *String* de RegEx
- `<path>`: Caminho para arquivo ou pasta

*Opções usadas:*

- `-i`: *Case insensitive*
- `-r`: Recursividade não seguindo *symlinks*
- `-n`: Número da linha da ocorrência
- `-h`: Nome do arquivo da ocorrência
- `-s`: Suprime somente mensagens de erro
- `-v`: Inverte a ocorrência (retorna todas as linhas que não casaram)
- `-o`: Retorna somente a ocorrência da linha (e não a linha toda)
- `-R`: Recursividade seguindo *symlinks*
- `-E`: Expressão Regular extendida
- `-P`: Expressão Regular PCRE
- `-I`: Rejeita arquivos binários na busca
- `-m <count>`: Pare depois de *n* ocorrências
- `-A <lines>`: Mostra *n* linhas à baixo da *match line*
- `-B <lines>`: Mostra *n* linhas à cima da *match line*
- `-C <lines>`: Mostra *n* linhas ao redor da *match line*

Sintaxe base:

```sh
grep [<options>] <pattern> {/path/file.txt|/path/folder/}[ ...]
```

Exemplos de exclusão:

- Arquivos:
	```sh
	grep --exclude=*file{4,2}* <pattern> <path>
	```
- Diretórios:
	```sh
	grep --exclude-dir={dir1,dir2} <pattern> <path>
	```

*OBSERVAÇÕES:*

- As exclusões irão excluir todos os arquivos e(ou) diretórios independente do nível do lugar que o grep estiver percorrendo que casar com a cadeia do `exclude` passado a partir da pasta *root*

### `sed`

*Parâmetros usados:*

- `<pattern>`: *String* de RegEx
- `<replacement>`: *String* de substituição

*Opções usadas:*

- `-n`: Suprime a saída padrão e mostra somente o *match*

Substituir nova linha por algum caracter:

```sh
sed -z 's/\n/; /g' /path/file.txt
```

Buscar as linhas que dão *match* e retornar somente o *pattern* do grupo especificado (*e.g.* `\1` para o primeiro grupo, `\2` para o segundo e assim por diante):

```sh
sed -nE 's/field: (.*)/\1/p' /path/file.txt
```

*OBSERVAÇÕES:*

- É como se o `sed` buscasse a linha e a recortasse (equivalente a uma *pipeline* de `grep | cut | sed | tr`)

Parar na primeira linha casada:

```sh
sed -nE '/<pattern>/{p;q}' /path/file.txt
```

*OBSERVAÇÕES:*

- É como se o `sed` percorresse as linhas de entrada até encontrar o primeiro *pattern* descrito no exemplo, depois, executasse o que está dentro do bloco de condição (`{}`) que seria "printar" (`p`) e (`;`) sair (`q`)

Substituição somente nas linhas que casam:

```sh
sed '/<pattern>/s/<pattern>/<replacement>/' /path/file.txt
```

Imprimir somente o *range* de linhas especificado:

```sh
sed -n '/<pattern>/,/<pattern>/p'
```

Remover todos caracteres de escape ANSI:

```sh
sed -nE 's/^.*\x1b\[([0-9]+;?)+m(.*)\x1b\[.*$/\2/p'
```

Cria backup na hora de efetivar as alterações & alterações em lote:

```sh
grep -rl '<pattern>' | xargs sed -Ei'.bak' '<pattern>'
```

### `xargs`

Pega a saida do pipe e concatena no final do comando que está a frente dele.

Exemplos base:

```sh
cat file.txt | xargs [sudo] apt install -y
```

```sh
xargs -a file.txt [sudo] apt install -y
```

```sh
find ./ -iname '*.mp3' | xargs rm -fv
```

### `file`

Mostra o tipo do arquivo e seu *path*:

```sh
file /path/file.txt
```

### `stat`

Ver informações e metadados de arquivos:

```sh
stat /path/file.txt
```

### `wget`

*Opções usadas:*

- `-P`: Diretório alternativo para salvar o arquivo
- `-O`: Mudar o nome de saida do arquivo
- `-c`: Continua um *download* que foi interrompido
- `-r`: Baixa pastas de forma recursiva
- `-np`: Se especificar uma pasta de *download*, não baixa o conteúdo das pastas pai (superiores)
- `--backups 0`: Sobrescrever o arquivo caso ele já exista

Sintaxe base:

```sh
wget [-P /path/save/|-O file.txt] <url>
```

Ao invés de salvar, envia para STDOUT:

```sh
wget -O - <url>
```

*OBSERVAÇÕES:*

- As opções `-P` e `-O` não podem ser usadas juntas
- Use a opção `-c` estando na pasta aonde está o arquivo de *download* interminado

### `curl`

*Parâmetros usados:*

- `<url>`: Endereço do arquivo a ser baixado
- `<path>`: Caminho para arquivo ou pasta
- `<type>`: Tipo da requisição (*e.g.* `GET`, `POST`)
- `<user>`: Nome de usuário de acesso
- `<password>`: Senha de acesso do usuário
- `<header>`: O cabeçalho da request é *case-insensitive* defino pela sintaxe `<chave>: <valor>` (*e.g.* `Content-Type: application/json` ou `content-type: application/json`)
- `<field>`: Identificador da *tag* HTML no *site*
- `<content>`: Qualquer valor possível para determinado tipo

*Opções usadas:*

- `-f`: Caso a *request* retorne algum código de erro, suprime a saída (*body response*)
- `-s`: Silencia o *curl*, suprime o progresso ou mensagens de erro, porém, mostra a *response* normalmente
- `-S`: Mostra o erro, caso ele ocorra enquanto a saída está silênciada (`-s`)
- `-L`: Tenta seguir redirecionamentos de URL
- `-d`: Específica o *body* da requisição
- `-k`: Desabilita verificações de segurança (*SSL* e etc)
- `-v`: Aumenta verbosidade da saída
- `-i`: Retorna o cabeçalho da requisição
- `-X <type>`: Tipo da *request*
- `-H <header>`: Define cabeçalho da *request* (aceita múltiplos `-H`)
- `-u <user>[:<password>]`: Credenciais para autênticação única
- `-o <path>`: Informa o nome e o local do arquivo de saída
- `-w '%{<variable>}\n[...]'`: Retorna somente a [chave específica](https://curl.se/docs/manpage.html#:~:text=The%20variables%20available%20are%3A) da *response*

Sintaxe base:

```sh
curl [-o /path/file.txt] -fsSL <url>
```

Popular *field* no HTML de determinado endereço:

```sh
curl -d "<field>=<content>" <url>
```

#### *Content-Type*

JSON:

```sh
curl [-H 'content-type: application/json'] -d '{"param1":"value1","param2":"value2"}' <url>
```

URL Encoded (espaços em branco trocados por `+`):

```sh
curl [-H 'content-type: application/x-www-form-urlencoded'] -d 'param1=value1&param2=value2' <url>
```

Form Data:

```sh
curl [-H 'content-type: multipart/form-data'] -F 'param1=value1' -F 'file=@/path/file.txt' <url>
```

XML:

```sh
curl [-H 'content-type: application/xml'] -d '<root><element>value</element></root>' <url>
```

### `nslookup`

*Parâmetros usados:*

- `<host>`: Domínio ou IP

Resolver *hostnames*/domínios:

```sh
nslookup [-type=PTR] <host>
```

### `arp-scan`

Programas necessários:

```sh
[sudo] apt install arp-scan
```

Descobrir *ips* conectados na rede local:

```sh
[sudo] arp-scan --localnet
```

### `dig`

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

- O comando `dig` aceita os tipos de domínio `A`, `MX` e `SOA`.

*LINKS:*

- [Content Base](https://www.certificacaolinux.com.br/comando-linux-dig/)
- [Record Types](https://www.cloudflare.com/pt-br/learning/dns/dns-records/)

### `history`

Salvar os comandos da sessão no histórico (manualmente, antes de encerrar o *shell*):

```sh
history -a
```

Carregar comandos do histórico que ainda não estão na sessão atual (pois foram adicionados por outra sessão):

```sh
history -r
```

Limpar histórico do terminal:

```sh
history -c
```

Não gravar comando no histórico (dê um espaço antes do comando):

```sh
 ls /tmp
```

Pesquisar algum comando no histórico:

```sh
ctrl+r
```

### `trap`

Comando *builtin* para interceptação de *SIGNALS*:

```sh
#!/bin/bash

# record new command to trap
trap "echo 'captured'" SIGTSTP EXIT

read -p 'Input: '
echo "$REPLY"

# reset signals to default
trap - SIGTSTP EXIT
```

Sinais to próprio comando `trap`:

- `EXIT`: Enviado no final do *script* e também quando capturado
	- `02`: **SIGINT** (`ctrl+c`)
	- `15`: **SIGTERM** (*kill*)
- `DEBUG`: Enviado antes de cada comando simples
- `RETURN`: Enviado no final do *script* quando for chamado com `.` ou `source`. Caso você defina o *trap* com esse sinal e depois o remova, terá que resetar o *shell* para que seu efeito passe
- `ERR`: Enviado depois de cada erro
- `WINCH`: Eviado quando a janela tem suas dimensões alteradas (diminuida ou aumentada)

*OBSERVAÇÕES:*

- Defina `set -o pipefail` para `ERR` conseguir capturar *pipelines*
- Defina `set -E` para `ERR` conseguir "exergar" os erros dentro de funções e *subshells*

### `yes`

*Loop* infinito de "echo" no STDOUT:

```sh
yes
```

Especificando a *string*:

```sh
yes n
```

### `progress`

*Parâmetros usados:*

- `<pid>`: ID do processo
- `<binary>`: Nome do executáve
- `<command>`: Comando final completo

*Opções usadas:*

- `-m`: Monitora em *loop* até o comando morrer
- `-M`: Monitor ativo mesmo sem comandos sendo monitorados
- `-p <pid>`: Monitora o comando pelo PID
- `-c <binary>`: Monitora o comando pelo nome (*e.g.* `cp`, `mv`)

Exemplos base:

```sh
<command> & progress -mp "$!"
```

```sh
<command>; progress -mc <binary>
```

```sh
<command>; progress -Mc <binary>
```

```sh
progress -M [-c <binary>]
```

### `exec`

*Parâmetros usados:*

- `<command>`: Comando final completo

O comando *exec* "substitui" o *shell* atual pelo comando passado. Caso não seja passado passado nenhum argumento, o próprio *shell* atual será "substituido" por ele mesmo.

Quando executamos algum comando num *shell*, geralmente, ele cria um PID para esse comando rodar sob ele, ou seja, um sub-processo. O *exec* faz com que o comando passado como argumento herde o PID do *shell* atual e qualquer *signal* que o novo processo receber, o processo original (o *shell*) também receberá, ou seja, quando o novo processo encerrar, o *shell* atual também encerrará (porque eles tem o "mesmo" PID).

```sh
exec [<options>] [<command>]
```

*OBSERVAÇÕES:*

- Use quando quiser que logo depois do termino do comando o *shell* atual seja encerrado
- Use para redirecionar a saída do próprio *shell* para controles de logs (no final, um script também executa num *shell*)

### `scp`

Local > Remoto:

```sh
scp [-r] [-P <port>] /local/path [<user>][@][<host>]:/remote/path
```

Remoto > Local:

```sh
scp [-r] [-P <port>] [<user>][@][<host>]:/remote/path /local/path
```

### `gpg`

*Parâmetros usados:*

- `<key>`: ID da chave privada
- `<pubkey>`: ID da chave pública
- `<path>`: Caminho para arquivo

Gerar chave *gpg* (a geração é silenciosa e será guardada automáticamente no chaveiro *gpg*, para podermos vê-la, precisamos exporta-la):

```sh
gpg --full-gen-key
```

*OBSERVAÇÕES:*

- Para mudar o "nível de segurança da chave":
	- `gpg --edit-key <key>`
	- `gpg> trust`
	- *escolher*
	- `gpg> save`

Listar chaves públicas:

```sh
gpg -k
```

Listar chaves privadas:

```sh
gpg -K
```

*Fingerprint* das cahves (16 últimos caracteres da chave):

```sh
gpg --fingerprint
```

Gerar certificado de revogação:

```sh
gpg --gen-revoke <key> > /path/revocation.crt
```

Exportar chave pública (gerar o arquivo da chave pública):

```sh
gpg --export --armor <key> > /path/pubkey
```

Exportar chave privada (gerar o arquivo da chave privada):

```sh
gpg --export-secret-key --armor <key> > /path/key
```

Criptografar arquivo de forma simétrica (*passphrase*):

```sh
gpg --symmetric /path/file.txt
```

Descriptografar arquivo de forma simétrica (*passphrase*):

```sh
gpg [--no-symkey-cache] --decrypt /path/file.txt.gpg
```

Importar chave pública para o chaveiro:

```sh
gpg --import /path/pubkey
```

Assinar texto de entrada com chave de forma limpa (sem criptográfia):

```sh
gpg --clear-sign > /path/file.asc
```

Assinar texto de entrada com chave de forma "suja" (com criptográfia):

```sh
gpg --sign > /path/file.asc
```

Assinar arquivo com chave de forma limpa (sem criptográfia):

```sh
gpg --clear-sign /path/file.txt
```

Assinar arquivo com chave de forma "suja" (com criptográfia):

```sh
gpg --sign /path/file.txt
```

Validar a integridade do arquivo (verifica se a assinatura do arquivo condiz com o conteúdo):

```sh
gpg --verify /path/file.txt
```

Criptografar de forma assimétrica (*pair of keys*):

```sh
gpg --encrypt --recipient <pubkey> /path/file.txt
```

*OBSERVAÇÕES:*

- Nesse caso você não precisa informar o recipiente privado (a chave privada) pois, em tese, ela já está em seu chaveiro privado

Descriptografar já validando a integridade da mensagem ou arquivo:

```sh
gpg --output /path/file.txt --decrypt /path/file.txt.gpg
```

Desempacote blindagem ASCII e empacota blindando em OpenPGP (*output redirecting and pipe entring accepted*):

```sh
gpg --dearmor /path/key.asc
```

Tipos de entrada para senha:

- Via *default setting*: *não passe nenhuma opção*
- Via *hidden prompt*:
	`--pinentry-mode loopback`
- Via *plain text*:
	`--batch --passphrase <password>`
- Via *STDIN*:
	`<password> | --batch --passphrase-fd 0` ou
	`--batch --passphrase-fd 0 <<< <password>`

*OBSERVAÇÕES:*

- Todos os redirecionamentos de arquivos feitos podem ser substituídos pela opção do próprio comando (`--output <path>`), ou seja, isso implica que se não for especificado a saída, o STDOUT é o padrão (a tela)
- Todos os parâmetros `<key>` podem ser substituídos pelos meio de identificação da chave, *e.g.* *email* ou *fingerprint*

### `gsettings`

Mudar tema via CLI:

```sh
gsettings set org.gnome.desktop.interface gtk-theme "Theme Name"
```

Mudar icone via CLI:

```sh
gsettings set org.gnome.desktop.interface icon-theme "Icon Name"
```

Habilitar/Desabilitar a o bloquei de tela (e a suspenção) quando escurecer a tela:

```sh
gsettings set org.gnome.desktop.screensaver lock-enabled {true|false}
```

Habilitar modo ***dark*** como padrão:

```sh
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
```

*OBSERVAÇÕES:*

- O tema que é escolhido (propriedade `gtk-name`) que deverá ser *dark* (caso queira que assim seja)
- A propriedade `prefer-dark` serve para aplicativos que tem seu próprio tema e com uma versão *dark*

### `basename`

Listar somente o nome do arquivo passando o *path* completo:

```sh
basename /path/file.txt
```

Listar com múltiplos *paths*:

```sh
basename -a /first/path/file.txt /second/path/file.txt
```

*OBSERVAÇÕES:*

- Com a opção `-a` do comando é possível usa-lo com `xargs`

Cortar a extensão do arquivo na saída:

```sh
basename -s .txt /path/file.txt
```

### `dirname`

Imprime o caminho de um *path* sem o último membro:

```sh
dirname /path/file.txt
```

### `realpath`

*Parâmetros usados:*

- `<path>`: Caminho para arquivo ou pasta
- `<folder>`: Caminho para pasta

*Opções usadas:*

- `-s`: *Links* simbólicos não são expandidos
- `-z`: Troca nova linha por nulo
- `--relative-to=<folder>`: Retorna o caminho relativo para chegar no arquivo por dentro da pasta passada

Retorna o caminho absoluto dos arquivos passados como argumento:

```sh
realpath [<options>] <path>[ ...]
```

*OBSERVAÇÕES:*

- Por padrão se o arquivo for um *link* simbólico, será expandido

### `readlink`

Retorna o caminho original de um *link* simbólico (*symlink*):

```sh
readlink -f /path/symlink
```

### `mktemp`

Gerar arquivos com nomes aleatórios:

```sh
mktemp XXXXXXX.tmp
```

Gerar pastas com nomes aleatórios:

```sh
mktemp -d XXXXXXX.tmp
```

Gerar capturando o nome:

```sh
temp="$(mktemp XXXXXXX.tmp)"
```

Gerando validando a operação:

```sh
if temp="$(mktemp XXXXXXX.tmp [2>&-])"; then
	# case created
else
	# case not created
fi
```

Caso queira validar somente se houver erro:

```sh
if ! temp="$(mktemp XXXXXXX.tmp [2>&-])"; then
	# case not created
fi
echo "temp: $temp"
```

### `column`

*Parâmetros usados:*

- `<delimiter>`: Caractere que define a separação de informações
- `<header>`: Nome do cabeçalho
- `<column>`: É o nome das colunas que foram renomeadas, caso não tenham sido, por padrão são numeradas a partir do índice `1`

*Opções usadas:*

- `-t`: Cria a tabela
- `-L`: Mantem linhas vazia
- `-J`: Saída formatada em JSON
- `-s <delimiter>`: Delimitador de entrada
- `-o <delimiter>`: Delimitador de saída
- `-N <header>[,...]`: Nomeia as colunas
- `-H <column>[,...]`: Esconde as colunas determinadas
- `-R <column>[,...]`: Alinha as colunas à direita

Exemplos base:

```sh
column -tL -s ':' -o '|' /etc/passwd
```

```sh
column -tL -s ':' -o '|' -H 2,5 /etc/passwd
```

```sh
column -tL -s ':' -o '|' -N 'USERNAME,PASSWORD,UID,GID,GECOS,HOME,SHELL' /etc/passwd
```

```sh
column -tL -s ':' -o '|' -N 'USERNAME,PASSWORD,UID,GID,GECOS,HOME,SHELL' -H PASSWORD,GECOS /etc/passwd
```

Exemplo com `jq`:

```sh
column -J -tL -s ':' -o '|' -N 'USERNAME,PASSWORD,UID,GID,GECOS,HOME,SHELL' /etc/passwd | jq
```

### `paste`

*Parâmetros usados:*

- `<command>`: Comando fina completo

Coloca linhas lado a lado:

```sh
paste <(<command>) <(<command>)
```

### `rsync`

*Parâmetros usados:*

- `<port>`: Porta da conexão SSH
- `<pattern>`: *String* de RegEx

*Opções usadas:*

- `-r`: Modo recursivo
- `-v`: Modo verboso
- `-h`: Aumenta a legibilidade
- `-a`: Aplica recursividade, preserva permissões, usuários, grupos e *timestamp* (*inode*)
- `-u`: Pula arquivos no qual o destino é mais novo
- `-z`: Comprime os dados trafegados deixando o tamanho do *payload* menor (consumindo mais processamento)
- `-P`: Mostra o progresso
- `-e 'ssh -p <port>'`: Muda a porta padrão (`22`) de conexão
- `--delete`: Caso algum arquivo da fonte não exista mais no destino, no destino também é excluído
- `--exclude=<pattern>`: Exclui arquivos ou diretórios, aceitando *glob* ou caminho absoluto
- `--include=<pattern>`: Inclui arquivos ou diretórios (que foram excluídos), aceitando *glob* ou caminho absoluto

Sintaxe base:

```sh
rsync [<options>] /path/folder1/ /path/folder2/ /path/file3.txt /path/backup/
```

Exemplo base:

```sh
rsync -auhv --include=.files-* --exclude={file1,folder2,.*} --exclude=*.bak /absolute/src/file1.txt relative/src/folder2/ /tmp/dst/backup/
```

*OBSERVAÇÕES:*

- O destino ou origem aceita o modo de *login* de protocolo `ssh` (`user@host:/path`)
- Caso a pasta de destino não exista o *rsync* criará automáticamente
- No *rsync* `/path/folder` representa o próprio arquivo, ou seja, na hora de fazer a cópia, copiará a pasta ***folder*** com os arquivos dentro, porém, se passar `/path/folder/` não está pegando o *basename* mas somente os arquivos dentro de ***folder***
- Por *default*, caso utilize o *rsync* com os mesmos *paths* de origem e destino, ele simplesmente faz a sincronia dos arquivos (copia somente oque foi alterado, ou seja, o que há de novo) e preserva do destino os que já foram excluídos da fonte (ver opção `--delete`)
- Opção `--exclude` é única para cada arquivo que deseja não sincronizar?

### `ncal`

*Parâmetros usados:*

- `<count>`: Quantidade de itens a serem mostrados
- `<month>`: Índice do mês a ser exibido (`1-12`)
- `<year>`: Ano a ser exibido (*e.g.* `2042`)

*Opções usadas:*

- `-B`: Mostra os meses **antes** desse (incluindo o atual)
- `-A`: Mostra os meses **depois** desse (incluindo o atual)
- `-3`: Mostra junto do atual o mês anterior e posterior
- `-j`: Mostra o número do dia (em relação ao ano)
- `-y`: Mostra todos os meses do ano
- `-w`: Mostra junto a contagem das semanas
- `-m`: Mostra um mês específico

Calendário CLI:

```sh
ncal -b [-{B|A}<count>] [-3] [-jyw] [-m <month>] [<year>]
```

### `apropos`

*Parâmetros usados:*

- `<about>`: Assunto a ser pesquisado

Pesquisar manpages para determinado assunto que case:

```sh
apropos <about>
```

### `slop`

*Opções usadas:*

- `-q`: Silencia a saída
- `-f`: Formata a saída

Programas necessários:

```sh
[sudo] apt install slop
```

Retorna a área selecionada no estilo `x,y+width+height` (`left,top+right+bottom`):

```sh
slop
```

Formatando a saída:

```sh
# %x: x axis
# %y: y axis
# %w: width
# %h: height
# %g: geometry (%wx%h+%x+%y)
# %i: window id
# %%: literal '%'
slop -f '%x %y %w %h %g %i'
```

### `ffmpeg`

*Parâmetros usados:*

- `<value>`: Pode variar de `0` até `1`, sendo que 1 é a velocidade normal, logo, **0.75** é **25%** mais rápido, **0.5** é **50%** e assim sucessivamente

Aumentar a velocidade de um vídeo:

```sh
ffmpeg -i /path/video.mp4 -filter:v "setpts=<value>*PTS" -an /path/output.mp4
```

*LINKS:*

- [Blog Viva o Linux](https://www.vivaolinux.com.br/dica/Como-aumentar-ou-reduzir-a-velocidade-de-um-video-via-linha-de-comando)

### `tiv`

Programas necessários:

```sh
[sudo] apt install tiv
```

Ver imagens pelo terminal:

```sh
tiv /path/image.png
```

### `gifwrap`

Ver *gifs* pelo terminal:

```sh
gifwrap -f /path/image.gif
```

*OBSERVAÇÕES:*

- Deixe o menor *zoom* possível do terminal

### `yt-dlp`

Listar formatos disponíveis:

```sh
yt-dlp -F <url>
```

Baixar somente áudio:

```sh
yt-dlp -x --audio-format mp3 <url>
```

Baixar áuido e vídeo, específicando tipo e resolução do vídeo (pode-se específicar somente o tipo ou resolução):

```sh
yt-dlp -S ext:mp4,res:1080 <url>
```

Baixar áudio e vídeo na melhor qualidade em conjunto, ou seja, a melhor qualidade de vídeo que tenha seu áuido diretamente compatível:

```sh
yt-dlp -f mp4 <url>
```

## Configurações

Anotações gerais sobre procedimentos (tutoriais).

### Sudo

Manipulação do arquivo **sudoers**:

```
[sudo] visudo -f /etc/sudoers.d/users
```

Remover ***cache*** de senha (via *sudoers*):

```
Defaults:ALL timestamp_timeout=0
```

Liberar usuário como **sudo**:

- Via grupo *sudo*:
	```sh
	[sudo] usermod -aG sudo <user>
	```
- Via arquivo *sudoers*:
	```sh
	<user> ALL=(ALL) [NOPASSWD:]ALL
	```

Liberar apenas comandos específicos (via *sudoers*):

```sh
<user> ALL=[NOPASSWD:]/absolute/path/command[,...]
```

### Bash

Variável PS1:

- `\u`: Usuário atual
- `\h`: Nome da máquina (host)
- `\H`: Nome da máquina completo (hostname)
- `\w`: Diretório de trabalho atual
- `\W`: Diretório de trabalho atual com o nome base (último segmento) apenas
- `$(__git_ps1 ["%s"])`: Branch atual caso esteja em um repositório Git, se não, não exibe nada

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

- *SECTORS > MB*:
	`<sectors>/2/1024`
- *SECTORS > GB*:
	`<sectors>/2/1024^2`
- *MB > SECTORS*:
	`<megas>*1048576/512`
- *GB > SECTORS*:
	`<gigas>*(1048576*1024)/512`

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

*OBSERVAÇÕES:*

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

### SSH

Configurações do SSH (*client & sever*) no sistema.

*Parâmetros usados:*

- `<user>`: Usuário para conexão (*default*: usuário atual)
- `<host>`: Domínio ou IP para conexão (*default*: *host* atual)
- `<port>`: Porta do serviço SSH
- `<seconds>`: Quantidade de segundos
- `<count>`: Inteiro de quantidade de vezes
- `<type>`: Tipo da chave ou algoritmo

#### Arquivos e Pastas

Arquivos de coniguração:

- Arquivo de configuração do usuário (*client*):
    `~/.ssh/config`
- Arquivo global de configuração (*client*):
    `/etc/ssh/ssh_config`
- Arquivo global de configuração (*server*):
    `/etc/ssh/sshd_config`

Diretórios de configuração:

- Pasta de configuração do usuário (*client*):
    `~/.ssh/`
- Pasta global de configuração:
    `/etc/ssh/`
- Pasta de configuração do usuário (*client*):
    `/etc/ssh/ssh_config.d/`
- Pasta de configuração do usuário (*server*):
    `/etc/ssh/sshd_config.d/`

Arquivos de identificação:

- `known_hosts`: Servidores que o *client* (usuário) aceitou como confiaveis na hora de estabelecer/solicitar conexão com um servidor. Ele envia seu *fingerprint* para que o *client* possa validar que está se conectando com o destino correto
- `authorized_keys`: Clientes que o usuário aceitou como confiaveis para se conectar. Caso o *server* estiver cofigurado para aceitar apenas conexões via chave, somente os clientes que tem suas chaves públicas adicionadas neste arquivo serão bem-sucedidos

#### Segurança e Privacidade

Nos arquivos de configuração para o servidor/*daemon*/`sshd`:

- Trocar porta de conexão:
	`Port <port>`
- Permitir ou não o acesso direto ao *root*:
	`PermitRootLogin {yes|no}`
- Permitir ou não senha vazias:
	`PermitEmptyPasswords {yes|no}`
- Quantidade e tempo de inatividade (sem tráfego de pacotes) até receber *disconect*:
	- Tempo de inatividade a cada *request TCPKeepAlive*:
		`ClientAliveInterval <seconds>`
	- Quantidade de *request TCPKeepAlive* antes do *disconect*:
		`ClientAliveCountMax <count>`
- Máximo de conexões simultâneas:
	`MaxSessions <count>`
- Máximo de tentativas de conexão:
	`MaxAuthTries <count>`
- Permitir ou não autênticação por senha (caso não, a autênticação será feita somente via par de chaves):
	`PasswordAuthentication no`
- Bloquear ou liberar determinados IPs (corings `*` e `?` podem ser usados):
	`{Allow|Deny}Users <user>[@<host>][ ...]`

Arquivo final de exemplo:

```conf
Port 9999
PermitRootLogin no
PermitEmptyPasswords no
ClientAliveInterval 30
ClientAliveCountMax 5
MaxSessions 3
MaxAuthTries 5
PasswordAuthentication no
AllowUsers user1 user2@ip2
DenyUsers user3@ip3
```

*OBSERVAÇÕES:*

- Caso o limite de tentativas de autenticação seja 3 e tenha 3 chaves no agente, quando a conexão for estabelecida, tentará ser feito a autenticação com essas 3 chaves e todas as tentativas serão esgotadas imediatamente. Em caso de uso de senha se a primeira falhar, a conexão será encerrada (se não, teria 3 tentativas por senha a serem tentadas)

- Na fase inicial da conexão *ssh* o **cliente** requisita a conexão ao **servidor** que por sua vez envia a sua chave pública (sua *host key*, que é a chave criada automáticamente pelo *ssh* quando instalado, ou seja, é a própria chave do *sshd*) para que o **cliente** possa validar que está se conectando realmente no **servidor** desejado e não em algum impostor. Quando o **servidor** envia a sua *host key*, o **cliente** verifica se ela já consta no `~/.ssh/know_hosts`, caso não, pergunta ao usuário se quer prosseguir com a conexão e então salva a *public key* no arquivo?

#### Agente Atuomático

1. Forma **manual** (mais segura?):
	- Deixe a chave *ssh* criptografada (com algum utilitário como `gpg` ou `toplip`)
	- Iniciado a sessão, descriptografe a chave
	- Faça o processo manual de colocar a chave no agente
1. Forma **automática** (usando o *keychain*):
	- Configure o arquivo `~/.ssh/config`
	- Instale o *keychain*
	- Configure o *keychain* no `~/.bash_profile`

Exemplo de configuração via `~/.ssh/config`:

```
Host *
	UseKeychain yes
	AddKeysToAgent yes
	IdentityFile /path/key
```

Exemplo de configuração via `keychain` (`~/.bash_profile`):

```sh
/usr/bin/keychain --clear /path/key
. ~/.keychain/$(hostname)-sh
```

*OBSERVAÇÕES:*

- Quando criamos as chaves **ssh** para o **git** por exemplo, não necessariamente precisamos adiciona-la ao **ssh-agent**, pois, caso você tente dar algum clone ou push (utilizando conexão **ssh** obviamente), por padrão o protocolo procurará se existe alguma chave no *default path* do **ssh** (`/path/key`)
- Quando for manipulado o respositório **git**, será encontrado a chave privada e será pedido sua senha (é claro que, caso tenha a chave adicionada ao *ssh-agent*, ele nem se quer irá pedir a senha, a autênticação será automática)

#### *Auto Accept*

Aceitar/Confiar em novos *host* automáticamente sem precisar responder que "sim":

```sh
# also ca put in the config file
ssh -o 'StrictHostKeychecking=no' [-p <port>] [<user>][@][<host>]
```

#### *Host Key*

Configurar a *host key* que o servidor entrega (no arquivo de configuração do *server*):

```sh
HostKey /etc/ssh/ssh_host_<type>_key
```

Permitir que o cliente aceite mais tipos de *host keys*:

```sh
# also ca put in the config file
ssh -o 'HostKeyAlgorithms=+<type>[,...]' [-p <port>] [<user>][@][<host>]
ssh -o 'PubkeyAcceptedKeyTypes=+<type>[,...]' [-p <port>] [<user>][@][<host>]
ssh -o 'PubkeyAcceptedAlgorithms=+<type>[,...]' [-p <port>] [<user>][@][<host>]
```

#### *Banners & Welcome*

1. Para mostrar mensagem antes de se logar precisa colocar a mensagem no *banner*:
	`[sudo] vim /etc/ssh/banner`
1. Depois coloque o caminho do *banner* na variável dentro do arquivo de configuração:
	`Banner /etc/ssh/banner`

#### *Troubleshooting*

A versão 9 e posterior do `openssh` usa o `ssh.socket` como gatilho para o *daemon* `ssh.service`, o que faz com que a porta precise ser configurado via `systemd` e não `sshd_config.conf`.

Para lidar com isso podemos desabilitar o `ssh.socket` e habilitar o `ssh.service`:

1. `[sudo] systemctl disable --now ssh.socket`
1. `[sudo] systemctl enable --now ssh.service`

Caso não queira desabilita-lo:

1. Edite as configurações do *server*:
	`/etc/ssh/sshd_config.d/sshd_config.conf`
1. Recarregue os *daemons* e reinicie o *socket*:
	`systemctl daemon-reload && systemctl restart ssh.socket`

OBSERVAÇÕES:

- Ao fazer o recarregamento e o reinício, `/usr/lib/systemd/system-generators/sshd-socket-generator` será executado, gerando o arquivo `/run/systemd/generator/ssh.socket.d/addresses.conf` contendo as configurações pro *sshd* funcionar como esperado

### GPG

Formas de resetar o agente:

- `gpgconf --kill gpg-agent`
- `gpgconf --reload gpg-agent`
- `gpg-connect-agent reloadagent /bye`

Caso precise trocar a interface de dialogo da senha do *gpg* (que usa o *pinentry*), execute:

```
update-alternatives --config pinentry
```

Ou para mudar a configuração apenas para o *gpg*:

```
pinentry-program /usr/bin/pinentry-{curses|tty} >> ~/.gnupg/gpg-agent.conf
```

Outra forma seria desinstalar o *pinentry* na qual NÃO deseja mais a utilizar:

```
[sudo] apt remove pinentry-gnome
```

### Fonts

Configuração de fontes no sistema.

#### Tipos

- `truetype` ou `ttf`
- `opentype` ou `otf`
- `webfonts` ou `woff`

Colocar as pastas de fontes dentro das pastas dos seus respectivos tipos, *e.g.* `<path>/truetype/Monospace`.

#### Diretórios

- Nível de sistema:
	`/usr/share/fonts/<type>/<family>`
- Nível de usuário:
	`~/.local/share/fonts/<type>/<family>`

#### Comandos

- Listar todas as fontes:
	`fc-list`
- Atualizar o *cache* de fontes:
	`fc-cache`
