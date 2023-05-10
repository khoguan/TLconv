#!/usr/bin/env raku

use lib <.>;
use TL_conv;

#my @音節檔 = <imtsiat.txt>;
#my @音節檔 = <imtsiat.txt syl-dia.txt>;
#my @音節檔 = <imtsiat.txt syl-dia.txt 泉古dia.txt>;
#my @音節檔 = <syl-num.txt>;
#my @音節檔 = <泉古num.txt>;
my @音節檔 = <syl-num2.txt>;

#.put for @音節檔;

=begin old
for $ims.lines {
    if /<TL>/ {
        if $_ eq $/.Str {
            put "掠著「$_」";
        }
        else {
            put "RE有掠著，但是無一致：原音節是「$_」，掠著个是「$/.Str」";
        }
    } else {
        put "RE無掠著，原音節是「$_」";
    }
}
=end old


sub liah(Str $im --> Str) {
    if $im ~~ /<TL>/ {
        return $/.Str;
    } else {
        return "掠無成";
    }
}

sub liah-match(Str $im --> Match) {
    if $im ~~ /<TL>/ {
        return $/;
    } else {
        fail "掠無成";
    }
}

my @ims = IO::ArgFiles.new(@音節檔).lines;

#=begin debug
use Test;
plan @ims.elems;

for @ims -> $im {
    is liah($im), $im, "掠「$im」";
}
#=end debug

=begin conv
# 台羅數字版輸出做台羅調號版
for @ims -> $im {
    put tls-tlt(liah-match($im));
}
=end conv
