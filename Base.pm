package Gentoo::Base;
use Moose;
use overload '""' => \&yaml;

sub yaml { 
    my ($self) = shift;
    require YAML;
    return YAML::Dump($self);   
}

1; 