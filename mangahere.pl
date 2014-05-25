#!/usr/bin/perl

use strict;
use warnings;

my @entries;
my $nb;
my $title;

# Parsing HTML
my $inlist  = !1;
my $inentry = !1;
my $firstp  = !1;
my $link;
my $name;
while(my $line = <>) {
    chomp $line;
    # Title
    if(not $inlist and $line =~ m/<li><label><h2>(.*?) Manga<\/h2> Summary:<\/label>/) {
        $title = $1;
    }
    # Starting of list of chapters
    elsif(not $inlist and $line =~ m/<div class="detail_list">/) {
        $inlist = !0;
    }
    # Start of an entry
    elsif($inlist and not $inentry and $line =~ m/<span class="left">/) {
        $inentry = !0;
    }
    # Link
    elsif($inentry and $line =~ m/<a class="color_0077" href="(.*?)" >/) {
        $link = $1;
    }
    # First part of name
    elsif($inentry and not $firstp and $line =~ m/^\s*(.*?)\s*<\/a>/) {
        $name = $1;
        $firstp = !0;
    }
    # End of name
    elsif($inentry and $line =~ m/<span class="mr6"><\/span>(.*?)<\/span>/) {
        $name = "" if not $firstp;
        $name = "$name : $1";
        push @entries, ($link,$name);
        ++$nb;
        $inentry = !1;
        $firstp  = !1;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>$title</title>\n";
print "<link>http://www.mangahere.co/</link>\n";
print "<description>$title manga</description>\n\n";

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


