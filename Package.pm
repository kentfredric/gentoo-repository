package Gentoo::Package;

#$Id:$
use Moose;
use version; our $VERSION = qv('0.1');
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

sub url {
    my ($self) = shift;
    return $self->category->url . $self->package_name . q{/};
}

sub versions {
    my ( $self, $iterator, $next, @dirs ) = ( (shift), 0, undef, undef );
    @dirs = sort $self->glob_url;
    $next = sub {
        while ( my $d = $dirs[ $iterator++ ] ) {
            ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
            next if $d !~ /[.]ebuild$/;
            next if !-f $d;
            return $self->remove_base($d);
        }
        return;
    };
    return Gentoo::Util::Iterator->new($next);
}
1;
