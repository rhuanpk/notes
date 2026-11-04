# Docker

Anotações gerais sobre Docker: comandos e configurações.

## Defaults

PostgreSQL:

```sh
docker volume create postgres
docker run -d [--rm] --name postgres -e POSTGRES_PASSWORD=postgres [-v [/path/]postgres:/var/lib/postgresql/data] [-p 5432:5432] postgres
```

Adminer:

```sh
docker run -d [--rm] --name adminer [--link database:db] [-p 80:8080] adminer
```

Windows:

```sh
docker run -it [--rm] --name windows -e "VERSION={11|11l|11e|10|10l|10e|8e|7u|vu|xp|2k|2025|2022|2019|2016|2012|2008|2003}" [-e "RAM_SIZE=8G"] [-e "CPU_CORES=8"] -p 8006:8006 --device=/dev/kvm --device=/dev/net/tun --cap-add NET_ADMIN [-v "./windows:/storage[:rw]"] --stop-timeout 120 dockurr/windows
```

Tor Proxy:

```sh
docker run --rm -it -p 127.0.0.1:3128:3128 zhaowde/rotating-tor-http-proxy
```

## Comandos

Anotações gerais sobre os comandos.

### `up`

`--build`: *Rebuilda* a imagem do *container*, quando o nosso serviço roda em cima de uma imagem que construímos por conta própria (a partir de um Dockerfile), sempre que qualquer coisa que faça parte do *build* da imagem (ou seja, os recursos descritos dentro do Dockerfile) for alterado, precisamos usar `--build`, porque, por mais que reiniciamos/recriamos o container, ele usará a imagem já existente, que não contem as novas alterações.

`--force-recreate`: Recria o *container* do zero (como se tivesse sendo criando pela primeira vez), quando usamos o comando `docker compose up`, por padrão, o Docker tenta reutilizar os *containers* existentes se não houver alterações nos serviços ou nas imagens, no entanto, pode haver situações em que desejamos garantir que os containers sejam sempre recriados do zero, por exemplo, para garantir que os volumes sejam remontados, variáveis de ambiente sejam aplicadas novamente, ou simplesmente para garantir um estado limpo do container.

### `inspect`

Verificar IPs do *container*:

```sh
docker container inspect <name/id> | grep -i 'ipaddress'
```

Verificar volumes do *container*:

```sh
docker container inspect <name/id> | grep -iA 11 'mounts'
```

### `volume`

Criar volume nomeado:

```sh
docker volume create <name>
```

## Volumes

> Volumes nada mais são do que "pastas dos containers" que salvamos ou mapeamos?

Basicamente existem dois tipos de volumes:

- *Data Volumes* (Volumes Nomeados): Volumes criados e controlados pelo *docker host* (pelo próprio docker, seu *daemon*) que não tem ligação com a MÁQUINA *host*
	- OBS: é como se fossem simplesmentes um ponto de montagem do próprio container?
- *Bind Volumes* (Volumes Mapeados/Conectados): Volumes que mapeia algum diretório ou arquivo da máquina *host* para dentro do container
- *TMPFS Volumes* (Volumes Temporários): Volumes que persitem dados em memória simplesmente (!)

### Data Volumes

Caso você crie um container no qual a sua imagem já cria algum volume por padrão, esse volume é criado com algum nome aleatório (`docker volume ls`).

Para uma melhor manutenção, é recomendado que se crie um volume manualmente (volume nomeado) e utilize esse volume nos seus containers para a persistencia, dessa forma garantindo até a reutilização dos dados gravados dos containers anteriores.

*OBSERVAÇÕES:*

- Caso queira utulizar essa "tecnica" para criar seus volumes nomeados em imagens que já criam por padrão, deverá saber todos os volumes que esse imagem cria

### Criação de Containers

Opções de volumes na criação de *containers*.

#### `--volume` (`-v`)

Sintaxe:

```sh
-v <named-volume>:<container-directory>[:<options>]
```

Exemplo:

```sh
docker container run -d --name mysql -v mysql:/var/lib/mysql:rw -e MYSQL_ROOT_PASSWORD=root mysql:latest
```

#### `--mount`

Sintaxe:
```sh
--mount 'type=<volume-type>,src=<named-volume>,dst=<container-directory>[,<options>,...]'
```

Exemplo:

- `type`: Tipo de volume utilizado
	- `volume`: Volume nomeado
		- Para volumes nomeados, caso ele não exista, ele será criado
	- `bind`: Volume mapeado
	- `tmpfs`: Volume temporário
- `source` (`src`): Nome do volume nomeado ou do diretório na maquina *host* a ser mepeado
- `target` (`dst`): Nome do diretório dentro do container

```sh
docker container run -d --name mysql --mount 'type=volume,source=mysql-db,target=/var/lib/mysql,readonly' -e MYSQL_ROOT_PASSWORD=root mysql:latest
```

*OBSERVAÇÕES:*

- Volumes não são excluídos por padrão quando seus containers morrem
- Cuidado com a utilização de *data volumes* pois pode causar efeitos não esperados nos containers, no caso de uso de um container *MySQL*, quando um novo container utiliza um *data volume*, além de todos os dados (todos os *databases* e tabelas), ele também puxará as informações "administrativas", logo a senha permanesse a mesma na primeira instâncias também

*LINKS:*

- [YouTube](https://www.youtube.com/watch?v=StQYXkFgeeA)

## *Prune*

Diferença entre as opções de *system prune*.

- `docker system prune`:
	- *all stopped containers*
	- *all unused networks*
	- *all dangling images*
	- *all unused build caches*
- `docker system prune --all`:
	- *all unassociated images*
	- *all build cache*
- `docker system prune --volumes`:
	- *all unused anonymous volumes*
- `docker system prune --all --volumes`:

Diferença plena entre as opções:

- `docker system prune`:
	- *all stopped containers*
	- *all unused networks*
	- *all dangling images*
	- *all unused build caches*
- `docker system prune --all`:
	- *all stopped containers*
	- *all unused networks*
	- *all unassociated images*
	- *all build cache*
- `docker system prune --volumes`
	- *all stopped containers*
	- *all unused networks*
	- *all unused anonymous volumes*
	- *all dangling images*
	- *all unused build caches*
- `docker system prune --all --volumes`
	- *all stopped containers*
	- *all unused networks*
	- *all unused anonymous volumes*
	- *all unassociated images*
	- *all build cache*

## *Compose*

Remove todos os recursos referentes aquele compose:

```sh
docker compose down --rmi all
```

## *Troubleshooting*

"network (docker0): networks have same bridge name":

```sh
ip link delete docker0
rm -iv /var/lib/docker/network/files/local-kv.db
systemctl restart docker
docker rm -f `docker container ls -aq`
```

## *Links*

- [Docker Swarm/Service](https://www.cloudbees.com/blog/running-services-within-docker-swarm)

### MySQL

Variáveis de ambiente:

- `MYSQL_DATABASE`: Define o nome de um *database* para ser criado junto com a criação do container, ou seja, caso o banco seja *dropado* é necessário remover e recriar o container. Caso esteja usando volumes isso não resolverá, terá que remover e recriar o volume também
