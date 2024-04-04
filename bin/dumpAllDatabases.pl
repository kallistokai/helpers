#!/usr/bin/perl

use strict;
use warnings;
no warnings "uninitialized";

my $password = shift;

# prefer pigz over gzip
my $gzipCommand = `which pigz`;
if($gzipCommand eq '')
{
    $gzipCommand = `which gzip`;
}
chomp $gzipCommand;

my @databases;
open IN, "mysql -uroot -p$password -e 'show databases' --skip-column-names |";
while(<IN>)
{
    chomp;
    my $db = $_;
    next if $db =~ m/_schema$/;
    print "INFO: db: $_\n";
    my $cmd = "mysqldump $db -p$password --events --routines --triggers | $gzipCommand > $db.sql.gz";
    print "EXEC: $cmd\n";
    system $cmd;
    print "\n";
}
close IN;
