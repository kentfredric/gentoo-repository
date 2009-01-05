
package Gentoo::Repository;
use Moose;

use Gentoo::Util::Iterator;
use Gentoo::Category;
use Gentoo::Types;

extends qw( Gentoo::Base );

has 'directory' => (
    isa      => 'Gentoo::Type::Directory',
    is       => 'rw',
    required => 1,
);

sub categories {
    my ($self) = shift;
    my (@dirs) = glob( $self->{directory} . '*' );
    @dirs = sort @dirs;
    my $iterator = 0;
    return Gentoo::Util::Iterator->new(
        sub {
            while ( my $d = $dirs[ $iterator++ ] ) {
                next if $d =~ qr{/(
                distfiles|eclass|licenses|metadata|packages|profiles|scripts
            )$}mx;
                next if !-d $d;
                $d =~ s{^\Q$self->{directory}\E}{};
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
