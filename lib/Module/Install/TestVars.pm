package Module::Install::TestVars;

use strict;
use warnings;

our $VERSION = '0.01_01';

use base qw(Module::Install::Base);

use Getopt::Long;
use Term::ReadLine;
use Term::UI;
use Text::ASCIITable;

=pod

  test_vars 
    DSN      => +{ default => 'dbi:mysql:dbname=test', prompt => 'DBI DSN' },
    USER     => +{ default => 'root', prompt => 'DBI USER' },
    PASSWORD => +{ default => '', prompt => 'DBI PASSWORD' };

=cut

sub test_vars {
    my ( $self, %config ) = @_;

    my $is_help = 0;

    GetOptions( 'help|h' => \$is_help, );

    my $term = Term::ReadLine->new('test_vars');
    my $out = $term->OUT || \*STDOUT;

    if ($is_help) {
        print $out 'Options: ', "\n\n";
        for my $var ( keys %config ) {
            $config{$var}->{prompt} ||= $var;

            print $out sprintf(
                "    %s : %s%s\n",
                $var,
                $config{$var}->{prompt},
                (
                    exists $config{$var}->{default}
                    ? sprintf( " (default: %s)", $config{$var}->{default} )
                    : ""
                )
            );
        }
        exit;
    }

 WIZARD:
    my %test_vars = map { ( split( /=/, $_, 2 ) ) } @ARGV;
    my $tbl = Text::ASCIITable->new( +{ headingText => 'test variables' } );
    $tbl->setCols( 'key', 'value' );

    print $out "Test configuration variables, \n\n";

    for my $var ( keys %config ) {
        unless ( exists $test_vars{$var} ) {
            $config{$var}->{prompt} ||= 'Input ' . $var;

            do {
                $test_vars{$var} = $term->get_reply(
                    ( exists $config{$var}->{default} )
                    ? (
                        prompt  => $config{$var}->{prompt},
                        default => $config{$var}->{default}
                      )
                    : ( prompt => $config{$var}->{prompt} . ': ' ),
                    (
                        exists $config{$var}->{choices}
                          && ref $config{$var}->{choices}
                      ) ? ( choices => $config{$var}->{choices} ) : ()
                );
            } until ( defined $test_vars{$var} );
        }
        else {
            print $out sprintf( "%s: %s\n", $var, $test_vars{$var} );
        }

        $tbl->addRow( $var, $test_vars{$var} );
    }

    print $out "\n", $tbl, "\n";

    unless (
        $term->ask_yn(
            prompt  => 'Check configuration, proceed?',
            default => 'y'
        )
      )
    {
        goto WIZARD;
    }

    %MY::TEST_VARS = (%test_vars);
}

package MY;
our %TEST_VARS = ();

sub test {
    my ( $self, %attrs ) = @_;
    my $vars = 'TEST_VARS='
      . join(
        ' ' => map { sprintf( '%s=%s', $_, $TEST_VARS{$_} ) }
          keys %TEST_VARS
      );
    my $section = $self->SUPER::test(%attrs);
    $section = $vars . "\n" . $section;
    $section =~ s|(PERL_DL_NONLAZY=1)|$1 \$\(TEST_VARS\)|g if ( length $vars );
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
