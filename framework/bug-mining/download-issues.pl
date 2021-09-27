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

download-issues.pl -- Collect all issues from the project issue tracker.

=head1 SYNOPSIS

download-issues.pl -g tracker_name -t tracker_project_id -o output_dir -f issues_file [-z organization_id] [-q query] [-u tracker_uri] [-l fetching_limit] [-D]

=head1 OPTIONS

=over 4

=item B<-g C<tracker_name>>

The source control tracker name, e.g., jira, github, google, or sourceforge.

=item B<-t C<tracker_project_id>>

The name used on the issue tracker to identify the project. Note that this might
not be the same as the Defects4j project name / id, for instance, for the
commons-lang project is LANG.

=item B<-o F<output_dir>>

The output directory for the fetched issues.

=item B<-f F<issues_file>>

The output file to write all issues ids and issues urls.

=item B<-z C<organization_id>>

The organization id required for the github issue tracker, it specifies the
organization the repo is under, e.g., apache.

=item B<-q C<query>>

The query (i.e., filter for bug type or label) sent to the issue tracker.
Suitable defaults for supported trackers are chosen so they identify only bugs.

=item B<-u C<tracker-uri>>

The URI used to locate the issue tracker. Suitable defaults have been chosen for
supported trackers, but you may change it, e.g., point it to a corporate GitHub
URI.

=item B<-l C<fetching_limit>>

The maximum number of issues to fetch at a time. Most issue trackers will limit
the number of results returned by the query, and suitable defaults have been
chosen for each supported tracker.

=item B<-D>

Debug: Enable verbose logging. Per default script is not verbose.

=back

=cut
use strict;
use warnings;

use Pod::Usage;
use File::Basename;
use Getopt::Std;
use URI::Escape;
use List::Util qw(all pairmap);
use JSON::Parse qw(json_file_to_perl);

use LWP::UserAgent; 
use Mozilla::CA;
use HTML::TreeBuilder;
use HTML::Element;

