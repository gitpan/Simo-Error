use Test::More 'no_plan';
use strict;
use warnings;

use Simo::Error;

{
    my $err_str = Simo::Error->create_err_str( type => '1', msg => '2', a => '3', b => '4' ) .  "c\nd\ne";
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => '1', msg => '2', pos => "c d e", info => { a => 3, b => 4 } }, 'success pattern1' );
}

{
    my $err_str = Simo::Error->create_err_str( type => '', msg => '', a => '', b => '' );
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => '', msg => '', pos => '', info => { a => '', b => '' } }, 'success pattern2' );
}

{
    my $err_str = Simo::Error->create_err_str();
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => '', msg => '', pos => '', info => {} }, 'success pattern3' );
}

{
    my $err_str = Simo::Error->create_err_str( type => 1 );
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => '1', msg => '', pos => '', info => {} }, 'success pattern4' );
}

{
    my $err_str = Simo::Error->create_err_str( type => "'", msg => "a'a", a => "a'", b => "'a" );
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => "'", msg => "a'a", pos => '', info => { a => "a'", b => "'a" } }, 'success pattern5 contain single quote' );
}

{
    my $err_str = "Error: { ^ => '1' }";
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => 'unknown', msg => $err_str, pos => '', info => {} }, 'error pattern1 key is invalid' );
}

{
    my $err_str = "Error: { a => '1 }";
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => 'unknown', msg => $err_str, pos => '', info => {} }, 'error close single quote is not found' );
}

{
    my $err_str = "Error: { type => 1 }";
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => 'unknown', msg => $err_str, pos => '', info => {} }, 'error pattern2 value is not start single quote' );
}

{
    my $err_str = "aaa";
    my $hash = Simo::Error->_create_err_hash( $err_str );
    is_deeply( $hash, { type => 'unknown', msg => $err_str, pos => '', info => {} }, 'error pattern3 not simo error obj' );
}
