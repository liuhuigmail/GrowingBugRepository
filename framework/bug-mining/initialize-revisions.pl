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

initialize-revisions.pl -- Initialize all revisions: identify the directory
layout and perform a sanity check for each revision.

=head1 SYNOPSIS

initialize-revisions.pl -p project_id -w work_dir [-s subproject]  [ -c component] 

=head1 OPTIONS

=over 5

=item B<-p C<project_id>>

The id of the project for which the meta data should be generated.

=item B<-w F<work_dir>>

The working directory used for the bug-mining process.

=item B<-s F<subproject>>

The subproject to be mined (if not the root directory)

=item B<-b C<bug_id>>

Only analyze this bug id. The bug_id has to follow the format B<(\d+)(:(\d+))?>.
Per default all bug ids, listed in the active-bugs csv, are considered.

=item B<-n C<project_name>>

In order to make the project name consistent before and after the version


=back

=cut
use warnings;
use strict;
use File::Basename;
use Cwd qw(abs_path);
use Getopt::Std;
use Pod::Usage;

use lib (dirname(abs_path(__FILE__)) . "/../core/");
use Constants;
use Project;
use DB;
use Utils;

my %cmd_opts;
getopts('p:b:w:s:n:', \%cmd_opts) or pod2usage(1);

pod2usage(1) unless defined $cmd_opts{p} and defined $cmd_opts{w};

my $PID = $cmd_opts{p};
my $BID = $cmd_opts{b};
my $WORK_DIR = abs_path($cmd_opts{w});
my $SUBPROJ = $cmd_opts{s}//".";
my $NAME = $cmd_opts{n};

# Check format of target bug id
if (defined $BID) {
    $BID =~ /^(\d+)(:(\d+))?$/ or die "Wrong version id format ((\\d+)(:(\\d+))?): $BID!";
}

# Add script and core directory to @INC
unshift(@INC, "$WORK_DIR/framework/core");

# Override global constants
$REPO_DIR = "$WORK_DIR/project_repos";
$PROJECTS_DIR = "$WORK_DIR/framework/projects";

# Create necessary directories
my $PROJECT_DIR = "$PROJECTS_DIR/$PID";
my $PATCH_DIR   = "$PROJECT_DIR/patches";
my $ANALYZER_OUTPUT = "$PROJECT_DIR/analyzer_output";
my $GEN_BUILDFILE_DIR = "$PROJECT_DIR/build_files";

-d $PROJECT_DIR or die "$PROJECT_DIR does not exist: $!";
-d $PATCH_DIR or die "$PATCH_DIR does not exist: $!";

system("mkdir -p $ANALYZER_OUTPUT $GEN_BUILDFILE_DIR");

# Temporary directory
my $TMP_DIR = Utils::get_tmp_dir();
system("mkdir -p $TMP_DIR");
system("mkdir -p $PROJECT_DIR/lib");

# Set up project
my $project = Project::create_project($PID);

