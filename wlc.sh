#!/usr/bin/env bash

# ==================================================================================================
# This script convert switch markdown links of github project wikis between:
#   - github wiki syntax  : [...](github.com/<userName>/<projectName>/<pageName>)
#   - vimwiki wiki syntax : [...](<pageName>)
# ==================================================================================================

# =[ VAR ]==========================================================================================
# -[ MODE ]-----------------------------------------------------------------------------------------
GITMODE=""
VIMMODE=""
# -[ COLOR BALISE ]---------------------------------------------------------------------------------
E="\033[0m"      # END color balise
R0="\033[0;31m"  # START RED
B0="\033[0;34m"  # START BLUE
V0="\033[0;32m"  # START GREEN
M0="\033[0;33m"  # START BROWN
# -[ PATH ]-----------------------------------------------------------------------------------------
ABS_PATH=$(realpath ${2})
FOLDNAME=$(basename ${2})

# =[ FCTS ]=========================================================================================
# -[ USAGE ]----------------------------------------------------------------------------------------
# print usage with specific error message 'arg1' then exit with 'arg2' (if no arg2, default value = 42)
usage()
{
    local txt=${1}
    [[ ${#} -eq 2 ]] && local exit_nb=${2} || local exit_nb=42
    echo -e "${R0}Wrong Usage, err_${exit_nb}${R0}: ${txt}${E}\n${V0}Usage${E}:  \`${B0}./wlc ${M0}<-g(or)-v> <path_to_wiki_folder>${E}\`"
    echo -e "-${B0} ./wlc ${M0}-g(or --github)  ${M0}<folder>${E}: In ${M0}<folder>${E} convert every markdown link to github syntax (from file to html)"
    echo -e "-${B0} ./wlc ${M0}-v(or --vimwiki) ${M0}<folder>${E}: In ${M0}<folder>${E} convert every markdown link to vimwiki syntax (from html to file)\n"
    exit ${exit_nb}
}

# -[ GET_URL ]--------------------------------------------------------------------------------------
# return clean url (from git remote command, if ssh or html remote)
get_url()
{
    local url=$(cd ${ABS_PATH} && git remote -v | head -1 | awk -F ' ' '{print $2}')
    [[ ( -n "${url}" ) && ( "${url}" != https* ) ]] && local url="https://github.com/${url#*github.com:}"
    echo ${url/\.git/\/wiki}
}

# ==================================================================================================
# Main
# ==================================================================================================
# =[ CHECK ARGUMENTS ]==============================================================================
[[ ${#} -ne 2 ]] && usage "Wrong nb of argument, script need 2args and ${#} was given" 2
[[ ! -d ${!#} ]] && usage "Last arg \"${!#}\" is not a folder" 3
[[ ! -d "${ABS_PATH}/.git" ]] && usage "Last arg \"${!#}\" is not git repo." 4
# =[ SET MODE ]=====================================================================================
case "${1}" in
    -g|--github) GITMODE="ok" ;; 
    -v|--vimwiki) VIMMODE="ok";;
    *) usage "arg1 is not an option: \"${1}\"" 5 ;;
esac
# =[ GET_URL ]======================================================================================
URL=$(get_url)
[[ -z "${URL}" ]] && usage "git repo \"${FOLDNAME}\" don't seems to have a remote repo" 6 || echo ${URL}
