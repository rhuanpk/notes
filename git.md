# Git

Anotações gerais sobre Git: comandos e configurações.

## *Quick Start*

1. `git add ./`
1. `git commit -m "commit message"`
1. `git push origin HEAD`

## *Branchs*

Comandos e configurações de *branchs*.

### Listagem

Locais:

```sh
git branch [-l]
```

Remotas:

```sh
git branch [-l] -r
```

Locais e remotas:

```sh
git branch -a
```

Adicionar verbosidade:

```sh
git branch -v[v]
```

### Troca

Com *checkout*:

```sh
# -b: creates the branch if not exists
git checkout [-b] <branch>
```

Com *switch* (padrão atual):

```sh
# -c: creates the branch if not exists
git switch [-c] <branch>
```

### Remoção

Comandos e configurações de remoção de *branchs*.

#### Local

Remover:

```sh
git branch -d <branch>
```

Forçando:

```sh
git branch -D <branch>
```

Deletar somente a referência das *branchs* remotas:

```sh
git branch -rl '<remote>/*' | xargs git branch -dr
```

#### Remoto

Remover:

```sh
git push origin {:<branch>|-d <branch>}
```

Parar de "trackear" *branch* remota:

```sh
git branch -dr <remote>/<branch>
```

### Nomeação

Comandos e configurações de nomeação de *branchs*.

#### Local

Nomear:

```sh
git branch -m <branch>
```

Forçando:

```sh
git branch -M <branch>
```

#### Remoto

Nomear:

```sh
git push <remote> <remote>/<old>:refs/heads/<new> :<old>
```

Desvincular local com remoto inexistente:

```sh
git branch --unset-upstream
```

Vincular local com novo remoto:

```sh
git branch --set-upstream-to=<remote>/<new>
```

### Criação

A partir de uma remoto já existente:

```sh
git switch -c <branch> <remote>/<branch>
```

### Alteração

Colocar *branch* em *commit* específico:

```sh
git branch -f <branch> <commit>
```

## *Push*

Enviar a *branch* local para o remoto, para uma *branch* (remota) com o mesmo noma da local. Caso a *branch* remota não exista, será criada:

```sh
git push <remote> <destination>
```

Enviar a *branch* local para o remoto, para a *branch* (remota) especificada. Caso a *branch* remota não exista, será criada:

```sh
# left of ":" is the existent local branch
# right of ":" is the new or existent remote branch
git push <remote> <source>:<destination>
```

## *Commits*

Comandos e configurações de *commits*.

### *Revert*

Desfaz o *commit* criando um novo *commit* sem essas alterações:

```sh
git revert <commit>
```

Passando um *range* (do mais antigo para o mais novo) de *commits*. Isso fará um *revert* por vez:

```sh
git revert <oldest>..<newst>
```

### *Reset*

Resetar o *commit* sem perder as alterações, colocando-as na *worktree*:

```sh
git reset <commit>
```

Resetar o *commit* sem perder as alterações, colocando-as no *index* (*staging area*):

```sh
git reset --soft <commit>
```

Remover o *commit* por completo (sem manter as alterações):

```sh
git reset --hard <commit>
```

### *Amend*

Para adicionar ou editar qualquer alteração no último *commit*, basta fazer as alterações desejadas, adicionar em *staging* (`git add <path>`) e "commitar" com *amend*.

Simplesmente "commitar", sem alterar nada (mensagem):

```sh
git commit --amend --no-edit
```

"Commitar" no modo interativo (abre o editor padrão):

```sh
git commit --amend -i
```

Já passando a mensagem:

```sh
git commit --amend -m "<message>"
```

### *Cherry Pick*

Trazer um *commit* específico para a branch:

```sh
git cherry-pick <commit>
```

Apenas aplicar as alterações do *commit*:

```sh
git cherry-pick --no-commit <commit>
```

Trazer o *commit* editando a mensagem do *commit*:

```sh
git cherry-pick --edit <commit>
```

*LINKS:*

- <https://www.atlassian.com/git/tutorials/cherry-pick>
- <https://git-scm.com/docs/git-cherry-pick>

### *Squash*

