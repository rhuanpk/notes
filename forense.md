# Forense

Anotações gerais sobre Forense: programas e configurações.

## `shred`

*Parâmetros usados:*

- `<count>`: Quantidade de vezes de execução

*Opções usadas:*

- `-v`: Mais verbosidade na saída
- `-n`: Número de vezes que passará sobrescrevendo com conteúdo randômico
- `-z`: Sobrescrever com zeros no final do procedimento
- `-u`: Remove o arquivo no final do procedimento

Sobrescrever o bloco (apagar o arquivo):

```sh
shred [-v|-z|-u|-n <count>] /path/file.txt
```

Alias de exemplo:

```sh
alias rms='shred -zuvn 10'
```

*OBSERVAÇÕES:*

- Por padrão o comando `shred` sobrescreve o conteúdo do blocl 3x com conteúdo randômico

## `sleuthkit`

*Parâmetros usados:*

- `X`: Letra do disco
- `<start>`: Número do bloco de *bits* inicial
- `<inode>`: *Inode* do arquivo no sistema

Verificar partições e seus blocos:

```sh
[sudo] mmls /dev/sdX
```

Verificar tipo de tabela de partição:

```sh
[sudo] mmstat /dev/sdX
```

Verificar todos os arquivo de determinado disco a partir do bloco:

```sh
[sudo] fls -o <start> /dev/sdX
```

*OBSERVAÇÕES:*

- Os marcados com "**\***" são arquivos a serem recuperados

Recuperar os arquivos:

```sh
[sudo] icat -o <start> /dev/sdX <inode> > /tmp/recover.txt
```

### Recuperação

1. SE for um arquivo editável:
	1. Pegue pid do na segunda coluna e o descritor de arquivo na quarta coluna:
		`lsof | grep '/path/to/file'`
	1. Copie o arquivo direto do descritor:
		`cp /proc/<pid>/fd/<fd> /path/to/restored/file`
1. Desmonte imediatamente a partição ou remonte somente leitura:
	- Para desmontar:
		`umount /dev/sdXY`
	- Para remontar somente leitura:
		`mount -o ro,norecovery,remount /dev/sdXY`
1. Faça backup da partição:
	`dd if=/dev/sdXY of=/tmp/backup.hd bs=8M status=progress`
	- Observação: a partir dessa cópia, você escolher em trabalhar diretamente no disco e deixar a imagem como backup ou vice-versa
1. <details>
	<summary>Execute a recuperação</summary>

	- <details>
		<summary><code>ext4</code>: <code>extundelete</code></summary>

		1. Instale a ferramenta: `apt install extundelete`
		1. Restaure toda a partição: `extundelete --restore-all {/dev/sdXY|/path/to/backup.hd}`
		1. OU restaure somente um arquivo: `extundelete --restore-file relative/path/to/file.any {/dev/sdXY|/path/to/backup.hd}`
		1. OU restaure somente uma pasta: `extundelete --restore-directory relative/path/to/directory/ {/dev/sdXY|/path/to/backup.hd}`

		_OBSERVAÇÕES_:
		- Arquivos restaurados serão salvos em `./RECOVERED_FILES/` se não especificado "`--output-dir /extundelete/`"
		- Se retornar `0 descriptors loaded` e `0 recoverable inodes`, o _journal_ não tem registros e a ferramenta não consegue recuperar
	- <details>
		<summary><code>ext4</code>: <code>ext4magic</code></summary>

		1. Instale a ferramenta: `apt install ext4magic`
		1. Restaure toda a partição: `ext4magic -md /ext4magic/ {/dev/sdXY|/path/to/backup.hd}`
		1. OU restaure somente uma pasta: `ext4magic -d /ext4magic/ -rf relative/path/to/directory/ {/dev/sdXY|/path/to/backup.hd}`
	- <details>
		<summary><code>ext4</code>: <code>strings</code></summary>

		1. Verifique se há indícios do que procura: `grep -oa "<pattern>" {/dev/sdXY|/path/to/backup.hd}`
		1. Restaure como texto pleno: `strings {/dev/sdXY|/path/to/backup.hd} | grep -A <lines> "<pattern>" > /recovered.txt`

		_OBSERVAÇÕES_:
		- Técnica mais indica para arquivos de texto (documentos, códigos fonte e etc)
		- Para com cabeçalhos bem definidos (imagens, vídeos, PDFs, ZIPs e etc) o `photorec` tem mais acurácia
	</details>
	</details>
	</details>
</details>
