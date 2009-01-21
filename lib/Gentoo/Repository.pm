#$Id$
package Gentoo::Repository;

use MooseX::Declare;
use version; our $VERSION = qv('0.1');

use Iterator::Util;
use Iterator::IO;

use Gentoo::Repository::Category;
use Gentoo::Util::Types;

class Gentoo::Repository extends Gentoo::Repository::Base {

    has 'directory' => (
        isa      => 'Gentoo::Util::Type::Directory',
        is       => 'rw',
        required => 1,
    );

    method SPECIALS {
        return {
            distfiles => 1,
            eclass    => 1,
            licenses  => 1,
            metadata  => 1,
            packages  => 1,
            profiles  => 1,
            scripts   => 1,
        };
    };

    method url() {
        return $self->directory;
    };

    method categories( CodeRef :$filter? ) {

        my ($it) = idir_listing( $self->url );              # List of Dirs

        $it = imap {                                        # General purpose tranformation.
          { dir => $_ , short => $self->remove_base($_) }   # See Iterator::Util
        } $it;

        if ( defined $filter ) {
            $it = igrep { $filter->( $_ ) } $it;
        }

        $it = igrep {
            ( not defined $self->SPECIALS->{ $_->{short} } )
            && ( -d $_->{dir} )
        } $it;

        $it = imap {
            Gentoo::Repository::Category->new(
                repository    => $self,
                category_name => $_->{short},
            );
        } $it;
        return $it;
    };

}

1;

__END__


=h1 Synopsis
my $x = Gentoo::Repository->new( directory => '/base/dir/' );

# Return Repository Base Dir
$x->url()

# Returns an Iterator which emits Gentoo::Repository::Category items
my $iteration = $x->categories();

my $iteration = $x->categories(filter=>sub{
    $_->{short} =~ /foo/;
});


=cut
