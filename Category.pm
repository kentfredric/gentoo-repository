package Gentoo::Category;

use Moose;
use Moose::Util::TypeConstraints;

extends qw( Gentoo::Base );
#use Scalar::Util qw/refaddr/;

subtype 'CategoryAtom' => ( 
    as 'Str',
    where { $_ =~ /^[-a-z0-9]+$/ },
    message { 
        "$_ is not a valid Category Atom."
    },
);

has 'repository' => ( 
    isa => 'Gentoo::Repository',
    is  => 'rw',
    required => 1,
);

has 'category_name' => ( 
    isa => 'CategoryAtom',
    is  => 'rw',
    required => 1,
    coerce => 1,
);

1;