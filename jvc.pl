#!/usr/bin/perl

use strict;
use warnings;

my @entries;
my $nb = 0;

# Parsing HTML
my $inlist = !1;
my $date;
while(my $line = <>) {
    chomp $line;
    if(not $inlist and $line =~ m/^<h3 class="titre_bloc"><span>Dernières Chroniques vidéo<\/span><\/h3>/) {
        $inlist = !0;
    } elsif($inlist and ($line =~ m/<li><strong>..\/.. : <a href="(.*?)">(.*?)<\/a>, (.*?)<\/strong><\/li>/
            or $line =~ m/<li>..\/.. : <a href="(.*?)">(.*?)<\/a>, (.*?)<\/li>/)) {
        my $link = $1;
        my $name = "$2 ($3)";
        push @entries, ($link,$name);
        ++$nb;
    }
}

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<title>Chroniques vidéos de jvc</title>\n";
print "<link>http://www.jeuxvideo.com</link>\n";
print "<description>Site français de jeux vidéos.</description>\n\n";

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


