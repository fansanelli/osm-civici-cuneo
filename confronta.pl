#!/usr/bin/perl
use strict;
use warnings;

sub fix_name {
  my $name = $_[0];
  $name = $name =~ s/'//r;
  $name = $name =~ s/à/a/ri;
  $name = $name =~ s/è/e/ri;
  $name = $name =~ s/ì/i/ri;
  $name = $name =~ s/ò/o/ri;
  $name = $name =~ s/ù/u/ri;
  $name = $name =~ s/monsignore/monsignor/ri;
  $name = $name =~ s/lungogesso papa/lungogesso/ri;
  $name = $name =~ s/canonico/can./ri;
  return $name;
}

my @osmdata;
my @goodosmdata;
my $total=0;
my $found=0;
my $skip=0;

open(f1, "<$ARGV[0]");
while (my $line1 = <f1>) {
  chomp($line1);
  #            0               1               2       3                      4
  #1713467696	44.3771286	7.5265380	40	Corso Alcide de Gasperi
  my @values1 = split("\t", $line1, -1);
  if (scalar(@values1)>4) {
    if (index($values1[3], ";") != -1) {
      #CIVICI MULTIPLI
      my @civici = split(";", $values1[3], -1);
      foreach (@civici) {
        my $civico = $_;
        push @osmdata, uc fix_name($values1[4].$civico);
      }
    } else {
      push @osmdata, uc fix_name($values1[4].$values1[3]);
    }
  }
}
close(f1);

print "NOT FOUND ON OSM:\n";
open(f2, "<$ARGV[1]");
while (my $line2 = <f2>) {
  chomp($line2);
  my @values2 = split(";", $line2, -1);
  # NEW NEW SCHEMA (2024-01-05)
  #  0      1         2                 3               4            5               6
  #VIA;CIVICO;ESPONENTE;CIVICO_ANAGRAFICO;ZONA_STATISTICA;SEZIONE_ELET;ZONA_CENSIMENTO
  if (scalar(@values2)>6) {
    $total++;
    my $esponente = $values2[2] =~ /^[A-z]+$/ ? $values2[2] : '';
    my $comparable = uc fix_name($values2[0].$values2[1].$esponente);
    if (grep { $_ eq $comparable } @osmdata) {
      push @goodosmdata, $comparable,
      $found++;
    } else {
      print "$line2\n";
    }
  }
}
close(f2);

print "#.#.#.#.#.#.#.#.#.#.#.#.#.#.#\n";
print "Rows analyzed: $total\n";
print "Rows found: $found\n";
print "Rows skipped: $skip\n";
print "#.#.#.#.#.#.#.#.#.#.#.#.#.#.#\n";

print "BAD OSM DATA:\n";
foreach (@osmdata) {
  my $comparable = $_;
  if (!grep { $_ eq $comparable } @goodosmdata) {
      print "$comparable\n";
  }
}
