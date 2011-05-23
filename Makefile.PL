use inc::Module::Install;

name     'CSA';
all_from 'lib/CSA.pm';
author   q{Benoit H Dessailly <benoit@biochem.ucl.ac.uk>};
license  'perl';

build_requires 'Test::More';

requires 'Test::Exception' => '0.29';

auto_install;

WriteAll;

