#!/usr/bin/perl -W
#
# Copyright (C) 2004 by Anuradha Ratnaweera
#
# This library is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the
# License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#

use strict;

my %trans = ();
my $id;
my $str;

while (<>) {
	if (/^\s*msgid\s+/) {
		my @id = ();
		s/^\s*msgid\s+(.*)\s*$/$1/;
		my $i = 0;
		$id[$i++] = $_;

		$_ = <>;
		until (/^\s*msgstr\s+/) {
			s/^\s*(.*)\s*$/$1/;
			$id[$i++] = $_;
			$_ = <> or die "Error reading data file\n";
		}

		my @str = ();
		s/^\s*msgstr\s+(.*)\s*$/$1/;
		$i = 0;
		$str[$i++] = $_;

		$_ = <>;
		until (not defined $_ or /^\s*$/) {
			s/^\s*(.*)\s*$/$1/;
			$str[$i++] = $_;
			$_ = <>;
		}

		$trans{join "\n", @id} = join "\n", @str;
	}
}

foreach my $i (sort keys %trans) {
	$i =~ s/[\._\&]//g;
	print("msgid $i\n");
	print("mststr $trans{$i}\n");
	print("\n");
}

exit 0;

