#!/usr/bin/perl

# mt-aws-glacier - Amazon Glacier sync client
# Copyright (C) 2012-2013  Victor Efimov
# http://mt-aws.com (also http://vs-dev.com) vs@vs-dev.com
# License: GPLv3
#
# This file is part of "mt-aws-glacier"
#
#    mt-aws-glacier is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    mt-aws-glacier is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use warnings;
use utf8;
use Test::More tests => 10;
use lib qw{.. ../lib ../../lib};
use Data::Dumper;
use TestUtils;


for (
	[qw!sync --config glacier.cfg --vault myvault --journal j --dir a!],
	[qw!purge-vault --config glacier.cfg --vault myvault --journal j!],
	[qw!restore --config glacier.cfg --vault myvault --journal j --dir a --max-number-of-files 1!],
	[qw!restore-completed --config glacier.cfg --vault myvault --journal j --dir a!],
	[qw!check-local-hash --config glacier.cfg --journal j --dir a!],
) {
	fake_config sub {
		disable_validations qw/journal secret key filename dir/ => sub {
			my $res = config_create_and_parse(@$_, '--dry-run');
			ok !($res->{errors}||$res->{warnings}), "$_->[0] should accept dry-run";
			ok $res->{options}->{'dry-run'};
		}
	}
}

1;