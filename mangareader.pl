#!/usr/bin/perl

use strict;
use warnings;

my $true  = !0;
my $false = !1;

my $name;
my $desc;
my @entries;
my $nb = 0;

my $latest = $false;
my $sum = $false;
my $end = $false;

# Parsing HTML
while(not $end and my $line = <>) {
    chomp $line;
    if($sum) {
        if($line =~ m/^<p>(.*?)<\/p>/) {
            $desc = $1;
            $end = $true;
        }
        next;
    }

    if($latest) {
        if($line =~ m/^<a href="(.*?)">(.*?)<\/a>(.*?)<\/li>/) {
            splice @entries, 0, 0, ("http://www.mangareader.net$1", "$2$3");
            ++$nb;
        } elsif($line =~ m/^<div id="readmangasum">/) {
            $latest = $false;
            $sum = $true;
        }
        next;
    }

    if($line =~ m/^<h2 class="aname">(.*?)<\/h2>/) {
        $name = $1;
    } elsif($line =~ m/LATEST CHAPTERS/) {
        $latest = $true;
    }

}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>$name</title>\n";
print "<link>http://mangareader.net/</link>\n";
print "<description>$name manga : $desc</description>\n\n";

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


