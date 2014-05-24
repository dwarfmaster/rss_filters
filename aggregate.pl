#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

# Configuration
my $list    = "list";
my $rssdir  = "/home/luc/.rss";
my $verbose = !0;

# Code
open FILE,"<",$list or die "Couldn't open $list : $!";
while(my $url = <FILE>) {
    # Getting the url
    chomp $url;
    if($url =~ m/^(.*?)#/) {
        $url = $1;
    }
    next if not $url;

    # Downloading the webpage
    print "Dowloading \"$url\"\n" if $verbose;
    my $file;
    if($verbose) {
        $file = `curl $url`;
    } else {
        $file = `curl $url 2> /dev/null`;
    }
    warn "Couldn't download $url" and next if not $file and $verbose;

    # Parsing the content
    print "Parsing the html for $url\n" if $verbose;
    my ($name,$nb,@list) = parseHTML($file);
    warn "Couldn't parse the html for $url" and next if not @list and $verbose;

    # Saving the RSS
    $name = lc $name;
    $name =~ s/ /_/g;
    my $path = "$rssdir/$name";
    print "Saving the RSS file to $path\n" if $verbose;
    warn "Couldn't save the RSS for $url at $path" if not saveRSS($path, $name, $nb, $url, @list) and $verbose;

}
close FILE;

sub parseHTML {
    my ($text) = @_;
    my @lines = split /\n/,$text;
    my @result;
    my $name;
    my $nb;
    foreach my $line (@lines) {
        if($line =~ m/^<h2 class="aname">(.*?)<\/h2>/) {
            $name = $1;
        }
        elsif($line =~ m/^<a href="(.*?)">(.*?)<\/a>(.*?)<\/td>/) {
            my $link = "http://www.mangareader.net$1";
            my $name = "$2$3";
            splice @result, 0, 0, ($link,$name);
            ++$nb;
        }
    }
    return ($name, $nb, @result);
}

sub saveRSS {
    my ($path,$name,$nb,$url,@entries) = @_;
    warn "Couldn't open $path : $!" and return !1 if not open RSS,">",$path and $verbose;

    # RSS header
    print RSS "<rss version=\"2.0\">\n";
    print RSS "<channel>\n";
    print RSS "<title>$name</title>\n";
    print RSS "<link>$url</link>\n";
    print RSS "<description>$name manga</description>\n\n";

    # RSS content
    for(my $i = 0; $i < $nb; ++$i) {
        my $link = $entries[$i*2];
        my $name = $entries[$i*2+1];
        print RSS "<item>\n";
        print RSS "\t<title>$name</title>\n";
        print RSS "\t<link>$link</link>\n";
        print RSS "\t<description>$name -- $link</description>\n";
        print RSS "</item>\n\n"
    }

    # RSS foot
    print RSS "</channel>\n";
    print RSS "</rss>\n";

    close RSS;
    return !0;
}


