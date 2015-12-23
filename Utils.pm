# Copyright (c) 2015 Don Owens <don@regexguy.com>.  All rights reserved.
#
# This software is released under the BSD license:
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#
#  * Neither the name of the author nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
# OF THE POSSIBILITY OF SUCH DAMAGE.

=pod

=head1 NAME

Owenslib::Prog::Utils - General programming utilities.

=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 VERSION

0.01

=cut

use strict;
use warnings;

package Owenslib::Prog::Utils;

use Getopt::Long qw(:config no_ignore_case bundling);

our $VERSION = '0.01';


=pod

=head1 METHODS


=cut

sub new {
    my ($class) = @_;
    my $self = bless {}, ref($class) || $class;
    return $self;
}

sub get_date_local_yesterday {
    my ($self) = @_;

    return $self->get_date_local(time() - 86400);
}

sub get_time_local {
    my ($self, $epoch_secs) = @_;

    my ($sec,$min,$hour,$mday,$mon,$year) = localtime($epoch_secs);
    $year += 1900 if $year < 1900;
    $mon++;

    my $ts = sprintf "%04d-%02d-%02dT%02d:%02d:%02d", $year, $mon,
        $mday, $hour, $min, $sec;

    return $ts;
}

sub get_date_local {
    my ($self, $epoch_secs) = @_;

    my ($sec,$min,$hour,$mday,$mon,$year) = localtime($epoch_secs);
    $year += 1900 if $year < 1900;
    $mon++;

    my $ts = sprintf "%04d-%02d-%02d", $year, $mon, $mday;

    return $ts;

}

sub get_time_utc {
    my ($self, $epoch_secs) = @_;

    my ($sec,$min,$hour,$mday,$mon,$year) = gmtime($epoch_secs);
    $year += 1900 if $year < 1900;
    $mon++;

    my $ts = sprintf "%04d-%02d-%02dT%02d:%02d:%02d", $year, $mon,
        $mday, $hour, $min, $sec;

    return $ts;
}

sub get_date_utc {
    my ($self, $epoch_secs) = @_;

    my ($sec,$min,$hour,$mday,$mon,$year) = gmtime($epoch_secs);
    $year += 1900 if $year < 1900;
    $mon++;

    my $ts = sprintf "%04d-%02d-%02d", $year, $mon, $mday;

    return $ts;
}

sub setup_logging {
    my ($self, $opts, $log_level_str) = @_;

    $log_level_str = 'info' unless defined $log_level_str;

    my $caller = caller();

    my $quiet = $opts->{quiet};
    (my $prog = $0) =~ s{^.*/([^/]+)$}{$1};

    $self->{log_level_map} = { emerg => 10,
                               alert => 20,
                               crit => 30,
                               err => 40,
                               warn => 50,
                               notice => 60,
                               info => 70,
                               debug => 80,
                             };
    $self->{log_level_map_num_to_str} = { reverse %{$self->{log_level_map}} };

    my $log_fh;
    $self->{log_level_str} = lc($log_level_str);
    my $log_level_num;
    if (defined $log_level_str) {
        $log_level_num = $self->{log_level_map}->{lc($log_level_str)};
        unless (defined $log_level_num) {
            die "bad log level '$log_level_str' in setup_logging()";
        }
        $self->{log_level} = $log_level_num;
    }

    if ($opts->{log}) {
        if ($opts->{log} eq '*STDERR') {
            $log_fh = *STDERR;
        }
        elsif ($opts->{log} eq '*STDOUT') {
            $log_fh = *STDOUT;
        }
        else {
            open($log_fh, '>>', $opts->{log})
                or die "couldn't open log file '$opts->{log}' for output";
        }
        select((select($log_fh), $| = 1)[0]);

        $self->{log_fh} = $log_fh;
    }

    my $out_log = sub {
        my ($level_str, $fmt, @rest) = @_;
        return 0 unless $log_fh;

        unless ($self->{log_level_map}{$level_str} <= $self->{log_level}) {
            return 0;
        }

        my ($sec,$min,$hour,$mday,$mon,$year) = localtime();
        $year += 1900 if $year < 1900;
        $mon++;

        # my $ts = sprintf "%04d-%02d-%02dT%02d:%02d:%02d", $year, $mon,
        #     $mday, $hour, $min, $sec;
        my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $year, $mon,
            $mday, $hour, $min, $sec;

        printf $log_fh "$ts $prog" . "[$$]: " . $fmt . "\n", @rest;
    };

    my $out_log_info = sub {
        my ($fmt, @rest) = @_;
        return $out_log->('info', $fmt, @rest);
    };

    $self->{out_log} = $out_log;

    no strict 'refs';
    # *{$caller . "::msg"} = $msg;
    *{$caller . "::out_log"} = $out_log_info;
}

sub log_debug {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('debug', $fmt, @args);
}

sub log_info {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('info', $fmt, @args);
}

sub log_notice {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('notice', $fmt, @args);
}

sub log_warning {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('warning', $fmt, @args);
}

sub log_err {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('err', $fmt, @args);
}

sub log_crit {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('crit', $fmt, @args);
}

sub log_alert {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('alert', $fmt, @args);
}

