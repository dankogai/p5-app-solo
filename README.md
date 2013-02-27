[![build status](https://secure.travis-ci.org/dankogai/p5-app-solo.png)](http://travis-ci.org/dankogai/p5-app-solo)

p5-app-solo
===========

run only one process up to given timeout

SYNOPSIS
--------

````
solo [-t seconds] [-P pidfile] [-K signal] cmd ...
````

DESCRIPTION
-----------

This program runs *cmd* up to the seconds then sends SIGTERM after that.

If *cmd* is already running, it terminates with the error message with
its PID.

If the previous session exited abnormally (exit code != 0, including
timeout), it terminates with the errar message with how the last sesion
ended.

    -f
      Force execution even if the last session ended abnormally. Note "solo"
      still refuse to execute the command if another session is in progress.

    -t seconds
      Sets the timeout in second. When ommited, 86400 (= 1d) is used.
      Fractional seconds accepted thanks to Time::HiRes.

    -P pidfile
      The path to the PID file. By default it is "/var/run/*cmd*.pid" if you
      are root, "/var/tmp/*cmd*.pid" otherwise.

    -K signal
      This option overrides default signal to be sent on timeout. SIGTERM by
      default.

EXAMPLE
-------

````
% cat sleep.pl
#!/usr/bin/env perl
use strict;
use warnings;
my $seconds = shift || 1;
while ($seconds > 0) {
    print $seconds--, "\n";
    sleep 1;
}    
% ./sleep.pl 3
3
2
1
% solo -t 2 ./sleep.pl 3
3
2
./sleep.pl: Operation timed out
% solo -t 2 ./sleep.pl 3
./sleep.pl: Last session ended abnormally: Operation timed out (60).
% solo -f -t 4 ./sleep.pl 3
3
2
1
% solo ./sleep.pl 3
3
2
1
````

LICENSE AND COPYRIGHT
---------------------

Copyright 2013 Dan Kogai.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

<http://www.perlfoundation.org/artistic_license_2_0>
