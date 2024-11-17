#!/usr/bin/env bash

 
# ============================================================================================================
# This script convert switch markdown links of github project wikis between:
#   - github wiki syntax  : [...](github.com/<userName>/<projectName>/<pageName>)
#   - vimwiki wiki syntax : [...](<pageName>)
#
#
# TODO
# - [ ] Check if folder has no modifications compared to its last commit (git status).
# - [ ] Manage link to paragraphe.
# ============================================================================================================

# =[ VAR ]====================================================================================================
# -[ MODE ]---------------------------------------------------------------------------------------------------
GITMODE=""
VIMMODE=""
# -[ COLOR BALISE ]-------------------------------------------------------------------------------------------
E="\033[0m"      # END color balise
R0="\033[0;31m"  # START RED
B0="\033[0;36m"  # START BLUE
V0="\033[0;32m"  # START GREEN
M0="\033[0;33m"  # START BROWN
# -[ PATH ]---------------------------------------------------------------------------------------------------
ABS_PATH=""
FOLDNAME=""

# =[ FCTS ]===================================================================================================
# -[ USAGE ]--------------------------------------------------------------------------------------------------
# print usage with specific error message 'arg1' then exit with 'arg2' (if no arg2, default value = 42)
usage()
{
    local txt=${1}
    [[ ${#} -eq 2 ]] && local exit_nb=${2} || local exit_nb=42
    echo -e "${R0}Wrong Usage, err_${exit_nb}${R0}: ${txt}${E}\n${V0}Usage${E}:  \`${B0}./wlc ${M0}<-g(or)-v> <path_to_wiki_folder>${E}\`"
    echo -e "-${B0} ./wlc ${M0}-g(or --github)  ${M0}<git_wiki_folder>${E}: In ${M0}<git_wiki_folder>${E} convert every markdown link to github syntax (from file to html)"
    echo -e "-${B0} ./wlc ${M0}-v(or --vimwiki) ${M0}<git_wiki_folder>${E}: In ${M0}<git_wiki_folder>${E} convert every markdown link to vimwiki syntax (from html to file)\n"
    exit ${exit_nb}
}

# -[ GET_URL ]------------------------------------------------------------------------------------------------
# return clean url (from git remote command, if ssh or html remote)
get_url()
{
    local url=$(cd ${ABS_PATH} && git remote -v | head -1 | awk -F ' ' '{print $2}')
    if [[ -n "${url}" ]];then
        if [[ "${url}" == *.wiki.git ]];then 
            url=${url/\.wiki\.git/\/wiki/}
            if [[ "${url}" != https* ]];then 
                url="https://github.com/${url#*github.com:}" # Case remote is a SSH
            else
                url=${url/\.wiki/\/wiki/}                    # Case remote is a HTTPS
            fi
            echo ${url}
        else
            echo "0"                                         # Case remote is not a wiki
        fi
    else
        echo ${url}                                          # Case no remote (url empty)
    fi
}

# -[ REPLACE_LINK ]-------------------------------------------------------------------------------------------
# set all find link to wiki format depending on active mode.
replace_links()
{
    local filename=$(basename $1)
    echo ${1} | while read -r file; do
    sed -n -E '/\[.*\]\(.*\)/{
    =;   # print line number
    p    # print line
    }' "${file}" | while read -r line_number; do
    read -r matched_line
    local extract_name=${matched_line#*[}
    extract_name=${extract_name%%]*}
    local extract_link=${matched_line#*(}
    extract_link=${extract_link%%)*}
    local suffixe="${extract_link#${URL}}"
    local found_file=$(find "${ABS_PATH}" -type f -iname "${suffixe}.md" -print -quit)
    local found_link=$(find "${ABS_PATH}" -type f -iname "${extract_link}" -print -quit)

    # SEARCH html-syntax TO CONVERT INTO markdown-syntax
    if [[ -n "${VIMMODE}" ]];then
        if [[ ${extract_link} =~ ${URL} ]];then
            if [[ -n "${found_file}" ]]; then
                local new_value="$(basename ${found_file})"
                echo -e "✅ ${V0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🔄 [${extract_name}](${new_value})${E}"
                sed -i "${line_number}s|\[${extract_name}\](${extract_link})|[${extract_name}](${new_value})|" "${file}"
            else
                echo -e "🟫 ${M0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🟤not a file in VIMMODE${E}🟤"
            fi
        else
            if [[ -n "${found_link}" ]];then
                echo -e "🟦 ${B0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🔵already in VIMWIKI LINK SYNTAX${E}🔵 "
            else
                echo -e "🟫 ${M0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🟤not a file in VIMMODE${E}🟤"
            fi
        fi
    else # SEARCH markdown-syntax TO CONVERT INTO html-syntax
        if [[ -n "${found_link}" ]]; then
            local new_filename="${extract_link%%\.*}"
            local new_value="${URL}${new_filename,,}"
            echo -e "✅ ${V0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🔄 [${extract_name}](${new_value})"
            sed -i "${line_number}s|\[${extract_name}\](${extract_link})|[${extract_name}](${new_value})|" "${file}"
        else
            if [[ ( "${extract_link}" =~ "${URL}" ) && ( -n ${found_file} ) ]];then
                echo -e "🟦 ${B0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🔵already in GITHUB LINK SYNTAX${E}🔵 "
            else
                echo -e "🟫 ${M0}${FOLDNAME}/${filename}, line ${line_number}: [${extract_name}](${extract_link}) 🟤not a file in GITMODE${E}🟤 "
            fi
        fi
    fi
    done
    done
}

 
# ============================================================================================================
# MAIN
# ============================================================================================================
# =[ CHECK ARGUMENTS ]========================================================================================
[[ ${#} -ne 2 ]] && usage "Wrong nb of argument, script need 2args and ${#} was given" 2
ABS_PATH=$(realpath ${2})
FOLDNAME=$(basename ${ABS_PATH})
[[ ! -d ${ABS_PATH} ]] && usage "Last arg \"${FOLDNAME}\" is not a folder" 3
[[ ( ! -d "${ABS_PATH}/.git" ) && ( ! -f "${ABS_PATH}/.git" ) ]] && usage "arg \"${FOLDNAME}\" is not git repo." 4
# =[ SET MODE ]===============================================================================================
case "${1}" in
    -g|--github) GITMODE="ok" ;; 
    -v|--vimwiki) VIMMODE="ok";;
    *) usage "arg1 is not an option: \"${1}\"" 5 ;;
esac
# =[ GET_URL ]================================================================================================
URL=$(get_url)
[[ -z "${URL}" ]] && usage "git repo \"${FOLDNAME}\" has no remote " 6
[[ "${URL}" == "0" ]] && usage "git repo \"${FOLDNAME}\" is not a github wiki repo" 7
# =[ SEARCH FILES FOR LINKS ]=================================================================================
echo "--------------------------"
for file in $(ls ${ABS_PATH});do
    [[ ${file} == *.md ]] && replace_links "${ABS_PATH}/${file}"
done
echo "--------------------------"