sub log_emerg {
    my ($self, $fmt, @args) = @_;

    return $self->{out_log}->('emerg', $fmt, @args);
}


########## begin option processing ##########

sub print_opts_usage {
    my ($self) = @_;

    my @dpy;

    my $max_left = 0;
    foreach my $s (@{$self->{opts_data}}) {
        my $old_spec = $s->{old_spec};
        my $name = $s->{name};
        unless (defined $name) {
            ($name) = split /\|/, $old_spec;
        }

        my $meta;
        if ($old_spec =~ /=/) {
            unless (defined ($meta = $s->{meta})) {
                $meta = $name;
            }
        }

        my $left = (length($name) > 1 ? '--' : '-') . $name;
        if (defined $meta) {
            $left .= sprintf '=<%s>', $meta;
        }

        my $right = $s->{help};
        $right = '' unless defined $right;
        my $len = length($left);

        if ($len > 35) {
            $right = "\n" . $right;
        }
        else {
            $max_left = $len if $len > $max_left;
        }
        push @dpy, [ $left, $right ];
    }

    print STDERR qq{\nUsage: @{[ ($0 =~ m{\A.*/([^/]+)\Z})[0] || $0 ]} options

    Options:
\n};

    my $pad = $max_left + 1;
    my $left_pad_cnt = 4;
    my $left_pad = ' ' x $left_pad_cnt;

    my $avail = 78 - $pad - $left_pad_cnt;
    foreach my $d (@dpy) {
        my $left = $d->[0];
        my $right = $d->[1];
        my $len = length($right);

        my $print;
        while (1) {
            if ($len < $avail) {
                $print = $right;
                $right = '';
            }
            else {
                $print = substr($right, 0, $avail);
                $right = substr($right, $avail);
            }
            printf STDERR "$left_pad%-${pad}s # %s\n", $left, $print;
            $left = '';
            $len = length($right);

            last if $len == 0;
        }
    }

    print STDERR "\n";
}

sub check_options {
    my ($self, $opts, $required, $params) = @_;

    if (not $opts or $opts->{help}) {
        if ($params->{exit_on_bad}) {
            $self->print_usage;
            exit 1;
        }
        else {
            return undef;
        }
    }

    my $opt_ok = 1;
    $required = [ ] unless $required;
    foreach my $key (@$required) {
        if (defined($opts->{$key})) {
            if (my $v = $opts->{$key}) {
                if (my $ref = ref($v)) {
                    if ($ref eq 'ARRAY' ) {
                        unless (@$v) {
                            $opt_ok = 0;
                            warn "missing required option '$key'
";
                        }
                    }
                }
            }
        }
        else {
            $opt_ok = 0;
            warn "missing required option '$key'\n";
        }
    }

    unless ($opt_ok) {
        if ($params->{exit_on_bad}) {
            $self->print_usage;
            exit 1;
        }
    }

    return $opt_ok;
}

sub get_options {
    my ($self, $spec, $defaults, $required, $params) = @_;

    my @new_spec;
    my @new_data;
    foreach my $e (@$spec) {
        my $meta;
        my $old_spec;
        my $data = { };
        if (UNIVERSAL::isa($e, 'ARRAY')) {
            $old_spec = $e->[0];
            %$data = @$e[1..$#$e];
        }
        else {
            $old_spec = $e;
        }
        my ($first, $rest) = split /\|/, $old_spec;
        if ($old_spec =~ /=/ and not defined $data->{meta}) {
            $data->{meta} = $first;
        }

        $data->{old_spec} = $old_spec;

        push @new_spec, $old_spec;
        push @new_data, $data;
    }

    $self->{opts_data} = \@new_data;

    return $self->get_options2(\@new_spec);
}

sub get_options2 {
    my ($self, $spec, $defaults, $required, $params) = @_;
    $required = [ ] unless defined $required;
    $params = { } unless defined $params;

    my $opts = $self->_get_options($spec, $defaults);

    $self->check_options($opts, $required, $params);

    $self->{opts} = $opts;

    return $opts;
}

sub _get_options {
    my ($self, $spec, $defaults) = @_;
    my %opts = $defaults ? %$defaults : ();
    $spec = [ ] unless $spec;

    my $process_opt = sub {
        my ($key, $val) = @_;

        if (scalar(@_) > 2) {
            $opts{$key}{$val} = $_[2];
        }
        else {
            if ( exists($opts{$key}) and (my $v = $opts{$key}) ) {
                if (my $ref = ref($v)) {
                    if ($ref eq 'ARRAY' ) {
                        push @{ $opts{$key} }, $val;
                        return 1;
                    }
                }
            }

            $opts{$key} = $val;
        }
    };

    my $opt_rv = Getopt::Long::GetOptions(map { ($_ => $process_opt) } @$spec);

    return $opt_rv ? \%opts : undef;
}
########## end option processing ##########


=pod

=head1 EXAMPLES


=head1 DEPENDENCIES


=head1 AUTHOR

Don Owens <don@regexguy.com>

=head1 SEE ALSO


=cut

1;

# Local Variables: #
# mode: perl #
# tab-width: 4 #
# indent-tabs-mode: nil #
# cperl-indent-level: 4 #
# perl-indent-level: 4 #
# End: #
# vim:set ai si et sta ts=4 sw=4 sts=4:
