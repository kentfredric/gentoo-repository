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
requires 'MooosX::Declare'              => 0.03;
requires 'version'                      => 0.76;
requires 'Best'                         => 0.11;
requires 'Gentoo::Util'                 => 0.01;
requires 'Iterator'                     => 1.04;
requires 'Iterator::Util'               => 0.02;
requires 'Iterator::IO'                 => 0.02;

WriteAll;
