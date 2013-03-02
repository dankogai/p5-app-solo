#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 8;

sub slurp {
    my $fn = shift;
    open my $fh, '<', $fn or die "$fn:$!";
    my $data = <$fh>;
    close $fh;
    $data;
}

$ENV{PATH} = '/bin:/usr/bin';
local $/;
my $outfile = "t/$$";

my $err = system qq{./bin/solo -t 0.1 sleep 1 > $outfile 2>&1};
ok $err, "exit status = $err";
isnt -s $outfile, 0, "timeout: message";
$err = system qq{./bin/solo -t 0.1 sleep 1 > $outfile 2>&1};
ok $err, "exit status = $err";
isnt -s $outfile, 0, "timeout: message";
$err = system qq{./bin/solo -f -t 2 sleep 1 > $outfile 2>&1};
ok !$err, "-f: exit status = $err";
is -s $outfile, 0,  "-f: No Message";
$err = system qq{./bin/solo -f -t 2 __no_such_command__ > $outfile 2>&1};
ok !$err, "nonexistent: exit status = $err";
isnt -s $outfile, 0, "nonexistent: message";
unlink $outfile;
