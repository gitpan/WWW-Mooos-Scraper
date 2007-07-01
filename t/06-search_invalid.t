use Test::More tests => 5;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->search( page => "aaa", url => "invalid url string" );

ok(exists $res->{error}, "exists error");

ok(exists $res->{param}->{page}, "exists param > page");
ok(exists $res->{param}->{url}, "exists param > url");

is($res->{param}->{page}, "it is not a value of one or more", "page error message");
is($res->{param}->{url}, "invalid url string", "url error message");


