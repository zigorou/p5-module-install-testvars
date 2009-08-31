use inc::Module::Install;

name 'Module-Install-TestVars';
all_from 'lib/Module/Install/TestVars.pm';

requires 'Getopt::Long';
requires 'Module::Install';
requires 'Module::Install::Base';
requires 'Term::ReadLine';
requires 'Term::UI';
requires 'Text::ASCIITable';

tests 't/*.t';
author_tests 'xt';

build_requires 'File::Path';
build_requires 'FindBin';
build_requires 'Test::More';

use_test_base;
auto_include;
WriteAll;
