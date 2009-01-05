package Gentoo::Package;

use Moose;
use Gentoo::Types;

extends qw( Gentoo::Base );

has 'category' => (
    isa      => 'Gentoo::Category',
    is       => 'rw',
    required => 1,
);

has 'package_name' => (
    isa      => 'Gentoo::Type::PackageAtom',
    is       => 'rw',
    required => 1,
);

1;
