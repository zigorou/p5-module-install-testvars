use strict;
use lib qw(./lib);
use Test::More;

use File::Path;
use FindBin;
use Term::UI;

plan tests => 3;

{
    use Module::Install::TestVars;
    use inc::Module::Install;
    
    no warnings 'redefine';

    local @ARGV = ( q|TEST_VAR_ARGV=test| );
    local $Term::UI::AUTOREPLY = 1;

    test_vars
        TEST_VAR_COLOR => +{ prompt => 'Input color', default => 1, choices => [qw/red blue yellow/] },
        TEST_VAR_ARGS => +{ prompt => 'Input from args', default => 'abc', };

    is($MY::TEST_VARS{TEST_VAR_COLOR}, 'red');
    is($MY::TEST_VARS{TEST_VAR_ARGV}, 'test');

    ok(rmtree( [ $FindBin::Bin . '/inc' ], 1, 1));
}
