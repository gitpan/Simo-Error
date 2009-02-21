use Test::More 'no_plan';
use strict;
use warnings;

use Simo::Error;

{
    my $t = Simo::Error->new( type => 1, msg => 2, pos => 3, info => { a => 1 } );
    isa_ok( $t, 'Simo::Error' );
    
    my $old_type = $t->type( 11 );
    my $old_msg = $t->msg( 22 );
    my $old_pos = $t->pos( 33 );
    my $old_info = $t->info( { b => 2 } );
    
    is_deeply( [ $old_type, $old_msg, $old_pos, $old_info ], [ 1, 2, 3, { a => 1 } ], 'old value' );
    is_deeply( $t, { type => 11, msg => 22, pos => 33, info => { b => 2 } }, 'set value' );
    is_deeply( [ $t->type, $t->msg, $t->pos, $t->info ], [ 11, 22, 33, { b => 2 } ], 'get value' );
}