#
# Initialize a specific version id.
#
sub _init_version {
    my ($project, $bid, $vid) = @_;

    my $work_dir = "${TMP_DIR}/${vid}";
    $project->{prog_root} = $work_dir;
    my $rev_id = $project->lookup("${vid}");
    
    # Use the VCS checkout routine, which does not apply the cached, possibly
    # minimized patch to obtain the buggy version.
    my $t;
    $project->{_vcs}->checkout_vid("${vid}", $work_dir ) or die "Cannot checkout $vid version";
    
    my $temp_work_dir=$work_dir;
    $work_dir .= "/$SUBPROJ/";
    $project->{prog_root} = $work_dir;
    
    
    system("mkdir -p $ANALYZER_OUTPUT/$bid");
    if (-e "$work_dir/pom.xml") {
        #here are two patterns : one is just deleting -SNAPSHOT , the other is changing the version and deleting -SNAPSHOT
    	 #system("sed -i \"s/<xmlsec\.version>2\.2\.0-SNAPSHOT<\/xmlsec\.version>/<xmlsec\.version>2\.2\.3-SNAPSHOT<\/xmlsec\.version>/g\"  `grep SNAPSHOT -rl $temp_work_dir`");
    	#sed -i \"s/-SNAPSHOT//g\"  `grep SNAPSHOT -rl $temp_work_dir`"
    	#system("sed -i \"s/\<bundle\.version\>2\.0-SNAPSHOT\<\\/bundle\.version\>/\<bundle\.version\>2\.0\<\\/bundle\.version\>/g\"  `grep SNAPSHOT -rl $temp_work_dir`");
    	
    	#system("sed -i \"s/\<xmlsec\.version\>2\..\..-SNAPSHOT\<\\/xmlsec\.version\>/\<xmlsec\.version\>2\.2\.3-SNAPSHOT\<\\/xmlsec\.version\>/g\"  `grep SNAPSHOT -rl $temp_work_dir`");
    	
    	#delete multi lines 
    	#system("sed -i  '/\<parent/,/parent\>/d' `grep parent -rl $work_dir` ");
    	
    	#system("cat $work_dir/pom.xml");
    	rename("$work_dir/build.xml", "$work_dir/build_init".'.bak');
    	
        # Run maven-ant plugin and overwrite the original build.xml whenever a maven build file exists
        my $cmd = " cd $work_dir" .
                  " && mvn ant:ant -Doverwrite=true 2>&1 -Dhttps.protocols=TLSv1,TLSv1.1,TLSv1.2,TLSv1.3 " .
                  " && patch build.xml $PROJECT_DIR/build.xml.patch 2>&1" .
                  " && rm -rf $GEN_BUILDFILE_DIR/$rev_id && mkdir -p $GEN_BUILDFILE_DIR/$rev_id 2>&1" .
                  " && cp maven-build.* $GEN_BUILDFILE_DIR/$rev_id 2>&1" .
                  " && cp build.xml $GEN_BUILDFILE_DIR/$rev_id 2>&1";
          
        my $try1=Utils::exec_cmd($cmd, "Convert Maven to Ant build file: " . $rev_id) ;
        # my $try1=system($cmd) ;
        if(!$try1){
        	system("sed -i \"s/-SNAPSHOT//g\"  `grep SNAPSHOT -rl $temp_work_dir`");
        	Utils::exec_cmd($cmd, "Convert Maven to Ant build file again : " . $rev_id) or next;
        } 
        
        if (-e "$GEN_BUILDFILE_DIR/$rev_id/build.xml"){
        	rename("$GEN_BUILDFILE_DIR/$rev_id/build.xml", "$GEN_BUILDFILE_DIR/$rev_id/build.xml".'.bak');
        	open(IN, '<'."$GEN_BUILDFILE_DIR/$rev_id/build.xml".'.bak') or die $!;
        	open(OUT, '>'."$GEN_BUILDFILE_DIR/$rev_id/build.xml") or die $!;
        	while(<IN>) {
            		$_ =~ s/name\=\".*from\-maven/name\=\"$NAME\-from\-maven/g;
            		print OUT $_;
        	}
        	close(IN);
        	close(OUT);
    	}
 	
 	if (-e "$GEN_BUILDFILE_DIR/$rev_id/maven-build.xml"){
        	rename("$GEN_BUILDFILE_DIR/$rev_id/maven-build.xml", "$GEN_BUILDFILE_DIR/$rev_id/maven-build.xml".'.bak');
        	open(IN, '<'."$GEN_BUILDFILE_DIR/$rev_id/maven-build.xml".'.bak') or die $!;
        	open(OUT, '>'."$GEN_BUILDFILE_DIR/$rev_id/maven-build.xml") or die $!;
        	while(<IN>) {
            		$_ =~ s/name\=\".*from\-maven/name\=\"$NAME\-from\-maven/g;
            		print OUT $_;
        	}
        	close(IN);
        	close(OUT);
    	}
 
 	
   	if (-e "$GEN_BUILDFILE_DIR/$rev_id/maven-build.properties"){
        	rename("$GEN_BUILDFILE_DIR/$rev_id/maven-build.properties", "$GEN_BUILDFILE_DIR/$rev_id/maven-build.properties".'.bak');
        	open(IN, '<'."$GEN_BUILDFILE_DIR/$rev_id/maven-build.properties".'.bak') or die $!;
        	open(OUT, '>'."$GEN_BUILDFILE_DIR/$rev_id/maven-build.properties") or die $!;
        	while(<IN>) {
            	#$_ =~ s/commons-collections4/commons-collections/g;
            	$_ =~ s/name\=\".*from\-maven/name\=\"$NAME\-from\-maven/g;
            	print OUT $_;
       	 }
        	close(IN);
        	close(OUT);
    	}
         
        #Utils::exec_cmd($cmd, "Convert Maven to Ant build file: " . $rev_id) or die;
        #system("cat $work_dir/maven-build.xml");
        $cmd = " cd $work_dir" .
               " && java -jar $LIB_DIR/analyzer.jar $work_dir $ANALYZER_OUTPUT/$bid maven-build.xml 2>&1";
        #Utils::exec_cmd($cmd, "Run build-file analyzer on maven-ant.xml.") or die;
	Utils::exec_cmd($cmd, "Run build-file analyzer on maven-ant.xml.")  ;#or next;
    
        # Fix broken dependency links
        my $fix_dep = "cd $work_dir && sed \'s\/https:\\/\\/oss\\.sonatype\\.org\\/content\\/repositories\\/snapshots\\//http:\\/\\/central\\.maven\\.org\\/maven2\\/\/g\' maven-build.xml >> temp && mv temp maven-build.xml";
        Utils::exec_cmd($fix_dep, "Fixing broken dependency links.");
        
        if (-e "$work_dir/maven-build.xml"){
        	rename("$work_dir/maven-build.xml", "$work_dir/maven-build.xml".'.bak');
        	open(IN, '<'."$work_dir/maven-build.xml".'.bak') or die $!;
        	open(OUT, '>'."$work_dir/maven-build.xml") or die $!;
        	while(<IN>) {
            		#$_ =~ s/commons-collections4/commons-collections/g;
            		$_ =~ s/name\=\".*from\-maven/name\=\"$NAME\-from\-maven/g;
            		print OUT $_;
        	}
        	close(IN);
        	close(OUT);
    	}
 
#   	if (-e "$work_dir/maven-build.properties"){
#        	rename("$work_dir/maven-build.properties", "$work_dir/maven-build.properties".'.bak');
#        	open(IN, '<'."$work_dir/maven-build.properties".'.bak') or die $!;
#        	open(OUT, '>'."$work_dir/maven-build.properties") or die $!;
#        	while(<IN>) {
#            	#$_ =~ s/commons-collections4/commons-collections/g;
#            	$_ =~ s/name\=\".*from\-maven/name\=\"$NAME\-from\-maven/g;
#            	print OUT $_;
#       	 }
#        	close(IN);
#        	close(OUT);
#        
#    	}

        # Get dependencies if it is maven-ant project
        my $download_dep = "cd $work_dir && ant -Dmaven.repo.local=\"$PROJECT_DIR/lib\" get-deps";
        Utils::exec_cmd($download_dep, "Download dependencies for maven-ant.xml.");
        #system($download_dep);
        
    }elsif (-e "$work_dir/build.xml") {
        my $cmd = " cd $work_dir" .
                  " && java -jar $LIB_DIR/analyzer.jar $work_dir $ANALYZER_OUTPUT/$bid build.xml 2>&1";
        Utils::exec_cmd($cmd, "Run build-file analyzer on build.xml.");
    } elsif (-e "$work_dir/build.gradle") {
        open(OUT, '>>'."$work_dir/build.gradle") or die $!;
        my $convert_cmd="\n".
                        "apply plugin: 'java'\n".
                        "apply plugin: 'maven'\n".
                        "task writeNewPom << {\n".
                        " pom {\n".
                        "project {\n".
                        "inceptionYear '2008'\n".
                        "licenses {\n".
                        "license {\n".
                        "name 'The Apache Software License, Version 2.0'\n".
                        "url 'http://www.apache.org/licenses/LICENSE-2.0.txt'\n".
                        "distribution 'repo'\n".
                        "}\n".
                        "}\n".
                        "}\n".
                        " }.writeTo(\"pom.xml\")\n".
                        "}\n".
                        "\n";
        print OUT $convert_cmd;
        close(OUT);
        print("$work_dir/build.gradle\n");
        my $trans_to_maven= " cd $work_dir".
                            " && gradle clean".
                            " && gradle writeNewPom";
                            #" && gradle writeNewPom ";
        Utils::exec_cmd($trans_to_maven, "Convert gradle to Maven build file: " . $rev_id) or next;

        
        my $cmd = " cd $work_dir" .
                  " && mvn ant:ant -Doverwrite=true 2>&1 -Dhttps.protocols=TLSv1.2" .
                  " && patch build.xml $PROJECT_DIR/build.xml.patch 2>&1" .
                  " && rm -rf $GEN_BUILDFILE_DIR/$rev_id && mkdir -p $GEN_BUILDFILE_DIR/$rev_id 2>&1" .
                  " && cp maven-build.* $GEN_BUILDFILE_DIR/$rev_id 2>&1" .
                  " && cp build.xml $GEN_BUILDFILE_DIR/$rev_id 2>&1";
        Utils::exec_cmd($cmd, "Convert Maven to Ant build file: " . $rev_id) or next;
        #Utils::exec_cmd($cmd, "Convert Maven to Ant build file: " . $rev_id) or die;
        #???

        $cmd = " cd $work_dir" .
               " && java -jar $LIB_DIR/analyzer.jar $work_dir $ANALYZER_OUTPUT/$bid maven-build.xml 2>&1";
        #Utils::exec_cmd($cmd, "Run build-file analyzer on maven-ant.xml.") or die;
        Utils::exec_cmd($cmd, "Run build-file analyzer on maven-ant.xml.") or next;
        

        # Fix broken dependency links
        my $fix_dep = "cd $work_dir && sed \'s\/https:\\/\\/oss\\.sonatype\\.org\\/content\\/repositories\\/snapshots\\//http:\\/\\/central\\.maven\\.org\\/maven2\\/\/g\' maven-build.xml >> temp && mv temp maven-build.xml";
        Utils::exec_cmd($fix_dep, "Fixing broken dependency links.");

        #download dependencies you need
        my $download_dep2 = "cd $PROJECT_DIR && ant -Dmaven.repo.local=\"$PROJECT_DIR/lib\" get-deps";
        Utils::exec_cmd($download_dep2, "Download dependencies for project");

        # Get dependencies if it is maven-ant project
        my $download_dep = "cd $work_dir && ant -Dmaven.repo.local=\"$PROJECT_DIR/lib\" get-deps";
        Utils::exec_cmd($download_dep, "Download dependencies for maven-ant.xml.");
        
    } 
    else {
        # TODO add support for other build systems
        if (-e "$work_dir"){
      	  die "Unsupported build system !";
    	}
    	else { 
    	    print("$work_dir does not exist !\n");
    	}
    }

    $project->initialize_revision($rev_id, "${vid}",$SUBPROJ);

    return ($rev_id, $project->src_dir("${vid}"), $project->test_dir("${vid}"));
}

