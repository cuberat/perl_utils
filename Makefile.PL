#!/usr/bin/env perl

use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
              NAME => 'Owenslib::Prog::Utils',
              DISTNAME => 'Owenslib-Prog-Utils',
              VERSION_FROM => 'lib/Owenslib/Prog/Utils.pm',
              ABSTRACT_FROM => 'lib/Owenslib/Prog/Utils.pm',
              AUTHOR => 'Don Owens <don@regexguy.com>',
              PM => { 'lib/Owenslib/Prog/Utils.pm' => '$(INST_LIBDIR)/Utils.pm' },
              dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz' },
              # DIR => [ ],
              # EXE_FILES => [ ],
              # PREREQ_PM => { },
              clean => { FILES => 'Owenslib-Prog-Utils-*.tar.gz' },
);

