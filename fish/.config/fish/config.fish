if status is-interactive
    # Environment & Paths
    set -Ux EDITOR nvim
    set -Ux VISUAL nvim
    set -Ux PAGER less
    set -Ux LESS '-R --use-color -Dd+r$Du+b'
    set -Ux MANPAGER 'sh -c "col -bx | bat -l man -p --theme=base16"'
    set -Ux QT_QPA_PLATFORM xcb
    set -Ux GTK_IM_MODULE None
    set -Ux QT_IM_MODULE None
    set -Ux XMODIFIERS @im=none
    fish_add_path $HOME/.local/bin $HOME/bin

    # Cargo
    if test -f $HOME/.cargo/env
        fish_add_path $HOME/.cargo/bin
    end

    # History
    # Colors 
    set -gx LS_COLORS "di=38;2;152;251;152:ln=38;2;175;238;238:ex=38;2;255;182;193:pi=38;2;255;250;205:so=38;2;221;160;221:bd=38;2;173;216;230:cd=38;2;173;216;230:*.tar=38;2;221;160;221:*.zip=38;2;221;160;221:*.jpg=38;2;173;216;230:*.png=38;2;173;216;230:*.mp4=38;2;173;216;230:*.mp3=38;2;255;250;205:*.md=38;2;175;238;238:*.json=38;2;175;238;238:*.sh=38;2;152;251;152:*.c=38;2;152;251;152"

    # Fish syntax highlighting colors
    set fish_color_normal ffb6c1
    set fish_color_command 98fb98
    set fish_color_keyword ffb6c1
    set fish_color_quote 98fb98
    set fish_color_redirection afeeee
    set fish_color_end dda0dd
    set fish_color_error ffb6c1
    set fish_color_param add8e6
    set fish_color_comment 5a2a5a
    set fish_color_operator afeeee
    set fish_color_escape afeeee
    set fish_color_autosuggestion 5a2a5a

    # Pager / selection colors
    set fish_pager_color_selected_background --background=261332
    set fish_pager_color_selected_completion 98fb98
    set fish_pager_color_prefix dda0dd
    set fish_pager_color_completion ffb6c1
    set fish_pager_color_description afeeee

    # FZF
    set -gx FZF_DEFAULT_OPTS "
  --color=bg+:#261332,bg:#1a0a1f,spinner:#dda0dd,hl:#98fb98
  --color=fg:#ffb6c1,header:#afeeee,info:#dda0dd,pointer:#ffb6c1
  --color=marker:#98fb98,prompt:#dda0dd,hl+:#afeeee,border:#3d1f4d
  --height=40% --layout=reverse --border=rounded
  --prompt='❯ ' --pointer='▶' --marker='✓'
