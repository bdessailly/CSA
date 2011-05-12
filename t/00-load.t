#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'CSA' ) || print "Bail out!
";
}

diag( "Testing CSA $CSA::VERSION, Perl $], $^X" );
