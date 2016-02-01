#!/bin/bash

__chipchap_completion() {

    local cur prev opts chipchap
    COMPREPLY=()
    chipchap="${COMP_WORDS[0]}"
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"


    if [[ ${COMP_CWORD} = 1 ]] ; then
      opts=$(${chipchap} __check__)
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    fi

    if [[ ${COMP_CWORD} = 2 ]] ; then
      opts=$(${chipchap} __check__ $prev)
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    fi

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0;

}

complete -F __chipchap_completion chipchap