my %SUPPORTED_TRACKERS = (
    'google' => {
                    'default_tracker_uri' => 'https://storage.googleapis.com/google-code-archive/v2/code.google.com/',
                    'default_query' => 'label:type-defect',
                    'default_limit' => 1, # Google Code archive only returns one page at time
                    'build_uri'   => sub {
                                            my ($tracker, $project, $query, $start, $limit) = @_;
                                            die unless all {defined $_} ($tracker, $project, $query, $start, $limit);
                                            $start = $start + 1;
                                            my $uri = $tracker
                                                         . uri_escape($project)
                                                         . "/issues-page-$start.json";
                                            return $uri;
                                        },
                    'results' => sub {
                                        my ($path, $project,) = @_;
                                        die unless all {defined $_} ($path, $project,);
                                        my @results = ();
                                        my $p = json_file_to_perl($path) or return \@results;
                                        for my $issue (@{$$p{'issues'}}) {
                                            for my $label (@{$$issue{'labels'}}) {
                                                $label =~ /^Type-Defect.*/ or next;
                                                my $url = "https://storage.googleapis.com/google-code-archive/v2/code.google.com/". uri_escape($project) . "/issues/issue-" . $$issue{'id'} . ".json";
                                                push @results, ($$issue{'id'}, $url);
                                                last;
                                            }
                                        }
                                        return \@results;
                                    }
                },
    'jira' => {
                    'default_tracker_uri' => 'https://issues.apache.org/jira/',
                    'default_query' => 'issuetype = Bug ORDER BY key DESC',
                    'default_limit' => 200,
                    'build_uri' => sub {
                                            my ($tracker, $project, $query, $start, $limit) = @_;
                                            die unless all {defined $_} ($tracker, $project, $query, $start, $limit);
                                            my $uri = $tracker
                                                         . "sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?"
                                                         . "jqlQuery="
                                                         . uri_escape("project = ${project} AND ${query}")
                                                         . "&tempMax=${limit}"
                                                         . "&pager/start=${start}";
                                            return $uri;
                                        },
                    'results' => sub {
                                        my ($path,) = @_;
                                        die unless all {defined $_} ($path,);
                                        open FH, $path or die;
                                        my @results = ();
                                        while (my $line = <FH>) {
                                            chomp $line;
                                            $line =~ m[^\s*<key.*?>(.*?)</key>] or next;
                                            push @results, ($1, "https://issues.apache.org/jira/browse/$1");
                                        }
                                        close FH or die;
                                        return \@results;
                                },
                },
    'github' => {
    # https://v2.kkpp.cc https://api.github.com
                    'default_tracker_uri' => 'https://api.github.com/repos/',
                    'default_query' => '',
                    'default_limit' => 100,
                    'build_uri' => sub {
                                            my ($tracker, $project, $query, $start, $limit, $organization_id) = @_;
                                            die unless all {defined $_} ($tracker, $project, $query, $start, $limit);
                                            my $has_org_in_proj = $project =~ /.+\/.+/;
                                            die 'github requires an organization id argument' unless $has_org_in_proj or (defined $organization_id and $organization_id ne '');
                                            my $page = $start / $limit + 1;
                                            my $uri = $tracker
                                                         . ( $has_org_in_proj ? '' : "$organization_id/" ) . $project
                                                         . "/issues?state=all&"
                                                         . $query
                                                         . "&per_page=${limit}"
                                                         . "&page=${page}"; 
                                            return $uri;
                                        },
                    'results' => sub {
                                        my ($path,) = @_;
                                        die unless all {defined $_} ($path,);
                                        my @results = ();
                                        my $p = json_file_to_perl($path) or return \@results;
                                        for my $issue (@{$p}) {
                                            push @results, ($$issue{'number'}, $$issue{'html_url'});
                                        }
                                        return \@results;
                                }
                },
    'sourceforge' => {
                        'default_tracker_uri' => 'http://sourceforge.net/rest/p/',
                        'default_query' => '/bugs/?',
                        'default_limit' => 100,
                        'build_uri' => sub {
                                            my ($tracker, $project, $query, $start, $limit) = @_;
                                            die unless all {defined $_} ($tracker, $project, $query, $start, $limit);
                                            my $page = $start / $limit;
                                            my $uri = $tracker
                                                         . $project
                                                         . $query
                                                         . "&page=${page}"
                                                         . "&limit=${limit}";
                                            return $uri;
                                        },
                        'results' => sub {
                                        my ($path,) = @_;
                                        die unless all {defined $_} ($path,);
                                        my @results = ();

                                        # Collect tickets numbers
                                        my @ticket_nums = ();
                                        my $p = json_file_to_perl($path) or return \@results;
                                        for my $issue (@{$$p{'tickets'}}) {
                                            push @ticket_nums, $$issue{'ticket_num'};
                                        }
                                        # Collect tickets urls
                                        foreach my $ticket_num (@ticket_nums) {
                                            # E.g., https://sourceforge.net/p/<project_name>/bugs/<ticket_id>
                                            my $url = "https://sourceforge.net" . $$p{'tracker_config'}{'options'}{'url'} . $ticket_num;
                                            push @results, ($ticket_num, $url);
                                        }

                                        return \@results;
                                }
                },
    'bugzilla' => {
                        'default_tracker_uri' => 'https://bz.apache.org/bugzilla/',
                        'default_query' => '/buglist.cgi?',
                        'default_limit' => 0,
                        'build_uri' => sub {
                                            my ($tracker, $project, $query, $start, $limit) = @_;
                                            die unless all {defined $_} ($tracker, $project, $query, $start, $limit);
                                            my $uri = $tracker
                                                         . "/buglist.cgi?"
                                                         . "bug_status=RESOLVED&order=bug_id&limit=0&"
                                                         . "product=${project}"
                                                         . "&query_format=advanced&resolution=FIXED";
                                            return $uri;
                                        },
                        'results' => sub {
                                        my ($path,) = @_;
                                        die unless all {defined $_} ($path,);
                                        open FH, $path or die;
                                        my @results = ();
                                        while (my $line = <FH>) {
                                            chomp $line;
                                            $line =~ m[^\s*<bug_id>(.*?)</bug_id>] or next;
                                            push @results, ("$1", "https://bz.apache.org/bugzilla//show_bug.cgi?id=$1");
                                            #push @results, ("bz-$1", "https://bz.apache.org/bugzilla//show_bug.cgi?id=$1");
                                        }
                                        close FH or die;
                                        return \@results;
                                },
                }
);

my %cmd_opts;
getopts('g:t:o:f:z:q:u:l:D', \%cmd_opts) or pod2usage(1);

pod2usage(1) unless defined $cmd_opts{g} and defined $cmd_opts{t} and defined $cmd_opts{o} and defined $cmd_opts{f};

my $TRACKER_NAME = $cmd_opts{g};
if (! defined $SUPPORTED_TRACKERS{$TRACKER_NAME}) {
    die "Invalid tracker-name! Expected one of the following options: " . join ('|', sort keys (%SUPPORTED_TRACKERS)) . ".";
}
my %TRACKER = %{$SUPPORTED_TRACKERS{$TRACKER_NAME}};

