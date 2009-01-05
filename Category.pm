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
                return Gentoo::Package->new(
                    category     => $self,
                    package_name => $d
                );
            }
            return;
        }
    );
}

1;
