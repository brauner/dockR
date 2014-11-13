dockR
===============

`Docker` images for `R` based on the official `Ubuntu` minimal build.  The
images have `R` set as their default entrypoint. Hence, they behave like
`R` binaries.

### Some properties

* All images are available as automated builds from `Docker Hub`. You can
  just pull them with `docker pull brauner/r-patched`
  and `docker pull brauner/r-devel`.
* The generic `R` images which reside in the `r-patched` and `r-devel`
  folders are compiled without setting the `march` flag. This will make
  them run on any system. To see how to adapt the image to a specific
  `architecture` by setting the `march` flag take a look at the
  `Dockerfiles` which reside in the folders which have `ivy`
  appended to them. There you can also see how to enable `3D` support and
  various other tweaks.
* Set up `user` so that the container does not need to run as root.
* Set up `/home` for `user` and a default repository in `.Rprofile`.
* Install all recommended `R` dependencies, pull `R-patched` or `R-devel`
  from `SVN` and compile `R-patched` or `R-devel` from source.
* The `R` binaries reside in `/usr/local/bin/R`.

### Workflow & R Library and Package Management
If you mainly run `R` as an ephemeral interactive container and install
new packages you will need to commit the newly created layer to your image
before you quit in order to have the packages you install available via
`library()` when you start the container again. To circumvent this I
suggest sharing volumes between your `R` containers in the following
manner:

* Create an extremely tiny container from the `busybox` image exposing two
  folders `R` and `R-dev` (for `devtools` afficionados) with the right
  permissions which you share via the `--volumes-from=DATACONTAINERNAME`
  flag among you `R` containers. You will find the `Dockerfile` for this
  in the folder `rlib` and the image on `Docker Hub`. You can pull it
  with `docker pull brauner/rlib`.
* Run `docker run --name=RDATA DATACONTAINERNAME true`
* Run `docker run --volumes-from = RDATA RCONTAINERNAME`

Now you can install packages into `RDATA` without having to commit the
container as data containers are handled differently by Docker. If you
pull a new `R` image you can just keep running it with your libraries
still intact. Should a new `R` version come out that requires upgrading
all libraries you can just remove your `RDATA` container which will also
remove all installed packages and start a new one.

* If you still want to install a package ephemerally which gets deleted
  when your `R` container exits. You can use `devtools` `dev_mode()`
  function to specify a new library path: `library(devtools); dev_mode(,
  path = "~/your/path/to/new/library/here")` or edit `.libPaths()`
  directly.

### Graphical Output from Docker Containers
There is a nice and semi-easy way of getting graphical output from a
Docker container without having to run an sshd daemon inside of the
container. Docker can provide bare metal performance when running a single
process which in this case is supposed to be R. Running an sshd daemon
will, marginal as it may be, introduce additional overhead. This is not
made better by running the sshd daemon as a child process of the
supervisor daemon. Both can be dispensed with when one makes good use of
bind mounts. After building the image from which the container is supposed
to be run we start an interactive container and bind mount the
`/tmp/.X11-unix` folder into it. I will state the complete command and
explain in detail what it does:

```
docker run -i -t --rm \
# -i sets up an interactive session; -t allocates a pseudo tty; --rm makes
# this container ephemeral
-e DISPLAY=$DISPLAY \
# sets the host display to the local machines display (which will usually
# be :0)
-u chbr \
# -u specify the process should be run by a user (here "chbr") and not by
# root. This step is important (v.i.)!
-v /tmp/.X11-unix:/tmp/.X11-unix \
# - v bind mounts the `X11` socket `/tmp/.X11-unix` into `/tmp/.X11-unix`
# in the container.
--name="rdev" ubuntu-r1 R
# --name="" specify the name of the container (here "rdev"); the image you
# want to run the container from (here "ubuntu-r"); the process you want
# to run in the container (here "R"). Note that the process for this image
(here "R") can be left unspecified as the program is the default
entrypoint of the image.
```

After issuing this command you should be looking at the beautiful `R`
start output. If you were to try `demo(graphics)` to see if graphical
output is already working you would note that it is not. That is because
of the `Xsecurity` extension preventing you from accessing the socket. You
could now type `xhost +` on your local machine and try `demo(graphics)` in
your container again. You should now have graphical output. This method
however, is strongly discouraged as you allow access to your xsocket to
any remote host you're currently connected to. As long as you're only
interacting with single-user systems this might be somehow justifiable but
as soon as there are multiple users involved this will be absolutely
unsafe! Hence, you should use a less dangerous method. A good way is to
use the server interpreted `xhost +si:localuser:username` which can be
used to specify a single local user (see `man xhost`). This means
`username` should be the name of the user which runs the `X11` server on
your local machine and which runs the `Docker` container. This is also the
reason why it is important that you specify a user when running your
container. Last but not least there is always the more complex solution of
using `xauth` and `.Xauthority` files to grant access to the `X11` socket
(see `man xauth`). This however will also involve a little more knowledge
how `X` works.

### Entering a running container with `docker exec`
As of release `1.3.` the recommended way of entering a running container
is by using `docker exec -it rdev bash` (`rdev` is the name of the running
container  and `bash` the program which is supposed to be run in the
container in this example.) which will spawn a new process in the running
container.

### Entering a running container with `nsenter`

Should you need to enter a running container with a new `tty` you can also
use nsenter. First find the `PID` of the (main) process running in the
container by either issuing `docker top containername` or `docker inspect
--format {{.State.Pid}} containername`. Then use `nsenter` which should
usually be installed on your system. If not install it. It can be found
`util-linux` (version must be at least `2.23`). You can use the command
`nsenter --target PID-you-just-found-out --mount --ipc --net --pid` or the
short version `nsenter -t PID-you-just-found-out -m -i -n -p`.

