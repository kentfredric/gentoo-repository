package Gentoo::Base;

#$Id:$
use Moose;
use MooseX::Method::Signatures 0.06;
use version; our $VERSION = qv('0.1');

#use overload '""' => \&yaml;

method yaml {
    require YAML::XS;
    return YAML::XS::Dump($self);
};

method _remove_base( $to_remove, $url ) {
    ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
    $url =~ s/^\Q$to_remove\E//;
    return $url;
};

method glob_url {
    my @x = glob $self->url . q{*};
    @x = sort @x;
    return @x;
};

method remove_base($url) {
    return $self->_remove_base( $self->url, $url );
};

method url {
    return $self->throw_error( 'You tried to use a url method on something,'
          . 'which may need to yet implement that feature' );
};

1;