#
# The Defects4J core framework requires certain metadata for each defect. This
# routine creates these artifacts, if necessary.
#
sub _bootstrap {
    my ($project, $bid) = @_;

    my $work_dir = "${TMP_DIR}/${bid}b";
    
    my $rev_id_buggy = $project->lookup("${bid}b");
    my $rev_id_fix = $project->lookup("${bid}f");
    $project->export_diff($rev_id_fix, $rev_id_buggy, "$PATCH_DIR/$bid.modify.patch", "$SUBPROJ");
    
    if (-z "$PATCH_DIR/$bid.modify.patch") {
        printf("      -> Skipping empty project modify\n");
        return;
    }

    my ($v1, $src_b, $test_b) = _init_version($project, $bid, "${bid}b");
    my ($v2, $src_f, $test_f) = _init_version($project, $bid, "${bid}f"); 

    die "Source directories don't match for buggy and fixed revisions of $bid" unless $src_b eq $src_f;
    die "Test directories don't match for buggy and fixed revisions of $bid" unless $test_b eq $test_f;

    # Create local patch so that we can use the D4J core framework.
    # Minimization doesn't matter here, which has to be done manually.
    $project->export_diff($v2, $v1, "$PATCH_DIR/$bid.src.patch", "$SUBPROJ/$src_f");
    $project->export_diff($v2, $v1, "$PATCH_DIR/$bid.test.patch", "$SUBPROJ/$test_f");
}

