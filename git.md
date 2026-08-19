# Git

Anotações gerais sobre Git: comandos e configurações.

### *Quick Start*

1. `git add ./`
1. `git commit -m 'commit message'`
1. `git push origin main`

_pipeline_:

```sh
git add ./ && git commit -m 'commit message' && git push origin main
```

### Branchs

#### Listagem de branchs

Locais:

```bash
git branch [--list|-l]
```

Remotas:

```bash
git branch {--remotes|-r} {--list|-l}
```

Locais e remotas:

```bash
git branch {--all|-a}
```

Detalhamento das branchs:

```bash
git branch -vva
```

Mostra além das branchs remotas, outras infos:

```bash
git remote show <remote_name>
```

#### Troca de branchs

Com *checkout*:

- -b: cria uma nova branch.

```bash
git checkout [-b] <branch_name>
```

Com *switch*:

- -c: cria uma nova branch.

```bash
git switch [-c] <branch_name>
```

OBS: casp seja passado a opção de criação de branch na hora de mudar para ela, será criado essa nova branch e seguida mudado para ela.

#### Remoção de branchs

##### Local

Remover:

```bash
git branch -d <branch_name>
```

Forçando:

```bash
git branch -D <branch_name>
```

Deletar somente a referência das branchs remotas:

```bash
git branch -rl '<remote>/*' | xargs git branch -dr
```

##### Remoto

Remover:

```bash
git push origin {:<remote_branch>|--delete <remote_branch>}
```

Parar de _trackear_ branch remota:

```sh
git branch -dr <remote>/<branch>
```

#### Renomeação de Branchs

##### Local

Renomear:

```sh
git branch -m <new_branch>
```
Forçando:

```sh
git branch -M <new_branch>
```

##### Remoto

Renomear:

```sh
git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch>
```

Desvincular local com remoto inexistente:

```sh
git branch --unset-upstream
```

Vincular local com novo remoto:

```sh
git branch --set-upstream-to=<remote>/<new_branch>
```

#### Criação de Branchs

A partir de uma remoto já existente:
```sh
git switch -c <local-branch> <remote>/<remote-branch>
```

#### Alteração de Branchs

Colocar _branch_ em _commit_ específico:
```sh
git branch -f <branch> <commit>
```

### Push

Enviar a _branch_ local para o _remote_ específicado com o mesmo nome da _branch_ local, caso a _branch_ local não exista no remoto, será criada:

```bash
git push <remote> <local-branch>
```

Enviar a _branch_ local para o _remote_ específicado para a _branch_ remota específicada, caso a _branch_ remota não exista no remoto, será criada:

```bash
git push <remote> <local-branch>:<remote-branch>
```

### Commits

#### Revert

Desfaz o _commit_ criando um novo _commit_ sem essas alterações:

```sh
git revert <commit>
```

Passando um _range_ (do mais antigo para o mais novo) de _commits_ (isso fará um **revert** por vez):

```sh
git revert <oldest-commit>..<newst-commit>
```

#### Reset

Resetar o commit sem perder as alterações colocando elas na _worktree_:

```bash
git reset <commit-hash>
```

Resetar o commit sem perder as alterações voltando elas para o _index_ (_staged area_):

```bash
git reset --soft <commit-hash>
```

Desfazer o commit por completo (sem manter as alterações):

```bash
git reset --hard <commit-hash>
```

#### Amend

Para adicionar um novo arquivo para o último _commit_ ou editar qualquer arquivo do _commit_, basta fazer as alterações desejadas e adicionar em _stage_ (`git add <path>`):

```bash
# simplesmente commitar sem alterar nada (mensagem):
git commit --amend --no-edit

# commitar no modo interativo (abre o editor padrão):
git commit [-i] --amend

# já passando a mensagem:
git commit --amend -m '<message>'
```

OBS: depois que realizar o comando, aparecerá um "commit extra", porém, simplesmente *pushe* a nova alteração forçando que esse novo commit já e sobrescrito: `git push -f origin <branch_name>`.

#### Cherry Pick

Trazendo um _commit_ específico para a branch:

```bash
git cherry-pick <commit_hash>
```

Somente aplicando as alterações do _commit_:

```bash
git cherry-pick --no-commit <commit-hash>
```

