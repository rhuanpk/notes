# Develop

Anotações gerais sobre Desenvolvimento: programas e configurações.

## `base64`

Tanto para codificar quanto para decodificar é necessário passar o dado via **arquivo** ou **STDIN**.

*Parâmetros usados:*

- `<cols>`: Quantidade de colunas
- `<data>`: Dado, seja ele puro ou retorno de alguma execução

*Opções usadas:*

- `-d`: Decodifica *base64* para o original
- `-w <cols>`: Número de colunas na saída, `0` para uma única linha

Exemplos base:

```sh
base64 [-w <cols>] [-d] /path/file.txt
```

```sh
base64 [-w <cols>] [-d] <<< <data>
```

```sh
<data> | base64 [-w <cols>] [-d]
```

## `sqlmap`

Teste automatizado de *SQL Injection*:

```sh
sqlmap \
	[--dbms=<dbms>] \
	[--level=<1..5>] \
	[--risk=<1..3>] \
	[--tamper=space2comment] \
	[--random-agent] \
	[-p 'param[,...]'] \
	[-v] \
	-u 'http://localhost:9999/v0/api/endpoint?param=value'
```

## `podman`

Programa Podman no sistema.

### *Troubleshooting*

Depois do *host* reiniciar ou suspender, o *podman* pode perder a sessão, causando o erro:

```
... try resetting the pause process with "podman system migrate"
```

Para resolver, habilite a permanência de login:

```sh
loginctl enable-linger
```

Verifique se retorna `yes`:

```sh
loginctl user-status | grep -m1 'Linger'
```

## `webfsd`

Servidor *web* estático leve.

*Parâmetros usados:*

- `<port>`: Porta do servidor *web*
- `<folder>`: Caminho da pasta raiz do projeto

*Opções usadas:*

- `-d`: Modo *debug* (verboso)
- `-F`: Roda em *foreground* (não desatacha o processo, consegue parar com `ctrl+c`)
- `-4`: Sobe como IPv4
- `-p <port>`: Troca a porta padrão do serviço (*default:* `8000`)
- `-r <folder>`: Troca a pasta padrão do serviço (*default:* `.`)

Programas necessários:

```sh
[sudo] apt install webfs
```

Exemplo base:

```sh
webfsd -dF [-4] [-p <port>] [-r <folder>]
```

*OBSERVAÇÕES:*

- Quando instalado, cria um *daemon* no sistema que pode ser desabilitado com `[sudo] systemctl disable --now webfs.service` se for desejado

## `asdf`

*Parâmetros usados:*

- `<plugin>`: Nome da ferramenta
- `<version>`: Versão da ferramenta

*Opções usadas:*

- `-u`: Define globalmente a versão
- `-p`: Define localalmente a versão no `.tool-versions` pai mais próximo

Comandos base:

1. Listar todos os *plugins* e suas versões (já instalados):
    `asdf list`
1. Listar todos os *plugins* disponíveis (para adição):
    `asdf plugin list all`
1. Adicionar um *plugin*:
    `asdf plugin add <plugin>`
1. Instalar uma ferramenta:
    `asdf install <plugin> {<version>|latest}`
1. Define localmente a versão de uma ferramenta:
    `asdf set [-u] [-p] <plugin> {<version>|latest}`
1. Verificar a versão atual de cada ferramenta:
    `asdf current`

## `aws`

*Parâmetros usados:*

- `<name>`: Nome do perfil
- `<key>`: Nome da variável
- `<value>`: Valor da variável

Comandos base:

- `aws configure`: configura o perfil padrão
- `aws configure --profile <name>`: configura o perfil especificado (cria se não existir)
- `aws configure list`: lista as configurações do perfil padrão
- `aws configure list-profiles`: lista os nomes dos perfis configurados
- `aws configure list --profile <name>`: lista as configuerações do perfil especificado
- `aws configure set <key> <value>`: define o valor na variável do perfil padrão
- `aws configure set <key> <value> --profile <name>`: define o valor na variável do perfil especificado
- `aws configure get <key>`: pega o valor da variável específica do perfil padrão
- `aws configure get <key> --profile <name>`: pega o valor da variável específica do perfil especificado

*OBSERVAÇÕES:*

- O parâmetro `<key>` dos comandos `get` e `set` podem ser encontradas pelo comando `aws configure [get|set] help`
