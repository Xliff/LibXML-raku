use v6;
use Collector;

unit class Counter is Collector;
use Test;
has UInt $!count;

method _calc_op_callback {
    sub { ++$!count }
}

method test(UInt $value, $blurb) {
    my $rv := is $!count, $value, $blurb;
    $!count = 0;
    $rv;
}

