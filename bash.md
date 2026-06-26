# Bash

Anotações gerais sobre Debian: programas e configurações.

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
