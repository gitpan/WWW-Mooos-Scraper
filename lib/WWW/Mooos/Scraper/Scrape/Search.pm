package WWW::Mooos::Scraper::Scrape::Search;

use strict;
use warnings;
use base qw(WWW::Mooos::Scraper::Scrape);
use Web::Scraper;

our $VERSION = 0.02;

sub valid_param {

    my($self, $param) = @_;
}

sub scrape_uri {

    my($self, %param) = @_;
    my $uri = $self->uri->clone;
    my $path = "/" . join "/", "entry.php", ($param{page} ||= 1), $param{url};
    $uri->path($path);
    return $uri;
}

sub scrape_run {

    my($self, $uri) = @_;
    my $article_comment = scraper {
        process "div.entry_time > div > img", entry_type => "\@src";
        process "div.entry_time > div", entry_time => "TEXT";
        process "div.comment > div", comment => "TEXT";
        result qw(entry_time comment entry_type);
    };

    my $res = scraper {
        process "div#content > div#title > a", page_title => "TEXT";
        process "div#content > div#url > a", page_url => "TEXT";
        process "div#content > div#thumbnail > a > img", thumbnail_url => "\@src";
        process "div#content > div#total > span.number", comment_num => "TEXT";
        process "div#article > table[summary=\"comments\"] > tr > td.data", "article_comments[]" => $article_comment;
        result qw(page_title page_url thumbnail_url comment_num article_comments);
    }->scrape($uri);

    # for empty
    $res->{article_comments} = [] if !$res->{article_comments};
    return $res;
}



1;

