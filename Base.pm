package Gentoo::Base;
use Moose;
use overload '""' => \&yaml;

sub yaml {
    my ($self) = shift;
    eval 'use YAML::XS';
    return YAML::XS::Dump($self);
}

1;
