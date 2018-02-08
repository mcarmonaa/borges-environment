# Borges' required services

Here you can find a `docker-compose.yml` file to run those services required by [borges](https://github.com/src-d/borges) so you can get quickly an environment to experiment and test with that tool locally.

Using [docker-compose](https://docs.docker.com/compose/) you can up and run this environment, but there is a `Makefile` that allow you with just a few commands get all the directory structure and run borges easily.

The launched services are:
- Postgres
- RabbitMQ
- HDFS (1 namenode, 1 datanode)

#### Usage

You need to install this [HDFS client](https://github.com/colinmarc/hdfs) written in Go because the `Makefile`uses it to create the directories needed by borges in HDFS.

- Up services:
```
make up
```

- Down an remove images and volumes:
```
make down
```

Volumes directories are created automatically under `./volumes/`  as well as `./tmp` when you use `make up`. If you need remove the volumes probably you will see how you don't have permissions on `./volumes/postgres`because the `postgres` container changes that directory's owner.

Don't worry , `sudo rm -r volumes/` ;)

Running borges requires you placing the borges binary under `./bin/`, and you must have a `repos.list`in the root of the repository where borges reads from.

- Run a borges producer
```
make producer
```

- Run a borges consumer
```
make consumer
```

- Also you can simulate an HDFS "error", it will just stop and restart HDFS:
```
make hdfs-fail
```

All the directories, files and options used are parametrized in the `Makefile` through env-vars, so you can use something like:
```
NUM_WORKERS=20 make consumer
```

Just have a look at the `Makefile`
