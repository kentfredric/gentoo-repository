package Gentoo::Category;

# $Id:$

use Moose;
use version; our $VERSION = qv('0.1');
use MooseX::Method::Signatures 0.06;

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

method url {
	return $self->repository->url . $self->category_name . q{/};
};

method packages( CodeRef : $filter ? ) {
	my ( $iterator, $next, @dirs ) = ( 0, undef, undef );
	  @dirs = $self->glob_url;
	  $next = sub {
		while ( my $d = $dirs[ $iterator++ ] ) {
			if ( defined $filter ) {
				local $_ = $self->remove_base($d);
				next if $filter->( $_, $d );
			}
			next if !-d $d;
			return Gentoo::Package->new(
				category     => $self,
				package_name => $self->remove_base($d)
			);
		}
		return;
	  };
	  return Gentoo::Util::Iterator->new($next);
};

1;