my $TRACKER_ID = $cmd_opts{t};
my $OUTPUT_DIR = $cmd_opts{o};
my $ISSUES_FILE = $cmd_opts{f};
my $ORGANIZATION_ID = $cmd_opts{z};
my $QUERY = $cmd_opts{q} // $TRACKER{'default_query'};
my $TRACKER_URI = $cmd_opts{u} // $TRACKER{'default_tracker_uri'};
my $FETCHING_LIMIT = $cmd_opts{l} // $TRACKER{'default_limit'};
# Enable debugging if flag is set
my $DEBUG = 1 if defined $cmd_opts{D};
system("mkdir -p $OUTPUT_DIR");
print "----------------------------------------------\n";
my $GIVE_UP = 0; # no
for (my $start = 0; ; $start += $FETCHING_LIMIT) {
    my $uri = $TRACKER{'build_uri'}($TRACKER_URI, $TRACKER_ID, $QUERY, $start, $FETCHING_LIMIT, $ORGANIZATION_ID);
    my $project_in_file = $TRACKER_ID;
    $project_in_file =~ tr*/*-*;
    my $out_file = "${OUTPUT_DIR}/${project_in_file}-issues-${start}.txt";
    if (! -s $out_file) {
        print "Downloading ${uri} to ${out_file}\n" if $DEBUG;
        if($TRACKER_NAME eq "bugzilla"){
            my @bug_id_list = get_id_List($uri,$TRACKER_ID);
            #TODO do not support other organizations' bugzilla website
            my $res_temp="https://bz.apache.org/bugzilla/show_bug.cgi?ctype=xml";
            my $size = @bug_id_list;
            my $index=0;
            my $temp=0;
            # 执行 for 循环
            for( ; $index < $size;  ){
                $res_temp.="&id=$bug_id_list[$index]";
                $index=$index+1;
                $temp=$index%50;
                if($temp== 0){
                    my $ret_v = get_file($res_temp, $out_file);
                    $start +=50;
                    $out_file = "${OUTPUT_DIR}/${project_in_file}-issues-${start}.txt";
                    $res_temp="https://bz.apache.org/bugzilla/show_bug.cgi?ctype=xml";
                }
            }
            if($temp!=0){
                my $ret_v = get_file($res_temp, $out_file);
            }
            for($index=0;$index<$size;$index=$index+50){
                $out_file = "${OUTPUT_DIR}/${project_in_file}-issues-${index}.txt";
                #print "$out_file\n";
                my @results = @{$TRACKER{'results'}($out_file,$TRACKER_ID)};
                open(my $fh, ">>$ISSUES_FILE") or die "Cannot write to ${ISSUES_FILE}!";
                print $fh join ('', (pairmap {"$a,$b\n"} @results));
                close($fh);
            }
            last;
        }
        else {
            my $ret_val = get_file($uri, $out_file);
            if ($ret_val == 0) {
                if ($GIVE_UP == 0) {
                    die "Could not download ${uri} to ${out_file}";
                } else {
                    last;
                }
            }
        }
    } else {
        print "Skipping download of ${out_file}\n" if $DEBUG;
    }

    my @results = @{$TRACKER{'results'}($out_file,$TRACKER_ID)};
    if (@results) {
        open(my $fh, ">>$ISSUES_FILE") or die "Cannot write to ${ISSUES_FILE}!";
        print $fh join ('', (pairmap {"$a,$b\n"} @results));
        close($fh);
        # continue going because there may be more results
    } else {
        last;
    }

    if ($TRACKER_NAME eq "google") {
        $GIVE_UP = 1; # from now on, if there is an error at downloading Google
        # Code issues data, the script can give up as some data has already been
        # collected
    }
    if ($TRACKER_NAME eq "bugzilla") {
        last;
    }
}

sub get_file {
    my ($uri, $save_to) = @_;
    die unless all {defined $_} ($uri, $save_to);
    my $cmd = "curl -s -S -L -o ${save_to} \"${uri}\"";
    #print "!!!! $cmd\n";
    my $retval = system($cmd);
    return $retval == 0 ? 1 : 0;
}

sub get_id_List {
    my ($uri,$project_name)=@_;
    die unless all {defined $_} ($uri,$project_name);
    my $ua = LWP::UserAgent->new(ssl_opts => { verify_hostname => 0, });
    $ua->timeout(10);
    $ua->env_proxy;
    $ua->agent("Mozilla/8.0");
    #$ua->ssl_opts(=>0);
    my $host = "https://bz.apache.org/bugzilla//buglist.cgi?bug_status=RESOLVED&order=bug_id&limit=0&product=${project_name}&query_format=advanced&resolution=FIXED";
    my $doc="";
    my $response = $ua->get($host);
    $ua->default_headers;
    if ($response->is_success) {
        $doc=$response->decoded_content;
        #print $response->decoded_content;  # or whatever
    }
    else {
        die $response->status_line;
    }
    my $root = new HTML::TreeBuilder;
    $root->parse($doc);
    my $body=$root->find_by_tag_name('body');
    my $p=$body->find_by_attribute('id','bugzilla-body');#在当前节点及其子节点下寻找lang属性为es-MX的节点
    #$p1=$p->find_by_attribute('class','bz_buglist');#在当前节点及其子节点下寻找lang属性为es-MX的节点 bug list!!!
    my $p1=$p->find_by_attribute('class','bz_query_buttons');
    my $p2=$p1->find_by_attribute('type','hidden');
    my @names = $p2->attr('value');
    my @id_list=split',',$names[0];
    return @id_list;
}

