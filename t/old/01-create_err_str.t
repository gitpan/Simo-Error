use Test::More 'no_plan';
use strict;
use warnings;

use Simo::Error;

{
    my $err_str = Simo::Error->create_err_str( a => 1, b => 2 );
    is( $err_str, "Error: { a => '1', b => '2' }", 'pass hash' );
}

{
    my $err_str = Simo::Error->create_err_str( { a => 1, b => 2 } );
    is( $err_str, "Error: { a => '1', b => '2' }", 'pass hash ref' );
}

{
    my $err_str = Simo::Error->create_err_str( a => "a'b'c" );
    is( $err_str, "Error: { a => 'a\\'b\\'c' }", 'pass single quote' );
}

{
    eval{ Simo::Error->create_err_str( 1, 2, 3 ) };
    like( $@, qr/key-value pairs must be passed to 'create_err_str'/, 'odd num args pass' )
}

{
    eval{ Simo::Error->create_err_str( '^' => 1 ) };
    like( $@, qr/Key must be word charcter/, 'odd num args pass' )
    
}


