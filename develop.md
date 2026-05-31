# Develop

Anotações gerais sobre Desenvolvimento: programas e configurações.

### `base64`

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
