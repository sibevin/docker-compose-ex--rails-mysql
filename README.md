# docker-compose-ex--rails-mysql
A docker compose example for rails + mysql development

## Prepare

Make sure your docker is running and the network is connected.

## Run `docker-compose up` to setup rails and mysql containers

```
$ docker-compose up
reating network "dockercomposeexrailsmysql_default" with the default driver
Creating dockercomposeexrailsmysql_db_1
Creating dockercomposeexrailsmysql_rails_1
Attaching to dockercomposeexrailsmysql_db_1, dockercomposeexrailsmysql_rails_1
db_1     | Initializing database
db_1     | 2017-03-23T06:21:48.484287Z 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
db_1     | 2017-03-23T06:21:48.496449Z 0 [Warning] Setting lower_case_table_names=2 because file system for /var/lib/mysql/ is case insensitive
db_1     | 2017-03-23T06:21:50.399313Z 0 [Warning] InnoDB: New log files created, LSN=45790
...
db_1     | 2017-03-23T06:22:06.156966Z 0 [Note] Beginning of list of non-natively partitioned tables
db_1     | 2017-03-23T06:22:06.889810Z 0 [Note] End of list of non-natively partitioned tables
db_1     | 2017-03-23T06:22:06.889924Z 0 [Note] mysqld: ready for connections.
db_1     | Version: '5.7.17'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

About mysql container:
1. Two mysql users/databases(rails_dev, rails_test) are created.(See mysql/prepare_rails_db.sql)
2. The mysql port is mapped to 7364:3306.(See docker-compose.yml)
3. The mysql data(/var/lib/mysql) is stored in shared_folder/mysql.(See docker-compose.yml)
4. The mysql root password is defined in mysql/Dockerfile.

About rails container:
1. The nodejs is installed by default in the rails container.(See rails/Dockerfile)
2. The rails server port is mapped to 3333:3000.(See docker-compose.yml)
3. The /app folder is linked to shared_folder/rails.(See docker-compose.yml)

## Connect to mysql from host

When the mysql container is ready, you can connect the mysql database from the host.

```
$ mysql -h0.0.0.0 -P7364 -urails_dev -prails_dev rails_dev
$ mysql -h0.0.0.0 -P7364 -urails_test -prails_test rails_test
```

## Attach to rails container and create a new rails app in it

* Attach to the rails container

```
$ docker attach dockercomposeexrailsmysql_rails_1
root@0b16c6b479d4#
```

* Create a new rails app in /app
```
root@0b16c6b479d4# cd /app
root@0b16c6b479d4:/app# rails new my-app
      create
      create  README.md
      create  Rakefile
      create  config.ru
      create  .gitignore
      create  Gemfile
      create  app
      create  app/assets/config/manifest.js
      create  app/assets/javascripts/application.js
      create  app/assets/javascripts/cable.js
...
Using rails 5.0.2
Using sass-rails 5.0.6
Bundle complete! 15 Gemfile dependencies, 62 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
         run  bundle exec spring binstub --all
* bin/rake: spring inserted
* bin/rails: spring inserted
```

* Edit database.yml from your host

When you create an app in /app, you can edit app files in shared_folder/rails/ from your host. Change the config/database.yml as follows:
```
$ vi shared_folder/rails/my-app/config/database.yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  socket: /tmp/mysql.sock
  host: db
  port: 3306

development:
  <<: *default
  database: rails_dev
  username: rails_dev
  password: rails_dev

test:
  <<: *default
  database: rails_test
  username: rails_test
  password: rails_test
```

* Run bundle install

```
root@0b16c6b479d4:/app/my-app# bundle install
Resolving dependencies...
Using rake 12.0.0
Using concurrent-ruby 1.0.5
Using i18n 0.8.1
Using minitest 5.10.1
...
Using rails 5.0.2
Using sass-rails 5.0.6
Bundle complete! 15 Gemfile dependencies, 62 gems now installed.
Bundled gems are installed into /usr/local/bundle.
```

* Run rails server

```
root@0b16c6b479d4:/app/my-app# rails s -b 0.0.0.0 -p 3000
=> Booting Puma
=> Rails 5.0.2 application starting in development on http://0.0.0.0:3000
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.8.2 (ruby 2.4.0-p0), codename: Sassy Salamander
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

## Connect to rails server from host

When rails server is running, you can connect web page with your browser from the host.

```
http://0.0.0.0:3333
```

## Shutdown all containers

If you use `ctrl-C` to stop `docker-compose up`, two containers are stop but not removed. Use `docker-compose down` to remove them.

```
$ docker-compose down
Removing dockercomposeexrailsmysql_rails_1 ... done
Removing dockercomposeexrailsmysql_db_1 ... done
Removing network dockercomposeexrailsmysql_default
```

