#!/usr/local/bin/perl
#
# @(#) cvs-repository.pl -- Modify CVS/Root and CVS/Repository
# @(#) $Id: cvs-repository.pl,v 1.2 2001/03/01 17:44:29 jaalto Exp $
#
#  File id
#
#	.Copyright (C) 2001 Jari Aalto
#	.$Contactid: jari.aalto@poboxes.com $
#	.Created:	2000-03
#	.Keywords:	Perl
#	.Perl:	        5.004
#
#	This program is free software; you can redistribute it and/or
#	modify it under the terms of the GNU General Public License as
#	published by the Free Software Foundation; either version 2 of
#	the License, or (at your option) any later version.
#
#	This program is distributed in the hope that it will be useful, but
#	WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#	General Public License for more details.
#
#	You should have received a copy of the GNU General Public License along
#	with this program; if not, write to the Free Software Foundation,
#	Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#   About program layout
#
#       The {{ }}} marks you see in this file are party of file "fold"
#       conrol package called folding.el (Unix Emacs lisp package).
#       ftp://ftp.csd.uu.se/pub/users/andersl/beta/ to get the latest.
#       There is also lines that look like # ....... &tag ... and they
#       are generated by Emacs Lisp package tinybm.el.
#
#   Funny identifiers at the top of file
#
#       The GNU RCS ident(1) program can print usefull information out
#       of all variables that are in format $ IDENTIFIER: text $
#       See also Unix man pages for command what(1) which outputs all lines
#       matching @( # ). Try commands:
#
#	    % what  PRGNAME
#	    % ident PRGNAME
#
#   Description
#
#	Call program with --help
#
#   End


use autouse 'Pod::Text'     => qw( pod2text );

use 5.004;
use strict;
use integer;
use English;
use Getopt::Long;
use File::Find;

    use vars qw ( $VERSION );

    #   This is for use of Makefile.PL and ExtUtils::MakeMaker
    #   So that it puts the tardist number in format YYYY.MMDD
    #   The REAL version number is defined later

    #   The following variable is updated by my Emacs setup whenever
    #   this file is saved

    $VERSION = '2001.0301';


# {{{ Initial setup
# ****************************************************************************
#
#   DESCRIPTION
#
#       Set global variables for the program
#
#   INPUT PARAMETERS
#
#	none
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

sub Initialize ()
{
    use vars qw
    (
	$debug
	$PROGNAME
	$LIB
	$FILE_ID
	$VERSION
	$CONTACT
	$URL
	$WIN32
    );
    $PROGNAME	= "cvs-repository.pl";
    $LIB	= $PROGNAME;
    my $id	= "$LIB.Initialize";
    $FILE_ID  = q$Id: cvs-repository.pl,v 1.2 2001/03/01 17:44:29 jaalto Exp $;
    $VERSION  = (split (' ', $FILE_ID))[2];
    $CONTACT  = "<jari.aalto\@poboxes.com>";
    $URL      = "http://poboxes.com/jari.aalto/";
    $WIN32    = 1   if  $OSNAME =~ /win32/i;
    $OUTPUT_AUTOFLUSH = 1;
}

# }}}



# ***************************************************************** &help ****
#
#   DESCRIPTION
#
#       Print help and exit.
#
#   INPUT PARAMETERS
#
#	$msg	[optional] Reason why function was called.-
#
#   RETURN VALUES
#
#       none
#
# ****************************************************************************

=pod

=head1 NAME

