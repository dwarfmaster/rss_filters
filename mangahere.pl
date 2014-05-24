#!/usr/bin/perl

use strict;
use warnings;

my $name;
my @entries;
my $nb;

# Parsing HTML
while(my $line = <>) {
    chomp $line;
    if($line =~ m/^<li><label><h2>(.*?)<\/h2> Summary:/) {
        $name = $1;
    }
    # TODO : improve regex to handle mangahere (not all data on on line)
    elsif($line =~ m/^<a href="(.*?)">(.*?)<\/a>(.*?)<\/td>/) {
        my $link = "http://www.mangahere.co$1";
        my $name = "$2$3";
        splice @entries, 0, 0, ($link,$name);
        ++$nb;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>$name</title>\n";
print "<link>http://www.mangahere.co/</link>\n";
print "<description>$name manga</description>\n\n";

# RSS content
for(my $i = 0; $i < $nb; ++$i) {
    my $link = $entries[$i*2];
    my $name = $entries[$i*2+1];
    print "<item>\n";
    print "\t<title>$name</title>\n";
    print "\t<link>$link</link>\n";
    print "\t<description>$name -- $link</description>\n";
    print "</item>\n\n"
}

# RSS foot
print "</channel>\n";
print "</rss>\n";


