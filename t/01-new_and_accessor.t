use Test::More 'no_plan';
use strict;
use warnings;

package Some;
use Simo::Error;

sub err{
    die Simo::Error->new( msg => 'a' );
}

sub throw_err{
    Simo::Error->throw( msg => 'a' );
}

package main;

{
    my $t = Simo::Error->new( type => 1, msg => 2, pos => 3, info => { a => 1 } );
    isa_ok( $t, 'Simo::Error' );
    
    my $old_type = $t->type( 11 );
    my $old_msg = $t->msg( 22 );
    my $old_pos = $t->pos( 33 );
    my $old_info = $t->info( { b => 2 } );
    
    is_deeply( [ $old_type, $old_msg, $old_pos, $old_info ], [ 1, 2, 3, { a => 1 } ], 'old value' );
    is_deeply( [ $t->type, $t->msg, $t->pos, $t->info ], [ 11, 22, 33, { b => 2 } ], 'set value' );
}

{
    my $t = Simo::Error->new( { type => 1 } );
    is( $t->type, 1, 'hash pass to new' );
}

{
    my $t = Simo::Error->new( pos => 1 );
    is_deeply( [ $t->type, $t->msg, $t->pos, $t->info] , [ 'unknown', '', 1, {} ], 'default value' );
}

{
    my $t = Simo::Error->new( msg => 'a', pos => 'b' );
    is( $t, 'ab', 'overload ""' );
}

{
    my $t = Simo::Error->new;
    like( $t->pos, qr/at/, 'err postion' );
}

{
    eval{ Simo::Error->new( 1 ) };
    like( $@, qr/key-value pairs must be passed to new/, 'pass not key-value paris to new' );
}

{
    eval{ Simo::Error->new( 'noexist' => 1 ) };
    like( $@, qr/Invalid key 'noexist' is passed to new/, 'no exists key is passed' );
}


{
    eval{ Some::err()}; my $line = __LINE__;
    like( $@, qr/ at /, 'err' );
    like( $@, qr/$line/, 'err line' );
    is( $@->type, 'unknown', 'object member type' );
    is( $@->msg, 'a', 'object member msg' );
}

{
    eval{ Some::throw_err()}; my $line = __LINE__;
    
    like( $@, qr/ at /, 'err' );
    like( $@, qr/$line/, 'err line' );
    is( $@->type, 'unknown', 'object member type' );
    is( $@->msg, 'a', 'object member msg' );
}
