package WWW::Mooos::Scraper::Scrape::Readers;

use strict;
use warnings;
use base qw(WWW::Mooos::Scraper::Scrape);
use Web::Scraper;

our $VERSION = 0.01;

sub valid_param {

    my($self, $param) = @_;
}

sub scrape_uri {

    my($self, %param) = @_;
    my $uri = $self->uri->clone;
    my $path = "/index.php/" . ($param{page} ||= 1);
    $uri->path($path);
    return $uri;
}

sub scrape_run {

    my($self, $uri) = @_;
    my $ref = {};
    my $recent_article = scraper {
        process "div.pageTitle > a", page_title => "TEXT", page_url => "\@href";
        process "div.total > span.number > a", comment_num => "TEXT", mooos_page_url => "\@href";
        process "div.entry_time", entry_time => "TEXT";
        process "div.comment > img", entry_type => "\@src";
        process "div.comment", comment => "TEXT";
        result qw(page_title page_url comment_num mooos_page_url entry_time comment entry_type);
    };

    my $res = scraper {
        process "div#recentComents > table[summary=\"recent comments\"] > tr > td", "recent_articles[]" => $recent_article;
        result qw(recent_articles);
    }->scrape($uri);
    $ref->{recent_articles} = (ref($res) eq "HASH" && !keys %{$res}) ? [] : $res;
    
    return $ref;
}


1;

