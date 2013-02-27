#!/usr/bin/env perl

=head1 NAME

solo - run only one process up to given timeout.

=head1 VERSION

$Id: solo.pl,v 0.1 2013/02/27 10:14:48 dankogai Exp dankogai $

=head1 SYNOPSIS

  solo -t seconds [-P pidfile] [-K signal] cmd ...

=head1 DESCRIPTION

This program runs I<cmd> up to the seconds then sends SIGTERM after
that.  If it find that I<cmd> is already running, it terminates with
the error message with its PID.

=over 2

=item -t seconds

Sets the timeout in second.  You cannot omit this.

=item -P pidfile

The path to the PID file.  By default it is
C<< /var/run/I<cmd>.pid >> if you are root,
C<< /var/tmp/I<cmd>.pid >>  otherwise.

=item -K signal

This option overrides default signal to be sent on timeout. SIGTERM by
default.

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Dan Kogai.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

=cut

use strict;
use warnings;
use Time::HiRes qw/alarm/;
use Getopt::Std;
use Errno qw/:POSIX/;
use File::Basename qw/basename/;
use File::Spec qw/catfile/;
use POSIX qw/:sys_wait_h strerror/;

our $VERSION = sprintf "%d.%02d", q$Revision: 0.1 $ =~ /(\d+)/g;

use constant DEBUG => 0;

sub usage { exec 'pod2text', $0 }

getopts ':t:K:P' => \my %opt;
my $timeout = 0 + $opt{t} or usage();
my $cmd = shift;
if ( !-x $cmd ) {
    my $which = qx/which $cmd/;
    chomp $which;
    die "$cmd: Command not found.\n" unless $which;
    $cmd = $which;
}
my $pidfile = $opt{P} || do {
    my $dir = $> ? '/var/tmp' : '/var/run';
    File::Spec->catfile( $dir, basename($cmd) . '.pid' );
};

sub getcpid {
    open my $fh, '<', $pidfile or die "$pidfile:$!";
    my $pid = <$fh>;
    close $fh;
    return 0 + $pid;
}

die "$cmd: already running (", getcpid(), ").\n" if -f $pidfile;

my $ksig = $opt{K} || 'TERM';
open my $pidfh, '>', $pidfile or die "$pidfile:$!";
my $cpid;

sub cleanup {
    my $code = shift || 0;
    warn $code if DEBUG;
    $code = 0 if $code =~ /^[A-Z]+$/;    # via signal handler
    kill $ksig => getcpid();
    unlink $pidfile;
    warn "$cmd: ", strerror($code), "\n" if $code;
    exit $code;
}

$SIG{INT} = $SIG{TERM} = \&cleanup;

eval {
    local $SIG{ALRM} = sub { die ETIMEDOUT, "\n" };
    alarm $timeout;
    $cpid = fork();
    die $! unless defined $cpid;
    if ($cpid) {
        print {$pidfh} $cpid, "\n";
        close $pidfh;
        wait;
    }
    else {
        exec $cmd, @ARGV;
    }
    alarm 0;
};
cleanup($@);

1;
__END__
