# Dropbox in Docker

Forked by [janeczku/dropbox](https://github.com/janeczku/docker-dropbox).

## Differences against the original repo

* Based on debian:buster
* no update available, DBOX_SKIP_UPDATE removed
* LAN broadcasting port not exposed

This repository provides the [paolodenti/dropbox](https://registry.hub.docker.com/u/paolodenti/dropbox/) image.

## Usage examples

### Quickstart

    docker run -d --restart=always --name=dropbox paolodenti/dropbox

### Dropbox data mounted to local folder on the host

    docker run -d --restart=always --name=dropbox \
    -v /path/to/localfolder:/dbox/Dropbox \
    paolodenti/dropbox

### Run dropbox with custom user/group id

This fixes file permission errrors that might occur when mounting the Dropbox file folder (`/dbox/Dropbox`) from the host or a Docker container volume. You need to set `DBOX_UID`/`DBOX_GID` to the user id and group id of whoever owns these files on the host or in the other container.

    docker run -d --restart=always --name=dropbox \
    -e DBOX_UID=110 \
    -e DBOX_GID=200 \
    paolodenti/dropbox

## Linking to Dropbox account after first start

Check the logs of the container to get URL to authenticate with your Dropbox account.

    docker logs dropbox

Copy and paste the URL in a browser and login to your Dropbox account to associate.

    docker logs dropbox

You should see something like this:

> "This computer is now linked to Dropbox. Welcome xxxx"

## Manage exclusions and check sync status

    docker exec -t -i dropbox dropbox help

## ENV variables

**DBOX_UID**  
Default: `1000`  
Run Dropbox with a custom user id (matching the owner of the mounted files)

**DBOX_GID**  
Default: `1000`  
Run Dropbox with a custom group id (matching the group of the mounted files)

## Exposed volumes

`/dbox/Dropbox`
Dropbox files
