# Initialize zsh completion system if not already done
autoload -Uz compinit
compinit

_cryptr() {
    local -a commands
    commands=(
        'encrypt:Encrypt files'
        'decrypt:Decrypt files'
        'help:Show help'
        'version:Show version'
    )

    _arguments -C \
        '1: :->cmds' \
        '*:: :->args'

    case "$state" in
        cmds)
            _describe -t commands 'commands' commands
            ;;
        args)
            case $words[1] in
                encrypt)
                    _files
                    ;;
                decrypt)
                    _files -g "*.aes"
                    ;;
            esac
            ;;
    esac
}

compdef _cryptr cryptr
