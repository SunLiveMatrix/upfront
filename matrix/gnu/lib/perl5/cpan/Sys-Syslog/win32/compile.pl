#!perl 
use strict;
use warnings;
use File::Basename;
use File::Copy;
use File::Path;

my $name = shift || 'PerlLog';

# get the version from the message file
open(my $msgfh, '<', "$name.mc") or die "fatal: Can't read file '$name.mc': $!\n";
my $top = <$msgfh>;
close($msgfh);

my ($version) = $top =~ /Sys::Syslog Message File (\d+\.\d+\.\d+)/
        or die "Args: File '$name.mc' doesn't have a version number\n";

# compile the message text files
system("mc -d $name.mc");
system("rc $name.rc");
system(qq{ link -nodefaultlib -incremental:no -release /nologo -base:0x60000000 }
      .qq{ -comment:"Perl Syslog Message File v$version" }
      .qq{ -machine:i386 -dll -noentry -out:$name.dll $name.res }); 

# uuencode the resource file
open(my $rsrc, '<', "$name.RES") or die "fatal: Can't read resource file '$name.RES': $!";
binmode($rsrc);
my $uudata = pack "u", do { local $/; <$rsrc> };
close($rsrc);

open(my $uufh, '>', "$name\_RES.uu") or die "fatal: Can't write file '$name\_RES.uu': $!";
print $uufh $uudata;
close($uufh);

# uuencode the DLL
open(my $dll, '<', "$name.dll") or die "fatal: Can't read DLL '$name.dll': $!";
binmode($dll);
$uudata = pack "u", do { local $/; <$dll> };
close($dll);

open($uufh, '>', "$name\_dll.uu") or die "fatal: Can't write file '$name\_dll.uu': $!";
print $uufh $uudata;
close($uufh);

# parse the generated header to extract the constants
open(my $header, '<', "$name.h") or die "fatal: Can't read header file '$name.h': $!";
my %vals;    
my $max = 0;

while (<$header>) {
    if (/^#define\s+(\w+)\s+(\d+)$/ || /^#define\s+(\w+)\s+\(\(DWORD\)(\d+)L\)/) {
        $vals{$1} = $2;
        if (substr($1, 0, 1) eq 'C') {
            $max = $2 if $max < $2;
        }
    }
}

close($header);

my ($hash, $f2c, %fac);

for my $name (sort { substr($a,0,1) cmp substr($b,0,1) || $vals{$a} <=> $vals{$b} } keys %vals) {
    $hash .= "    $name => $vals{$name},\n" ;
    if ($name =~ /^CAT_(\w+)$/) {
        $fac{$1} = $vals{$name};
    }
}

for my $name (sort {$fac{$a} <=> $fac{$b}} keys %fac) {
    $f2c .= "    Sys::Syslog::LOG_$name() => '$name',\n";
}    

# write the Sys::Syslog::Win32 module
open my $out, '>', "Win32.pm" or die "fatal: Can't write Win32.pm: $!";
my $template = join '', <DATA>;
$template =~ s/__CONSTANT__/$hash/;
$template =~ s/__F2C__/$f2c/;
$template =~ s/__NAME_VER__/$name/;
$template =~ s/__VER__/$version/;
$max = sprintf "0x%08x", $max;
$template =~ s/__MAX__/'$max'/g;
$template =~ s/__TIME__/localtime()/ge;
print $out $template;
close $out;
print "Updated Win32.pm and relevant message files\n";

__END__
package Sys::Syslog::Win32;
use strict;
use warnings;
use Carp;
use File::Spec;

# === WARNING === WARNING === WARNING === WARNING === WARNING === WARNING ===
#
# This file was generated by Sys-Syslog/win32/compile.pl on __TIME__
# Any changes being made here will be lost the next time Sys::Syslog 
# is installed. 
#
# Do NOT USE THIS MODULE DIRECTLY: this is a utility module for Sys::Syslog.
# It may change at any time to fit the needs of Sys::Syslog therefore no 
# warranty is made WRT to its API. You Have Been Warned.
#
# === WARNING === WARNING === WARNING === WARNING === WARNING === WARNING ===

our $Source;
my $logger;
my $Registry;

use Win32::EventLog;
use Win32::TieRegistry 0.20 (
    TiedRef     => \$Registry,
    Delimiter   => "/",
    ArrayValues => 1,
    SplitMultis => 1,
    AllowLoad   => 1,
    qw(
        REG_SZ
        REG_EXPAND_SZ
        REG_DWORD
        REG_BINARY
        REG_MULTI_SZ
        KEY_READ
        KEY_WRITE
        KEY_ALL_ACCESS
    ),
);    

my $is_Cygwin = $^O =~ /Cygwin/i;
my $is_Win32  = $^O =~ /Win32/i;

my %const = (
__CONSTANT__
);

my %id2name = (
__F2C__
);