Trazendo o _commit_ e edita a mensagem antes de concluir:

```bash
git cherry-pick --edit <commit-hash>
```

OBS: estando na _branch_ que vai receber as alterações.

_REFERENCELINKS_:

- https://www.atlassian.com/git/tutorials/cherry-pick
- https://git-scm.com/docs/git-cherry-pick

#### Squash

_Squashear commits_ da mesma branch com `rebase`:

```bash
git rebase -i {HEAD*|<commit_hash>}
```

### Merge

_Dry-run_:

1. Faça o "_merge_ falso":
	`git merge --no-commit --no-ff <branch-name>`

1. Caso tenha alguma alteração, veja com:
	`git diff --cached`

OBS: caso precise desafzer algum merge: `git merge --abort`.

Com _squash_:

```bash
git merge --squash <branch-name>
```

OBS: dessa forma, como tudo irá virár um único _commit_, no final ele deixa tudo em _staged_ para você _commitar_ com a mensagem desejada.

#### Conflito

Se a mesclagem já estiver em progresso:
- Aceitar as alterações "locais":
    `git checkout --ours file.txt`
- Aceitar as alterações "remotas":
    `git checkout --theirs file.txt`

Se ainda irá mesclar:
- Aceitar as alterações "locais":
    `git merge -X ours <branch-name>`
- Aceitar as alterações "remotas":
    `git merge -X theirs <branch-name>`

_OBSERVATIONS_:
- _Branch_ "local": _branch_ atual na qual será mesclada
- _Branch_ "remota": _branch_ que será mesclada na atual

### Rebase

#### Simple Rebase

Command:
	`git rebase <new-base>`

We say: rebase atual branch to "new base" branch.

Command:
	`git rebase <new-base> <rebase-branch>`

We say: rebase "branch to rebase" branch to "new base" branch.

Eexplain: before perform normal rebase, switch to the "branch to rebase" branch.

#### Rebase With Onto

Command:
	`git rebase --onto <new-base> <start-point>`

We say: rebase atual branch to "new base" branch starting from "start point".

Command:
	`git rebase --onto <new-base> <start-point> <end-point>`

We say: in atual branch starting from "start point" util the "end point" rebasing onto "new base" branch.

OBSERVATIONS:

