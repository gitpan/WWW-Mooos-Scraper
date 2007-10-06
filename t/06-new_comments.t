use Test::More tests => 4;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->new_comments( page => 7 );

ok(!exists $res->{error}, "not exists error");

ok(exists $res->{new_comments}, "exists new_comments");

isa_ok($res->{new_comments}, "ARRAY", "new_comments is not empty");

is(scalar @{$res->{new_comments}}, 10, "new_comments is 10 counts");


