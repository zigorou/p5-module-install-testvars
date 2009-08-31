use strict;
use Test::More;

use File::Path;
use FindBin;
use Term::UI;

plan tests => 4;

{
    use inc::Module::Install;
    
    no warnings 'redefine';
    
    local $Term::UI::AUTOREPLY = 1;

    test_vars
        TEST_VAR_FOO => +{ prompt => 'Input Foo', default => 1, },
        TEST_VAR_BAR => +{ prompt => 'Input Bar', default => 'abc', },
        TEST_VAR_BAZ => +{ prompt => 'Input Baz', default => 1.35, };

    is($MY::TEST_VARS{TEST_VAR_FOO}, 1);
    is($MY::TEST_VARS{TEST_VAR_BAR}, 'abc');
    is($MY::TEST_VARS{TEST_VAR_BAZ}, 1.35);

    ok(rmtree( [ $FindBin::Bin . '/inc' ], 1, 1));
}
