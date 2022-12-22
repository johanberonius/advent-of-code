#!/usr/bin/perl

%v=map{s/ \D\w+/v($&)/g;split':'}<>;sub v{eval$v{$_[0]}}print v root

