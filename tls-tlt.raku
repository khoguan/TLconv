#!/usr/bin/env raku

# 作者：潘科元
# v0.2 2023-02-22

=begin 程式說明
tls-tlt.raku 即个命令列程式，是將數字式台羅純文字檔轉換做調號式台羅純文字檔个
家私頭仔。

用法：
1. 將 TLconv.rakumod 佮 tls-tlt.raku 囥佇仝一个工作目錄內底，欲用進前，
   愛先確認 tls-tlt.raku 个檔案存取模式是「可執行」的。了後執行：

   ./tls-tlt.raku "數字式台羅文字檔名"

2. 程式會將轉換結果直接顯示佇螢幕畫面，這會使得用「輸出重新導向」个方式，
   將結果存檔起來：

   ./tls-tlt.raku "數字式台羅文字檔名" > "調號式台羅文字檔名"

   注意：輸出檔名毋通佮輸入檔名 號仝款哦！

3. 進階用法：
   會使一遍轉換超過一个以上个數字式台羅文字檔案，但是輸出會相連紲接落去。
   也會使接受 stdin 个輸入方式。這佮一般个 Unix/Linux 文字轉換程式个慣勢
   做法仝款。
=end 程式說明

use lib <.>;
use TLconv;

for lines() {
    unless /\S/ {
        .put;
        next;
    }
    put S:g/(<TL>)/{tls-tlt($0)}/;
}
