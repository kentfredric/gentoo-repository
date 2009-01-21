#!/usr/bin/perl 

use strict;
use warnings;
use version; our $VERSION = qv('0.1');

use Iterator::Util;
use Iterator;
use Data::Dumper;

use lib '../lib';

use Gentoo::Repository;

my $repository = Gentoo::Repository->new( directory => '/usr/portage/' );
my $categories = $repository->categories( filter => sub {   $_->{short} eq 'dev-perl'  });
my $packages   = Iterator->new(sub{ Iterator::is_done(); });

while( $categories->isnt_exhausted()){
    $packages  = iappend( $packages, $categories->value->packages() );
}

while( $packages->isnt_exhausted() ){
    print $packages->value()->package_atom(), "\n";
}
