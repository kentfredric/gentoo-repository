
package Gentoo::Repository;

# $Id:$
use Moose;
use version; our $VERSION = qv('0.1');

use Gentoo::Util::Iterator;
use Gentoo::Category;
use Gentoo::Types;
use Readonly;

extends qw( Gentoo::Base );

Readonly my %SPECIALS => (
    distfiles => 1,
    eclass    => 1,
    licenses  => 1,
    metadata  => 1,
    packages  => 1,
    profiles  => 1,
    scripts   => 1,
);

has 'directory' => (
    isa      => 'Gentoo::Type::Directory',
    is       => 'rw',
    required => 1,
);

sub url {
    return (shift)->directory;
}

sub categories {
    my ( $self, $iterator, $next, @dirs ) = ( (shift), 0, undef, undef );
    @dirs = sort $self->glob_url;
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

=begin
    Determines if the given url looks like a repository special or not. 
    Takes only the trimmed urn (ie: without the repository base address).
=end 
=cut

sub _is_metafile {
    my ($url) = shift;
    return defined $SPECIALS{$url};
}
1;
