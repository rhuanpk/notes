# Bash

Anotações gerais sobre Debian: programas e configurações.

## *Internal Variables*

Variáveis do **bash**:

- `BASH_ENV`: Arquivo que será carregado antes do comando
- `PROMPT_COMMAND`: Define um comando para ser executado depois de cada comando

Parâmetros da variável `PS1`:

- `\u`: Usuário atual
- `\h`: Nome da máquina (host)
- `\H`: Nome da máquina completo (hostname)
- `\w`: Diretório de trabalho atual
- `\W`: Diretório de trabalho atual com o nome base (último segmento) apenas
- `$(__git_ps1 ["%s"])`: Branch atual caso esteja em um repositório Git, se não, não exibe nada

## *Parameter Expansion*

*Default values:*

- `:-`:
	```sh
	echo "$foo"
	#

	echo "${foo:-bar}"
	# bar

	echo "$foo"
	#
	```
- `:=`:
	```sh
	echo "$foo"
	#

	echo "${foo:=bar}"
	# bar

	echo "$foo"
	# bar
	```
- `:?`:
	```sh
	: ${foo:?not defined}
	# bash: foo: not defined
	```
- `:+`:
	```sh
	foo='bar'

	echo "$foo"
	# bar

	echo "${foo:+boo baz}"
	# boo baz

	echo "$foo"
	# bar

	foo="${foo:+boo baz}"

	echo "$foo"
	# boo baz
	```

*OBSERVAÇÕES:*

- Essas expansões podem ser usadas sem `:`:
	- COM `:` Bash testa se o parâmetro é ***unset*** ou ***null***
	- SEM `:` Bash testa apenas se o parâmetro é ***unset***

*Case modification:*

- `^`:
	```sh
	xpto='hello world'

	echo "${xpto^}"
	# Hello world
	```
- `^^`:
	```sh
	xpto='hello world'

	echo "${xpto^^}"
	# HELLO WORLD
	```
- `,`:
	```sh
	xpto='HELLO WORLD'

	echo "${xpto,}"
	# hELLO WORLD
	```
- `,,`:
	```sh
	xpto='HELLO WORLD'

	echo "${xpto,,}"
	# hello world
	```

- `~`:
	```sh
	xpto='Hello World'

	echo "${xpto~}"
	# hello World
	```

- `~~`:
	```sh
	xpto='Hello World'

	echo "${xpto~~}"
	# hELLO wORLD
	```

*OBSERVAÇÕES:*

- Essas expanções aceitam *wildcards*:
    `echo "${foo^^[aeiou]}"`

*Remove matching:*

- `#`:
	```sh
	url="https://sub.domain.xyz/downloads/archive.tar.gz"

	echo "${url#*/}"
	# /sub.domain.xyz/downloads/archive.tar.gz
	```
- `##`:
	```sh
	url="https://sub.domain.xyz/downloads/archive.tar.gz"

	echo "${url##*/}"
	# archive.tar.gz
	```
- `%`:
	```sh
	url="https://sub.domain.xyz/downloads/archive.tar.gz"

	echo "${url%/*}"
	# https://sub.domain.xyz/downloads
	```
- `%%`:
	```sh
	url="https://sub.domain.xyz/downloads/archive.tar.gz"

	echo "${url%%/*}"
	# https:
	```

*Parameter transformation:*

- `@E` (trata como `$''`):
	```sh
	xpto='hello\nworld'

	echo "$xpto"
	# hello\nworld

	echo "${xpto@E}"
	# hello
	# world
	```

- `@Q` (cita a *string*):
	```sh
	xpto='hello world'

	echo "$xpto"
	# hello world

	echo "${xpto@Q}"
	# 'hello world'
	```

*Arrays*:

| Expansão            | Descrição                                                  |
| ------------------- | ---------------------------------------------------------- |
| `${array[@]}`       | Imprime todos os elementos do array em strings protegidas. |
| `${array[*]}`       | Imprime todos os elementos do array em uma única string.   |
| `${array[N]}`       | Imprime o elemento na posição ‘N’.                         |
| `${#array[@]}`      | Imprime o total de elementos do array.                     |
| `${!array[@]}`      | Imprime os índices do array.                               |
| `${array[@]:N}`     | Imprime todos os elementos a partir da posição ‘N’.        |
| `${array[@]:N:M}`   | Imprime ‘M’ elementos a partir da posição ‘N’.             |
| `${array[@]: -N}`   | Imprime os últimos ‘N’ elementos.                          |
| `${array[@]: -N:M}` | Imprime ‘M’ elementos a partir da última ‘N’ posição.      |

