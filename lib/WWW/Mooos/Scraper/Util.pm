package WWW::Mooos::Scraper::Util;

=pod

=head1 NAME

WWW::Mooos::Scraper::Util - WWW::Mooos::Scraper util module

=head1 VERSION

0.02

=head1 DESCRIPTION

WWW::Mooos::Scraper util module

=cut

use strict;
use warnings;
use DateTime;
use Encode;
use Encode::JP::H2Z;
use Exporter;
use URI;

our @ISA         = qw(Exporter);
our @EXPORT_OK   = qw(
                    _entry_time2datetime
                    _get_entry_type
                    _get_mooos_page_url
                    _h2z
                    _strip
                    _uri
                    _utf8_encode
                    );

our %EXPORT_TAGS = ( all => \@EXPORT_OK );
our $VERSION     = 0.02;

=pod

=head1 METHOD

=head2 _entry_time2datetime

=cut

sub _entry_time2datetime {

    my($entry_time, $timestamp, $timezone) = @_;
    return if !defined $entry_time;
    $timestamp ||= time;
    my($day, $hour, $min);

    # e.g.1  1 hours 3 min ago
    # e.g.2  4 days ago
    # e.g.3  24 min ago
    if($entry_time =~ /((\d{1,})\s+days)?\s?((\d{1,})\s+hours)?\s?((\d{1,})\s+min)?\s?ago$/){
        $day  = $2 || 0;
        $hour = $4 || 0;
        $min  = $6 || 0;
    }

    my $pass_time = (86_400 * $day) + (3_600 * $hour) + (60 * $min);
    my $dt = DateTime->from_epoch(epoch => $timestamp - $pass_time);
    $dt->set_time_zone($timezone) if $timezone;
    return $dt;
}

=pod

=head2 _get_entry_type

=cut

sub _get_entry_type {

    my $entry_type = shift;
    return if !defined $entry_type;
    return $entry_type =~ /positive/ ? "positive" : "negative";
}

=pod

=head2 _get_mooos_page_url

=cut

sub _get_mooos_page_url { 

    my($mooos_page_url, $uri) = @_;
    return if !defined $mooos_page_url;
    $mooos_page_url =~ s#^\.##;
    $uri->path($mooos_page_url);
    return $uri;
}

=pod

=head2 _h2z

=cut

sub _h2z {

    my $str = shift;
    return if !defined $str;
    Encode::from_to($str, "utf8", "euc-jp");
    Encode::JP::H2Z::h2z(\$str);
    Encode::from_to($str, "euc-jp", "utf8");
    return $str;
}

=pod

=head2 _strip

=cut

sub _strip {

    my $str = shift;
    return if !defined $str;
    $str =~ s/^\s+//;
    $str =~ s/\s+$//;
    return $str;
}

=pod

=head2 _uri

=cut

sub _uri {

    my $uri = shift;
    return if !defined $uri;
    return URI->new($uri);
}

=pod

=head2 _utf8_encode

=cut

sub _utf8_encode {

    my $str = shift;
    return if !defined $str;
    return $str if !Encode::is_utf8($str);
    return Encode::encode_utf8($str);
}


1;

__END__

=head1 SEE ALSO

L<DateTime> L<Encode> L<Encode::JP::H2Z> L<Exporter> L<URI>

=head1 AUTHOR

Akira Horimoto

=head1 COPYRIGHT AND LICENSE

This library is free software.
You can redistribute it and/or modify it under the same terms as perl itself.

Copyright (C) 2007 Akira Horimoto

=cut

