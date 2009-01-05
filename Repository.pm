
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

=for Remove Base: 
    $x->remove_base($foo) will trim $self->directory from $foo. 
=cut

sub remove_base {
    my ($self) = shift;
    return $self->_remove_base( $self->directory, @_ );
}

sub categories {
    my ( $self, $iterator, $next, @dirs ) = ( (shift), 0, undef, undef );
    @dirs = glob( $self->directory . '*' );
    @dirs = sort @dirs;
    $next = sub {
        while ( my $d = $dirs[ $iterator++ ] ) {
            my $short = $self->remove_base($d);
            next if _is_metafile($short);
            next if !-d $d;
            return Gentoo::Category->new(
                repository    => $self,
                category_name => $short,
            );
        }
        return;
    };
    return Gentoo::Util::Iterator->new($next);
}

=for Internal:
    Determines if the given url looks like a repository special or not. 
    Takes only the trimmed urn (ie: without the repository base address). 
=cut

sub _is_metafile {
    my ($url) = shift;
    return $url =~ qr{
       ^(distfiles|eclass|licenses|metadata|packages|profiles|scripts)$
    }x;
}

1;
