package Gentoo::Util::Iterator;

#$Id$
use strict;
use warnings;
use version; our $VERSION = qv('0.1');
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

sub next_item {

	my ( $self, @rest ) = @_;

	if ( isFalse $self->{'started'} ) {
		$self->{'started'} = true;
	}
	if ( isTrue $self->{'finished'} ) {
		return;
	}
	my $item = $self->{'next'}->( $self, @rest );
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
	if ( isFalse $self->{'started'} ) {
		$self->next_item();
	}
	return $self->{'current'};
}

sub all {
	my ($self) = shift;
	while ( isFalse $self->{'finished'} ) {
		$self->next_item();
	}
	my ($cr) = shift;
	if ( defined $cr && ref $cr eq 'CODE' ) {
		return map { $cr->($_) } @{ $self->{'seen'} };
	}
	return @{ $self->{'seen'} };
}

1;
