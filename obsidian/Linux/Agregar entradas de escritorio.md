https://specifications.freedesktop.org/desktop-entry/latest/

```bash
mkdir ~/.local/share/applications
cd ~/.local/share/applications
mkdir obsidian
wget https://upload.wikimedia.org/wikipedia/commons/1/10/2023_Obsidian_logo.svg
mv 2023_Obsidian_logo.svg obsidian.svg
nano Obsidian.desktop
# contents
[Desktop Entry]
#Version=1.0
Name=Obsidian
#Comment=Unipro UGENE is a cross-platform visual environment for DNA and protein sequence analysis.
Exec=/home/yuki/Apps/obsidian/obsidian
Path=/home/yuki/Apps/obsidian
Icon=/home/yuki/Apps/obsidian.svg
Terminal=false
Type=Application
Categories=Utility;Productivity;
```

