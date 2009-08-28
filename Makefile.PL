use FindBin;
use lib "$FindBin::Bin/lib";
use inc::Module::Install;

name 'Module-Install-TestVars';
all_from 'lib/Module/Install/TestVars.pm';

requires 'Module::Install';

tests 't/*.t';
author_tests 'xt';

test_vars
    "TEST_VAR_FOO" => 1,
    "TEST_VAR_BAR" => "abc",
    "TEST_VAR_BAZ" => 1.35;

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