*OBSERVAÇÕES:*

- Essas expansões aceitam variáveis no lugar dos valores:
	```sh
	array=(hello world)
	
	echo "${array[@]:1}"
	# world
	
	index=1

	echo "${array[@]:index}"
	# world
	```

## *Extended Glob*

| *Glob*       | Descrição                                         |
| ------------ | ------------------------------------------------- |
| `?(pattern)` | Corresponde a zero ou uma ocorrência do padrão.   |
| `*(pattern)` | Corresponde a zero ou mais ocorrências do padrão. |
| `+(pattern)` | Corresponde a uma ou mais ocorrência do padrão.   |
| `@(pattern)` | Corresponde a uma ocorrência do padrão.           |
| `!(pattern)` | Corresponde a qualquer coisa exceto o padrão.     |

## Classes POSIX

| Classe       | Descrição                                                                   |
| ------------ | ---------                                                                   |
| `[:alnum:]`  | Caracteres alfanuméricos (letras e números, conforme locale).               |
| `[:alpha:]`  | Caracteres alfabéticos (conforme locale).                                   |
| `[:lower:]`  | Letras minúsculas (conforme locale).                                        |
| `[:upper:]`  | Letras maiúsculas (conforme locale).                                        |
| `[:digit:]`  | Dígitos decimais (`[0-9]`).                                                 |
| `[:blank:]`  | Espaços horizontais (espaço e `tab`).                                       |
| `[:cntrl:]`  | Caracteres de controle (ASCII: `0x00–0x1F` e `0x7F`).                       |
| `[:print:]`  | Caracteres imprimíveis, incluindo espaço.                                   |
| `[:graph:]`  | Caracteres visíveis (equivale a `[:print:]` sem espaço).                    |
| `[:punct:]`  | Caracteres de pontuação (imprimíveis que não são alfanuméricos nem espaço). |
| `[:space:]`  | Espaços em branco (` `, `\t`, `\n`, `\v`, `\f`, `\r`).                      |
| `[:xdigit:]` | Dígitos hexadecimais (`[0-9A-Fa-f]`).                                       |

*OBSERVAÇÕES:*

- Num RegEx você também pode negar uma classe inteira com: `[^[:<class>:]]`

## *Internal Keywords*

Palavras reservadas do Bash.

### `return`

Usar quando dentro de uma função você não quiser encerrar o *script* por completo (com comando `exit` por exemplo), ou seja, quando quiser somente sair da função antecipadamente.

Com esse comando podemos especificar o código de retorno da função com `return <code>` e caso não especifique o código de retorno o comando automáticamente retornará a função com o código de retorno do último comando executado.

E o comando também só será útil caso queira retornar de forma antecipada pois caso utilize o `return` na última linha, NÃO ter o `return` terá o mesmo efeito.

## *Tips & Tricks*

Dicas e truques gerais do Bash.

### Iterar (via *Loop*) Sobre *Strings*

1ª Opção:

```sh
foo='string'; for ((index=0; index < ${#foo}; index++)); do echo "${foo:$index:1}"; done
```

2ª Opção:

```sh
while read -n1 line; do echo "$line"; done < <(echo -n 'string')
```

3ª Opção:

```sh
grep --only-matching --color=never '.' <<< 'string' | while read line; do echo "$line"; done
```

4ª Opção:

```sh
for char in `sed -E 's/(.)/\1\n/g' <<< 'string'`; do echo "$char"; done
```

### Montar *String* de Opções Sem Espaços

```sh
options=('option1' 'option2' 'option3' 'option4')
<command> --options "`IFS=,; echo "${options[*]}"`"

# or

array=('option1' 'option2' 'option3' 'option4')
options=`IFS=,; echo "${array[*]}"`
<command> "$options"
```

### Comando `test` Como Um `if` Tradicional

```sh
[ 0 -eq 0 ] && { ls /foo; :; } || echo false
```

Nesse caso o comando do bloco verdade falhará (`ls /foo`), e caso não tenha o ":;", o bloco false também será executado pois como o operador `&&`, o operador `||` avalia o código de saída do último comando executado (comando anterior a ele) e não a condição do comando `test` (para isso temos especificamente o comando `if`). Isso não é uma falha, muito pelo contrário, de fato é o comportamento correto uma vez que você entende o intuito e o funcionamento dos operadores lógicos do _shell_... Esse exemplo é apenas um _trick_ para que o comportamento dessa expressão seja o mais próximo de um **if** tradicional.
