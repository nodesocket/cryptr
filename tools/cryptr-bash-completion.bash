_cryptr_complete()
{
     local cur_word prev_word type_list
     COMPREPLY=()
     cur_word="${COMP_WORDS[COMP_CWORD]}"
     prev_word="${COMP_WORDS[COMP_CWORD-1]}"
 
     opts='encrypt decrypt help version'
 
     case "$prev_word" in
         'encrypt')
             COMPREPLY=( $(compgen -f -d -- ${cur_word}) )
             return 0
             ;;
         'decrypt')
             COMPREPLY=( $(compgen -f -G "*.aes" -- ${cur_word}) )
             return 0
             ;;
         *)
             COMPREPLY=( $(compgen -W "${opts}" -- ${cur_word}) )
             return 0
             ;;
     esac
}
 
complete -F _cryptr_complete cryptr.bash cryptr
