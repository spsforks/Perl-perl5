#!./perl -w
use strict;

use Test::More;
use Config;

BEGIN {
    plan(skip_all => "GDBM_File was not built")
	unless $Config{extensions} =~ /\bGDBM_File\b/;

    # https://rt.perl.org/Public/Bug/Display.html?id=117967
    plan(skip_all => "GDBM_File is flaky in $^O")
        if $^O =~ /darwin/;

    plan(tests => 8);
    use_ok('GDBM_File');
}

unlink <Op_dbmx*>;

my %h;
my $db = tie(%h, 'GDBM_File', 'Op_dbmx', GDBM_WRCREAT, 0640);
isa_ok($db, 'GDBM_File');
SKIP: {
     my $name = eval { $db->dbname } or do {
         skip "gdbm_setopt GET calls not implemented", 6
             if $@ =~ /GDBM_File::dbname not implemented/;
     };
     is($db->dbname, 'Op_dbmx', 'get dbname');
     is(eval { $db->dbname("a"); }, undef, 'dbname - bad usage');
     is($db->flags, GDBM_WRCREAT, 'get flags');
     is($db->sync_mode, 0, 'get sync_mode');
     is($db->sync_mode(1), 1, 'set sync_mode');
     is($db->sync_mode, 1, 'get sync_mode');
}

unlink <Op_dbmx*>;