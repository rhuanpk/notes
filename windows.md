# Windows

Anotações gerais sobre Windows: programas e configurações.

## Otimização

Lista de coisas a se fazer para otimização do sistema:

- *Atualizar drivers da placa mãe*
- *Atualizar drivers da placa de vídeo*
- *Atualizar o sistema (Windows Update)*
- Menu > "aplicativos em segundo plano" > *Desabilite os apps desejados*
- Menu > "cmd" > Executar como administrador > "powercfg /h off"
- Painel de controle > Hardware e sons > Opções de energia > Melhor desempenho
- Configurações > Jogos > Modo de jogo > Desativar
- Configurações > Jogos > Modo de jogo > Elementos gráficos > *Adicione os apps desejados*
- Configurações > Jogos > XBox Game Bar > Desativar
- Configurações > Personalização > *Altere as opções desejadas*
- Windows update > Opções avançadas > Otimização de entrega > Permitir *downloads* de outros computadores > Desativado
- `super+r` > "sysdm.cpl" > Avançado > Configurações (desempenho) > Melhor desempenho
- `super+r` > "msconfig" > Serviços > Ocultar serviços Microsoft > *Desabilite os serviços desejados*
- `super+r` > "taskschd.msc" > *biblioteca/microsoft/windows/maintenance/* > WinSAT > *Botão direito* > Desabilitar
- `super+r` > "taskschd.msc" > *biblioteca/* > *Desabilite os serviços desejados*
- `ctrl+shift+esc` > Inicialização > *Desabilite os apps desejados*
- ***Botão direito** no **Menu*** > Gerenciador de dispositivos > Dispositivos de sistema > Timer de eventos de alta precisão > *Botão direito* > Desabilitar dispositivo

## IA

Configuração para desabilitar por completo as funções de IA no sistema:

1. `super+r` > "regedit"
1. *Computador\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows*
1. *botão direito* > Nova > Chave > "WindowsCopilot"
1. *botão direito* > Nova > Valor DWORD > "TurnOffWindowsCopilot"
1. *botão direito* > Modificar > "1"

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

## Certificado

Conteúdo sobre configuração de certificado digital no sistema:

- [Soluti (Website)](https://manuais.soluti.com.br/certificado-a1-pj/instalando-o-certificado-digital/instalacao-windows)
- [Dicas de Sistemas (YouTube)](https://youtu.be/aWqYiTAoDzw)

## Troubleshooting

Correções de problemas em gera.

### Reparar NTFS

Reparar partição NTFS:

```cmd
chkdsk X: /f /r`
```

### Erro `0x80070306`

Erro `0x80070306` no _Windows Update_ (decorrente da desinstalação do _Microsoft Edge_):

1. `dism.exe /online /cleanup-image /checkhealth`
1. `dism.exe /online /cleanup-image /scanhealth`
1. `dism.exe /online /cleanup-image /restorehealth`
1. `sfc /scannow`

### Ventoy

Em caso de instalação via Ventoy, o tipo da partição `VTOYEFI` deve ser `Microsoft reserved data` ao invés de `EFI System`.

O tipo da partição pode ser ajustado com o comando `[sudo] fdisk /dev/sdX`.
