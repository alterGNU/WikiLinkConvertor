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

## Convert from github to vimwiki syntax
