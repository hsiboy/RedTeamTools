#!/usr/bin/perl
#
# motu v0.1, (c) Hexacorn.com, 2015-06-17
# https://www.hexacorn.com/tools/motu.pl
# by 
#
# This is a simple script that extract strings from a file
# it then outputs a list of string islands based on the
# distance between islands & number of strings/island
#
# Usage:
#      perl motu.pl <filename> <sl> <di> <mo>
#       where
#         sl - String length (Default=4)
#         di - Distance between islands (Default=128 bytes)
#         mo - Min. # of strings/island (Default=10 strings)
#
# Examples:
#      perl motu.pl sample.exe
#

use strict;
use warnings;

$| = 1;

print STDERR "
============================================================================
 motu v0.1, written (c) Hexacorn.com, 2015-06-17
============================================================================
";

my $file = shift;
if (!defined($file))
{
  print "Gimme a file name!\n";
  exit;
}

my $arg = shift;
my $sl=4;
   $sl = $arg if defined($arg);

my $arg = shift;
my $di=128;
   $di = $arg if defined($arg);

my $arg = shift;
my $mo=10;
   $mo = $arg if defined($arg);

print STDERR "
File:                     $file
String length:            $sl
Distance between islands: $di
Min. # of strings/island: $mo
";
if (!open    (FILE, '<'.$file))
{
  print "Can't open \"$file\"\n";
  exit;
}

my $filesize=-s $file;

binmode (FILE);
read (FILE, my $data, $filesize);

my @s;
my $cnt=0;
$s[$cnt]{'cnt'}=0;
my $lastp=0;
my $goodprintable=0;
while ($data =~ /([ -~]{$sl,}|([ -~]\x00){$sl,})/sg)
  {
     my $p = pos $data;
     my $t = $1;
     if ($p-$lastp>$di)
     {
      if ($goodprintable==1)
      {
        $cnt++;
        $goodprintable=0;
      }
      $s[$cnt]{'cnt'}=0;
      $s[$cnt]{'dat'}=[];
     }
     $t =~ s/\x00//gs if $t =~ /([ -~]\x00){2,}/s;
     $goodprintable = 1 if $t=~ /[a-z]{$sl}/i;
     #print STDERR "$t\n" if $t=~ /[a-z]{$sl}/i;
     $s[$cnt]{'dat'}[ $s[$cnt]{'cnt'} ]=$t;
     $s[$cnt]{'cnt'}++;
     $lastp = $p;
  }

close FILE;

for (my $i=0; $i<=$cnt; $i++)
{
  if ($s[$i]{'cnt'}>$mo)
  {
     #print ('-' x 80);
     #print "\n".$s[$i]{'cnt'}."\n" ;
     for (my $k=0; $k < $s[$i]{'cnt'}; $k++)
     {
        print $s[$i]{'dat'}[$k]."\n" ;
     }
  }
  else
  {
     # uncomment if you want to see 'meaningful' strings as well
     # even if they do not motu criteria
     #for (my $k=0; $k < $s[$i]{'cnt'}; $k++)
     #{
     #  if ($s[$i]{'dat'}[$k]=~ /[a-z]{$sl}/i)
     #  {
     #    #print ('-' x 80);
     #    print $s[$i]{'dat'}[$k]."\n" ;
     #  }
     #}
  }
}
