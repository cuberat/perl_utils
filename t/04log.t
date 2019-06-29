#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Owenslib::Prog::Utils;

sub out_log;

# main
{
    my $utils = Owenslib::Prog::Utils->new;
    my $num_tests = 0;
    my $log_out_str = "";
    open(my $log_fh, ">", \$log_out_str);

    $utils->setup_logging({ log => $log_fh, log_src => 1, log_norm_ts => 1,
        log_micro_ts => 1,
        # log_no_prog => 1,
        });

    out_log "testing %s", "foo";

    close $log_fh;

    ok($log_out_str =~ /testing foo$/, "log output looks right"); $num_tests++;
    ok($log_out_str =~ /\n$/, "ends with newline"); $num_tests++;

    # diag "log out: " . $log_out_str;

    done_testing($num_tests);

}

exit 0;

###############################################################################
# Subroutines
