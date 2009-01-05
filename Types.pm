package Gentoo::Types;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'Gentoo::Type::Directory' => (
    as 'Str',
    where {
        return if not -e -r -d $_;
        if ( $_ =~ m{\/$} ) {
            return 1;
        }
        $@ = 'Directory needs / at end';
        return;
    },
    message {
        "The Directory '$_' is invalid or not readable. ( $@ $!)";
    }
);

subtype 'Gentoo::Type::PackageAtom' => (
    as 'Str',
    where { $_ =~ /^[-A-Za-z0-9_+]+$/ },
    message {
        "$_ is not a valid Package Atom.";
    },
);

subtype 'Gentoo::Type::CategoryAtom' => (
    as 'Str',
    where { $_ =~ /^[-a-z0-9]+$/ },
    message {
        "$_ is not a valid Category Atom.";
    },
);

1;