"
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
    set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'

    # Starship & Zoxide
    starship init fish | source
    zoxide init fish | source

    # Aliases
    # System
    alias ls 'eza --group-directories-first --color=always'
    alias ll 'eza -lah --git --group-directories-first --color=always'
    alias la 'eza -a --group-directories-first --color=always'
    alias lt 'eza --tree --level=2 --group-directories-first --color=always'
    alias cl clear
    alias q exit
    alias md 'mkdir -p'
    alias smd 'sudo mkdir -p'
    alias df 'df -h'
    alias du 'du -sh'
    alias free 'free -h'
    alias weather 'curl -s wttr.in'

    # Safe ops
    alias rm 'rm -i'
    alias cp 'cp -i'
    alias mv 'mv -i'

    # Dev & Git
    alias nvim nvim
    alias snvim 'sudo -E nvim'
    alias g git
    alias ga 'git add'
    alias gaa 'git add --all'
    alias gc 'git commit -m'
    alias gco 'git checkout'
    alias gcb 'git checkout -b'
    alias gd 'git diff'
    alias gs 'git status -sb'
    alias gl 'git log --oneline --graph --decorate --all'
    alias gp 'git push'
    alias gpl 'git pull'

    # C/C++
    alias gccr 'g++ -Wall -Wextra -Wpedantic -fdiagnostics-color'
    alias fastmake 'cmake .. && make -j(nproc)'

    # Configs
    alias fishrc '$EDITOR ~/.config/fish/config.fish'
    alias srcfish 'source ~/.config/fish/config.fish && echo "✓ config.fish reloaded"'
    alias foot-conf '$EDITOR ~/.config/foot/foot.ini'
    alias waybar-conf '$EDITOR ~/.config/waybar/config.jsonc'
    alias mango-conf '$EDITOR ~/dotfiles/mango/.config/mango/config.conf'

    # Functions

    function mango
        if not test -d /run/user/(id -u)
            sudo mkdir -p /run/user/(id -u)
            sudo chown (id -u):(id -g) /run/user/(id -u)
            chmod 700 /run/user/(id -u)
        end

        exec dbus-run-session mango
    end

    function mkcd
        mkdir -p $argv[1] && cd $argv[1]
    end

    function bak
        cp $argv[1] $argv[1].bak && echo "✓ backed up: $argv[1].bak"
    end

    function up
        set n (math (count $argv) > 0 ? $argv[1] : 1)
        set d ""
        for i in (seq 1 $n)
            set d "../$d"
        end
        cd $d
    end

    function buildc
        if test (count $argv) -eq 0
            echo "Error, file name is not found"
            return 1
        end
        set out_file (string replace -r '\.[^.]+$' '' $argv[1])
        clang -std=c11 \
            -Wall -Wextra -Wpedantic \
            -g \
            -fsanitize=address -fsanitize=undefined \
            $argv[1] -o $out_file
        if test $status -eq 0
            echo "all is ok, insert ./$out_file"
        end
    end

    function runc
        if test (count $argv) -eq 0
            echo "Error, file name is not found"
            return 1
        end
        set out_file (string replace -r '\.[^.]+$' '' $argv[1])
        buildc $argv[1] && ./$out_file
    end

    function buildcpp
        if test (count $argv) -eq 0
            echo "Error, file name is not found"
            return 1
        end
        set out_file (string replace -r '\.[^.]+$' '' $argv[1])
        clang++ -std=c++23 \
            -Wall -Wextra -Wpedantic \
            -Wshadow -Wconversion -Wnull-dereference \
            -g \
            -fsanitize=address -fsanitize=undefined \
            $argv[1] -o $out_file
        if test $status -eq 0
            echo "All is ok"
        end
    end

    function runcpp
        if test (count $argv) -eq 0
            echo "Error, file name is not found"
            return 1
        end
        set out_file (string replace -r '\.[^.]+$' '' $argv[1])
        buildcpp $argv[1] && ./$out_file
    end

    function fcd
        set dir (fd --type d --hidden --exclude .git | fzf --prompt='cd ❯ ')
        if test -n "$dir"
            cd $dir
        end
    end

    function fkill
        set pid (ps aux | tail -n +2 | fzf --prompt='kill ❯ ' | awk '{print $2}')
        if test -n "$pid"
            kill -9 $pid && echo "killed PID $pid"
        end
    end

    function gbf
        set branch (git branch --all | grep -v HEAD | fzf --prompt='branch ❯ ' | string replace -r 'remotes/origin/' '')
        if test -n "$branch"
            git checkout $branch
        end
    end

    function fnvim
        set file (fd --type f --hidden --exclude .git | fzf --prompt='nvim ❯ ')
        if test -n "$file"
            nvim $file
        end
    end

    function glog
        git log --oneline --color=always $argv | fzf --ansi --no-sort --reverse \
            --preview 'git show --stat --color=always {1}' \
            --prompt='log ❯ ' --bind 'enter:execute(git show --color=always {1} | bat --color=always -l diff)'
    end

    function note
        if test (count $argv) -gt 0
            set file $HOME/Obsidian/$argv[1].md
        else
            set file $HOME/Obsidian/(date +%Y-%m-%d).md
        end
        mkdir -p (dirname $file) && nvim $file
    end
end

