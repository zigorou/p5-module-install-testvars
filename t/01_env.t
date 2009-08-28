use strict;
use Test::More;

plan tests => 3;

is($ENV{TEST_VAR_FOO}, 1);
is($ENV{TEST_VAR_BAR}, 'abc');
is($ENV{TEST_VAR_BAZ}, 1.35);
