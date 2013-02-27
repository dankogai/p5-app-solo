[![build status](https://secure.travis-ci.org/dankogai/p5-app-solo.png)](http:/\
/travis-ci.org/dankogai/p5-app-solo)

p5-app-solo
===========

run only one process up to given timeout

SYNOPSIS
--------

````
solo -t seconds [-P pidfile] [-K signal] cmd ...
````

DESCRIPTION
-----------

This program runs cmd up to the seconds then sends SIGTERM after that.
If it find that cmd is already running, it terminates with the error
message with its PID.

* -t seconds
Sets the timeout in second.  You cannot omit this.

* -P pidfile

The path to the PID file.  By default it is "/var/run/cmd.pid" if you
are root, "/var/tmp/cmd.pid"  otherwise.

* -K signal

This option overrides default signal to be sent on timeout. SIGTERM
by default.

LICENSE AND COPYRIGHT
---------------------

Copyright 2013 Dan Kogai.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

<http://www.perlfoundation.org/artistic_license_2_0>
