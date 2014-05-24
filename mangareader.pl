#!/usr/bin/perl

use strict;
use warnings;

my $name;
my @entries;
my $nb;

# Parsing HTML
while(my $line = <>) {
    chomp $line;
    if($line =~ m/^<h2 class="aname">(.*?)<\/h2>/) {
        $name = $1;
    }
    elsif($line =~ m/^<a href="(.*?)">(.*?)<\/a>(.*?)<\/td>/) {
        my $link = "http://www.mangareader.net$1";
        my $name = "$2$3";
        splice @entries, 0, 0, ($link,$name);
        ++$nb;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>$name</title>\n";
print "<link>http://mangareader.net/</link>\n";
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