@(#) cvs-repository.pl - Chnage CVS repository file contents

=head1 README

CVS is a concurrent version control system and available for multiple
platforms at C<http://www.cvshome.com>. This program will help changing the
content of client files B<Root>, B<Repository>, B<Entries> and B<Tag>. From
time to time there is a need to change the repository locations and this
needs immediate changin in following files:

Before:

    CVS/Root		/cygdrive/g/data/version-control/cvsroot
    CVS/Repository	emacs/gnu-emacs/lisp

After:

    CVS/Root		/cygdrive/h/data/version-control/cvsroot
    CVS/Repository	emacs/gnu-emacs/lisp

In the above example, the Win32 http://www.cygwin.com/ hard disk repository
was changed from disk g (that possibly filled up) to a partition h. Any similar
change can be carried out with any of these files. The changes to the files are
made using perl code that is evaled and for the above situation the command
line parameters in Win32 would be:

    perl -S cvs-repository.pl --name "/Root$" --eval "s,/g/,/h/," .

=head1 SYNOPSIS

    cvs-repository.pl --name FILE-REGEXP --eval PERL-CODE DIR [DIR DIR ..]

=head1 OPTIONS

=head2 Gneneral options

=over 4

=item B<--name FILE-REGEXP>

Search files that match regexp for modification. The regexp is amtched against
absolute path name, so don't use "^Repository$" to match file exactly, but
the leasing forward slash for absolute name: "/Repository$"

=item B<--eval PERL-CODE>

Evaluate perl code for each line in the found file. The current line is available
at $ARG, so simple substrirutions s/search/substitute/ are the most used ones.
However, you can include any valid perl e.g in "do{ the; code; here }".

=back

=head2 Miscellaneous options

=over 4

=item B<--debug LEVEL>

Turn on debug with positive LEVEL number. Zero means no debug.

=item B<--help>

Print help

=item B<--test>

Run in test mode, do not actually do anything.

=item B<--verbose>

Print informational messages.

=item B<--Version>

Print contact and version information

=back

=head1 EXAMPLES

To move the repository from g disk to h disk for file "Root", when the
content is "/cygdrive/g/data/version-control/cvsroot". The prefix "Perl -S"
is for win32, where the program is searched along PATH environment
variable. With the B<--test> options the program will only print what
would happen and no actual changes are made.

    perl -S cvs-repository.pl --test --name "/Root$" --eval "s,/g/,/h/," .

=head1 TROUBLESHOOTING

<what to check in case of error or weird behavior>

=head1 ENVIRONMENT

No environment variables used.

=head1 FILES

None.

=head1 SEE ALSO

cvs(1) http://www.cvshome.com/

=head1 STANDARDS

No standards referenced.

=head1 BUGS

None known.

=head1 AVAILABILITY

CPAN entry is at http://www.perl.com/CPAN-local//scripts/ or
with author id at http://www.cpan.org/modules/by-authors/id/J/JA/JARIAALTO/

Reach author at jari.aalto@poboxes.com HomePage is at
http://poboxes.com/jari.aalto/

=head1 SCRIPT CATEGORIES

CPAN/Administrative

=head1 PREREQUISITES

None.

=head1 COREQUISITES

None.

=head1 OSNAMES

C<any>

=head1 VERSION

$Id: cvs-repository.pl,v 1.2 2001/03/01 17:44:29 jaalto Exp $

=head1 AUTHOR

Copyright (C) 2001 Jari Aalto. All rights reserved.
This program is free software; you can redistribute and/or modify program
under the same terms as Perl itself or in terms of Gnu General Public
licence v2 or later.

=cut


sub Help (;$)
{
    my $id  = "$LIB.Help";
    my $msg = shift;  # optional arg, why are we here...

    pod2text $PROGRAM_NAME;

    defined $msg  and  print $msg;

    exit 1;
}


# ************************************************************** &args *******
#
#   DESCRIPTION
#
#       Read and interpret command line arguments ARGV. Sets global variables
#
#   INPUT PARAMETERS
#
#	none
#
#   RETURN VALUES
#
#	none
#
# ****************************************************************************

sub HandleCommandLineArgs ()
{
    my    $id = "$LIB.HandleCommandLineArgs";

    use vars qw
    (
	$debug
	$verb
	$test
	$OPT_EVAL
	$FILE
    );


    my ( $version, $help, $binary );

    # .................................................... read args ...

    Getopt::Long::config( qw
    (
	no_ignore_case
        require_order
    ));

    GetOptions      # Getopt::Long
    (
	  "h|help"		=> \$help
	, "verbose"		=> \$verb
	, "Version"		=> \$version
	, "debug:i"		=> \$debug
	, "test"		=> \$test
	, "eval=s"		=> \$OPT_EVAL    #font "
	, "name=s"		=> \$FILE
    );

    $version        and die "$VERSION $PROGNAME $CONTACT $URL\n";
    $help           and Help();

    $debug = 1	    if  defined $debug  and  $debug == 0;
    $verb  = 1	    if  $debug;
    $verb  = 1	    if  $test;

    unless ( $FILE )
    {
	die "$id: What file to chnage? Supply --file option.";
    }

    unless ( $OPT_EVAL )
    {
	die "$id: How to change the content? Supply --eval option.";
    }

}

# ****************************************************************************
#
#   DESCRIPTION
#
#	Modify content of file
#
#   INPUT PARAMETERS
#
#	$file		Filename
#	$perl-code	Perl code to eval() for each line. Line is in $ARG
#
#   RETURN VALUES
#
#	none
#
# ****************************************************************************

sub FileModify ( $ $ )
{
    my $id = "$LIB.FileModify";
    my ( $file, $code ) = @ARG;

    local ($ARG, *FILE);
    my    $status;

    # ......................................................... read ...

    unless ( open FILE, "< $file" )
    {
	warn "$id: Cannot read [$file] $ERRNO";
	return;
    }

    binmode FILE;
    my @lines = <FILE>; close FILE;


    # ....................................................... change ...

    for ( @lines )
    {
	eval $code;
	if ( $EVAL_ERROR )
	{
	    warn "$id: PERL EVAL fail [$code] $EVAL_ERROR\n";
	    return;
	}
    }

    # ........................................................ write ...

    if ( $test )
    {
	print "$id: Would change $file => @lines";
    }
    else
    {
	unless ( open FILE, "> $file" )
	{
	    warn "$id: Cannot write [$file] $ERRNO";
	    return;
	}
	binmode FILE;
	print FILE @lines;
	close FILE;
    }

}

# ****************************************************************************
#
#   DESCRIPTION
#
#	See Module File::find
#
#   INPUT PARAMETERS
#
#	none
#
#   RETURN VALUES
#
#	none
#
# ****************************************************************************


sub wanted ()
{
    my $id 	 = "$LIB.wanted";

    local $ARG = $File::Find::name;      # complete pathname to the file
    my $dir    = $File::Find::dir;       # We are chdir()'d here


    if ( /$FILE/o )
    {
	$verb  and  print "$id: processing $ARG\n";

	FileModify $ARG, $OPT_EVAL;
    }
}

# ************************************************************** &main *******
#
#   DESCRIPTION
#
#       The start of the program
#
#   INPUT PARAMETERS
#
#	none
#
#   RETURN VALUES
#
#	none
#
# ****************************************************************************

sub Main ()
{
    Initialize();
    my $id  = "$LIB.Main";


    if ( grep /^--?d/, @ARGV )
    {
	print "$id: DEBUG ", join(' ', @ARGV), "\n";
    }


    HandleCommandLineArgs();


    unless ( @ARGV )
    {
	die "$id: What directories to search recursively?";
    }

    find ( \&wanted, @ARGV );

}

Main();

0;
__END__