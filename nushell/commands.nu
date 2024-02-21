# Safely removes local branches in the current directory
def git_cleanup [
    --all (-a) # removes all branches except the dedicated master branch, if any
] {
    let branches = (git branch --merged) 
    let current_branch = (git rev-parse --abbrev-ref HEAD)
    let main_branches = [main, master]

    let current_branches = (git branch --merged) 
                                    | split row --regex '\n' 
                                    | str trim 
                                    | filter {
                                        |i| $i != ''
                                        }
                                    
    $current_branches
        | each {
            |i| if ((($i | str contains --not $current_branch) 
                        and ($i not-in $main_branches))
                        or ($all)
                    ) {
                git branch -d $i
            }
        }
        | to text
}