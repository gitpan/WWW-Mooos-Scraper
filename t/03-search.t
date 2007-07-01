use Test::More tests => 4;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->search( page => 1, url => "http://www.mooos.net/" );

ok(!exists $res->{error}, "not exists error");

ok(exists $res->{article_comments}, "exists article_comments");

isa_ok($res->{article_comments}, "ARRAY");

is(scalar @{$res->{article_comments}}, 10, "article_comments is 10 counts");


