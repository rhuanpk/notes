# Windows

Anotações gerais sobre Windows: programas e configurações.

## Ativação

Fazer ativação da versão Pro:

1. Instale a chave:
    ```
    slmgr /ipk <key>
    ```
1. Aponte o servidor KMS:
    ```
    slmgr /skms <url>[:1688]
    ```
1. Ative a chave:
    ```
    slmgr /ato
    ```
1. Verifique a chave:
    ```
    slmgr /dlv
    ```
1. Checar status da ativação:
    ```
    slmgr /xpr
    ```

Verificar se o servidor KMS está *online*:

- Agnóstico:
    ```
    nslookup -type=srv _vlmcs._tcp.<url>
    ```
- Windows:
    ```
    Test-NetConnection -ComputerName <url> -Port 1688
    ```
- Linux:
    ```sh
    nc -zv <url> 1688
    ```
    ```sh
    # batch check, put all domains (one per line) inside `domains.txt`, the result is outputed `check.txt`
    > check.txt; while read domain; do { echo "=====> $domain <====="; nslookup -type=srv _vlmcs._tcp.$domain; } >> check.txt 2>&1; done < domains.txt
    ```

Para limpar o estado de ativação (chave instalada):

```
slmgr /ckms
```

<details>
<summary>Chaves genéricas:</summary>

| Edição                                                                 | KMS Client Product Key          |
| ---------------------------------------------------------------------- | ------------------------------- |
| Windows 11 Pro<br>Windows 10 Pro                                       | `W269N-WFGWX-YVC9B-4J6C9-T83GX` |
| Windows 11 Pro N<br>Windows 10 Pro N                                   | `MH37W-N47XK-V7XM9-C7227-GCQG9` |
| Windows 11 Pro for Workstations<br>Windows 10 Pro for Workstations     | `NRG8B-VKK3Q-CXVCJ-9G2XF-6Q84J` |
| Windows 11 Pro for Workstations N<br>Windows 10 Pro for Workstations N | `9FNHH-K3HBT-3W4TD-6383H-6XYWF` |
| Windows 11 Pro Education<br>Windows 10 Pro Education                   | `6TP4R-GNPTD-KYYHQ-7B7DP-J447Y` |
| Windows 11 Pro Education N<br>Windows 10 Pro Education N               | `YVWGF-BXNMC-HTQYQ-CPQ99-66QFC` |
| Windows 11 Education<br>Windows 10 Education                           | `NW6C2-QMPVW-D7KKK-3GKT6-VCFB2` |
| Windows 11 Education N<br>Windows 10 Education N                       | `2WH4N-8QGBV-H22JP-CT43Q-MDWWJ` |
| Windows 11 Enterprise<br>Windows 10 Enterprise                         | `NPPR9-FWDCX-D2C8J-H872K-2YT43` |
| Windows 11 Enterprise N<br>Windows 10 Enterprise N                     | `DPH2V-TTNVB-4X9Q3-TJR4H-KHJW4` |
| Windows 11 Enterprise G<br>Windows 10 Enterprise G                     | `YYVX9-NTFWV-6MDM3-9PT4T-4M68B` |
| Windows 11 Enterprise G N<br>Windows 10 Enterprise G N                 | `44RPN-FTY23-9VTTB-MP9BX-T84FV` |

Acesse o [artigo oficial da Microsfot](https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys) para mais detalhes.
</details>

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

## *Browsers*

Instalação de *browsers* sem precisar de um, apenas com ferramentas CLI.

### Google Chrome

Via `winget`:

```
winget install --id Google.Chrome -e --accept-source-agreements --accept-package-agreements
```

Via `curl`:

- 64 bits (x64):
    ```
    curl -L -o ChromeSetup_x64.exe "https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe"
    ```
- 32 bits (x86):
    ```
    curl -L -o ChromeSetup_x86.exe "https://dl.google.com/chrome/install/ChromeStandaloneSetup.exe"
    ```

### Firefox

Via `winget`:

```
winget install --id Mozilla.Firefox.pt-BR -e --accept-source-agreements --accept-package-agreements
```

Via `curl`:

- 64 bits (x64):
    ```
    curl -L -o FirefoxSetup_x64.exe "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=pt-BR"
    ```
- 32 bits (x86):
    ```
    curl -L -o FirefoxSetup_x86.exe "https://download.mozilla.org/?product=firefox-latest-ssl&os=win&lang=pt-BR"
    ```
- ARM64 (AArch64):
    ```
    curl -L -o FirefoxSetup_arm64.exe "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64-aarch64&lang=pt-BR"
    ```

## Certificado

Conteúdo sobre configuração de certificado digital no sistema:

- [Soluti (Website)](https://manuais.soluti.com.br/certificado-a1-pj/instalando-o-certificado-digital/instalacao-windows)
- [Dicas de Sistemas (YouTube)](https://youtu.be/aWqYiTAoDzw)

## Comandos

Saber arquitetura do sistema:

```
echo %PROCESSOR_ARCHITECTURE%
```

### ImageMagick

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
