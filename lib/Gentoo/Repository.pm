
package Gentoo::Repository;

# $Id:$
use Moose;
use MooseX::Method::Signatures;

use version; our $VERSION = qv('0.1');

use Gentoo::Util::Iterator;
use Gentoo::Repository::Category;
use Gentoo::Repository::Types;

use Readonly;

extends qw( Gentoo::Repository::Base );

Readonly my %SPECIALS => (
	distfiles => 1,
	eclass    => 1,
	licenses  => 1,
	metadata  => 1,
	packages  => 1,
	profiles  => 1,
	scripts   => 1,
);

has 'directory' => (
	isa      => 'Gentoo::Repository::Type::Directory',
	is       => 'rw',
	required => 1,
);

method url {
	return $self->directory;
};

method categories( CodeRef :$filter? ) {
	my ( $iterator, $next, @dirs ) = ( 0, undef, undef );
	  @dirs = $self->glob_url;
	  $next = sub {
		while ( my $d = $dirs[ $iterator++ ] ) {
			my $short = $self->remove_base($d);
			if ( defined $filter ) {
				local $_ = $short;
				next if $filter->( $_, $d );
			}
			next if __PACKAGE__->_filter_metafile($short);
			next if !-d $d;
			return Gentoo::Repository::Category->new(
				repository    => $self,
				category_name => $short,
			);
		}
		return;
	  };
	  return Gentoo::Util::Iterator->new($next);
	};

method _filter_metafile( Str @urls ) {
	return grep { defined $SPECIALS{$_} } @urls;

};

1;
