use 5.008001;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'App::solo',
    AUTHOR       => q{Dan Kogai <dankogai+cpan@gmail.com>},
    VERSION_FROM => 'bin/solo',
    # ABSTRACT_FROM    => 'bin/solo',
    ABSTRACT           => 'run only one process up to given timeout',
    LICENSE            => 'Artistic_2_0',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.008001,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    EXE_FILES => ['bin/solo'],
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'App-solo-*' },
);
