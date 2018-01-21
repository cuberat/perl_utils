#!/usr/bin/env perl

use strict;
use warnings;
use ExtUtils::MakeMaker;

sub MY::postamble {
    my ($self) = @_;

    my $out = '';

    my $which;
    foreach my $path ('/usr/bin/which', '/bin/which', '/usr/local/bin/which') {
        if (-x $path) {
            $which = $path;
            last;
        }
    }

    if (defined $which) {
        chomp(my $pod2markdown = `$which pod2markdown`);
        unless ($?) {
            # found it
            # my @cmd = ($pod2markdown, '$(TO_INST_PM)', 'README.md');
            $out .= "readme:\n\t$pod2markdown \$(TO_INST_PM) README.md\n\n";
            $out .= "all:: \$(TO_INST_PM)\n\t$pod2markdown \$(TO_INST_PM) README.md\n\n";
        }
    }

    return $out;
}

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

