package Module::Install::TestVars;

use strict;
use warnings;

our $VERSION = '0.01_01';

use base qw(Module::Install::Base);

sub test_vars {
    my ($self, %vars) = @_;
    %MY::TEST_VARS = ( %vars );
}

package MY;
our %TEST_VARS = ();
sub test {
    my ( $self, %attrs ) = @_;
    my $vars = 'TEST_VARS=' . join(' ' => map { sprintf('%s=%s', $_, $TEST_VARS{$_}) } keys %TEST_VARS);
    my $section = $self->SUPER::test(%attrs);
    $section = $vars . "\n" . $section;
    $section =~ s|(PERL_DL_NONLAZY=1)|$1 \$\(TEST_VARS\)|g if (length $vars);
    $section;
}

1;
__END__

=for stopwords vars

=head1 NAME

Module::Install::TestVars - Passing variables before running tests

=head1 SYNOPSIS

  use inc::Module::Install;

  test_vars
    TEST_DBI_DSN      => 'dbi:mysql:dbname=test',
    TEST_DBI_USER     => 'root',
    TEST_DBI_PASSWORD => '',

In your test,

  use Test::More tests => 1;

  diag($ENV{TEST_DBI_DSN});      # 'dbi:mysql:dbname=test'
  diag($ENV{TEST_DBI_USER});     # 'root'
  diag($ENV{TEST_DBI_PASSWORD}); # ''

  ok(1);

=head1 DESCRIPTION

Module::Install::TestVars is module fetching test setting variables via %ENV vars.

=head1 METHODS

=head2 test_vars %vars

key-value.

=head1 AUTHOR

Toru Yamaguchi E<lt>zigorou@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=for :stopwords

=cut
