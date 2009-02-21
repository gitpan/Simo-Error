#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Simo::Error' );
}

diag( "Testing Simo::Error $Simo::Error::VERSION, Perl $], $^X" );
