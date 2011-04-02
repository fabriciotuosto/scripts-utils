#! /bin/bash

# Do compilation
function compile()
{
	mvn clean install "${@}"
}

# Compile with no tests
function compile-notest()
{
	mvn clean install -Dmaven.test.skip=true "${@}"
}

# Perform resources process
function resources()
{
	mvn resources:resources
}
