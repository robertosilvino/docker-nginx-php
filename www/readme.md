# Instrução

O diretório **www** deverá conter o código do site PHP em um subdiretório.

Exemplo: ./docker-nginx-php/www/moodle_mooc

## Comandos

Colocar o repositório abaixo do diretório www

``` bash
cd www
git clone git@gitlab.setic.ufsc.br:moodle-ufsc/moodle.git moodle_mooc -b UFSC_33_STABLE-MOOC --recursive 
```

