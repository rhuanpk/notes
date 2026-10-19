# Windows

Anotações gerais sobre Windows: programas e configurações.

## ImageMagick

Programas necessários:

```
winget install ImageMagick.ImageMagick
```

Converter imagem:

```
magick input.jpg output.png
```

Converter imagens:

```
magick mogrify -format png {*|*.jpg}
```

Redimensionar imagem:

- `magick image.png -resize 1920x image[_resize].png`: Mantem a proporção da imagem, porém, especifica a largura
- `magick image.png -resize x1920 image[_resize].png`: Mantem a proporção da imagem, porém, especifica a altura
- `magick image.png -resize 1920x1080 image[_resize].png`: Mantem a proporção da imagem, pode ficar apenas com a largura em `1920` ou altura em `1080`
- `magick image.png -resize 1920x1080! image[_resize].png`: Pode distorcer a imagem, força a resolução especificada
- `magick image.png -resize 1920x1080^ -gravity center -extent 1920x1080 image[_resize].png`: Exatamente a resolução, preservando a proporção e cortando o excesso
- `magick image.png -resize 1920x1080 -gravity center -background black -extent 1920x1080 image[_resize].png`: Exatamente a resolução, preservando a proporção e preenchendo o excesso de preto

Redimensionar imagens:

```
Get-ChildItem -File | ForEach-Object {
	magick $_.FullName <...> "$($_.DirectoryName)\$($_.BaseName)_resize$($_.Extension)"
}
```

```
Get-ChildItem -File -Filter *.jpg | ForEach-Object {
	magick $_.FullName <...> "$($_.DirectoryName)\$($_.BaseName)_resize$($_.Extension)"
}
```
