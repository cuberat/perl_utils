#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;

use Owenslib::Prog::Utils;

# main
{
    my $utils = Owenslib::Prog::Utils->new; ok(1, "obj creation");
    
    my $conf_str = qq{stuff=3

[db]
foo.bar=stuff
more=1
stuff=2
};

    my $out_str = '';
    open(my $in_fh, '<', \$conf_str)
        or die "couldn't create filehandle for string";

    my $conf_data = $utils->get_conf($in_fh);
    close $in_fh;

    $out_str = $conf_data->{'db.more'};

    is($out_str, '1', "simple check");

    $out_str = $conf_data->{'db.foo.bar'};

    is($out_str, 'stuff', "deeper level");

    $out_str = $conf_data->{'global.stuff'};

    is($out_str, '3', "global level");

    undef $in_fh;
    open($in_fh, '<', \$conf_str)
        or die "couldn't create filehandle for string";

    $utils->setup_conf("test", $in_fh);

    close $in_fh;

    $out_str = $utils->get_conf_val("test", 'db.more');

    is($out_str, '1', "simple check");

    $out_str = $utils->get_conf_val("test", 'db.foo.bar');

    is($out_str, 'stuff', "deeper level");

    $out_str = $utils->get_conf_val("test", 'global.stuff') ;

    is($out_str, '3', "global level");


    exit 0;
}