Comprimir *commits* da mesma branch com *rebase*:

```sh
git rebase -i {HEAD*|<commit>}
```

## *Merge*

Para desfazer qualquer *merge* em andamento:

```sh
git merge --abort
```

*Dry-run*:

1. Faça o "*merge* falso":
	`git merge --no-commit --no-ff <branch>`
1. Caso tenha alguma alteração, veja com:
	`git diff --cached`
1. SE for necessário, desafaça o *merge*

### Conflito

Se a mesclagem já estiver em progresso:

- Aceitar as alterações "locais":
    `git checkout --ours file.txt`
- Aceitar as alterações "remotas":
    `git checkout --theirs file.txt`

Se ainda irá mesclar:

- Aceitar as alterações "locais":
    `git merge -X ours <branch>`
- Aceitar as alterações "remotas":
    `git merge -X theirs <branch>`

*OBSERVAÇÕES:*

- "Local": *Branch* atual na qual será mesclada
- "Remota": *Branch* que será mesclada na atual

## *Rebase*

Comandos e configurações de *rebase*.

### *Simple*

A base da *branch* atual deve ser essa:

```sh
git rebase <base>
```

Especifica a *branch* que terá a nova base:

```sh
git rebase <base> <branch>
```

### *Onto*

A base da *branch* atual deve ser essa, começando desse ponto (*commit*):

```sh
git rebase --onto <base> <start>
```

A base da *branch* atual deve ser essa, começando e terminando desse ponto (*commit*):

```sh
git rebase --onto <base> <start> <end>
```

*OBSERVAÇÕES:*

- No caso do *rebase onto*, o ponto inicial (que será a base), é um *commit* filho da *branch* base, ou seja, você pode usar `<start>~2`, `<end>^` e etc
- Em termos técnicos, no *rebase* simples (e também no *onto*) a `<base>` é, na verdade, o `<new-parent-commit>` da *branch* que tera a nova base. No *rebase onto*, o `<start>` corresponde ao `<old-parent-commit>` e o `<end>` ao `<util-the-commit>`

## *Stash*

*Parâmetros usados:*

- `<message>`: Mensagem do *commit*
- `<stash>`: Identificador único (ID) do *stash* (*e.g.* `0`, `1`)

*Opções usadas:*

