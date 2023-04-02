# gitxc

## What problem does it solve?

If two branches need to be merged and the CFBundleVersion value has been changed in both branches then git will detect a conflict that needs to be resolved manually. This occurs frequently if using a script to increment the build number automatically. This can get very tedious working on a project with multiple branches & developers.

## Installation

Build the tool using the release configuration, and then move the compiled binary to /usr/local/bin:

`$ cd path/to/gitxc`

`$ swift build -c release`

`$ cd .build/release`

`$ cp -f gitxc /usr/local/bin/gitxc`

## Usage

Basically use  `gitxc` instead of `git` to either `merge` or `pull`.

Instead of 

`$ git merge otherBranch`

Use

`$ gitxc merge otherBranch`

If you want to perform the commit yourself or, if you are happy with a "Merged by gitxc" message

`$ gitxc merge otherBranch -c`

Optionally add `-v` for verbose log messages

Merge and Pull have the same command signatures so replace `merge` with `pull` in any of the above examples.



## Warnings

gitxc delibrately does not attempt to resolve conflicts in an info.plist if there is more than one conflict.

gitxc determines what the result of a git merge/pull command is by reviewing the text output from that command so this is a bit fragile and could break if the output content or formatting is changed. And it just occurs to me now that this will only work if the git output is in English so don't use if git outputs text in any other language.

Use at your own risk, I have been using it for four months at time of writing and it hasn't failed me yet but still be careful and if you want to be safe duplicate or archive your project folder before using just in case.


## ToDo

- Also handle conflicts with `CFBundleShortVersionString`
- Better, more robust interpretation of git command results


## gitxc Documentation

OVERVIEW: A tool that performs git merge or pull but additionally checks for and resolves conflicts in an Xcode project's info.plist files, specifically conflicts with the CFBundleVersion value.

USAGE: gitxc <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  merge                   Merges two git branches and checks for and resolves any CFBundleVersion conflicts in all
						  Info.plist files by taking the highest value
  pull                    Pulls a branch changes into the current branch and checks for and resolves any CFBundleVersion
						  conflicts in all Info.plist files by taking the highest value


### Merge Documentation

OVERVIEW: Merges two git branches and checks for and resolves any CFBundleVersion conflicts in all Info.plist files by
taking the highest value

USAGE: gitxc merge <branch-name> [--verbose] [--commit]

ARGUMENTS:
  <branch-name>           The name of the branch to merge into the current branch

OPTIONS:
  -v, --verbose           If enabled prints additional information during the merge process
  -c, --commit            If enabled will commit after resolving plist conflicts if that is possible, will not attempt to
						  commit if unresolved conflicts remain
  -h, --help              Show help information.
  

### Pull Documentation

OVERVIEW: Pulls a branch changes into the current branch and checks for and resolves any CFBundleVersion conflicts in all
Info.plist files by taking the highest value

USAGE: gitxc pull [<branch-name>] [--verbose] [--commit]

ARGUMENTS:
  <branch-name>           The name of the branch to pull into the current branch

OPTIONS:
  -v, --verbose           If enabled prints additional information during the pull process
  -c, --commit            If enabled will commit after resolving plist conflicts if that is possible, will not attempt to
						  commit if unresolved conflicts remain
  -h, --help              Show help information.
