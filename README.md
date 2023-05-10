# TL_conv 數字式台羅轉做調號式台羅个工具程式說明

Author: 潘科元 khoguanp@yahoo.com  
Date: 2023-02-22  
License: 本軟體予社會自由使用，作者無為使用者負擔任何責任。汝若修改本軟體，請寄一份予作者參考利用。

## 特色

使用教育部台羅个拼寫法，連老泉腔（有 ir / er / ere / irn / irt / irm .... 个韻母），
古泉腔（有 irinn / irng / iro .... 韻母）都有法度正確轉換做調號式。

## 說明

一、`TL_conv.rakumod` 是將教育部版个數字式台語羅馬字轉換做調號式台語羅馬字个
Raku module。

module 內底提供兩个仝名个函式。汝寫个 Raku 程式，欲叫用 `TL_conv` module，著愛佇頭前先寫：

```
  use lib <.>;  # TL_conv.rakumod 佮汝个程式囥佇仝一个目錄內。
  use TL_conv;
```

以下是 `tls-tlt()` 函式个說明：

`tls` 是 Tâi-Lô Sòo-jī; tlt 是 Tâi-lô Tiāu-hō
`tls-tlt()` 就是用來將台羅數字版轉做調號版个函式，有兩種呼叫介面：

1. `tls-tlt($match)` 
  佇caller遐，愛先用regex个 m/ / 指令掠著台羅音節个Match object：

```
  my $tlt;
  if $input ~~ /<TL>/ { $tlt = tls-tlt($/); }
```

  注意 / / 內底个 <TL> 就是我佇 `TL_conv.rakumod` 內底提供出來个一个數字式台羅个
  regular expression（RE，正規表示式）。

2. `tls-tlt($str)`
  佇caller遐，直接將有包含數字式台羅个字串(Str type)擲予 tls-tlt 進行轉換。

```
  for lines() {
      put tls-tlt($_);
  }
```

二、`tls-tlt.raku` 命令列程式，是將數字式台羅純文字檔轉換做調號式台羅純文字檔个
軟體家私。

用法：
1. 將 `TL_conv.rakumod` 佮 `tls-tlt.raku` 囥佇仝一个工作目錄內底，欲用進前，
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
   o 輸出檔名佮輸入檔名著愛號無仝款名。
   o 佇 Windows CMD（所謂DOS視窗）/ Powershell 內底使用，愛扑：
```
     raku tls-tlt.raku "數字式台羅文字檔名.txt" > "調號式台羅文字檔名.txt"
```

3. 進階用法：
   會使一遍轉換超過一个以上个數字式台羅文字檔案，但是輸出會相連紲接落去。
   也會使接受 stdin 个輸入方式。這佮一般个 Unix/Linux 文字轉換程式个慣勢
   做法仝款。

-----------------------------------------------------------------------
## Windows 10 環境安裝設定

0. 將本說明檔閣有一个module檔 `TL_conv.rakumod` 佮程式檔 `tls-tlt.raku` 掠落來，
   囥佇一个工作目錄（資料夾）內，可比講 C:\\Users\\"使用者名稱"\\TL
   其中个 "使用者名稱" 著愛換做汝个電腦真正咧用个使用者名稱。

1. 先去「開始功能表->控制台->地區->系統管理」點「變更系統地區設定」入去，
   勾選「Beta: 使用 Unicode UTF-8 提供全球語言支援」。

2. 去「開始功能表->所有程式->Windows PowerShell->Windows PowerShell」揤mouse右鍵，
   點「以系統管理員身份執行」，就會跳出對話框，問講「您是否要允許此 App 變更您的裝置，
   點「是」。就會出現PowerShell視窗，視窗內若浮紅字，寫講：
  「因為這個系統上已停用指令碼執行，所以無法載入……」，按呢咱就扑指令：
```
     Set-ExecutionPolicy RemoteSigned
```
   揤Enter，伊就會問咱「……。您要變更執行原則嗎？」揤 a，Enter。關掉 PowerShell 視窗。
   詳細參考 https://israynotarray.com/other/20200510/1067127387/

3. 安裝新版个 PowerShell，點「開始功能表->執行」，佇對話框扑：
```
     winget install --id Microsoft.Powershell --source winget
```
   揤確定。

4. 安裝 Raku 程式套件，去 https://rakudo.org/downloads 頁面，點上新个安裝檔，
   目今(2023-2-22)上新个安裝檔个檔名是 rakudo-moar-2022.12-01-win-x86_64-msvc.msi
   下載落來，點兩下，安裝。佇安裝對話框个第二頁，愛會記得勾選：
   **I accept the terms in the License Agreement**
   才有法度點 Next 進到下一頁。第三頁就免改，點 Next。第四頁，會記得勾選
   **Add environment variables.** 一步一步做落去，系統就會問咱：
   「您是否要允許這個來自未知發行者的 App 變更您的裝置？」
   點「是」。

5. 佇 Windows 桌面揤右鍵，「新增->捷徑」，佇對話框「輸入項目的位置」遐扑：
```
     "C:\Program Files\PowerShell\7\pwsh.exe" -NoExit -File "C:\Program Files\Rakudo\scripts\set-env.ps1"
```
   點「下一步」，佇「輸入這個捷徑的名稱」遐扑一个汝佮意个名稱，可比講「台羅轉換」，
   揤「完成」。閣來，佇「桌面」揣著「台羅轉換」即个捷徑个圖示，點右鍵，選「內容」，
   佇對話框->捷徑的「開始位置」遐，扑咱佇頭前第0步所設个目錄。

6. 以後欲執行台羅轉換个指令，只要點兩下即个捷徑，就會出現PowerShell視窗予咱扑指令，可比講：
```
     raku tls-tlt.raku "數字式台羅文字檔名.txt" > "調號式台羅文字檔名.txt"
```
   其中迄个`數字式台羅文字檔名.txt`檔案，著愛先存佇咱个工作目錄內，若存佇別位，
   檔名頭前著愛加目錄名。
