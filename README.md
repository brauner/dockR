docker-ubuntu-r
===============

Ubuntu image intended for dockerized R development.

### Some properties:

* Sets up `user` (with sudo rights) so that the container does not need to
  run as root.
* Sets up `/home` for `user` and some basic options in `.Rprofile` and
  `.bashrc` which should be changed to your own needs.
* Installs all recommended `R` dependencies, pulls `R-devel` from `SVN` and
  compiles `R-devel` from source.
* Runs `ssh` daemon inside (mainly for `X11`-forwarding)

Small how-to-`ssh`-into-docker-container:

1. Build docker image from `Dockerfile`: 
   * `sudo docker build -t ubuntu-r Dockerfile`.
   
   The parameter `-t` allows to specify the name of the resulting image.
   In this case `ubuntu-r`.

2. Run container from image as daemon:
   * `docker run -d -P --name="ssd" ubuntu-r`
   
   The parameter `-d` makes the resulting container run as a daemon;
   parameter `-P` publishes all exposed ports to the host system; `--name`
   allows to specify a name for the resulting container and is followed by
   the name of the image from which it will be created (`--name` in our
   case is `ssd` and the image it is run from is `ubuntu-r` which we just
   created before).

3. Find `ip` and `port` of container: One option is to use
   * `docker inspect ssd`.
   It will give you all low-level information about your container
   including `ip` and the `port` to which the standard port `22` is mapped
   on the host. (This is done so that you can have multiple containers
   running each with a different port.)

4. Actually `ssh` into your container as `user` (`root`-login is not
   allowed!):
   * `ssh -X yourusername@ip-adress-you-found-out -p
   port-number-you-found-out`

   e. g.

   * `ssh -X chbr@172.17.0.80 -p 49154`.

   The `-X` flag sets up `X11`-forwarding (So that you can see plots and
   pdfs and so on.).
