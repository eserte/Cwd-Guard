use strict;
use warnings;
use Test::More;

use Cwd qw/getcwd/;
use Cwd::Guard qw/cwd_guard/;
use File::Temp qw/tempdir/;

plan skip_all => "Safe renames only possible with fchdir"
    if !Cwd::Guard::USE_FCHDIR;

my $tempdir = tempdir(CLEANUP => 1);
my $olddir = "$tempdir/foo";
my $newdir = "$tempdir/bla";
mkdir $olddir;
chdir $olddir or die $!;

{
    my $guard = cwd_guard $tempdir;
    rename $olddir, $newdir or die $!;
}

is getcwd, $newdir, 'can change back to renamed directory';

chdir '/'; # so tempdir can do a cleanup

done_testing;

__END__
