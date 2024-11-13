# Wiki Link Convertor

## Problematic
I often use github wiki feature for hosting my project's documentation when I don't want to write Big README files.

I also use vimwiki with mardown syntax to write my own wikis locally.

I therefore decided to use Vimwiki to write local wikis for my various GitHub projects, allowing me to easily display them on the GitHub pages of those projects using this github feature.

The problem is that even though they both use markdown, there are still syntax differences between github wikis and vimwiki wikis:
- Pb1. First Wiki Page:
    - VimWiki   : the first page has to be named **index.md**
    - GitHub    : the first page has to be named **Home.md**
- Pb2. Folders:
    - VimWiki   : feature enable (we can use folders to regroup files)
    - GitHub    : feature desable (we can't use folders)
- Pb3. Links between pages:
    - VimWiki   : `[link to page2](page2.md)`
    - GitHub    : `[link to page2](github.com/<userName>/<ProjectName>/wiki/<page2Name>)`

_(Pb1&2 can be easily solved by the use of symbolic link and by avoiding subfolder creation while editing with vimwiki.)_

This project aims to respond to problem number 3 by allowing all links to be converted to the github format or to the vimwiki format.

## Convert from vimwiki to github syntax
```bash
tree ~/path_to/tutu
~/path_to/tutu
  ├── file1.md
  └── file2.md
1 directory, 2 files

./wlc.sh -g ~/path_to/tutu
--------------------------
✅ tutu/file1.md, line 3: [link to file2](file2.md) 🔄 [link to file2](https://github.com/alterGNU/tutu/wiki/file2)
✅ tutu/file2.md, line 5: [link to file1](file1.md) 🔄 [link to file1](https://github.com/alterGNU/tutu/wiki/file1)
🟫 tutu/file2.md, line 7: [random weblink](https://www.google.com) 🟤not a file in GITMODE🟤 
🟫 tutu/file2.md, line 8: [link to a nonexisting wiki page](https://github.com/alterGNU/tutu/wiki/not_a_page) 🟤not a file in GITMODE🟤 
🟫 tutu/file2.md, line 9: [link to a nonexisting file](not_a_file) 🟤not a file in GITMODE🟤 
--------------------------

./wlc.sh --github ~/path_to/tutu
--------------------------
🟦 tutu/Home.md, line 3: [link to file2](https://github.com/alterGNU/tutu/wiki/file2) 🔵already in GITHUB LINK SYNTAX🔵 
🟦 tutu/prem.md, line 5: [link to file1](https://github.com/alterGNU/tutu/wiki/file1) 🔵already in GITHUB LINK SYNTAX🔵 
🟫 tutu/prem.md, line 7: [random weblink](https://www.google.com) 🟤not a file in GITMODE🟤 
🟫 tutu/prem.md, line 8: [link to a nonexisting wiki page](https://github.com/alterGNU/tutu/wiki/not_a_page) 🟤not a file in GITMODE🟤 
🟫 tutu/prem.md, line 9: [link to a nonexisting file](not_a_file) 🟤not a file in GITMODE🟤 
--------------------------
```

## Convert from github to vimwiki syntax
```bash
./wlc.sh --vimwiki ~/path_to/tutu
--------------------------
✅ tutu/Home.md, line 3: [link to file2](https://github.com/alterGNU/tutu/wiki/file2) 🔄 [link to file2](file2.md)
✅ tutu/prem.md, line 5: [link to file1](https://github.com/alterGNU/tutu/wiki/file1) 🔄 [link to file1](file1.md)
🟫 tutu/prem.md, line 7: [random weblink](https://www.google.com) 🟤not a file in VIMMODE🟤
🟫 tutu/prem.md, line 8: [link to a nonexisting wiki page](https://github.com/alterGNU/tutu/wiki/not_a_page) 🟤not a file in VIMMODE🟤
🟫 tutu/prem.md, line 9: [link to a nonexisting file](not_a_file) 🟤not a file in VIMMODE🟤
--------------------------

./wlc.sh -v ~/path_to/tutu
--------------------------
🟦 tutu/Home.md, line 3: [link to file2](file2.md) 🔵already in VIMWIKI LINK SYNTAX🔵 
🟦 tutu/prem.md, line 5: [link to file1](file1.md) 🔵already in VIMWIKI LINK SYNTAX🔵 
🟫 tutu/prem.md, line 7: [random weblink](https://www.google.com) 🟤not a file in VIMMODE🟤
🟫 tutu/prem.md, line 8: [link to a nonexisting wiki page](https://github.com/alterGNU/tutu/wiki/not_a_page) 🟤not a file in VIMMODE🟤
🟫 tutu/prem.md, line 9: [link to a nonexisting file](not_a_file) 🟤not a file in VIMMODE🟤
--------------------------
```
