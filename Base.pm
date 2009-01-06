package Gentoo::Base;

#$Id:$
use Moose;
use version; our $VERSION = qv('0.1');

#use overload '""' => \&yaml;

sub yaml {
    my ($self) = shift;
    require YAML::XS;
    return YAML::XS::Dump($self);
}

sub _remove_base {
    ## no critic ( DotMatchAnything ExtendedFormatting LineBoundaryMatching )
    my ( $self, $to_remove, $url ) = @_;
    $url =~ s/^\Q$to_remove\E//;
    return $url;
}

sub glob_url {
    my ($self) = shift;
    my @x = glob $self->url . q{*};
    return @x;
}

sub remove_base {
    my ( $self, @rest ) = @_;
    return $self->_remove_base( $self->url, @rest );
}

sub url {
    my ($self) = shift;
    return $self->throw_error( 'You tried to use a url method on something,'
          . 'which may need to yet implement that feature' );
}

1;
