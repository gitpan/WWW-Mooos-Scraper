use Test::More tests => 7;

use strict;
use WWW::Mooos::Scraper;

my $mooos = WWW::Mooos::Scraper->new;

my $res = $mooos->entry(
                        comment => "",
                        url     => "http://www.mooos.net/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                        entry_type => "foo" 
                    );

ok(exists $res->{error}, "exists error");

ok(exists $res->{param}->{comment}, "exists param > comment");
ok(exists $res->{param}->{url}, "exists param > url");
ok(exists $res->{param}->{entry_type}, "exists param > entry_type");

is($res->{param}->{comment}, "value is empty", "comment error message");
is($res->{param}->{url}, "within 256 bytes", "url error message");
is($res->{param}->{entry_type}, "invalid entry type. positive or negative", "entry error message");


