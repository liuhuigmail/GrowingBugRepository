#!/usr/bin/env perl
#
#-------------------------------------------------------------------------------
# Copyright (c) 2014-2019 René Just, Darioush Jalali, and Defects4J contributors.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#-------------------------------------------------------------------------------

=pod

=head1 NAME

minimize-patch.pl -- View and minimize patch in a visual diff editor. If a patch
is minimized, the script performs a few sanity checks: (1) whether the source
code and the test cases still compile and (2) whether the list of triggering
test cases is still the same. The script also recomputes all metadata by
rerunning the `get-metadata.pl` script if a patch has been minimized.

=head1 SYNOPSIS

minimize-patch.pl -p project_id -b bug_id -w work_dir -s sub_project

=head1 OPTIONS

=over 5

=item B<-p C<project_id>>

The id of the project for which the patch should be displayed.

=item B<-b C<bug_id>>

The id of the bug for which the patch should be displayed.

=item B<-w F<work_dir>>

The working directory used for the bug-mining process.

=item B<-s F<sub_project>>

The working directory used for the bug-mining process.


=back

=cut
use warnings;
use strict;
use FindBin;
use File::Basename;
use File::Compare;
use Cwd qw(abs_path);
use Getopt::Std;
use Pod::Usage;

use lib abs_path("$FindBin::Bin/../core");
use Constants;
use Project;

my %cmd_opts;
getopts('p:b:w:s:', \%cmd_opts) or pod2usage(1);

pod2usage(1) unless defined $cmd_opts{p} and defined $cmd_opts{b} and defined $cmd_opts{w}  ;

=pod

=head1 EDITOR

The default editor (merge tool) used to visualize patches is meld. A different
editor can be set via the environment variable D4J_EDITOR.

=cut
my $EDITOR = $ENV{"D4J_EDITOR"} // "meld";

my $PID = $cmd_opts{p};
my $BID = $cmd_opts{b};
my $WORK_DIR = abs_path($cmd_opts{w});
my $SUB_PROJECT =   $cmd_opts{s}//".";
# Check format of target version id
$BID =~ /^(\d+)$/ or die "Wrong version id format: $BID -- expected: (\\d+)!";

# Add script and core directory to @INC
unshift(@INC, "$WORK_DIR/framework/core");
# Override global constantsf
$REPO_DIR = "$WORK_DIR/project_repos";
$PROJECTS_DIR = "$WORK_DIR/framework/projects";

# Set the projects and repository directories to the current working directory.
my $PROJECTS_DIR = "$WORK_DIR/framework/projects";
my $PROJECTS_REPOS_DIR = "$WORK_DIR/project_repos";

# Patch
my $PATCH_DIR = "$PROJECTS_DIR/$PID/patches";
-d $PATCH_DIR or die "Cannot read patch directory: $PATCH_DIR";
my $src_patch = "$BID.src.patch";
-s "$PATCH_DIR/$src_patch" or die "Cannot read patch file or the file is empty: $PATCH_DIR/$src_patch";

# Triggering test cases
my $TRIGGER_TESTS_DIR = "$PROJECTS_DIR/$PID/trigger_tests";
-e $TRIGGER_TESTS_DIR or die "Cannot read trigger_tests directory: $TRIGGER_TESTS_DIR";
my $trigger_tests = "$TRIGGER_TESTS_DIR/${BID}";
-s "$trigger_tests" or die "Cannot read triggering tests file or the file is empty: $trigger_tests";

my $TMP_DIR = Utils::get_tmp_dir();
system("mkdir -p $TMP_DIR");

my $CHECKOUT_DIR = "$TMP_DIR/$PID-${BID}f";

# Set up project
my $project = Project::create_project($PID);
$project->{prog_root} = $CHECKOUT_DIR;
 
# Remove temporary checkout directory create a new one
system("rm -rf $CHECKOUT_DIR && mkdir -p $CHECKOUT_DIR");

# Minimize patch with Bugbuilder 
#system("$EDITOR $CHECKOUT_DIR");???
# Checkout v1
$project->{prog_root} = "$TMP_DIR/$PID-${BID}b/$SUB_PROJECT";
$project->checkout_vid("${BID}b",  "$TMP_DIR/$PID-${BID}b",1,$SUB_PROJECT) == 1 or die; 
$project->compile();
#$project->compile_tests();
my $src_path_buggy = $project->src_dir("${BID}b"); 
# Checkout v2
$project->{prog_root} = "$TMP_DIR/$PID-${BID}f/$SUB_PROJECT";
$project->checkout_vid("${BID}f",  "$TMP_DIR/$PID-${BID}f", 1,$SUB_PROJECT) == 1 or die;
$project->compile();
#$project->compile_tests();
my $src_path = $project->src_dir("${BID}f");

my $outputPath= "$TMP_DIR/$src_patch";
system("rm  -f $outputPath");


