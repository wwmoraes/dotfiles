set -e argv[1]

if not isatty
    while read -l arg
        set -a argv $arg
    end
end

switch "$cmd"
    case new
        if test (count $argv) -lt 1
            echo "usage: projects new <name> [description]"
            return 1
        end

        set -l project $argv[1]
        set -l description $argv[2]

        set -l projectDir $PROJECTS_DIR/$project
        set -l printProjectName (set_color blue)$project(set_color normal)
        set -l printProjectDir (set_color cyan)$projectDir(set_color normal)

        printf "%-"(tput cols)"s\r" "[$printProjectName] checking if it exists..."
        test -d $projectDir/.git; and begin
            printf "%-"(tput cols)"s\n" "[$printProjectName] already exists, skipping"
            return
        end

        printf "%-"(tput cols)"s\r" "[$printProjectName] creating on $printProjectDir..."
        mkdir -p $projectDir
        git -C $projectDir init -q
        test -n "$description"; and echo "$description" >$projectDir/.git/description
        git -C $projectDir remote add origin (printf $PROJECTS_ORIGIN $project)
        curl -fsSL https://gist.github.com/wwmoraes/75dc66767a9f487c8235c5423027f69c/raw/setup.sh | sh -s -- "$projectDir"
        printf "%-"(tput cols)"s\n" "[$printProjectName] created on $printProjectDir"
    case dev
        test -d $PROJECTS_DIR; or begin
            echo -e "projects directory "(set_color cyan)$PROJECTS_DIR(set_color normal)" does not exist"
            return 1
        end

        switch (count $argv)
            case 0
                set -l projects (fd --type d --max-depth 1 "" $PROJECTS_DIR --exec basename | sort -u | fzf -m)
                and _projects_dev $projects
            case "*"
                for project in $argv
                    test -d "$PROJECTS_DIR/$project"; or begin
                        echo -e "project "(set_color cyan)$project(set_color normal)" does not exist"
                        continue
                    end

                    zellij action new-tab -c "$PROJECTS_DIR/$project" -l development -n (basename "$PROJECTS_DIR/$project")
                end
        end
    case lg
        test -d $PROJECTS_DIR; or begin
            echo -e "projects directory "(set_color cyan)$PROJECTS_DIR(set_color normal)" does not exist"
            return 1
        end

        test (count $argv) -eq 1; or begin
            echo "unable to open lazygit for multiple projects"
            return 1
        end

        test -d $PROJECTS_DIR/$argv[1]; or begin
            echo -e "project "(set_color cyan)$argv[1](set_color normal)" does not exist"
            return 1
        end
        lazygit -p $PROJECTS_DIR/$argv[1]
    case cd
        test -d $PROJECTS_DIR; or begin
            echo -e "projects directory "(set_color cyan)$PROJECTS_DIR(set_color normal)" does not exist"
            return 1
        end

        switch (count $argv)
            case 0
                cd $PROJECTS_DIR
            case 1
                test -d $PROJECTS_DIR/$argv[1]; or begin
                    echo -e "project "(set_color cyan)$argv[1](set_color normal)" does not exist"
                    return 1
                end
                cd $PROJECTS_DIR/$argv[1]
            case "*"
                echo "unable to change to multiple projects' directories"
                return 1
        end
    case ls
        test -d $PROJECTS_DIR; or begin
            echo -e "projects directory "(set_color cyan)$PROJECTS_DIR(set_color normal)" does not exist"
            return 1
        end

        ls -1 $PROJECTS_DIR
        find $PROJECTS_DIR -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort
    case update
        set -l project $argv[1]
        set -l description $argv[2]

        test "$project" = "."; and set -l project (basename "$PWD")
        test -n "$project"; or set -l project (basename "$PWD")
        set -l projectDir $PROJECTS_DIR/$project

        test -d "$projectDir"; or begin
            echo "error: project $project not found on $projectDir"
            echo "usage: projects update <name> [description]"
            return 1
        end

        test -n "$description"; and echo "$description" >"$projectDir/.git/description"
        curl -fsSL https://gist.github.com/wwmoraes/75dc66767a9f487c8235c5423027f69c/raw/setup.sh | sh -s -- "$projectDir"
    case "" "*"
        echo "Unknown option $cmd"
end
