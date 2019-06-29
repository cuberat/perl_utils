#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Owenslib::Prog::Utils;

# main
{
    my $utils = Owenslib::Prog::Utils->new;
    my $num_tests = 0;
    my $ln;

    my ($file_path, $line_number) = $utils->get_file_line_num; $ln = __LINE__;

    # diag "file_path=$file_path, line=$line_number";

    ok(defined($file_path), "file_path defined"); $num_tests++;
    ok(defined($line_number), "line_number defined"); $num_tests++;
    ok($file_path =~ m{\b03line_number\.t}, "file_path ending"); $num_tests++;
    ok($line_number == $ln, "correct line number"); $num_tests++;

    my $filename;
    ($filename, $line_number) = $utils->get_filename_line_num; $ln = __LINE__;

    # diag "filename=$filename, line=$line_number";
    ok(defined($filename), "filename defined"); $num_tests++;
    ok(defined($line_number), "line_number defined (2)"); $num_tests++;
    ok($filename eq "03line_number.t", "correct filename"); $num_tests++;
    ok($line_number == $ln, "correct line number (2)"); $num_tests++;

    done_testing($num_tests);

}

exit 0;

###############################################################################
# Subroutines
