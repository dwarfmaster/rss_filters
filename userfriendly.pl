#!/usr/bin/perl

use strict;
use warnings;

my $name;
my @entries;
my $nb;

# Parsing HTML
my $incalendar = !1;
my $intable    = !1;
my $date;
while(my $line = <>) {
    chomp $line;
    if(not $intable and $line =~ m/^<TABLE/) {
        $intable = !0;
    } elsif($intable and $line =~ m/^<\/TABLE>/) {
        $intable = !1;
        $incalendar = !1;
    } elsif($intable and $line =~ m/^<TR><TD COLSPAN=7 VALIGN=center ALIGN=CENTER.*?<a href=".*?">(.*?) - (.*?)<\/a>/) {
        $date = "$1 $2";
        $incalendar = !0;
    } elsif($incalendar and $line =~ m/^<TD width=..% VALIGN=TOP .*?><a href="(.*?)">(.*?)<\/a>/) {
        my $link = $1;
        my $name = "Comic for $2 $date";
        splice @entries, 0, 0, ($link,$name);
        ++$nb;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>UserFriendly.org</title>\n";
print "<link>http://www.userfriendly.org</link>\n";
print "<description>A webcomic about a small IT enterprise.</description>\n\n";

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


