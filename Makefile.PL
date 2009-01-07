use strict;
use warnings;
use inc::Module::Install;

name 'Gentoo-Repository';

#all_from 'lib/Gentoo/Repository.pm';
abstract 'Utilities for Using/Traversing Gentoo Repositories';
author 'Kent Fredric <kentfredric@gmail.com>';
version '0.1';
license 'perl';
perl_version '5.010';

requires 'Moose'                        => 0.63;
requires 'Moose::Util::TypeConstraints' => 0.63;
requires 'MooseX::Method::Signatures'   => 0.06;
requires 'version'                      => 0.76;
requires 'YAML::XS'                     => 0.29;
requires 'Readonly'                     => 1.03;
requires 'boolean'                      => 0.20;

WriteAll;
