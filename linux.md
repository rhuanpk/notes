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

*Parâmetros usados:*

- `<commit>`: *Hash* do *commit*

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

*Opções usados:*

- `-H`: Para a máquina
- `-P`: Desliga a máquina (*desliga*)
- `-r`: Reinicia a máquina
- `-c`: Cancela a operação de *shutdown* pendente
- `--show`: Mostra (se houver) a operação de *shutdown* pendente

```
shutdown [<options>] [<time>|now [wall]]
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
