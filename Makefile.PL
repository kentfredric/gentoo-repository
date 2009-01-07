use strict;
use warnings;
use inc::Module::Install;

name 'Gentoo-Repository';
all_from 'lib/Gentoo/Repository.pm';
abstract 'Utilities for Using/Traversing Gentoo Repositories'; 
author   'Kent Fredric <kentfredric@gmail.com>';
version  '0.1';
license  'perl';
perl_version '5.010';

requires 'Moose'; 
requires 'Moose::Util::TypeConstraints'; 
requires 'MooseX::Method::Signatures' => 0.06; 
requires 'version'; 
requires 'YAML::XS';
requires 'Readonly'; 
requires 'boolean';



WriteAll;
