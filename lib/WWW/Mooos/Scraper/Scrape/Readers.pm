package WWW::Mooos::Scraper::Scrape::Readers;

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
    my $path = "/index.php/" . ($param{page} ||= 1);
    $uri->path($path);
    return $uri;
}

sub scrape_run {

    my($self, $uri) = @_;
    my $ref = { recent_articles => [] };
    my $res = scraper {
        process "dt.totalComments > a", "mooos_page_url[]" => "\@href";
                                                            #sub {
                                                            #    my $elem = shift;
                                                            #    (my $href = $elem->attr("href")) =~ s#\./##;
                                                            #    return $self->uri->clone->abs($self->uri)->as_string . $href;
                                                            #};
        process "dt.totalComments > a > em", "total_comments[]" => "TEXT";
        process "dd.pageTitle > a", "page_title[]" => "TEXT";
        process "dd.pageTitle > a", "page_url[]" => "\@href";
        process "dd.lastComment", "last_comment[]" => "TEXT";
        process "dd.lastComment", "last_comment_type[]" => sub {
                                                    my $elem = shift;
                                                    return $elem->find_by_tag_name("li")->attr("class");
                                                    },
        process "dd.entryData > ul > li.entryTime", "entry_time[]" => "TEXT";
        process "dd.entryData > ul > li.positive", "positive_count[]" => "TEXT";
        process "dd.entryData > ul > li.negative", "negative_count[]" => "TEXT";
        result qw(mooos_page_url total_comments page_title page_url last_comment last_comment_type entry_time positive_count negative_count);
    }->scrape($uri);

    # mooos_page_url is base count
    if(defined $res->{mooos_page_url}){
        foreach my $i(0..scalar @{$res->{mooos_page_url}} - 1){
            
            my %hash = ();
            foreach my $key(keys %{$res}){
                $hash{$key} = $res->{$key}->[$i];
            }
            push @{$ref->{recent_articles}}, \%hash;
        }
    }

    return $ref;
}


1;

