use Test::More tests => 4;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->hot_comments( page => 4 );

ok(!exists $res->{error}, "not exists error");

ok(exists $res->{recent_articles}, "exists recent_articles");

isa_ok($res->{recent_articles}, "ARRAY", "recent_articles is not empty");

is(scalar @{$res->{recent_articles}}, 10, "recent_articles is 10 counts");


