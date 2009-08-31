use FindBin;
use lib "$FindBin::Bin/lib";
use inc::Module::Install;

name 'Module-Install-TestVars';
all_from 'lib/Module/Install/TestVars.pm';

requires 'Module::Install';

tests 't/*.t';
author_tests 'xt';

test_vars 
    "TEST_VAR_FOO" => +{ prompt => 'Foo', default => 'foo' },
    "TEST_VAR_BAR" => +{ prompt => 'Bar', default => 'bar' },
    "TEST_VAR_BAZ" => +{ choices => [qw/1 3 6/] };

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
