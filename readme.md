# Docker: Ubuntu, Nginx and PHP Stack

This is the basis for LEMP stack (minus MySQL). This is based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) base Ubuntu image, which takes care of system issues which Docker's base Ubuntu image does not take care of, such as watching processes, logrotate, ssh server, cron and syslog-ng.

You can build this yourself after cloning the project (assuming you have Docker installed).

```bash
cd /path/to/repo/docker-nginx-php
docker build -t webapp . # Build a Docker image named "webapp" from this location "."
# wait for it to build...

# Run the docker container
docker run -v /path/to/local/web/files:/var/www:rw -p 80:80 -d webapp /sbin/my_init --enable-insecure-key
```

This will bind local port 80 to the container's port 80. This means you should be able to go to "localhost" in your browser (or the IP address of your virtual machine oh which Docker is running) and see your web application files.

* `docker run` - starts a new docker container
* `-v /path/to/local/web/files:/var/www:rw` - Bind a local directory to a directory in the container for file sharing. `rw` makes it "read-write", so the container can write to the directory.
* `-p 80:80` - Binds the local port 80 to the container's port 80, so local web requests are handled by the docker.
* `-d webapp` - Use the image tagged "webapp"
* `/sbin/my_init` - Run the init scripts used to kick off long-running processes and other bootstrapping, as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker)
* `--enable-insecure-key` - Enable a generated SSL key so you can SSH into the container, again as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker). Generate your own SSH key for production use.
* If you use this with [fideloper/docker-mysql](https://github.com/fideloper/docker-mysql), then [link this container](http://docs.docker.io/en/latest/use/working_with_links_names/) with MySQL's (after running the MySQL container first) via `-link mysql:db`


## Instruções

O arquivo Dockerfile deverá ser usado para montar a imagem Docker.

Estrutura:

* `build` - Arquivos usados para a montagem e inicialização da imagem
* `conf` - Arquivo de configuração do nginx, para os vhosts
* `install` - Scripts para inicialização e execução da imagem
* `loca-conf` - Exemplo de arquivo local para conf do nginx 
* `moodledata` - Diretório reservado para os dados do Moodledata
* `www` - Diretório reservado para os dados do repositório do site

Nos capítulos a seguir os passos que serão usados na geração e execução
da imagem PHP serão detalhados.

Diversos scripts foram criados para facilitar a execução destes passos.

### 1 - Montar a imagem

Para criar uma máquina virtual, uma imagem contendo os dados desejados 
deve ser criada.

As instruções para a geração da imagem estão no arquivo **Dockerfile**, 
que serão utilizadas no script **build.sh** 

Executar:

```bash
./build.sh
```

Após a execução deste script uma imagem chamda **docker-php56-nginx** 
estará disponível.

Para checar a existência da imagem o comando abaixo podeser utilizado:

```bash
sudo docker images
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
docker-php56-nginx      latest              c0253e257acc        4 days ago          619MB
...
```

### 2 - Alterar dns (/etc/hosts) local

Para que a autenticação centralizada possa ser acessada o site local 
deve terminar com "*.moodle.ufsc.br"

Para que isso possa ocorrer deve-se redirecionar o acesso deste site
para o endereco IP da máquina local do usuário, alterando o arquivo 
/etc/hosts e adicionado a linha abaixo:

```bash
150.162.999.999   local-mooc.moodle.ufsc.br
```

### 3 - Criar o vhost na máquina local

Deve-se criar uma entrada na configuração de virtual host no nginx.

Esta configuração possui um exemplo na base deste projeto, que está 
localizada no arquivo ./local-conf/mooc.conf
  
Para um novo site moodle o arquivo pase pode ser alterado ou copiado 
para outro nome e editado para as necessidades do novo site.
  
Os comandos para colocar este arquivo exemplo na máquina local são 
descritos a seguir:
  
```bash
sudo cp local-conf/mooc.conf /etc/nginx/sites-available/.
cd /etc/nginx/sites-enabled
sudo ln -s /etc/nginx/sites-available/mooc.conf .
sudo service nginx restart
```

### 4 - Levantar imagem php

O passo final será executar o comando para a imagem contendo a versão
desejada do PHP com os sites pré-configurados.

Para colocar no ar a imagem um script deve ser executado, conforme os 
camandos a seguir:

```bash
cd install
./run.image.sh
./bash.image.sh (para acessar o shell da imagem em execução)
```

