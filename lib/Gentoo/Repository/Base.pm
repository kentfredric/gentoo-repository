package Gentoo::Repository::Base;

#$Id:$

use MooseX::Declare 0.03;
use Best [ [ 'YAML::XS','YAML::Syck', 'YAML' ], qw( Dump ) ];

use version; our $VERSION = qv('0.1');
use Iterator::IO;

class Gentoo::Repository::Base {

    method yaml {
        if( my $sub = Best->which('YAML::XS')->can('Dump') ){
            return $sub->($self);
        }
        return $self->throw_error('Somethings wrong with the YAMLizer, or Best, or both ' );
    };

    method _remove_base( $to_remove, $url ) {
        ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
        $url =~ s/^\Q$to_remove\E//;
        return $url;
    };

    method remove_base($url) {
        return $self->_remove_base( $self->url, $url );
    };

    method url {
        return $self->throw_error( 'You tried to use a url method on something,'
              . 'which may need to yet implement that feature' );
    };

};

1;
