# Mídia

Anotações gerais sobre Mídia: programas e configurações.

## `ffmpeg`

*Parâmetros usados:*

- `<speed>`: Pode variar de `0` até `1`, sendo que 1 é a velocidade normal, logo, **0.75** é **25%** mais rápido, **0.5** é **50%** e assim sucessivamente

Programas necessários:

```sh
[sudo] apt install ffmpeg
```

Aumentar a velocidade de um vídeo:

```sh
ffmpeg -i /path/video.mp4 -filter:v "setpts=<speed>*PTS" -an /path/output.mp4
```

*LINKS:*

- [Blog Viva o Linux](<https://www.vivaolinux.com.br/dica/Como-aumentar-ou-reduzir-a-velocidade-de-um-video-via-linha-de-comando>)

*MKV to MP4:*

```sh
ffmpeg -i /path/video.mkv -codec copy /path/video.mp4
```

*VIDEO to GIF:*

```sh
ffmpeg -i /path/video.mp4 /path/image.gif
```

## `imgp`

Nomenclatura de `HxV`:

- *Horizontal x Vertical*
- *X Axis x Y Axis*
- *Width x Height*

*Parâmetros usados:*

- `<resolution>`: Representação de resolução em `HxV` ou `%`
- `<quality>`: Valor da `%` de qualidade da imagem

*Opções usadas:*

- `-w`: Sobrescreve a imagem original
- `-r`: Aplica recursividade
- `-n`: Permite a imagem ser escala para dimensões maiores que 100%
- `-x <resolution>`: Adapta a imagem para a resolução especificada
- `-q <quality>`: Especifica a qualidade final da imagem (para imagens JPEG)

Programas necessários:

```sh
[sudo] apt install imgp
```

Adapta a imagem para a resolução preservando a altura:

```sh
imgp [-w] -rnx 1366x768 -q 95 /path/folder/ image.png
```

Adapta a imagem apenas na largura e especifica a alatura:

```sh
imgp [-w] -rnx 0x250 -q 95 /path/folder/ image.png
```

Escala a imagem para 150%:

```sh
imgp [-w] -rnx 150 -q 95 /path/folder/ image.png
```

## `tiv`

Programas necessários:

```sh
[sudo] apt install tiv
```

Ver imagens pelo terminal:

```sh
tiv /path/image.png
```

## `gifwrap`

Programas necessários:

```sh
[sudo] apt install gifwrap
```

Ver *gifs* pelo terminal:

```sh
gifwrap -f /path/image.gif
```

*OBSERVAÇÕES:*

- Deixe o menor *zoom* possível do terminal

## `gocr`

Programas necessários:

```sh
[sudo] apt install gocr
```

Extrair textos de imagens:

```sh
gocr /path/image.png
```

## `yt-dlp`

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

## `mkvtoolnix`

Programas necessários:

```sh
[sudo] apt install mkvtoolnix
```

Mesclar arquivos MP4 (depois é necessário converter de volta para MP4):

```sh
mkvmerge -o final.mp4 video0.mp4 \+ video1.mp4
```

## `pdftoppm`

Programas necessários:

```sh
[sudo] apt install poppler-utils
```

*PDF to IMAGE:*

```sh
# one to one
pdftoppm -png /path/file.pdf /path/file.pdf

# multiples, one to one
find /path/folder -maxdepth 1 -type f -name -name '*.pdf' -exec pdftoppm -png '{}' '{}' \;
```

## `avifenc`

*Parâmetros usados:*

- `<quality>`: Valor da qualidade final da imagem num *range* de `{0..100}`
- `<speed>`: Valor da velocidade de processamento num *range* de `{0..10}`
- `<jobs>`: Contagem de processadores a serem usados na condificação ou `all` para usar todos de forma automática
- `<procs>`: Contagem de processadores a serem usados na paralelização de processos

*Opções usadas:*

- `-q <quality>`: Qualidade da codificação, `0` **menor qualidade** e tamanho, `100` **maior qualidade** e tamanho (`50` **melhor custo benefício**)
- `-s <speed>`: Velocidade da condificação, `0` **melhor compressão** lento, `10` **pior compressão** rápido (`5` melhor **custo benefício**)
- `-j <jobs>`: Quantidade de processadores usados para processamento simultâneo (paralelismo)

Programas necessários:

```sh
[sudo] apt install libavif-bin
```

Converter JPG|JPEG|PNG|Y4M para AVIF:

```sh
avifenc [-q <quality>] [-s <speed>] [-j <jobs>] /path/image.png /path/image.avif
```

Converter múltiplos em paralelo:

```sh
find /path/images -not -path '*/images' | parallel -j<procs> 'avifenc -q <quality> -s <speed> -j <jobs> {} {.}.avif'
```

## `rav1e`

*Parâmetros usados:*

- `<path>`: Caminho para arquivo no sistema
- `<quantizer>`: Valor da qualidade final do vídeo num *range* de `{0..255}`
- `<speed>`: Valor da velocidade de processamento num *range* de `{0..10}`
- `<threads>`: Contagem de processadores a serem usados na condificação
- `<tiles>`: Contagem de quadros a serem processados por vez de cada *frame*
- `<jobs>`: Contagem de processadores a serem usados na paralelização de processos

*Opções usadas:*

- `-i <path>`: Caminho do vídeo de entrada (de qualquer tipo que o `ffmpeg` suporte)
- `-qp <quantizer>`: Qualidade da codificação, `0` **maior qualidade** e tamanho, `255` **menor qualidade** e tamanho (`128` **melhor custo benefício**)
- `-speed <speed>`: Velocidade da condificação, `0` **melhor compressão** lento, `10` **pior compressão** rápido (`5` melhor **custo benefício**)
- `-threads <threads>`: Quantidade de processadores usados para processamento simultâneo (paralelismo)
- `-tiles <tiles>`: Quantidade de quadros de *frame* processados simultâneamente (paralelismo)

Programas necessários:

```sh
[sudo] apt install librav1e-dev ffmpeg
```

Encodar MP4|MKV|MOV|AVI|WebM em AV1:

```sh
ffmpeg -i /path/video.mp4 -c:v librav1e [-qp <quantizer>] [-speed <speed>] [-threads <threads>] [-tiles <tiles>] /path/video.mkv
```

Encodar múltiplos em paralelo:

```sh
find /path/videos -not -path '*/videos' | parallel -j<jobs> 'ffmpeg -i {} -c:v librav1e -qp <quantizer> -speed <speed> -threads <threads> -tiles <tiles> {.}.mkv'
```

*OBSERVAÇÕES:*

- Para um bom equilíbrio de paralelismo em um processamento individual de vídeo, utilize um proporção de 50% até 75% de *tiles* em relação a quantidade de *threads* (*e.g.* `-threads 12 -tiles 6`, `-threads 12 -tiles -9`)

## *ImageMagick*

Programas necessários:

```sh
[sudo] apt install imagemagick
```

### `identify`

Verificar metadados de imagens:

```sh
identify -verbose /path/image.png | grep exif
```

### `mogrify`

Remover metadados de imagens:

```sh
mogrify -strip /path/folder/*.png
```

*IMAGE to PDF:*

```sh
# one to one
mogrify -format pdf /path/image.png

# multiples, one to one
mogrify -format pdf /path/folder/*.png
```

### `convert`

*IMAGE to PDF:*

```sh
# one to one
convert /path/image.png /path/document.pdf

# many to one
convert /path/folder/*.png /path/document.pdf

# multiples, one to one
for file in /path/folder/*.png; do convert "$file" "${file%.*}.pdf"; done
```

### *Troubleshooting*

Se houver erro de não permissão devido a policitas para PDFs:

```sh
sed -Ei 's,(<policy domain="coder" rights=").*(" pattern="PDF" />),\1read|write\2,' /etc/ImageMagick-?/policy.xml
```

## SVG

Programas necessários:

```sh
[sudo] apt install librsvg2-bin imagemagick
```

*SVG to PNG:*

```sh
rsvg-convert -o /path/image.png /path/image.svg
```

*SVG to JPG:*

```sh
# can set background color as desired
rsvg-convert -b '#ffffff' /path/image.svg | magick - /path/image.jpg
```

## Fonts

Configuração de fontes no sistema.

### Tipos

- `truetype` ou `ttf`
- `opentype` ou `otf`
- `webfonts` ou `woff`

Colocar as pastas de fontes dentro das pastas dos seus respectivos tipos, *e.g.* `<path>/truetype/Monospace`.

### Diretórios

- Nível de sistema:
	`/usr/share/fonts/<type>/<family>`
- Nível de usuário:
	`~/.local/share/fonts/<type>/<family>`

### Comandos

- Listar todas as fontes:
	`fc-list`
- Atualizar o *cache* de fontes:
	`fc-cache`