- In **rebase onto** the _start point_ actually is the child commit of him (so you'll probably want to do something like `<start-point>^` or `<start-point>~1`);

- This guide uses "newbie terms" for better explanation. In "technical terms" in **common rebase** (and **git onto**) the `<new-base>` actually is `<new-parent-commit>` and in **rebase onto** the `<start-point>` is `<old-parent-commit>` and `<end-point>` is `<until-the-commit>`.

### Stash

- `-u`: _stashear_ arquivos não traqueados (#saving,#listing);
- `-p`: _patch_ dos arquivos (#listing);
- `-S`: aplica o **stash** somente sobre o _staging_ (#saving);
- `-k`: apesar de _stashear_ o que está em _staging_, não o limpa (#saving);
- `-m <message>`: _stashear_ com mensagem específica (#saving);
- `--index`: restaurar preservando o _staging_ (#applying).

_Stashear_ todos os arquivos:

```bash
git stash [-uk] [-m <message>]
```

_Stashear_ arquivos específicos:

```bash
git stash push [-uk] [-m '<message>'] <path/to/folder/or/file.any>*
```

Listar/Mostrar _stash_:

```bash
git stash show [-up] 'stash@{<stash_id>}'
```

Aplicar/Aplicar e Dropar _stash_:

```sh
git stash {apply|pop} [--index] ['stash@{<stash_id>}']
```

Deletar **stash**:

```sh
git stash drop ['stash@{<stash_id>}']
```

_OBERSAVTIONS_:

- Nas operações com **stash**, quando NÃO especificado o _id_, é pego por padrão o último (o primeiro da _FIFO_).

### Log's

- `--all`: caso sua branch esteja atrás, mostra logs dos ramos a frente também;
- `--oneline`: mostra o log de forma resumida, um por linha;
- `--patch`: mostras as alteraçẽos feitas nos commits;
- `--graph`: dsenha uma gráfo da time line dos logs;
- `--author=<name>`: filtra os logs pelo autor.

Mostra o log de commits:

```bash
git log [--all|--oneline|--patch|--graph]
```

OBS: todas as opções podem ser usadas ao mesmo tempo ou não (divirta-se).

Rastrear um único arquivo pelos *commits*:

```bash
git log --folow [-p] <file_name>
```

### Blame

Mostra quem fez as alterações (autor do commit) em determinado arquivo:

- -w: remove espaços em branco.
- -L: limita a faixa de linhas.

```bash
git blame [-w|-L 1,12] <file_name>
```

### Clonagem

Clonar repositório remoto:

```bash
git clone <url>
```

Clonar repositório remoto de uma branch ou tag específica:

```bash
git clone -b {<branch_name>|<tag_name>} <url>
```

OBS: caso clone por algum tag, pode ser que essa tag esteja num vínculada a um hash que não está apontado por nenhuma branch, nesse caso, se faz necessário cria uma branch logo depois que clonar: `git switch -c newbranch`

Clonar sem outras branch ou referência delas:
```sh
git clone --single-branch [-b {<branch_name>|<tag_name>}] <url>
```

### Submodule

Adicionar um novo _submodule_:

```bash
git sobmodule add {./path/to/another/local/repo|<remote_url>}
```

Iniciar os _submodules_ de um repositório clonado (estando na raiz do repositório local):

```bash
git sobmodule init
```

_Updatar_ os submódulos:

```bash
git sobmodule update
```

Caso o _submodule_ não esteja apontando para a HEAD do seu repectivo remoto, você pode resolver isso entrando na pasta do submódulo e realizando um `pull` ou diretamente da sua raiz:

```bash
git submodule update --remote
```

Para retirar o _submodule_ do `.git/config`, que é da onde o comando de `update` puxa os _submodules_:

```bash
git submodule deinit <submodule_folder>
```

Clonar repositórios com submódulos já inicializando e atualizando-os:

```bash
git clone --recurse-submodules <remote_url>
```

_OBSERVATIONS_:

- toda vez que fizer alterações nos submódulos, deve-se commitar.

- `git submodule init` refaz a configuração dos submódulos com base no `.gitmodules` caso algum seja retirado do `.git/config`.

- arquivos e pastas:
	- `.gitmodules`: arquivo de configuração que mapeia os submódulos dentro do repo (gerado a partir do `git submodules init`).
	- `.git/config`: dentro do arquivo de configuração do _repo_ local é criado uma sessão com os submódulos para serem _updatados_.
	- `.git/modules`: é a pasta que vão os múdulos baixados por _url_.

### .gitignore

#### Arquivos

Arquivo **global**: pode estar alocado em qualquer lugar e vale para qualquer repositório na máquina.

```
~/.gitignore
```

Arquivo **local**: deve estar na raiz do projeto e vale somente para aquele projeto e todos que contribuem.

```
/path/to/project/.gitignore
```

Arquivo do usuário: é um arquivo já prédefinido pelo git e não é versionado pelo código.

```
/path/to/project/.git/info/exclude
```

#### Comandos

Setar o `.gitignore` global:

```bash
git config --global core.excludesfile ~/.gitignore
```

Caso algum arquivo seja ignorado deve-se remove-lo do índice:

```bash
git rm --cached file.txt
```

Adicionar no índice algum arquivo que esteja sendo ignorado:

```bash
git add -f file.txt
```

#### Skip Work Tree

Remover da árvore de trabalho:

```bash
git update-index --skip-worktree file.txt
```

Retornar para a árvore de trabalho:

```bash
git update-index --no-skip-worktree file.txt
```

Listar os arquivos *skipados*:

```bash
git ls-files -v | grep -E '^S'
```

### Tag's

Colocar tag em commits (da para clonar de um commit específico):

```bash
git tag <tag_name> <commit_hash>
```

Remover tag local:

```bash
git tag -d <tag_name>
```

Remover tag remota:

```bash
git push origin :refs/tags/<tag_name>
```

### Remote

Limpar as referência do remoto no seu repositório local (remover o que não existe mais no repositório remoto?):

```sh
git remote prune <remote>
```

### Repos

#### Remotes

Renomear repositório remoto:

```bash
git remote rename <nome_atual> <novo_nome>
```

#### Forks

Sincronizar repo local com upstream:

1. Add remote repo:
	`git remote add upstream <url>`;

1. Fetch infos:
	`git fetch upstream`;

1. Change to target branch (if needed):
	`git switch main`;

1. Merge with upstream:
	`git merge upstream/main`;

### Authentication

#### Cache

Configurar:

```bash
git config --global credential.helper cache
# or seting the time
git config --global credential.helper 'cache --timeout 28800'
```

Limpar a senha do cache:

```bash
git credential-cache exit
```

#### Store

Configurar:

```bash
git config --global credential.helper store
# or seting the file
git config --global credential.helper 'store --file /path/to/.credentials-file'
```

_Setar_ o arquivo de configuração (_default_):

```bash
echo 'https://<user>:<token>@<domain>' >> ~/.git-credentials
```

#### Libsecret (Linux)

Programas necessários:
```sh
sudo apt install -y libsecret-1-dev
```

_Setup_:
1. _Buildar_ o binário: `sudo make --directory=/usr/share/doc/git/contrib/credential/libsecret`
1. _Setar_ o helper: `git config --global credential.helper /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret`

_TIP/TRICK_:

- Para definir credenciais para usuários diferente do mesmo host (porém como consequência para cada repo):
```sh
git config --global credential.https://.useHttpPath true
```

---

_Desetar_ a configuração global:

```bash
git config --global --unset credential.helper {cache|store}
```

_OBSERVATIONS_:
- Pode-se utilizar os dois _helpers_ aonde caso não seja encontrado o helper do store será pedido a senha que posteriormente será gravada no cache.

### Configuration

_Setar_ usuário e email:
```sh
git config --global user.name <user>
git config --global user.email <email>
```

OBS: para setar usuário e email local troque a flag `--global` para `--local`.

Listar todas as configuração:
```sh
git config --list --show-origin
```

OBS: caso você esteja dentro de um repo também será mostrado as configurações locais do repo.

Trocar editor padrão:
```sh
git config --global core.editor <editor>
```

#### `include`

Definir arquivo de configuração para ser incluso:
```sh
git config --global include.path ~/path/to/.gitconfig
```

#### `includeIf`

Definir arquivo de configuração específico para todos os repos dentro de terminada pasta:
```sh
git config --global includeIf.'gitdir:~/path/to/projects/[**]'.path ~/path/to/projects/.gitconfig
```

_OBSERVATIONS_:
- Aqui dizemos: Inclua o `.gitconfig` quando estiver dentro da pasta _projects_ ou numa subpasta
- Necessário a "/" no final do caminho do em `gitdir`

### Bare

#### "Servidor Remoto" Local

1. Defina o servidor remoto local:
	`git clone --bare /path/to/local/project /mnt/project.git`
1. Adicione o servidor remoto local no projeto local:
	`git remote add drive /mnt/project.git`

_OBSERVATIONS_:
- Caso necessário outra pessoa pode pegar a mídia externa que está sendo usada como servidor externo, plugar em sua máquina, adiciona-lo como remote e pegar suas atualização com `pull`:
	1. `git remote add drive /mnt/project.git`
	1. `git pull drive main`

#### Expor "Servidor Remoto" Local

1. _Entre no "servidor remoto" local_
1. Atualize o _bare_:
	`git --bare update-server-info`
1. Troque os _hooks_ de update:
	`mv hooks/post-update{.sample,}`
1. Suba um mini servidor web (como em **python**):
	`python -m http.server 8000`
1. _Faça o clone teste_:
    `git clone http://localhost:8000 project`
1. <details>
    <summary>Acesse de fora</summary>

    - <details>
        <summary>Utilize uma VPN</summary>

        Para clonar, ao invés de usar `localhost`, utilize o IP da sua VPN ou seu _DDNS_.
    ou
    - <details>
        <summary>Utilize um <em>Reverse Proxy</em></summary>

        1. Exponha a porta 8000 como HTTP (que aponta para nosso mini _web server_):
            `ngrok http 8000`
        1. Clone de fora da rede com:
            `git clone https://<uuid>.ngrok.io project`
    </details>
    </details>
</details>

_OBSERVATIONS_:
- Sugestões VPN:
    - `PiVPN`
	- `tailscale`
	- `ZEROTIER`

### Commands

- _Printa_ o _hash_ do _commit_ em comum de duas _branchs_: `git merge-base <first_branch> <second_branch>`
- _Printa_ o _hash_ de objeto git do arquivo (seja pasta ou diretório): `git hash-object path/to/any-file`

### Tips & Tricks

#### Sintaxe de URL's:

http:

```bash
https://<user>:<token>@<domain>/<user>/<repo>.git
```

ssh:

```bash
git@<domain>:<user>/<repo>.git
```

latest release:

```bash
https://github.com/<user>/<repo>/releases/latest/download/<filename>
```

#### Certificados de Segurança

Desabilitar verificação de SSL do git:

```bash
git config --global http.sslverify false
```

#### Copiar/Pegar as Modificações de Um Arquivo de Outra Branch

```bash
git checkout <other_branch> -- ./path/to/{folder|file.any}
```

#### Comparar Arquivos Entre Duas Commits/Branchs

```bash
git diff <src-branch/commit> <dst-branch/commit> -- file.any
```

#### Comparar Duas Branchs Pelo Commit Pai Mais Recente

```sh
# `git diff $(git merge-base <source> <target>) <target>` is an alias from git itself for:
git diff HEAD...<target_branch>
```

#### Splitar Commit's

Último _commit_:

1. _Com seu repo local limpo..._
1. Reseta o último _commit_ para a _worktree_: `git reset HEAD^`
1. Adicione e _commite_ conforme a necessidade.

OBS: necessário _force push_?

Algúm _commit_ no meio da árvore/história:

1. Use `rebase`: `git rebase -i <commit_hash>^`

OBS:

- simplesmente marque todos _commit's_ a serem editados com `e` ou `edit`;
- _reset_ o _commit_ atual com `git reset HEAD^` e _commite_ conforme desejado;
- será necessário _force push_;

#### Mesclar Sem Commitar

1. Mescle sem commitar (as alterações iram para o _index_ (_staging area_)): `git merge --no-commit <branch>`
1. _resolve conflicts and mark them as resolved (if exists)_
1. Saia do merge (as aterações continuaram no _index_): `git merge --quit`
1. Fça um `amend` para aplicar as alterações no último _commit_: `git commit --amend --no-edit`

_pipeline_ (work if not have conflicted):

```sh
git merge --no-commit <branch> && git merge --quit && git commit --amend --no-edit
```

#### Dar Rebase da Própria Branch (_self rebase_) Pelo Commit de `merge-base`

```sh
git rebase [-if] `git merge-base feature main`
```

OBS: será útil fazer dessa forma e não pegando de forma manual o último commit da branch quando antes do rebase tiver feito algum merge.

#### Personalização de URL

Inclua a sessão `url` no arquivo `.git/config`:

- Imbutir token de acesso:
```git
[url "https://<user>:<token>@"]
	insteadOf = https://
```
OBS: No final haverá a substituição: `https://remote.any/user/repo.git` -> `https://user:token@remote.any/user/repo.git`

- Redirecionar para o protocolo SSH:
```git
[url "ssh://git@"]
	insteadOf = https://
```
OBS:
- No final haverá a substituição: `https://remote.any/user/repo.git` -> `ssh://git@remote.any/user/repo.git`
- Tenha a chave ssh no agente
- O mesmo vale caso queira fazer o inverso, `SSH` to `HTTPS`
- Também é possível fazer via _CLI_: `git config --global url.'git@<remote>:'.insteadOf 'https://<remote>/'`

#### Aplicar Diff Patch Gerado com Cor

Quando for salvar um patch para ser aplicado posteriormente gere com:
```sh
git diff --no-color > /path/to/save/diff.patch
```

Caso esteja com cor aplique com:
```sh
cat -v /path/to/saved/diff.patch | sed 's/\^\[\[[[:digit:]]*m//g' | git apply -
```

#### Sobre `git config --get`

- Com a flag `--global`: listará as informações do arquivo de configuração global (`~/.gitconfig`) ou do sistema (`/etc/gitconfig` ou `/etc/git/gitconfig`);
- Com a flag ``: listará as informações de escopo do "grupo" (ver #includeIf-repo-groups);
- Com a flag `--local`: listará as informações do arquivo de configuração do repo local (`/path/to/project/.git/config`).

#### Descartar Somente Alterações do Index

1. `git stash --staged`
1. `git stash drop`

#### Alterar Modo de Prompt

Desabilitar o _prompt_ (git espera encontrar as credenciais no ambiente):
```sh
GIT_TERMINAL_PROMPT=0 <command>
```

Habilitar o _prompt_ (git forçara a entrada manual das credenciais):
```sh
GIT_TERMINAL_PROMPT=1 <command>
```

#### Remover Commit do Meio do Log

Utilize `git rebase -i` ou `git revert`. O **revert** é preferível por ser uma abordagem mais "segura" pois evitará pushs forçados, o que bagunçaria o histórico de todos (claro que se as alterações ainda não estiverem no remoto, utilizar o **rebase -i** não seria um problema).

#### _Author_ X _Commiter_

O autor é a pessoa que originalmente escreveu o código. O committer, por outro lado, é considerado a pessoa que cometeu o código em nome do autor original. Isso é importante no Git porque o Git permite reescrever o histórico ou aplicar patches em nome de outra pessoa.

#### Pegar Código de Saída de Status

_Exit status_ para arquivos modificados/deletados (**worktree**):
```sh
if git diff -s --exit-code <pathspec>; then
	echo not changed
else
	echo changed
fi
```

_Exit status_ para arquivos não traqueados (**untracked**):
```sh
git status --porcelain | grep '^\?\?'
```

#### Múltiplos Remotes

Buscar configurar somente a branch HEAD do remoto:

1. Verificar qual o nome da HEAD do remoto:
    `git remote show <remote>`

1. Buscar somente a HEAD do remoto:
    `git fetch <remote> <branch>`

1. Configure a `remote/HEAD` local:
    `git remote set-head --auto <remote>`

#### Clonagem de Todos Repositórios (Ou Só Alguns)

Comando para GitHub:
```sh
for repo in $(curl -fsSL [-H 'authorization: bearer <token>'] https://api.github.com/users/<user>/repos | sed -nE 's~^.*clone_url.*("https.*[<search>.*]").*$~\1~p' | tr -d '"'); do git clone "$repo"; done
```

### Troubleshooting

#### Pasta inacessível (pasta com *submodule*)

1. `git rm --cached <folder_name>`
1. `rm -rf <folder_name>/.git`
1. `git add .`
1. `git push origin main`

#### Listar somente os arquivos com conflito no `--rebase`:

```bash
git status --short | sed -n 's/AA //p'
```

#### Depois de alterar o nome da branch default no remoto:

1. `git branch -m master main`
1. `git fetch origin`
1. `git branch -u origin/main main`
1. `git remote set-head origin -a`
1. `git remote prune origin`

_pipeline_:

```bash
git branch -m master main && git fetch origin && git branch -u origin/main main && git remote set-head origin -a && git remote prune origin
```

#### Renomear Branch Local e Remota

1. `git branch -m <new_branch>`
1. `git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch>`
1. `git fetch <remote>`
1. `git branch -u <remote>/<new_branch>`

_pipeline_:

```sh
git branch -m <new_branch> && git push <remote> <remote>/<old_branch>:refs/heads/<new_branch> :<old_branch> && git fetch <remote> && git branch -u <remote>/<new_branch>
```

#### Setar Manualmente Branch Upstream das Branchs Locais

Comando:
```sh
for branch in `git branch --color=never | sed -E 's/^[ \*] //g'`; do
	git switch "$branch" \
	&& git branch -u "origin/$branch"
done
```

#### Adicionar Arquivos Já Commitados no .gitignore

É necessário resetar o cache do repositório local:

1. `git rm --cached -r ./`
1. `git add ./`
1. `git commit -m '<message>'`

_pipeline_:

```sh
git rm --cached -r ./ && git add ./ && git commit -m '<message>'
```

#### Objeto de Arquivos Vazios

Quando alguma operação Git é interrompida:

1. `find .git/objects/ -type f -empty -delete`
1. `git fetch -p`
1. `git fsck --full`

_pipeline:_

```sh
find .git/objects/ -type f -empty -delete && git fetch -p && git fsck --full
```

### Git Playground

<http://git-school.github.io/visualizing-git/>
