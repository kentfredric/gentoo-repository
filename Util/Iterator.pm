package Gentoo::Util::Iterator; 
use strict; 
use warnings; 

sub new {
     
    my( $class ) = shift;
    my( $next  ) = shift; 
    $next //= sub{ return };
    my $x = bless {
        'next' => $next,
        'state' => undef,
        'current' => undef,
    }, $class; 
    return $x;
       
}

sub next{
    my($self) = shift; 
    my $item  = $self->{'next'}->( $self, @_ );
    $self->{'current'} = $item; 
    return $item;
}

sub current{
    my ($self) = shift; 
    return $self->{'current'};
}

1;