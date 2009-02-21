use Test::More 'no_plan';
use strict;
use warnings;

use Simo::Error;

{
    my $err_str = Simo::Error->create_err_str( type => '1', msg => '2' );
    my $obj = Simo::Error->create_from_err_str( $err_str );
    
    is_deeply( $obj, { type => '1', msg => '2', pos => '', info => {} }, 'get error object' );
    isa_ok( $obj, 'Simo::Error' );
}

{
    my $err_str = Simo::Error->create_err_str( type => '1', msg => '3' );
    my $obj = Simo::Error->create_from_err_str( $err_str );
    my $obj_re = Simo::Error->create_from_err_str( $err_str );
    
    is( $obj, $obj_re, 'get chash' );
}

{
    my $obj = Simo::Error->create_from_err_str( undef );
    ok( !defined $obj, 'pass undef' );
}