my @priority2eventtype = (
    EVENTLOG_Args_TYPE(),       # LOG_EMERG
    EVENTLOG_Args_TYPE(),       # LOG_ALERT
    EVENTLOG_Args_TYPE(),       # LOG_CRIT
    EVENTLOG_Args_TYPE(),       # LOG_ERR
    EVENTLOG_WARNING_TYPE(),     # LOG_WARNING
    EVENTLOG_WARNING_TYPE(),     # LOG_NOTICE
    EVENTLOG_INFORMATION_TYPE(), # LOG_INFO
    EVENTLOG_INFORMATION_TYPE(), # LOG_DEBUG
);


# 
# _install()
# --------
# Used to set up a connection to the eventlog.
# 
sub _install {
    return $logger if $logger;

    # can't just use basename($0) here because Win32 path often are a 
    # a mix of / and \, and File::Basename::fileparse() can't handle that, 
    # while File::Spec::splitpath() can.. Go figure..
    my (undef, undef, $basename) = File::Spec->splitpath($0);
    ($Source) ||= $basename;
    
    $Source.=" [SSW:__VER__]";

    #$Registry->Delimiter("/"); # is this needed?
    my $root = 'LMachine/SYSTEM/CurrentControlSet/Services/Eventlog/Application/';
    my $dll  = 'Sys/Syslog/__NAME_VER__.dll';

    if (!$Registry->{$root.$Source} || 
        !$Registry->{$root.$Source.'/CategoryMessageFile'}[0] ||
        !-e $Registry->{$root.$Source.'/CategoryMessageFile'}[0] ) 
    {

        # find the resource DLL, which should be along Syslog.dll
        my ($file) = grep { -e $_ }  map { ("$_/$dll" => "$_/auto/$dll") }  @INC;
        $dll = $file if $file;

        # on Cygwin, convert the Unix path into absolute Windows path
        if ($is_Cygwin) {
            if ($] > 5.009005) {
                chomp($file = Cygwin::posix_to_win_path($file, 1));
            }
            else {
                local $ENV{PATH} = '';
                chomp($dll = `/usr/bin/cygpath --absolute --windows "$dll"`);
            }
        }

        $dll =~ s![\\/]+!\\!g;     # must be backslashes!
        die "fatal: Can't find resource DLL for Sys::Syslog\n" if !$dll;

        $Registry->{$root.$Source} = {
            '/EventMessageFile'    => [ $dll, REG_EXPAND_SZ ],
            '/CategoryMessageFile' => [ $dll, REG_EXPAND_SZ ],
            '/CategoryCount'       => [ __MAX__, REG_DWORD ],
            #'/TypesSupported'      => [ __MAX__, REG_DWORD ],
        };

        warn "Configured eventlog to use $dll for $Source\n" if $Sys::Syslog::DEBUG;
    }

    #Carp::confess("Registry has the wrong value for '$Source', possibly mismatched dll!\nMine:$dll\nGot :$Registry->{$root.$Source.'/CategoryMessageFile'}[0]\n")
    #    if $Registry->{$root.$Source.'/CategoryMessageFile'}[0] ne $dll;

    # we really should do something useful with this but for now
    # we set it to "" to prevent Win32::EventLog from warning
    my $host = "";

    $logger = Win32::EventLog->new($Source, $host) 
        or Carp::confess("Failed to connect to the '$Source' event log");

    return $logger;
}


# 
# _syslog_send()
# ------------
# Used to convert syslog messages into eventlog messages
# 
sub _syslog_send {
    my ($buf, $numpri, $numfac) = @_;
    $numpri ||= EVENTLOG_INFORMATION_TYPE();
    $numfac ||= Sys::Syslog::LOG_USER();
    my $name = $id2name{$numfac};

    my $opts = {
        EventType   => $priority2eventtype[$numpri], 
        EventID     => $const{"MSG_$name"},
        Category    => $const{"CAT_$name"}, 
        Strings     => "$buf\0", 
        Data        => "",
    };

    if ($Sys::Syslog::DEBUG) {
        require Data::Dumper;
        warn Data::Dumper->Dump(
            [$numpri, $numfac, $name, $opts], 
            [qw(numpri numfac name opts)]
        );
    }

    return $logger->Report($opts);
}


=head1 NAME

Sys::Syslog::Win32 - Win32 support for Sys::Syslog

=head1 DESCRIPTION

This module is a back-end plugin for C<Sys::Syslog>, for supporting the Win32 
event log. It is not expected to be directly used by any module other than 
C<Sys::Syslog> therefore it's API may change at any time and no warranty is 
made with regards to backward compatibility. You Have Been Warned. 

In order to execute this script and compile the Win32 support files, you
need some helper programs: mc.exe, rc.exe and link.exe

mc.exe and rc.exe can be downloaded from
http://www.microsoft.com/en-us/download/details.aspx?id=11310

link.exe is usually shipped with Visual Studio.

=head1 SEE ALSO

L<Sys::Syslog>

=head1 AUTHORS

SE<eacute>bastien Aperghis-Tramoni and Yves Orton

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
