#!/usr/bin/perl 

use strict;
use warnings;
use version; our $VERSION = qv('0.1');

use lib '../lib';

use Gentoo::Repository;

my $x = Gentoo::Repository->new( directory => '/usr/portage/' );

my @categories = $x->categories(
    filter => sub {
        $_ ne 'dev-perl';
    }
)->all;

for (@categories) {
    print $_->packages->all(
        sub {
            $_->yaml;
        }
    );
}
