# *Hardware*

Anotações gerais sobre *Hardware*: programas e configurações.

## `lsusb`

Listar dispositivos USB:

```sh
[sudo] lsusb
```

## `dmidecode`

Saber o número de série do dispositivo:

```sh
[sudo] dmidecode -s system-serial-number
```

## `acpi`

Ver porcentagem da bateria (*notebooks*):

```sh
acpi --battery
```

## `smartctl`

*Parâmetros usados:*

- `X`: Letra do disco
- `N`: Número do NVMe

Programas necessários:

```sh
[sudo] apt install smartmontools
```

Mostra informações sobre o disco (inclusive se tem suporte a tecnologia SMART e está habilitado):

```sh
[sudo] smartctl -i /dev/sdX
```

Habilita a tecnologia SMART caso esteja desabilitado (e o disco tenha suporte):

```sh
[sudo] smartctl -s on /dev/sdX
```

Testa a saúde do disco:

```sh
[sudo] smartctl -H /dev/sdX
```

Faz a checagem no disco:

```sh
[sudo] smartctl -t {short|long} /dev/sdX
```

Lista as checagens manuais feitas no disco (pela opção `-t`):

```sh
[sudo] smartctl -l selftest /dev/sdX
```

Mostra todas as informações SMART sobre o dispositivo:

```sh
[sudo] smartctl -a /dev/sdX
```

Pegar informações relevantes sobre **HDD**:

```sh
# HDD, <30k, ==0
[sudo] smartctl -a /dev/sdX | grep -P '^ID#|Power_On_Hours|Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable|Reported_Uncorrect' | column -t -H 3-9
```

Pegar informações relevantes sobre **SSD**:

```sh
# SSD, % lifespan remaining
[sudo] smartctl -a /dev/sdX | grep -P '^ID#|Power_On_Hours|Reallocated_Sector_Ct|Current_Pending_Sector|Offline_Uncorrectable|Reported_Uncorrect|Remaining_Lifetime_Perc|Wear_Leveling_Count|Percent_Lifetime_Remain|SSD_Life_Left|Media_Wearout_Indicator' | column -t -H 3,5,7-9
```

Pegar informações relevantes sobre **NVMe**:

```sh
# NVMe, % disk usage
[sudo] smartctl -a /dev/nvme0nN | grep -P '^(Power On Hours:|Media and Data Integrity Errors:|Error Information Log Entries:|Critical Warning:|Percentage Used:)'
```

*OBSERVAÇÕES:*

- Para as informações relacionadas a nível de saúde do dispositivo, usar a coluna `VALUE`, qualquer outras informações (como contagem de erros) e etc, usar a coluna `RAW_VALUE`

## `fio`

*Benchmark* de I/O (HDDs, SSDs, NVMes, Pendrives, SD Cards e etc).

Para usa-lo você deve passar um série de parâmetros como opções ou arquivos de configurações. Não há um teste de I/O padrão que todas as ferramentas de *benchmark* usam, cada uma específicas seus próprios "perfis de parâmetros".

Exemplos de arquivos de configuração de "perfis de parâmetros":

- <details>
	<summary><i>Global</i> (<code>global.fio</code>)</summary>

	```ini
	filename=test.dat
	size=1G

	direct=1
	invalidate=1

	time_based=1
	runtime=30

	group_reporting=1

	randrepeat=0
	refill_buffers=1
	norandommap=1

	end_fsync=1

	#ioengine=libaio
	ioengine=io_uring

	loops=3
	```
- <details>
	<summary><i>Default</i> (<code>default.fio</code>)</summary>

	```ini
	[global]
	include=global.fio

	##########################################
	# SEQ1M Q8T1
	##########################################

	[SEQ1M_Q8T1_READ]
	rw=read
	bs=1M
	iodepth=8
	numjobs=1

	[SEQ1M_Q8T1_WRITE]
	stonewall
	rw=write
	bs=1M
	iodepth=8
	numjobs=1

	##########################################
	# SEQ1M Q1T1
	##########################################

	[SEQ1M_Q1T1_READ]
	stonewall
	rw=read
	bs=1M
	iodepth=1
	numjobs=1

	[SEQ1M_Q1T1_WRITE]
	stonewall
	rw=write
	bs=1M
	iodepth=1
	numjobs=1

	##########################################
	# RND4K Q32T1
	##########################################

	[RND4K_Q32T1_READ]
	stonewall
	rw=randread
	bs=4K
	iodepth=32
	numjobs=1

	[RND4K_Q32T1_WRITE]
	stonewall
	rw=randwrite
	bs=4K
	iodepth=32
	numjobs=1

	##########################################
	# RND4K Q1T1
	##########################################

	[RND4K_Q1T1_READ]
	stonewall
	rw=randread
	bs=4K
	iodepth=1
	numjobs=1

	[RND4K_Q1T1_WRITE]
	stonewall
	rw=randwrite
	bs=4K
	iodepth=1
	numjobs=1
	```
- <details>
	<summary><i>SSD</i> (<code>ssd.fio</code>)</summary>

	```ini
	[global]
	include=global.fio

	##########################################
	# SEQ1M Q8T1
	##########################################

	[SEQ1M_Q8T1_READ]
	rw=read
	bs=1M
	iodepth=8
	numjobs=1

	[SEQ1M_Q8T1_WRITE]
	stonewall
	rw=write
	bs=1M
	iodepth=8
	numjobs=1

	##########################################
	# SEQ128K Q32T1
	##########################################

	[SEQ128K_Q32T1_READ]
	stonewall
	rw=read
	bs=128K
	iodepth=32
	numjobs=1

	[SEQ128K_Q32T1_WRITE]
	stonewall
	rw=write
	bs=128K
	iodepth=32
	numjobs=1

	##########################################
	# RND4K Q32T16
	##########################################

	[RND4K_Q32T16_READ]
	stonewall
	rw=randread
	bs=4K
	iodepth=32
	numjobs=16

	[RND4K_Q32T16_WRITE]
	stonewall
	rw=randwrite
	bs=4K
	iodepth=32
	numjobs=16

	##########################################
	# RND4K Q1T1
	##########################################

	[RND4K_Q1T1_READ]
	stonewall
	rw=randread
	bs=4K
	iodepth=1
	numjobs=1

	[RND4K_Q1T1_WRITE]
	stonewall
	rw=randwrite
	bs=4K
	iodepth=1
	numjobs=1
	```
</details>
</details>
</details>

*Parâmetros usados:*

- `<job>`: Caminho do arquivo de configuração de parâmetros
- `<type>`: Tipo do formato de saída do comando: `normal`, `terse`, `json` e `json+`

Programas necessários:

```sh
[sudo] apt install fio
```

Executar teste a partir do arquivo de configuração:

```sh
fio <job>
```

Salvando o resultado do teste:

```sh
fio --output /path/log.txt <job>
```

Trocando formato de saída do resultado:

```sh
fio --output-format=<type> [--output /path/log.<type>] <job>
```

*OBSERVAÇÕES:*

- O teste será executado no *drive* onde o arquivo de dados está (parâmetro `filename`), ou seja, se não alterar o caminho desse arquivo (com base no exemplo de configuração global), o teste será executado no disco atual (provável `/dev/sda` ou `/dev/nvme0n1`). Se quiser realizar o teste em outro disco interno ou dispositivo *flash*, monte alguma partição desse *drive* e altere o valor do parâmetro `filename` apontando o caminho do arquivo para lá
