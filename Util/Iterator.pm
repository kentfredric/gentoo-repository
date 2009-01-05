package Gentoo::Util::Iterator;
use strict;
use warnings;
use boolean qw( isFalse isTrue false true );

sub new {

    my ($class) = shift;
    my ($next)  = shift;
    $next //= sub { return };
    my $x = bless {
        'started'  => false,
        'finished' => false,
        'next'     => $next,
        'state'    => undef,
        'current'  => undef,
        'seen'     => [],
    }, $class;
    return $x;
}

sub next {
    my ($self) = shift;
    
    if ( isFalse $self->{'started'} ) {
        $self->{'started'} = true;
    }
    
    if ( isTrue $self->{'finished'} ){
        return;
    }
    
    my $item = $self->{'next'}->( $self, @_ );
    
    if ( defined $item ) {
        $self->{'current'} = $item;
        push @{ $self->{'seen'} }, $item;
        return $item;
    }
    else {
        $self->{'finished'} = true;
        return;
    }
}

sub current {
    my ($self) = shift;
    if( isFalse $self->{'started'}){
        $self->next();
    }
    return $self->{'current'};
}

sub all {
    my ($self) = shift;
    while( isFalse $self->{'finished'} ){
        $self->next();
    }
    return @{$self->{'seen'}};
}

1;
