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
use Test::Spec;
use lib qw{../lib ../../lib};
use App::MtAws::ConfigEngineNew;
use Data::Dumper;

sub context()
{
	$App::MtAws::ConfigEngineNew::context
}

sub localize(&)
{
	local $App::MtAws::ConfigEngineNew::context;
	shift->();
}


describe "option" => sub {
	it "should work" => sub {
		localize sub {
			option 'myoption';
			cmp_deeply context->{options}->{myoption}, {'name' => 'myoption'}
		}
	};
	it "should not overwrite existing option" => sub {
		localize sub {
			option 'myoption';
			cmp_deeply context->{options}->{myoption}, {'name' => 'myoption'};
			mandatory 'myoption';
			cmp_deeply context->{options}->{myoption}, {'name' => 'myoption', 'seen' => 1};
			option 'myoption';
			cmp_deeply context->{options}->{myoption}, {'name' => 'myoption', 'seen' => 1};
		}
	};
	it "should return option name as scalar" => sub {
		localize sub {
			my $name = option 'myoption';
			ok $name eq 'myoption';
		}
	};
};

describe "options" => sub {
	it "should work with one argument" => sub {
		localize sub {
			options 'myoption';
			cmp_deeply context->{options}->{myoption}, {'name' => 'myoption'}
		}
	};
	it "should work with many arguments" => sub {
		localize sub {
			options 'myoption1', 'myoption2';
			cmp_deeply context->{options}->{myoption1}, {'name' => 'myoption1'};
			cmp_deeply context->{options}->{myoption2}, {'name' => 'myoption2'};
		}
	};
	it "should not overwrite existing options" => sub {
		localize sub {
			options 'myoption1', 'myoption2';
			cmp_deeply context->{options}->{myoption1}, {'name' => 'myoption1'};
			cmp_deeply context->{options}->{myoption2}, {'name' => 'myoption2'};
			mandatory 'myoption1';
			cmp_deeply context->{options}->{myoption1}, {'name' => 'myoption1', 'seen' => 1};
			options 'myoption1';
			cmp_deeply context->{options}->{myoption1}, {'name' => 'myoption1', 'seen' => 1};
		}
	};
	it "should return option name as array" => sub {
		localize sub {
			my @res = options 'myoption1', 'myoption2';
			cmp_deeply [@res], ['myoption1', 'myoption2'];
		}
	};
	it "should return option name as scalar if just one option is specified" => sub {
		localize sub {
			my $name = options 'myoption';
			ok $name eq 'myoption';
		}
	};
	it "should return array length if several option names are passed and context is scalar" => sub {
		localize sub {
			my $name = options qw/myoption1 myoption2/;
			ok $name eq 2;
		}
	};
};


runtests unless caller;

1;