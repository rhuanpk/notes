# Develop

Anotações gerais sobre Desenvolvimento: programas e configurações.

## `printf`

Imprimir caracteres em sequência:

```sh
printf -- '-%.s' `seq <count>`
# or
printf -- '|%.s\n' `seq <count>`
```

## `python`

Programas necessários:

```sh
apt install python3-venv python3-full
```

Criando e executando projeto Python em ambiente isolado:

1. Crie o ambiente virtual:
    ```sh
    python3 -m venv .venv
    ```
1. Ative o ambiente virtual:
    ```sh
    source .venv/bin/activate
    ```
1. Instale/Configure o programa/projeto:
    ```sh
    [python -m] pip install -r requirements.txt [-c constraints.txt]
    # or
    [python -m] pip install <program>
    ```
1. Execute/Inicie o programa/projeto:
    ```sh
    python main.py
    # or
    <program> [<options>]
    ```

Para sair do ambiente virtual:

```sh
deactivate
```

*OBSERVAÇÕES:*

- Quando entrar no ambiente virtual, pode ser que apenas o pacote `python` esteja configurado e não o `pip`, se for o caso, temos duas opções:
    1. Usar o `pip` pelo `python` prefixando o comando `python -m`
    1. Configurar o `pip` para ambientes virtuais com `python -m ensurepip --upgrade` (porém, nem todos os sistemas permitem essa configuração nativamente)
- Ao fazer o *download* de dependências (`pip install -r requirements.txt`), caso esteja demorando muito, pode ser que a versão instalada no sistema, não seja a mesma do programa/projeto, então as dependências teram que ser compiladas. Para contornar isso, use alguma ferramenta como `asdf` para definir uma versão local, a mesma da aplicação

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

- `<plugin>`: Nome do programa
- `<version>`: Versão do programa

*Opções usadas:*

- `-u`: Define globalmente a versão
- `-p`: Define localalmente a versão no `.tool-versions` pai mais próximo

Comandos base:

- `asdf list`:
	Listar todos os *plugins* e suas versões (já instaladas)
- `asdf plugin list all`:
	Listar todos os *plugins* disponíveis (para adição)
- `asdf plugin add <plugin>`:
	Adicionar um *plugin*
- `asdf install <plugin> {<version>|latest}`:
	Instalar um *plugin*
- `asdf set [-u] [-p] <plugin> {<version>|latest}`:
	Definer a versão de um *plugin*
- `asdf current`:
	Verificar a versão atual de cada *plugin*

## `aws`

*Parâmetros usados:*

- `<name>`: Nome do perfil
- `<key>`: Nome da variável
- `<value>`: Valor da variável

Comandos base:

- `aws configure`:
	Configura o perfil padrão
- `aws configure --profile <name>`:
	Configura o perfil especificado (cria se não existir)
- `aws configure list`:
	Lista as configurações do perfil padrão
- `aws configure list-profiles`:
	Lista os nomes dos perfis configurados
- `aws configure list --profile <name>`:
	Lista as configuerações do perfil especificado
- `aws configure set <key> <value>`:
	Define o valor na variável do perfil padrão
- `aws configure set <key> <value> --profile <name>`:
	Define o valor na variável do perfil especificado
- `aws configure get <key>`:
	Pega o valor da variável específica do perfil padrão
- `aws configure get <key> --profile <name>`:
	Pega o valor da variável específica do perfil especificado

*OBSERVAÇÕES:*

- O parâmetro `<key>` dos comandos `get` e `set` podem ser encontradas pelo comando `aws configure [get|set] help`
