package Gentoo::Category;

use Moose;
use Moose::Util::TypeConstraints;
use Gentoo::Util::Iterator;

extends qw( Gentoo::Base );

#use Scalar::Util qw/refaddr/;

subtype 'CategoryAtom' => (
    as 'Str',
    where { $_ =~ /^[-a-z0-9]+$/ },
    message {
        "$_ is not a valid Category Atom.";
    },
);

has 'repository' => (
    isa      => 'Gentoo::Repository',
    is       => 'rw',
    required => 1,
);

has 'category_name' => (
    isa      => 'CategoryAtom',
    is       => 'rw',
    required => 1,
    coerce   => 1,
);

sub packages {
    my ($self) = shift;
    my (@dirs);
    @dirs =
      glob( $self->{repository}->{directory} . $self->{category_name} . '/*' );
    @dirs = sort @dirs;
    my $iterator = 0;

    return Gentoo::Util::Iterator->new(
        sub {
            while ( my $d = $dirs[ $iterator++ ] ) {
                next if !-d $d;
                $d =~ s{^\Q$self->{'repository'}->{'directory'}\E}{};
                $d =~ s{^\Q$self->{'category_name'}\E/}{};
                return $d;
            }
            return;
        }
    );
}

1;
