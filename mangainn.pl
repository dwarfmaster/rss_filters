#!/usr/bin/perl

use strict;
use warnings;

my $true = !0;
my $false = !1;

my $name = "";
my @entries;
my $nb = 0;

# Parsing html
my $inchapters = $false;
my $entryline = "";
while (my $line = <>) {
    chomp $line;
    if($line =~ m/<table class="headLBL".*itemprop="name">(.*?)<\/td>/) {
        $name = $1;
    }
    elsif($inchapters) {
        if($line =~ m/<span class="BlackLabel14"/) {
            $entryline = $line;
            $inchapters = $false;
        }
    }
    elsif($line =~ m/Latest Chapters/) {
        $inchapters = $true;
    }
}

die "Invalid html page" if $entryline eq "";
my @lines = split "<br/>", $entryline;
for my $line (@lines) {
    if($line =~ m/<a href="(.*?)"><strong>(.*?)<\/strong>(.*?)<\/a>/) {
        my $link = $1;
        my $title = "$2$3";
        splice @entries, 0, 0, ($link,$title);
        ++$nb;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>$name</title>\n";
print "<link>http://mangainn.me</link>\n";
print "<description>$name</description>\n";

# RSS content
for(my $i = $nb - 1; $i >= 0; --$i) {
    my $link = $entries[$i*2];
    my $name = $entries[$i*2+1];
    print "<item>\n";
    print "\t<title>$name</title>\n";
    print "\t<link>$link</link>\n";
    print "\t<description>$name -- $link</description>\n";
    print "</item>\n\n";
}

# RSS foot
print "</channel>\n";
print "</rss>\n";

