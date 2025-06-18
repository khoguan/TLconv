# TLconv 數字式、調號式台語羅馬字互轉程式

Author: 潘科元 khoguanp@yahoo.com  
Date: 2023-02-22, 2025-06-17
Version: 0.3
License: 本軟體予社會自由使用，作者無為使用者負擔任何責任。汝若修改本軟體，
請寄一份予作者參考利用。

## 特色

使用教育部台羅个拼寫法，連老泉腔（有 ir / er / ere / irn / irt / irm .... 个韻母），
古泉腔（有 irinn / irng / iro .... 韻母）都有法度正確轉換做調號式。

## 進度

1. 數字式台語羅馬字轉做調號式台語羅馬字，有做出一个 Raku module 佮一支獨立个程式。
2. 調號式台語羅馬字轉做數字式台語羅馬字，猶未做。

## 說明

一、`TLconv.rakumod` 是將教育部版个數字式台語羅馬字轉換做調號式台語羅馬字个
Raku module。

module 內底提供一个函式 `tls-tlt()`，但是有兩種呼叫方式，也就是會使接受兩種
無仝型別个引數，所執行个動作無仝（C++ 叫做 `overloading function`，Raku 叫做
`multi-dispatch routine`）。

汝寫个 Raku 程式，欲叫用 `TLconv` module，著愛佇頭前先寫：

```raku
  use lib <.>;  # TLconv.rakumod 佮汝个程式囥佇仝一个目錄內。
  use TLconv;
```

以下是 `tls-tlt()` 函式个說明：

`tls` 是 Tâi-Lô Sòo-jī（台羅數字）; `tlt` 是 Tâi-lô Tiāu-hō（台羅調號）
`tls-tlt()` 就是用來將台羅數字版轉做調號版个函式，有兩種呼叫介面：

1. `tls-tlt($match)` 

  `$match` 是一个有可能是數字式台羅个單音節，經過咱个程式比對了後，
  確定有符合數字式台羅音節个構成條件（聲母+韻母+數字聲調），
  所得著个一个 Raku `Match class` 个 `object`（佇遮就是指 `$match`
  迄个變數）。了後將 `$match` 擲予 `tls-tlt()` 函式做轉換，就會得著
  一个調號式台羅音節。做法是佇 caller 遐，先用 regex 个 `m/ /` 相關个指令
  掠著台羅音節个 Match object：

  ```raku
  my $input;  # 可比講將一篇文本進行音節分切，了後共每一个音節 assign 予 `$input`
  my $tlt;    # 欲寄囥後手轉換出來个調號式台羅音節

  # 假使 `$input` 內底个字串有符合台羅音節个構造，按呢就會使放心共伊交予
  # `tls-tlt()` 轉做調號式音節
  if $input ~~ /<TL>/ { $tlt = tls-tlt($/); }
  ```

  注意 `/ /` 內底个 <TL> 就是我佇 `TLconv.rakumod` 內底提供出來个一个對應數字式
  台羅音節个 regular expression（RE，正規表示式）。`if $input ~~ /<TL>/` 个意思
  就是講「假使 `$input` 內中个字串確實有符合台羅音節个構造」。
  
  這是一種較低階个使用方式，若是下面欲講个另外一種呼叫介面，伊內部个實作方式就是對遮
  閣進一步來處理濟音節、長文本个數字式台羅轉做調號式。

2. `tls-tlt($str)`

  佇 caller 遐，直接將有包含數字式台羅个字串(Str type)，無限定是毋是單音節，
  規篇台羅文章嘛無差，擲予 tls-tlt 進行轉換，來紡出正式版个調號式台羅。
  Lò-lò長个輸入字串內底若有無符合台羅結構个音節，可比講英文多音節單字，
  按呢本函式會照原樣輸出迄部份。

  ```raku
  for lines() {
      put tls-tlt($_);
  }
  ```

二、`tls-tlt.raku` 命令列程式，是將數字式台羅純文字檔轉換做調號式台羅純文字檔个
軟體家私。

### 用法：

1. 將 `TLconv.rakumod` 佮 `tls-tlt.raku` 囥佇仝一个工作目錄內底，欲用進前，
   愛先確認 `tls-tlt.raku` 个檔案存取模式是「可執行」--个。了後執行：
   
  ```
  ./tls-tlt.raku "數字式台羅文字檔名.txt"
  ```
