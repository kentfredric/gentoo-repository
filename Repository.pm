
package Gentoo::Repository;
use Moose;
use Moose::Util::TypeConstraints;
use Gentoo::Util::Iterator;
use Gentoo::Category;

extends qw( Gentoo::Base );

subtype 'Directory' => (
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

has 'directory' => (
    isa      => 'Directory',
    is       => 'rw',
    required => 1,
);

sub categories {
    my ($self) = shift;
    my @dirs = glob( $self->{directory} . '*' );
    @dirs = sort @dirs;
    my $iterator = 0;
    return Gentoo::Util::Iterator->new(
        sub {
            while ( my $d = $dirs[ $iterator++ ] ) {
                next if $d =~ qr{/(
                distfiles|eclass|licenses|metadata|packages|profiles|scripts
            )$}mx;
                next if !-d $d;
                $d =~ s{^\Q$self->{'directory'}\E}{};
                return Gentoo::Category->new(
                    repository    => $self,
                    category_name => $d,
                );
            }
            return;
        }
    );
}

1;
