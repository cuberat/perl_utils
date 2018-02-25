#!/usr/bin/env perl

use strict;
use warnings;

use File::Temp;

use Test::More;

use Owenslib::Prog::Utils;

{ # main

    my $utils = Owenslib::Prog::Utils->new;

    my $num_tests = 4;
    my @suffixes = ('.gz');
    if ($utils->get_bzip) {
        push @suffixes, '.bz2';
        $num_tests += 2;
    }
    if ($utils->get_xz) {
        push @suffixes, '.xz';
        $num_tests += 2;
    }

    my $this_source = __FILE__;
    (my $this_dir = $this_source) =~ s{^(.*)/[^/]+$}{$1};

    # diag("source='$this_source', dir='$this_dir'");

    my $test_str = qq{Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
};

    my $test_in = sprintf "%s/data/test_decompress.txt.gz", $this_dir;
    my $in_fh = $utils->open_file_ro($test_in);

    ok($in_fh, "open compressed file");
    my $content = '';
    my $buf;
    while (read($in_fh, $buf, 8192)) {
        $content .= $buf;
    }
    close $in_fh;

    ok($content eq $test_str, "decompressed file");

    test_compress($utils, $test_str, \@suffixes);
        
    done_testing($num_tests);
}

sub test_compress {
    my ($utils, $test_str, $suffixes) = @_;

    foreach my $suffix (@$suffixes) {
        my $temp_fh = File::Temp->new(UNLINK => 1, SUFFIX => $suffix);
        my $temp_file = $temp_fh->filename;

        my $compress_file = $temp_file;
        # diag("compressed file is $compress_file");
        my $out_fh = $utils->open_file_w($compress_file);

        ok($out_fh, 'open file for compression');

        print $out_fh $test_str;
        close $out_fh;

        my $in_fh = $utils->open_file_ro($compress_file);
        my $content = '';
        my $buf;
        while (read($in_fh, $buf, 8192)) {
            $content .= $buf;
        }
        close $in_fh;

        ok($content eq $test_str, "compressed file correct");
    }
}