2. 程式會將轉換結果直接顯示佇螢幕畫面，這會使得用「輸出重新導向」个方式，
   將結果存檔起來：
   
  ```
  ./tls-tlt.raku "數字式台羅文字檔名.txt" > "調號式台羅文字檔名.txt"
  ```
  注意：
  * 「輸入檔名」（來源檔）佮「輸出檔名」（結果檔）著愛號無仝款名，shell 才袂未曾未
  就共來源檔清空去。
  * 佇 Windows CMD（所謂 DOS 視窗）/ Powershell 內底使用，愛扑：

  ```
     raku tls-tlt.raku "數字式台羅文字檔名.txt" > "調號式台羅文字檔名.txt"
  ```

3. 進階用法：
   會使一遍轉換超過一个以上个數字式台羅文字檔案，但是輸出會相連紲接落去。
   也會使接受 stdin 个輸入方式。這佮一般个 Unix/Linux 文字轉換程式个慣勢
   做法仝款。

-----------------------------------------------------------------------
## Windows 10 環境安裝設定

1. 將本說明檔閣有一个 module 檔 `TLconv.rakumod` 佮程式檔 `tls-tlt.raku` 掠落來，
   囥佇一个工作目錄（資料夾）內，可比講 `C:\Users\"使用者名稱"\TL`
   其中个 "使用者名稱" 著愛換做汝个電腦真正咧用个使用者名稱。

2. 先去「開始功能表->控制台->地區->系統管理」點「變更系統地區設定」入去，
   勾選「Beta: 使用 Unicode UTF-8 提供全球語言支援」。

3. 去「開始功能表->所有程式->Windows PowerShell->Windows PowerShell」揤 mouse 右鍵，
   點「以系統管理員身份執行」，就會跳出對話框，問講「您是否要允許此 App 變更您的裝置，
   點「是」。就會出現 PowerShell 視窗，視窗內若浮紅字，寫講：
  「因為這個系統上已停用指令碼執行，所以無法載入……」，按呢咱就扑指令：

  ```
  Set-ExecutionPolicy RemoteSigned
  ```
   揤 Enter，伊就會問咱「……。您要變更執行原則嗎？」揤 a，Enter。關掉 PowerShell 視窗。
   詳細參考 [解決 Windows 上輸入指令出現「因為這個系統上已停用指令碼執行，所以無法載入...」的問題](https://israynotarray.com/other/20200510/1067127387/)。

4. 安裝新版个 PowerShell，點「開始功能表->執行」，佇對話框扑：

  ```
  winget install --id Microsoft.Powershell --source winget
  ```
  揤確定。

5. 安裝 Raku 程式套件，去 [Raku官網下載區](https://rakudo.org/downloads) ，點上新个安裝檔，
   目今(2023-2-22)上新个安裝檔个檔名是 `rakudo-moar-2022.12-01-win-x86_64-msvc.msi`  
   下載落來，點兩下，安裝。佇安裝對話框个第二頁，愛會記得勾選：  
   **I accept the terms in the License Agreement**  
   才有法度點 Next 進到下一頁。第三頁就免改，點 Next。第四頁，會記得勾選：  
   **Add environment variables.**  
   一步一步做落去，系統就會問咱：  
   **_您是否要允許這個來自未知發行者的 App 變更您的裝置？_**  
   點「是」。

6. 佇 Windows 桌面揤右鍵，「新增->捷徑」，佇對話框「輸入項目的位置」遐扑：

  ```
  "C:\Program Files\PowerShell\7\pwsh.exe" -NoExit -File "C:\Program Files\Rakudo\scripts\set-env.ps1"
  ```
  點「下一步」，佇「輸入這個捷徑的名稱」遐扑一个汝佮意个名稱，可比講「台羅轉換」，
  揤「完成」。閣來，佇「桌面」揣著「台羅轉換」即个捷徑个圖示，點右鍵，選「內容」，
  佇對話框->捷徑的「開始位置」遐，扑咱佇頭前第 1 步所設个目錄。

7. 以後欲執行台羅轉換个指令，只要點兩下即个捷徑，就會出現 PowerShell 視窗予咱扑指令，可比講：

  ```
  raku tls-tlt.raku "數字式台羅文字檔名.txt" > "調號式台羅文字檔名.txt"
  ```
  其中迄个 `數字式台羅文字檔名.txt` 檔案，著愛先存佇咱个工作目錄內，若存佇別位，
  檔名頭前著愛加目錄名。
