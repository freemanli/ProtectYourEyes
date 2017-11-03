# ProtectYourEyes
Protect Your Eyes
這個程式是設計用來保護眼睛的

安裝方式
========
  如果您已安裝AutoIt3 
  請下載下列三個檔案到任何一個資料夾
    1. ProtectYourEyes.au3
    2. parse_ini.au3
    3. configure.ini
  然後執行 ProtectYourEyes.au3
  
  如果您未安裝AutoIt3
  請下載下列三個檔案到任何一個資料夾
    1. ProtectYourEyes.exe
	2. configure.ini
	3. README.md
  然後執行 ProtectYourEyes.exe

測試程式是否執行
================
  請按 PRINTSCREEN 熱鍵來關閉螢幕，然後再按 Shift+PRINTSCREEN 組合的熱鍵來開啟螢幕，
  如果上述操作正常執行，表示程式正常執行中。
  
操作方式
========
  程式在經過 PowerOnTime (預設是 2400 秒) 之後會短暫關閉約0.1秒，然後再經過 DelayTime (預設是 60 秒)後會關閉螢幕。
  當您覺得眼睛充分休息後可以按 Shift+PRINTSCREEN 組合的熱鍵來開啟螢幕，程式會重新計時。
  如果您覺得這個程式很煩，請按 Alt+PRINTSCREEN 組合的熱鍵來離開程式(螢幕會恢復開啟)
  離開電腦時請按 PRINTSCREEN 熱鍵來關閉螢幕
  上述的熱鍵與時間都可以透過修改 configure.ini 檔案來完成。
