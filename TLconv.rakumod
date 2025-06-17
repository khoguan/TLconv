# 台羅音節數字版个正規表示式，使用 Raku (Perl 6) 程式語言。
# v0.9 2023-02-22 增加介音o，主要是欲予南管腔使用，因為南管个叫字，拄著
#   「瓜」、「杯」韻，介音攏愛叫o，毋是u。
# v0.91 小改前邊界、後邊界定義
# v0.92 小改純聲母、聲母定義
# v0.93 用 <  > 來定義聲母
# 作者：潘科元

unit module TLconv:ver<0.9.3>:auth<github:khoguan>:api<1>;

my regex 漢字 { <:Script<Han>> }
my regex 前邊界 { << || <?after <漢字>> }
my regex 後邊界 { >> || <?before <漢字>> }

#my regex 純聲母 { :i [ ph || th || kh || tsh || ts || ng || <[bghjklmnpst]> ]? };
#my regex 純聲母 { :i [ ph? || th? || kh? || tsh? || ng? || <[bghjlms]> ]? };
my regex 純聲母 { :i < p ph m b t th n l ts tsh s j k kh ng g h >? };

my regex 聲母 is export {
    <前邊界>
    :i [ ph? || th? || kh? || tsh? || ng? || <[bghjlms]> ]?
    <?before [<介音> || <韻腹>] >
};

my regex 介音 { :i [ir || er || i || u || o <?before a || e> ]? };

my regex 韻腹 {
    :i oo || ee || <[au]> || <[eio]> r? || <!after ir || er || i || u> [ng || m]
};

my regex 陰聲韻尾 { :i [i || u]? };

my regex 喉入聲尾 { :i [nnh || h]? };
my regex 鼻元音尾 { :i [nnh | nn]? };

my regex 鼻元音佮喉入聲尾 { :i [nnh || nn || h]? };

my regex 陰聲韻字 is export {
    <前邊界> <純聲母> <介音> <韻腹> <陰聲韻尾> <後邊界>
};

# -ngh / -nh / -mh 無算台羅正書法，總是有儂欲愛用著即款特殊韻母
my regex 陽聲韻尾 { :i ngh || ng || nh || n || mh || m };

my regex 陽聲韻字 is export {
    <前邊界> <純聲母> <介音> <韻腹> <陽聲韻尾> <後邊界>
};

my regex 入聲韻尾 { :i p || t || k || <陰聲韻尾>? <喉入聲尾> };

my regex 入聲韻字 is export {
    <前邊界> <純聲母> <介音> <韻腹> <入聲韻尾> <後邊界>
};

# 鼻音韻字佮入聲韻字有部份重疊，可比：-nnh
my regex 鼻音韻字 is export {
    [ <前邊界> <純聲母> <介音> <韻腹> <陰聲韻尾>? <鼻元音尾> <後邊界> ] ||
    [ <前邊界> [ :i ng || n || m ] <介音> <韻腹> <陰聲韻尾>? h? <後邊界> ]
};

my regex 非陰聲韻尾 { :i <陽聲韻尾> || <入聲韻尾> || nn };

my regex 非陰聲韻字 is export {
    <前邊界> <純聲母> <介音> <韻腹> <非陰聲韻尾> <後邊界>
};

my regex 韻尾 {
    [ <陰聲韻尾> <鼻元音佮喉入聲尾> ] || <非陰聲韻尾>
}

my regex 聲調數字 { <[1..9]> };

my regex TL is export {
    <前邊界>
    <純聲母> <介音> <韻腹> 
    <韻尾>
    <聲調數字>
    <後邊界>
};

=begin TL_tonemarks
U+0301 COMBINING ACUTE ACCENT         # 2nd tone
U+0300 COMBINING GRAVE ACCENT         # 3nd tone
U+0302 COMBINING CIRCUMFLEX ACCENT    # 5th tone
U+030C COMBINING CARON                # 6th tone
U+0304 COMBINING MACRON               # 7th tone
U+030D COMBINING VERTICAL LINE ABOVE  # 8th tone
U+030B COMBINING DOUBLE ACUTE ACCENT  # 9th tone
=end TL_tonemarks

my %調號 := {
    1 => '',
    2 => "\x301",
    3 => "\x300",
    4 => '',
    5 => "\x302",
    6 => "\x30C",
    7 => "\x304",
    8 => "\x30D",
    9 => "\x30B",
};

sub add-tone-mark(Str $unpak where *.elems == 1|2, Str $tonenum --> Str) {
    S/^(.)/{$0 ~ %調號{$tonenum}}/ with $unpak;
} 

=begin tls-tlt
tls: Tâi-Lô Sòo-jī; tlt: Tâi-lô Tiāu-hō
tls-tlt() 將台羅數字版轉做調號版，有兩種呼叫介面：
一、
tls-tlt($match) 
  佇caller遐，愛先用regex个 m/ / 指令掠著台羅音節个Match object：

  my $tlt;
  if $input ~~ /<TL>/ { $tlt = tls-tlt($/); }

二、
tls-tlt($str)
  佇caller遐，直接將有包含數字式台羅个字串(Str type)擲予 tls-tlt 進行轉換。

  for lines() {
      put tls-tlt($_);
  }

=end tls-tlt

multi sub tls-tlt(Match $tls --> Str) is export
{
    # A1/A2/A3/A5/A6/A7 可能是紙張大細个規格，若拄著，會特別提示。
    with ~$tls {
        when /^A<[123467]>$/ {
            $*ERR.put: "有將 $_ 轉做調號式台羅，請巡看 $_ 佇原稿是毋是指紙張規格。";
        }
    }

    return [~] $tls<TL><純聲母>,
               $tls<TL><介音>,
               add-tone-mark($tls<TL><韻腹>.Str, $tls<TL><聲調數字>.Str),
               $tls<TL><韻尾>;
}

multi sub tls-tlt(Str $tls --> Str) is export
{
    return S:g/(<TL>)/{tls-tlt($0)}/ with $tls;
}