my @ids = $project->get_bug_ids();
if (defined $BID) {
    if ($BID =~ /(\d+):(\d+)/) {
        @ids = grep { ($1 <= $_) && ($_ <= $2) } @ids;
    } else {
        # single bid
        @ids = grep { ($BID == $_) } @ids;
    }
}
foreach my $bid (@ids) {
    printf ("%4d: $project->{prog_name}\n", $bid);

    # Clean up previously generated data
    system("rm -rf $ANALYZER_OUTPUT/${bid} $PATCH_DIR/${bid}.src.patch $PATCH_DIR/${bid}.test.patch");
    system("touch   $PATCH_DIR/${bid}.src.patch $PATCH_DIR/${bid}.test.patch");
    # Populate the layout map and patches directory
    _bootstrap($project, $bid);

    # Defects4J cannot handle empty patch files -> skip the sanity check since
    # these candidates are filtered in a later step anyway.
    if (-z "$PATCH_DIR/$bid.src.patch") {
        printf("      -> Skipping sanity check (empty source patch)\n");
        system("rm -rf $TMP_DIR && mkdir -p $TMP_DIR ");
        next;
    }

    # Clean the temporary directory
    Utils::exec_cmd("rm -rf $TMP_DIR && mkdir -p $TMP_DIR", "Cleaning working directory")
            or die "Cannot clean working directory";
    $project->{prog_root} = $TMP_DIR."/$SUBPROJ";
    $project->checkout_vid("${bid}f", $TMP_DIR, 1,$SUBPROJ) or die "Cannot checkout fixed version";
    $project->sanity_check();

}

print("\n--- Add the following to the <fileset> tag identified by the id 'all.manual.tests' in the <PROJECT_ID.build.xml> file ---\n");
system("cat $ANALYZER_OUTPUT/*/includes | sort -u | while read -r include; do echo \"<include name='\"\$include\"' />\"; done");
system("cat $ANALYZER_OUTPUT/*/excludes | sort -u | while read -r exclude; do echo \"<exclude name='\"\$exclude\"' />\"; done");

system("rm -rf $TMP_DIR");

