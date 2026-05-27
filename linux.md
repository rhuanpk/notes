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

- `<shell>`: Nome do *shell*, ex. `sh`, `bash`
- `<user>`: Nome do usuário para *login*
- `<command>`: Comando final completo
- `<args>`: Parâmetros de opções

*Opções usadas:*

- `-c <command>`: Executa o comando no usuário especificado
- `-s <shell>`: Especifica o *shell* de login
- `-p`: Preserva o ambiente, ex. variáveis (não usado com `--login`)
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
grep [<options>] <pattern> {/path/file.txt|/path/folder/[ ...]}
```

Exemplos de exclusão:

- Arquivos:
	```sh
	grep --exclude=*file_{3,4}* <pattern> <path>
	```
- Diretórios:
	```sh
	grep --exclude-dir={dir_1,dir_2} <pattern> <path>
	```

*OBSERVAÇÕES:*

- As exclusões irão excluir todos os arquivos e(ou) diretórios independente do nível do lugar que o grep estiver percorrendo que casar com a cadeia do `exclude` passado a partir da pasta *root*

### `file`

Mostra o tipo do arquivo e seu *path*:

```sh
file /path/file.txt
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
- `-v`: Deixa a saída verbosa

Criar *link* físico:

```sh
ln /path/original/file.txt /path/hardlink
```

Criar *link* simbólico:

```sh
ln -s /path/original/file.txt /path/symlink
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
	sudo usermod -aG sudo <user>
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
- Atualizar o *cache* de fontes: `fc-cache`

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
