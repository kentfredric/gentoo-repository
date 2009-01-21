package Gentoo::Repository::Package;

#$Id:$
use MooseX::Declare;
use version; our $VERSION = qv('0.1');

use Iterator::Util;
use Iterator::IO;

use Gentoo::Util::Types;

class Gentoo::Repository::Package extends Gentoo::Repository::Base {

    has 'category' => (
        isa      => 'Gentoo::Repository::Category',
        is       => 'rw',
        required => 1,
    );

    has 'package_name' => (
        isa      => 'Gentoo::Util::Type::PackageAtom',
        is       => 'rw',
        required => 1,
    );

    method package_atom {
        return $self->category->category_name . '/' . $self->package_name;
    }

    method url {
        return $self->category->url . $self->package_name . q{/};
    };

    method versions ( CodeRef :$filter? )  {

        my ($it) = idir_listing( $self->url );

        $it = imap {
            { file => $_ , short => $self->remove_base( $_ ) }
        } $it;

        if ( defined $filter ) {
            $it = igrep {
                $filter->( $_ )
            } $it;
        }

        $it = igrep {
            $_->{file} =~ /[.]ebuild$/  and  -f $_->{file}
        } $it;

        $it = imap {
            $_->{short}
        } $it;

        return $it;
    };

};

1;
