# Bash

Anotações gerais sobre Debian: programas e configurações.

Variável PS1:

- `\u`: Usuário atual
- `\h`: Nome da máquina (host)
- `\H`: Nome da máquina completo (hostname)
- `\w`: Diretório de trabalho atual
- `\W`: Diretório de trabalho atual com o nome base (último segmento) apenas
- `$(__git_ps1 ["%s"])`: Branch atual caso esteja em um repositório Git, se não, não exibe nada
