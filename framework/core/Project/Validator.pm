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
Project::Validator.pm -- L<Project> submodule for commons-validator.
=head1 DESCRIPTION
This module provides all project-specific configurations and subroutines for the
commons-validator project.
=cut
package Project::Validator;

use strict;
use warnings;

use Constants;
use Vcs::Git;

our @ISA = qw(Project);
my $PID  = "Validator";

sub new {
    @_ == 1 or die $ARG_ERROR;
    my ($class) = @_;

    my $name = "commons-validator";
    my $vcs  = Vcs::Git->new($PID,
                             "$REPO_DIR/$name.git",
                             "$PROJECTS_DIR/$PID/$BUGS_CSV_ACTIVE",
                             \&_post_checkout);

    return $class->SUPER::new($PID, $name, $vcs);
}

##
## Determines the directory layout for sources and tests
##
sub determine_layout {
    @_ == 2 or die $ARG_ERROR;
    my ($self, $rev_id) = @_;
    my $work_dir = $self->{prog_root};

    # Add additional layouts if necessary
    my $result = _ant_layout($work_dir) // _maven_layout($work_dir);
    
    if (-e "$work_dir/src/main/java" and -e "$work_dir/src/test/java"){
        $result = {src=>"src/main/java", test=>"src/test/java"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main/java" and -e "$work_dir/src/tests/java"){
        $result = {src=>"src/main/java", test=>"src/tests/java"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/testcases"){
        $result = {src=>"src/main", test=>"src/testcases"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/tests/junit"){
        $result = {src=>"src/main", test=>"src/tests/junit"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/tests"){
        $result = {src=>"src/main", test=>"src/tests"} unless defined $result;
    }
    elsif (-e "$work_dir/src/java" and -e "$work_dir/src/test"){
        $result = {src=>"src/java", test=>"src/test"} unless defined $result;
    }
    elsif (-e "$work_dir/src/java" and -e "$work_dir/src/tests"){
        $result = {src=>"src/java", test=>"src/tests"} unless defined $result;
    }
    else {
        system("tree -d $work_dir");
        die "Unknown directory layout" unless defined $result;
    }
    die "Unknown layout for revision: ${rev_id}" unless defined $result;
    return $result;
}

#
# Post-checkout tasks include, for instance, providing cached build files,
# fixing compilation errors, etc.
#
sub _post_checkout {
    my ($self, $rev_id, $work_dir) = @_;

    my $project_dir = "$PROJECTS_DIR/$self->{pid}";
    # Check whether ant build file exists
    unless (-e "$work_dir/build.xml") {
        my $build_files_dir = "$PROJECTS_DIR/$PID/build_files/$rev_id";
        if (-d "$build_files_dir") {
            Utils::exec_cmd("cp $build_files_dir/* $work_dir", "Copy generated Ant build file") or die;
        }
    }

     if (-e "$work_dir/build.xml"){
        rename("$work_dir/build.xml", "$work_dir/build.xml".'.bak');
        open(IN, '<'."$work_dir/build.xml".'.bak') or die $!;
        open(OUT, '>'."$work_dir/build.xml") or die $!;
        while(<IN>) {

            $_ =~ s/compile-tests/compile\.tests/g;
            #$_ =~ s/classesdir/classes\.dir/g;
            #$_ =~ s/testclasses\.dir/test\.classes\.dir/g;
            #$_ =~ s/<pathelement location="\${download\.lib\.dir}\/commons-logging\.jar"\/>/<pathelement location="\${download\.lib\.dir}\/commons-logging\.jar"\/> <pathelement location="\${download\.lib\.dir}\/commons-collections\.jar"\/>/g;
            
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/commons-logging\/jars\/commons-logging-1\.0\.3\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-logging\/commons-logging\/1\.0\.3\/commons-logging-1\.0\.3\.jar/g;
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/commons-beanutils\/jars\/commons-beanutils-1\.7\.0\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-beanutils\/commons-beanutils\/1\.7\.0\/commons-beanutils-1\.7\.0\.jar/g;
            $_ =~ s/http:\/\/mirrors\.ibiblio\.org\/pub\/mirrors\/maven\/commons-beanutils\/jars\/commons-beanutils-1\.7\.0\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-beanutils\/commons-beanutils\/1\.7\.0\/commons-beanutils-1\.7\.0\.jar/g;
            $_ =~ s/http:\/\/repo\.maven\.apache\.org\/maven2\/commons-beanutils\/commons-beanutils\/1\.9\.2\/commons-beanutils-1\.9\.2\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-beanutils\/commons-beanutils\/1\.9\.2\/commons-beanutils-1\.9\.2\.jar/g;
            
            $_ =~ s/https:\/\/repo\.maven\.org*/https:\/\/repo1\.maven\.org*/g;
            
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/commons-logging\/jars\/commons-logging-1\.0\.4\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-logging\/commons-logging\/1\.0\.4\/commons-logging-1\.0\.4\.jar/g;
            $_ =~ s/http:\/\/mirrors\.ibiblio\.org\/pub\/mirrors\/maven\/commons-logging\/jars\/commons-logging-1\.1\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-logging\/commons-logging\/1\.1\/commons-logging-1\.1\.jar/g;
            $_ =~ s/http:\/\/repo\.maven\.apache\.org\/maven2\/commons-logging\/commons-logging\/1\.2\/commons-logging-1\.2\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-logging\/commons-logging\/1\.2\/commons-logging-1\.2\.jar/g;
            
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/commons-digester\/jars\/commons-digester-1\.8\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\/commons-digester-1\.8\.jar/g;
            $_ =~ s/https:\/\/repo\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\/commons-digester-1\.8\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\/commons-digester-1\.8\.jar/g;
            $_ =~ s/http:\/\/mirrors.ibiblio.org\/pub\/mirrors\/maven\/commons-digester\/jars\/commons-digester-1\.8\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\/commons-digester-1\.8\.jar/g;
            $_ =~ s/http:\/\/mirrors.ibiblio.org\/maven\/commons-digester\/jars\/commons-digester-1\.8\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\/commons-digester-1\.8\.jar/g;
            $_ =~ s/http:\/\/repo\.maven\.apache\.org\/maven2\/commons-digester\/commons-digester\/1\.8\.1\/commons-digester-1\.8\.1\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.8\.1\/commons-digester-1\.8\.1\.jar/g;

            
            
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/commons-digester\/jars\/commons-digester-1\.6\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-digester\/commons-digester\/1\.6\/commons-digester-1\.6\.jar/g;
            $_ =~ s/http:\/\/www\.ibiblio\.org\/maven\/oro\/jars\/oro-2\.0\.8\.jar/https:\/\/repo1\.maven\.org\/maven2\/oro\/oro\/2\.0\.8\/oro-2\.0\.8\.jar/g;
            $_ =~ s/http:\/\/dojotoolkit.org\/svn\/dojo\/trunk\/buildscripts\/lib\/custom_rhino.jar/https:\/\/repo1\.maven\.org\/maven2\/org\/dojotoolkit\/custom_rhino\/0\.9\.0\/custom_rhino-0\.9\.0\.jar/g;
            
            $_ =~ s/http:\/\/repo\.maven\.apache\.org\/maven2\/commons-collections\/commons-collections\/3\.2\.1\/commons-collections-3\.2\.1\.jar/https:\/\/repo1\.maven\.org\/maven2\/commons-collections\/commons-collections\/3\.2\.1\/commons-collections-3\.2\.1\.jar/g;
            #support java8
            $_ =~ s/fork="false"/fork="true"/g;
            print OUT $_;
        }
        close(IN);
        close(OUT);
    }

    if (-e "$work_dir/maven-build.xml"){
        rename("$work_dir/maven-build.xml", "$work_dir/maven-build.xml".'.bak');
        open(IN, '<'."$work_dir/maven-build.xml".'.bak') or die $!;
        open(OUT, '>'."$work_dir/maven-build.xml") or die $!;
        while(<IN>) {
            $_ =~ s/compile-tests/compile\.tests/g;
            #$_ =~ s/classesdir/classes\.dir/g;
            #$_ =~ s/testclasses\.dir/test\.classes\.dir/g;
            
            
            #support java8
            $_ =~ s/fork="false"/fork="true"/g;
            print OUT $_;
        }
        close(IN);
        close(OUT);
    }
    #exclude the test you don't need
    if (-e "$work_dir/src/test/org/apache/commons/validator/EmailTest.java"){
        rename("$work_dir/src/test/org/apache/commons/validator/EmailTest.java", "$work_dir/src/test/org/apache/commons/validator/EmailTest.java".".bak");
        open(OUT, '>'."$work_dir/src/test/org/apache/commons/validator/EmailTest.java") or die $!;
        my $converted_file = `iconv -f iso-8859-1 -t utf-8 "$work_dir/src/test/org/apache/commons/validator/EmailTest.java.bak"`;
        print OUT $converted_file;
        close(OUT);
    }
    if (-e "$work_dir/src/test/java/org/apache/commons/validator/EmailTest.java"){
        rename("$work_dir/src/test/java/org/apache/commons/validator/EmailTest.java", "$work_dir/src/test/java/org/apache/commons/validator/EmailTest.java".".bak");
        open(OUT, '>'."$work_dir/src/test/java/org/apache/commons/validator/EmailTest.java") or die $!;
        my $converted_file = `iconv -f iso-8859-1 -t utf-8 "$work_dir/src/test/java/org/apache/commons/validator/EmailTest.java.bak"`;
        print OUT $converted_file;
        close(OUT);
    }
}


#
# This subroutine is called by the bug-mining framework for each revision during
# the initialization of the project. Example uses are: converting and caching
# build files or other time-consuming tasks, whose results should be cached.
#
sub initialize_revision {
    my ($self, $rev_id, $vid) = @_;
    $self->SUPER::initialize_revision($rev_id);

    my $work_dir = $self->{prog_root};
    my $result = _ant_layout($work_dir) // _maven_layout($work_dir);
    
    if (-e "$work_dir/src/main/java" and -e "$work_dir/src/test/java"){
        $result = {src=>"src/main/java", test=>"src/test/java"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main/java" and -e "$work_dir/src/tests/java"){
        $result = {src=>"src/main/java", test=>"src/tests/java"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/testcases"){
        $result = {src=>"src/main", test=>"src/testcases"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/tests/junit"){
        $result = {src=>"src/main", test=>"src/tests/junit"} unless defined $result;
    }
    elsif (-e "$work_dir/src/main" and -e "$work_dir/src/tests"){
        $result = {src=>"src/main", test=>"src/tests"} unless defined $result;
    }
    elsif (-e "$work_dir/src/java" and -e "$work_dir/src/test"){
        $result = {src=>"src/java", test=>"src/test"} unless defined $result;
    }
    elsif (-e "$work_dir/src/java" and -e "$work_dir/src/tests"){
        $result = {src=>"src/java", test=>"src/tests"} unless defined $result;
    }
    else {
        system("tree -d $work_dir");
        die "Unknown directory layout" unless defined $result;
    }
    
    $self->_add_to_layout_map($rev_id, $result->{src}, $result->{test});
    $self->_cache_layout_map(); # Force cache rebuild
}

#
# Distinguish between project layouts and determine src and test directories.
# Each _layout subroutine returns undef if it doesn't match the layout of the
# checked-out version. Otherwise, it returns a hash that provides the src and
# test directory, relative to the working directory.
#

#
# Existing Ant build.xml and default.properties
#
sub _ant_layout {
    @_ == 1 or die $ARG_ERROR;
    my ($dir) = @_;
    my $src  = `grep "source.home" $dir/default.properties 2>/dev/null`;
    my $test = `grep "test.home" $dir/default.properties 2>/dev/null`;

    # Check whether this layout applies to the checked-out version
    return undef if ($src eq "" || $test eq "");

    $src =~ s/\s*source.home\s*=\s*(\S+)\s*/$1/;
    $test=~ s/\s*test.home\s*=\s*(\S+)\s*/$1/;

    return {src=>$src, test=>$test};
}

#
# Generated build.xml (from mvn ant:ant) with maven-build.properties
#
sub _maven_layout {
    @_ == 1 or die $ARG_ERROR;
    my ($dir) = @_;
    my $src  = `grep "maven.build.srcDir.0" $dir/maven-build.properties 2>/dev/null`;
    my $test = `grep "maven.build.testDir.0" $dir/maven-build.properties 2>/dev/null`;

    return undef if ($src eq "" || $test eq "");

    $src =~ s/\s*maven\.build\.srcDir\.0\s*=\s*(\S+)\s*/$1/;
    $test=~ s/\s*maven\.build\.testDir\.0\s*=\s*(\S+)\s*/$1/;

    return {src=>$src, test=>$test};
}

1;
