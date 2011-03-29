#! /bin/bash

PROJECT="foo"
# checkout dir
PROJECT_ROOT="$HOME/Projects"
REPO=http://hosting.com/$PROJECT/

#Go to current project trunk
function trunk()
{
	cd $PROJECT_ROOT/$PROJECT
}
# Go to current project branch
# - $1 argument must be branch name
function branch()
{
	cd $PROJECT_ROOT/$PROJECT-branches/$1
}

# List checked out branches from current working project
function branch-list()
{
	list $PROJECT_ROOT/$PROJECT-branches
}
# Create a new branch for current project
# - $1 the tag name
# - $2 comment for commit
function branch-add()
{
	pushd .
	svn cp $REPO/trunk/dev  $REPO/branches/dev/$1 -m "$2"
	cd $PROJECT_ROOT/$PROJECT-branches/
	svn co $REPO/tags/dev/$1 $1
	cd $1
	mvn clean install -Dmaven.test.skip=true -o

	popd
}
# Remove branch for current project
# - $1 the branche name
function branch-rm()
{
	svn rm $REPO/branches/dev/$1 -m "Removed branch $1 - : $2"
	pushd .
	cd $PROJECT_ROOT/$PROJECT-branches/
	rm -Rf $1
	popd
}
# Go to current project tag
# - $1 argument must be tag name
function tag()
{
	cd $PROJECT_ROOT/$PROJECT-tags/$1
}

# List checked out branches from current working project
function tag-list()
{
	list $PROJECT_ROOT/$PROJECT-tags
}
# Create a new tag for current project
# - $1 the tag name
# - $2 comment for commit
function tag-add()
{
	pushd .
	svn cp $REPO/trunk/dev  $REPO/tags/dev/$1 -m "$2"
	cd $PROJECT_ROOT/$PROJECT-tags/
	svn co $REPO/tags/dev/$1 $1
	cd $1
	mvn clean install -Dmaven.test.skip=true -o
	popd
}

# Remove tag for current project
# - $1 the tag name
function tag-rm()
{
	svn rm $REPO/tags/dev/$1 -m "Removed tag $1 - : $2"
	pushd .
	cd $PROJECT_ROOT/$PROJECT-tags/
	rm -Rf $1
	popd
}
#Colorfull svn diff
# package colordiff needs to be isntalled
# sudo apt-get install colordiff
function svn-diff()
{
	CMD="svn diff ${1}"
	if [[  $2 -gt 0 ]] && [[ $3 -gt 0 ]]  ;then
		CMD="svn diff -r$2:$3 $1"
	elif [[ $2 -gt 0 ]]; then
		CMD="svn diff -r$2:HEAD $1"
	fi
	$CMD | colordiff
}

# Paginated color output for diff
function svn-diff-view()
{
	svn-diff ${@} | less -r
}

# Add pendent files to svn repository in current dir
# only adds java and action script files automatically
function svn-add()
{
	svn st | awk '{ if($1 == "?" && $1 ~ /^.*\.[js|java|as|xml|properties|mxml|swf]$/ ) { print $2 } }' | xargs svn add
}

# Revert all changes from current svn repository
function svn-revert()
{
	svn st | awk '{ if($1 ~ /$[M|A|!]/ ) { print $2 } }' | xargs svn revert
}

# Ignore eclipse and maven related files
function svn-ignore()
{	# $1 should be 'empty', 'files', 'immediates', or 'infinity'
	CMD_1='svn propset'
	CMD_2="svn:ignore '.project .classpath .settings target ~*'"
	if [ -z $1 ]; then
		CMD="$CMD_1 -R $CMD_2"
	else
		CMD="$CMD_1 --depth $1 $CMD_2"
	fi
	$CMD
}

# Utility function to print branches and tag names
function list()
{
	ls -l $1 | awk '{ if( $8 != "" ) { print $8 } }'
}