package Gentoo::Types;

#$Id:$
use Moose;
use version; our $VERSION = qv('0.1');
use Moose::Util::TypeConstraints;

subtype 'Gentoo::Type::Directory' => (
    as 'Str',
    where {
        return if not -e -r -d $_;
        ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
        if ( $_ =~ m{\/$} ) {
            return 1;
        }
        $@ = 'Directory needs / at end';
        return;
    },
    message {
        "The Directory '$_' is invalid or not readable. ( $@ $!)";
    },
);

subtype 'Gentoo::Type::PackageAtom' => (
    as 'Str',
    where {
        ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
        $_ =~ /^[-\w\d+]+$/;
    },
    message {
        "$_ is not a valid Package Atom.";
    },
);

subtype 'Gentoo::Type::CategoryAtom' => (
    as 'Str',
    where {
        ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
        $_ =~ /^[-\p{IsLower}\d]+$/;
    },
    message {
        "$_ is not a valid Category Atom.";
    },
);

1;
