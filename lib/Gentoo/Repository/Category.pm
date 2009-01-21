package Gentoo::Repository::Category;

# $Id:$

use MooseX::Declare 0.03;
use version; our $VERSION = qv('0.1');

use Iterator::Util;
use Iterator::IO;

use Gentoo::Repository::Package;
use Gentoo::Util::Types;

class Gentoo::Repository::Category extends Gentoo::Repository::Base {
    has 'repository' => (
        isa      => 'Gentoo::Repository',
        is       => 'rw',
        required => 1,
    );

    has 'category_name' => (
        isa      => 'Gentoo::Util::Type::CategoryAtom',
        is       => 'rw',
        required => 1,
    );

    method url {
        return $self->repository->url . $self->category_name . q{/};
    };

    method packages( CodeRef :$filter? ) {

        my ( $it ) = idir_listing( $self->url );

        $it = imap {                                        # General purpose tranformation.
            { dir => $_ , short => $self->remove_base($_) } # See Iterator::Util
        } $it;

        if ( defined $filter ) {                            # Probably The Most Confusing Part
            $it = igrep { $filter->($_ )}  $it;
        }

        $it = igrep{ -d $_->{dir} } $it;

        $it = imap { Gentoo::Repository::Package->new(
                    category     => $self,
                    package_name => $_->{short}
        ) } $it ;
        return $it;
    };
};
1;
