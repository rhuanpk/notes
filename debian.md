# Debian

Anotações gerais sobre Debian: programas e configurações.

---

## `dpkg`

*Parâmetros usados:*

- `<package>`: Nome do pacote/programa
- `<binary>`: Nome do binário/executável

Listar programas instalados:

```sh
dpkg -l [<package>]
```

Listar todos os binários do pacote:

```sh
dpkg -L <package>
```

Saber a qual pacote perterce determinado binário (executável):

- Todas as ocorrências
	```sh
	dpkg -S <binary>
	```
- Filtrar pelos diretórios **bin**:
	```sh
	dpkg -S <binary> | grep -P '/usr(/local)?/bin/'
	```

---

## `apt`

*Parâmetros usados:*

- `<package>`: Nome do pacote/programa
- `<version>`: Versão do pacote

Remover completamente o programa:

```sh
[sudo] apt remove [--purge] <package>
```

Apenas baixa o programa e suas dependências sem instalar (os *debs* serão salvos em `/var/cache/apt/archives/`):

```sh
[sudo] apt install --download-only <package>
```

Marcar/Desmarcar pacote para não ser atualizado:

```sh
[sudo] apt-mark [un]hold <package>
```

Instalar pacote com versão específica (o número da versão pode ser obtido com `apt policy <package>`):

```sh
[sudo] apt install <package>:<version>
```

Listar pacotes instalados que não sejam dos repositórios do Debian:

```sh
apt list '~i!~Odebian'
```

### *apt-pinning*

Edite `/etc/apt/preferences.d/all`:

```
Package: *
Pin: release a=stable
Pin-Priority: 500

Package: *
Pin: release a=testing
Pin-Priority: 400

Package: *
Pin: release a=unstable
Pin-Priority: 300
```

Com essa configuração de versão de pacotes (e `sources.list` arquivos) você terá acesso a mais de uma versão de pacote por vez sendo que a estável será a prioridade e será baixada automática quando não específicado a versão.

*Parâmetros usados:*

- `<source>`: Fonte de busca do pacote

Para baixar de um *source* específico:

- `apt install <package>/<source>`: Tenta instalar a versão instável mantendo as dependências na versão **estável**
- `apt install -t <source> <package>`: Tenta instalar a versão instável atualizando as dependências para a versão **instável**

### *Keys*

*Parâmetros usados:*

- `<url>`: URL de *download* da chave de autenticação

Adicionar chave baixando via URL:

```sh
curl -fsSL <url> | [sudo] gpg --dearmor --output /etc/apt/keyrings/<package>.gpg
```

### *Mirrors*

Debian `/etc/apt/sources.list`:

```sh
# stable
deb http://deb.debian.org/debian stable main contrib non-free non-free-firmware
deb http://security.debian.org/debian-security stable-security main contrib non-free non-free-firmware
deb http://deb.debian.org/debian stable-updates main contrib non-free non-free-firmware

# testing
deb http://deb.debian.org/debian testing main contrib non-free non-free-firmware

# unstable
deb http://deb.debian.org/debian sid main contrib non-free non-free-firmware
```

Os arquivos `.list` (*one-line style*) serão depreciados em favor dos `.sources` (*deb822 style*). No novo estilo, o diretório `/etc/apt/trusted.gpg.d/` é depreciado, sendo oficial agora apenas o `/usr/share/keyrings` (chaves instaladas por pacotes) e `/etc/apt/keyrings` (chaves instaladas pelo usuário):

```
Types: {deb|deb-src}[ ...]
URIs: <uri>[ ...]
Suites: <suite>[ ...]
Components: [<component> ...]
Architectures: [<arch> ...]
Signed-By: [{/usr/share|/etc/apt}/keyrings/<package>.gpg]
```

## `wajig`

Programas necessários:

```bash
[sudo] apt install wajig
```

Saber o tamanho dos pacotes instalados:

```bash
wajig sizes
```
