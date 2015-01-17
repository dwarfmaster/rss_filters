#!/usr/bin/perl

use strict;
use warnings;

my ($author, $url, $page) = @ARGV;
exit() if not $author or not $url;

# RSS header
print "<rss version=\"2.0\">\n";
print "<channel>\n";
print "<description>A Dwarf Fortress forum.</description>\n";
print "<link>$url</link>\n";

my $inpostzone = !1;
my $title = "";
my $found;
while(my $line = <STDIN>) {
    if($inpostzone) {
        if($line =~ m/title="View the profile of (.*?)"/) {
            $found = $1;
        } elsif ($line =~ m~ on:</strong> (.*? .m) ~) {
            my $name = $1;
            my $link = $page; # TODO Find link to post and not to page
            addItem($name, $link) if $found =~ m/$author/;
        }
    }
    else {
        if($line =~ m~<title>(.*?)</title>~) {
            $title = $1;
            print "<title>DwarfFortress : $title</title>\n";
        }
        $inpostzone = !0 if $line =~ m/<div id="forumposts"/;
    }
}

sub addItem {
    my ($name, $link) = @_;
    print "<item>\n";
    print "\t<title>$name</title>\n";
    print "\t<link>$link</link>\n";
    print "\t<description>$name of $title</description>\n";
    print "</item>\n\n";
}

# RSS footer
print "</channel>\n";
print "</rss>\n";

