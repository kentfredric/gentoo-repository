package Gentoo::Category;

use Moose;

use Gentoo::Util::Iterator;
use Gentoo::Package;
use Gentoo::Types;

extends qw( Gentoo::Base );

has 'repository' => (
    isa      => 'Gentoo::Repository',
    is       => 'rw',
    required => 1,
);

has 'category_name' => (
    isa      => 'Gentoo::Type::CategoryAtom',
    is       => 'rw',
    required => 1,
);

sub remove_base {
    my ( $self ) = shift;
    return $self->_remove_base( $self->category_name .'/' , @_ );
}

sub packages {
    my ( $self, $iterator, $next, @dirs ) = ( (shift), 0, undef, undef );
    @dirs = glob( $self->repository->directory . $self->category_name . '/*' );
    @dirs = sort @dirs;
    $next = sub {
        while ( my $d = $dirs[ $iterator++ ] ) {
            next if !-d $d;
            $d = $self->repository->remove_base($d);
            $d = $self->remove_base($d);
            return Gentoo::Package->new(
                category     => $self,
                package_name => $d
            );
        }
        return;
    };
    return Gentoo::Util::Iterator->new($next);
}

1;
