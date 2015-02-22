#!/usr/bin/perl

use strict;
use warnings;
my $true = !0;
my $false = !1;

my $title = $ARGV[0];
my $inchannel = $false;
my $line = "";
while($line = <STDIN>) {
    $inchannel = $true if $line =~ m/<channel>/;
    if($inchannel and $title and $line =~ m~<title>.*?</title>~) {
        $line =~ s~<title>.*?</title>~<title>$title</title>~;
    } elsif ($line =~ m/<item>/) {
        $inchannel = $false;
    }
    print $line;
}

