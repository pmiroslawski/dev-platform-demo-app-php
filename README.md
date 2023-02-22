# Dockerized demo app 



This repository contains a demo PHP app and can be a working example of the app which uses [`Dev Platform`](https://github.com/pmiroslawski/dev-platform) as the base stack.

Read the description of [documentation](https://github.com/pmiroslawski/dev-platform) to see what a `Dev Platform` is and how to run it.

This example contains just two containers:
- php-fpm
- nginx

Nginx serves websites on the default port, without any virtual host. `Dev Platform` has installed proxy which will server this website on the port 80/443 on your host machine

## Installation

- Make sure Docker is installed on your machine.
- Make sure you installed and configured [Dev Platform](https://github.com/pmiroslawski/dev-platform), see the section [Installation](https://github.com/pmiroslawski/dev-platform#installation) to make sure that everything works as expected.
- Download the newest version of this repository.
- Configure .env file - make sure all required vars are the same like in `Dev Platform` and do your custom setup for your application 
- run command docker-compose up -d

When both containers started successfully you should add required users/configuration in existing `Dev Platforms` services. To do that run

```bash
cd _docker
./init.sh
```


Default configuration also contains in `public` dir extra files which can confirm that everything works as expected. To do that open in your browser 
```
http://$ADDR_IP_DEMO_NGINX/
```
Where value of $ADDR_IP_DEMO_NGINX you can find in `.env` file. As default it's a `10.56.1.60`

## Configuration

Feel free to change `docker-compose.yaml` to add an extra container and use `.env` to configure your setup. Remember to add extra code for `init.sh` to make it more useful for your needs.