- `-u`: "Stashear" arquivos não traqueados (#saving,#listing)
- `-p`: Mostrar as alterações (*patch*) dos *stashs* (#listing)
- `-S`: Aplicar o *stash* somente sobre o *staging* (#saving)
- `-k`: Apesar de "stashear" o que está em *staging*, não o limpa (#saving)
- `-m <message>`: "Stashear" com mensagem específica (#saving)
- `--index`: Restaurar o *stash* preservando o que estava em *staging* (#applying)

"Stashear" todos os arquivos:

```sh
git stash [-uk] [-m "<message>"]
```

"Stashear" arquivos específicos:

```sh
git stash push [-uk] [-m "<message>"] path/folder/ path/file.txt
```

Listar/Mostrar *stashs*:

```sh
git stash show [-up] ['stash@{<stash>}']
```

Aplicar/Aplicar e Dropar *stash*:

```sh
git stash {apply|pop} [--index] ['stash@{<stash>}']
```

Deletar **stash**:

```sh
git stash drop ['stash@{<stash>}']
```

*OBSERVAÇÕES:*

- Nas operações com *stash*, quando NÃO especificado o ID, por padrão é usado o último

## *Log*

*Parâmetros usados:*

- `<user>`: Nome de usuário do *commiter*

*Opções usadas:*

- `--all`: Caso sua *branch* esteja atrás, mostra *logs* dos ramos a frente também
- `--oneline`: Mostra o *log* resumido, um por linha
- `--patch`: Mostra as alteraçẽos feitas nos *commits*
- `--graph`: Dsenha uma gráfo da *time line* dos *logs*
- `--author=<name>`: Filtra os *logs* pelo autor

Mostra o *log* dos *commits*:

```sh
git log [--all|--oneline|--patch|--graph]
```

Rastrear um único arquivo pelos *commits*:

```sh
git log [-p] --folow file.txt
```

## *Blame*

*Opções usadas:*

- `-w`: Remove espaços em branco
- `-L`: Limita a faixa de linhas

Mostra quem fez as alterações (autor do *commit*) em determinado arquivo:

```sh
git blame [-w|-L 1,23] file.txt
```

## *Clone*

Clonar repositório remoto:

```sh
git clone <url>
```

Clonar repositório remoto de uma *branch* ou *tag* específica:

```sh
git clone -b {<branch>|<tag>} <url>
```

*OBSERVAÇÕES:*

- Caso clone via *tag*, pode ser que ela esteja vínculada a um *hash* que não está apontado para nenhuma *branch*, nesse caso, se faz necessário criar uma *branch* logo depois do clone: `git switch -c <branch>`

Clonar sem outras *branchs* ou referência delas:

```sh
git clone [-b {<branch>|<tag>}] --single-branch <url>
```

## *Submodule*

Adicionar um novo *submodule*:

```sh
git sobmodule add {<url>|/path/local/repo}
```

Iniciar os *submodules* de um repositório clonado (estando na raiz do repositório local):

```sh
git sobmodule init
```

Atualizar os *submodules*:

```sh
git sobmodule update
```

Caso o *submodule* não esteja apontando para a `HEAD` do seu repectivo remoto, entre na pasta do *submodule* e realize um *pull*, ou, execute diretamente na sua raiz:

```sh
git submodule update --remote
```

Para retirar o *submodule* do `.git/config`, que é da onde o comando `update` puxa os *submodules*:

```sh
git submodule deinit <submodule>
```

Clonar repositórios com *submodules* já inicializando e atualizando-os:

```sh
git clone --recurse-submodules <url>
```

*OBSERVAÇÕES:*

- Toda vez que fizer alterações nos submódulos, deve-se commitar
- `git submodule init` refaz a configuração dos submódulos com base no `.gitmodules` caso algum seja retirado do `.git/config`
- Arquivos e pastas de submódulos:
	- `.gitmodules`: Arquivo de configuração que mapeia os submódulos dentro do repo (gerado a partir do `git submodules init`)
	- `.git/config`: Arquivo de configuração local (do repositório), dentro dele é criado uma sessão com o mapeamento das URLs dos submódulos
	- `.git/modules`: Pasta de destino dos submúdulos baixados (via URL)

## `.gitignore`

Comandos e configurações de `.gitignore`.

### Arquivos

Arquivo **global**: pode estar em qualquer lugar e vale para qualquer repositório:

```
~/.gitignore
```

Arquivo **local**: deve estar na raiz do projeto e vale somente para aquele repositório e todos que contribuem:

```
/path/project/.gitignore
```

Arquivo **usuário**: é um arquivo já pré-definido pelo Git e não é versionado:

```
/path/project/.git/info/exclude
```

### Comandos

Definir o `.gitignore` global:

```sh
git config --global core.excludesfile ~/.gitignore
```

Caso algum arquivo seja ignorado, remova do índice:

```sh
git rm --cached file.txt
```

Adicionar no índice algum arquivo que esteja sendo ignorado:

```sh
git add -f file.txt
```

### *Work Tree*

Remover da árvore de trabalho:

```sh
git update-index --skip-worktree file.txt
```

Retornar para a árvore de trabalho:

```sh
git update-index --no-skip-worktree file.txt
```

Listar os arquivos "skipados":

```sh
git ls-files -v | grep -E '^S'
```

## *Tag*

Colocar *tag* em *commit*, caso não especificado, o último (atual) é usado:

```sh
git tag <tag> [<commit>]
```

Remover *tag* local:

```sh
git tag -d <tag>
```

Remover *tag* remota:

```sh
git push origin :refs/tags/<tag>
```

## *Remote*

Limpar as referência do repositório remoto no local (remover o que não existe mais no repositório remoto):

```sh
git remote prune <remote>
```

Renomear repositório remoto:

```sh
git remote rename <old> <new>
```

## *Forks*

Sincronizar repositório *upstream* no local:

1. Adicionar repositório remoto:
	`git remote add upstream <url>`
1. Baixar informações do remoto:
	`git fetch upstream`
1. Trocar para *branch* alvo (se necessário):
	`git switch main`
1. Mesclar com *upstream*:
	`git merge upstream/main`;

## Autenticação

Comandos e configurações de autenticação. Configurações para autenticações via senha/*token*.

Para definir credenciais para diferentes usuários no mesmo host (e como consequência para cada repositório):

```sh
git config --global credential.https://.useHttpPath true
```

*OBSERVAÇÕES:*

- Pode-se utilizar os dois *helpers* onde, caso não seja encontrado o *helper* do *store* será pedido a senha que posteriormente será gravada no *cache*

### *Cache*

Definir cache (tempo padrão de 900s (15 minutos)):

```sh
git config --global credential.helper cache
```

Definir cache especificando tempo:

```sh
git config --global credential.helper 'cache --timeout 3600'
```

Desarmar a configuração global:

```sh
git config --global --unset credential.helper cache
```

Limpar o cache (senha/*token*):

```sh
git credential-cache exit
```

### *Store*

Definir credencial:

```sh
git config --global credential.helper store
```

Definir credencial especificando arquivo:

```sh
git config --global credential.helper 'store --file /path/.git-credentials'
```

Desarmar a configuração global:

```sh
git config --global --unset credential.helper store
```

Definir o arquivo de configuração (caminho *default*):

```sh
echo 'https://<user>:<token>@<domain>' >> ~/.git-credentials
```

### *Vault*

Configuração do gerenciador de senha via cofre.

#### Linux

Programas necessários:

```sh
[sudo] apt install libsecret-tools
```

Configuração do cofre:

1. "Buildar" o binário:
	`sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret`
1. Definir o *helper*:
	`git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret`

## Configuration

Definir nome de usuário:

```sh
git config --global user.name <user>
```

Definir email:

```sh
git config --global user.email <email>
```

*OBSERVAÇÕES:*

- Para definir nome de usuário e email somente no repositório local, troque a *flag* `--global` por `--local`

Listar todas as configuração:

```sh
git config [--global] [--local] --list --show-origin
```

Trocar editor padrão:

```sh
git config --global core.editor <editor>
```

### `include`

Definir arquivo de configuração adicional:

```sh
git config --global include.path ~/path/.gitconfig
```

### `includeIf`

Definir arquivo de configuração adicional para todos os repositórios dentro de terminado diretório:

```sh
git config --global includeIf.'gitdir:~/path/projects/[**]'.path ~/path/projects/.gitconfig
```

Nesse exemplo, a diretiva `includeIf` diz para incluir o `.gitconfig` quando você estiver dentro da pasta "*projects*" ou numa subpasta.

*OBSERVAÇÕES:*

- É necessário a "`/`" no final do caminho do em `gitdir`

## *Bare*

Comandos e configurações de *bare*.

### Servidor Local

Usar pasta local como servidor remoto:

1. Defina o servidor local:
	`git clone --bare /path/local/repo /tmp/project.git`
1. Adicione o servidor local no repositório local:
	`git remote add drive /tmp/project.git`
1. Empurre as alterações também para o servidor local:
	`git push drive HEAD`

Se necessário, é possível montar o servidor remoto numa mídia removível (pendrive ou HD externo), plugar em outra máquina, adiciona-lo como *remote* e pegar suas atualização com `pull`:

1. Adicione o servidor remoto local no repositório local:
	`git remote add drive /tmp/project.git`
1. Atualize o repositório local:
	`git pull drive HEAD`

### Expor Servidor Local

1. *Entre no servidor local*
1. Atualize o *bare*:
	`git --bare update-server-info`
1. Troque os *hooks* de update:
	`mv hooks/post-update{.sample,}`
1. Suba um servidor *web* (como em `python` ou `webfs`):
	- `python -m http.server 9418`
	- `webfsd -Fdp 9418`
1. *Faça o clone teste*:
    `git clone http://localhost:9418 project`

Depois, basta expor o servidor local via VPN (**OpenVPN**, **WireGuard**) ou *reverse proxy* (**ngrok**).

## Comandos

Imprime o *hash* do *commit* em comum entre duas *branchs*:

```sh
git merge-base <source> <target>
```

Imprime o *hash* de objeto Git do arquivo (seja pasta ou diretório):

```sh
git hash-object path/folder/ path/file.txt
```

## *Tips & Tricks*

Dicas e truques sobre Git em geral.

### Protocolos

HTTP:

```
https://[<user>:<token>@]<domain>/<user>/<repo>.git
```

SSH:

```
git@<domain>:<user>/<repo>.git
```

*Latest release*:

```
https://github.com/<user>/<repo>/releases/latest/download/<file>
```

### Certificados de Segurança

Desabilitar verificação de SSL do Git:

```sh
git config --global http.sslverify false
```

### Copiar Modificações

Pegar modificações de um arquivo de outra *branch*:

```sh
git checkout <branch> -- path/{folder/|file.txt}
```

### Comparar Arquivos

Comparar arquivos entre dois *commits/branchs*:

```sh
git diff <source> <target> -- file.txt
```

### Comparar Branchs

Comparar duas *branchs* pelo *commit* pai mais recente:

```sh
git diff HEAD...<target>
```

*OBSERVAÇÕES:*

- O alias `...` seria o equivalente a: `git diff $(git merge-base <source> <target>) <target>`

### "Splitar" *Commits*

Último *commit*:

1. *Deixe o repositório local limpo*
1. Resete o último *commit* para a *worktree*:
	`git reset HEAD^`
1. Adicione e faça *commit* conforme a necessidade

Algúm *commit* no meio do histórico:

1. *Deixe o repositório local limpo*
1. Use *rebase* interarivo:
	`git rebase -i <commit>^`

*OBSERVAÇÕES:*

- Simplesmente marque todos *commits* a serem editados utilizando `e` ou `edit`

### Mesclar Sem *Commit*

Mesclar "sem precisar fazer um novo *commit*":

1. Mescle sem *commit* (as alterações iram para o *index* (*staging area*)):
	`git merge --no-commit <branch>`
1. *Resolva conflitos e marque eles como resolvidos (se existirem)*
1. Saia do *merge*, as aterações continuaram no *index*:
	`git merge --quit`
1. Faça um `amend` para aplicar as alterações no último *commit*:
	`git commit --amend --no-edit`

*PIPELINE* (funciona se não houver conflitos):

```sh
git merge --no-commit <branch> && git merge --quit && git commit --amend --no-edit
```

### *Self Rebase*

Dar *rebase* da própria *branch* pelo *commit* de *merge-base*:

```sh
git rebase [-if] `git merge-base <source> main`
```

*OBSERVAÇÕES:*

- Será útil fazer dessa forma e não pegar de forma manual o último *commit* da *branch*, quando antes do *rebase* tiver ocorrido algum *merge*

### Personalização de URL

Inclua a sessão `url` nos arquivos de configurações globais (`~/.gitconfig`) ou locais (`.git/config`).

Injetar *token* de acesso:

```
[url "https://<user>:<token>@"]
	insteadOf = https://
```

*OBSERVAÇÕES:*

- Haverá a substituição: `https://domain.ext/user/repo.git` -> `https://<user>:<token>@domain.ext/user/repo.git`

Redirecionar para protocolo SSH:

```
[url "ssh://git@"]
	insteadOf = https://
```

*OBSERVAÇÕES:*

- Haverá a substituição: `https://domain.ext/user/repo.git` > `ssh://git@domain.ext/user/repo.git`
- Tenha a chave SSH no agente

### Aplicar *Patch*

Aplicar *diff patch* gerado com cor:

```sh
cat -v /path/diff.patch | sed 's/\^\[\[[[:digit:]]*m//g' | git apply -
```

Quando for salvar um *patch* para ser aplicado posteriormente, gere com `--no-color`:

```sh
git diff --no-color > /path/diff.patch
```

### `git config --get`

Com a *flag* `--system`, listará as informações dos arquivos de configuração do sistema, são eles `/etc/gitconfig` e `/etc/git/gitconfig`.

Com a *flag* `--global`, listará as informações do arquivo de configuração global `~/.gitconfig`.

Com a *flag* `--local`: listará as informações do arquivo de configuração do repositório local `/path/project/.git/config`.

### Alterar *Prompt*

Desabilitar o *prompt* (Git espera encontrar as credenciais no ambiente):

```sh
GIT_TERMINAL_PROMPT=0 <command>
```

Habilitar o *prompt* (Git forçara a entrada manual das credenciais):

```sh
GIT_TERMINAL_PROMPT=1 <command>
```

### Remover Commit do Meio do Log

Utilize `git rebase -i` ou `git revert`.

O **revert** é preferível por ser uma abordagem mais "segura" pois, evitará *pushs* forçados, o que bagunçaria o histórico de todos, isso se as alterações ainda não estiverem no remoto, nesse caso, utilizar o *rebase* não seria um problema.

### _Author_ X _Commiter_

O **autor** é a pessoa que originalmente escreveu o código. O ***committer***, por outro lado, é considerado a pessoa que confirmou o código em nome do autor original.

Isso é importante no Git porque é possível reescrever o histórico ou aplicar *patches* em nome de outra pessoa.

### *Exit Code*

Código de saída para arquivos modificados/deletados (*worktree*):

```sh
if git diff -s --exit-code <pathspec>; then echo not changed; else echo changed; fi
```

Código de saída para arquivos não traqueados (*untracked*):

```sh
git status --porcelain | grep '^\?\?'
```

### Múltiplos Remotos

Buscar configurar somente a *branch* HEAD do remoto:

1. Verificar qual o nome da HEAD do remoto:
    `git remote show <remote>`
1. Buscar somente a HEAD do remoto:
    `git fetch <remote> <branch>`
1. Configure a *branch* `<remote>/HEAD` local:
    `git remote set-head --auto <remote>`

## Troubleshooting

Resolução de problemas sobre Git em geral.

### Pasta Inacessível

Removendo pasta com *submodule* já indexado:

1. `git rm --cached <folder>`
1. `rm -rf <folder>/.git`
1. `git add ./`
1. `git push origin HEAD`

### Listar Conflitos

Listar somente os arquivos com conflito durante um *rebase*:

```sh
git status --short | sed -n 's/AA //p'
```

### Nomeação de *Branch*

Alterar nome da branch local e remoto:

1. `git branch -m <new>`
1. `git push <remote> <remote>/<old>:refs/heads/<new> :<old>`
1. `git fetch <remote>`
1. `git branch -u <remote>/<new>`

*PIPELINE:*

```sh
git branch -m <new> && git push <remote> <remote>/<old>:refs/heads/<new> :<old> && git fetch <remote> && git branch -u <remote>/<new>
```

### Nomeação de *Branch Default*

Depois de alterar o nome da *branch default* no remoto:

1. `git fetch origin`
1. `git branch -m master main`
1. `git branch -u origin/main main`
1. `git remote set-head origin -a`
1. `git remote prune origin`

*PIPELINE:*

```sh
git fetch origin && git branch -m master main && git branch -u origin/main main && git remote set-head origin -a && git remote prune origin
```

### *Branch Upstream*

Definir automaticamente *branchs* remotas das *branchs* locais:

```sh
for branch in `git branch --color=never | sed -E 's/^[[:blank:]\*]*//'`; do
	git switch "$branch" && \
	git branch -u "origin/$branch"
done
```

### Arquivos Indexados

Adicionar arquivos já "commitados" no `.gitignore`:

1. `git rm --cached -r ./`
1. `git add ./`
1. `git commit -m "<message>"`

*PIPELINE:*

```sh
git rm --cached -r ./ && git add ./ && git commit -m "<message>"
```

### Objeto de Arquivos Vazios

Quando alguma operação Git é interrompida:

1. `find .git/objects/ -type f -empty -delete`
1. `git fetch -p`
1. `git fsck --full`

*PIPELINE:*

```sh
find .git/objects/ -type f -empty -delete && git fetch -p && git fsck --full
```

## Git Playground

Espaço virtual para testar e treinar Git: <http://git-school.github.io/visualizing-git/>.
