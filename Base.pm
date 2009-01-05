package Gentoo::Base;
use Moose;

#use overload '""' => \&yaml;

sub yaml {
    my ($self) = shift;
    eval 'use YAML::XS';
    return YAML::XS::Dump($self);
}
sub _remove_base {
    my ( $self, $toRemove, $url ) = @_;
    $url =~ s/^\Q$toRemove\E//;
    return $url;
}

1;