my $bbcmd = "java -jar $LIB_DIR/Bug_Builder.jar $TMP_DIR/$PID-${BID}b/$SUB_PROJECT/$src_path_buggy $TMP_DIR/$PID-${BID}f/$SUB_PROJECT/$src_path $outputPath";
#my $exec_status=Utils::exec_cmd($bbcmd, "Running BugBuilder to minimize patch   ") ;
print("$bbcmd \n");
system($bbcmd); 
if (! -e "$outputPath"){
	 system("rm -rf $TMP_DIR");
         die "Failed to generate the patch!";
}

system("mkdir -p $WORK_DIR/minimum_patches ; cp -f $outputPath $WORK_DIR/minimum_patches/$src_patch");
system("rm -rf $TMP_DIR/$PID-${BID}f");
$project->checkout_vid("${BID}f",  "$TMP_DIR/$PID-${BID}f", 1,$SUB_PROJECT) == 1 or die;
system("cat $outputPath");
$project->apply_patch($CHECKOUT_DIR, "$outputPath") or die "Cannot apply patch";


# Check whether patch could be successfully minimized

my $orig=`cd $CHECKOUT_DIR; git log | head -1 | cut -f2 -d' '`;
chomp $orig;
system("cd $CHECKOUT_DIR; git commit -a -m \"minimized patch\"");
my $min=`cd $CHECKOUT_DIR; git log | head -1 | cut -f2 -d' '`;
chomp $min;

# Does it still compile?
my $compile_log_file = "$TMP_DIR/$SUB_PROJECT/compile-log.txt";
system(">$compile_log_file");
unless ($project->compile($compile_log_file)) {
  system("cat $compile_log_file");
}
    
my $compile_tests_log_file = "$TMP_DIR/$SUB_PROJECT/compile_tests-log.txt";
system(">$compile_tests_log_file");
unless ($project->compile_tests($compile_tests_log_file)) {
   system("cat $compile_tests_log_file"); 
}

# Is the list of triggering test still the same?
my $local_trigger_tests = "$TMP_DIR/$SUB_PROJECT/trigger_tests";
system(">$local_trigger_tests");
$project->run_relevant_tests($local_trigger_tests);
system("grep \"^--- \" $trigger_tests | sort > $local_trigger_tests.sorted.original");
system("grep \"^--- \" $local_trigger_tests | sort > $local_trigger_tests.sorted.minimal");

if (compare("$local_trigger_tests.sorted.original", "$local_trigger_tests.sorted.minimal") == 1) {
   print("The list of triggering test cases has changed to:\n");
   system("cat $local_trigger_tests");
   die "the list of triggering test not the same! "
}

# Do triggering test cases fail due to the exact same (original) reason?
system(">$local_trigger_tests-reason.original");
system(">$local_trigger_tests-reason.minimal");
system("cat \"$local_trigger_tests.sorted.original\" | while read -r trigger_test_case; do " .
                "grep -A10 --no-group-separator \"^\$trigger_test_case\$\" $trigger_tests | grep -v \"	at \" >> $local_trigger_tests-reason.original; " .
                "grep -A10 --no-group-separator \"^\$trigger_test_case\$\" $local_trigger_tests | grep -v \"	at \" >> $local_trigger_tests-reason.minimal; " .
           "done");
           
# sort temp2.txt temp1.txt temp1.txt | uniq -u > temp3.txt ; cat temp3.txt temp2-temp1 should be empty (if temp2 is temp1's subset)
#system("cat $local_trigger_tests-reason.original");
#system("cat $local_trigger_tests-reason.minimal");
if (compare("$local_trigger_tests-reason.original", "$local_trigger_tests-reason.minimal") == 1) {
  print("Triggering test cases now fail due to other reasons:\n");
  system("cat $local_trigger_tests-reason.original");
  print("vs\n");
  system("cat $local_trigger_tests-reason.minimal");
  die "triggering test cases fail do not due to the exact same (original) reason! "
}

# Stack trace might have changed (e.g., line numbers), update it
system("cat $local_trigger_tests > $trigger_tests");

# Store minimized patch
system("cp -f $PATCH_DIR/$src_patch $PATCH_DIR/$src_patch.bak");
Utils::exec_cmd("cd $CHECKOUT_DIR; git diff $orig $min -- $src_path $src_path > $PATCH_DIR/$src_patch",
  "Export minimized patch") or die "Cannot export patch";

# Re-run get-metadata script as metadata might have changed
if (!Utils::exec_cmd("./get-metadata.pl -p $PID -w $WORK_DIR -b $BID", "Re-running get-metadata script as metadata might have changed")) {
	Utils::exec_cmd("cp $TMP_DIR/$SUB_PROJECT/$src_patch $PATCH_DIR", "Restore original patch")
        or die "Cannot restore patch";
}

# Remove temporary directory 
system("rm -rf $TMP_DIR");
