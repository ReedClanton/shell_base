#/ DESCRIPTION:
#/	Contains unit test(s) of flatpakAliasCreator() that only deals with required option(s).
#/
#/ USAGE: ./bash_unit [OPTIONS]... ./path/to/this/<thisFileName>.sh
#/
#/ TODO(S):
#/	- TODO

#/ DESCRIPTION:
#/	Setup that's run once prior to all test(s) in this file.
#/
#/ TODO(S):
#/	- None
setup_suite() {
	# Ensure required environment variable(s) are set.
	. $(readlink -f $PWD/../../../../../src/shell/shell_functions)
	# Short hand used to call function so full path doesn't have to be used each time.
	flatpakAliasCreator=$(readlink -f $PWD/../../../../../src/environmentSetup/util/flatpakAliasCreator.sh) "${@}"
}

#/ DESCRIPTION:
#/	The point of this test is to ensure that the function doc is returned, so
#/	test just ensures the first line of the doc is returned.
#/
#/ TODO(S):
#/	- Create another method that verifies the return value.
test__-h() {
	assert_equals \
		"#/" \
		$($flatpakAliasCreator -h)
}

#/ DESCRIPTION:
#/	Ensure exit code is `0`.
#/
#/ TODO(S):
#/	- NoOp
test__-h__valid_return_code() {
	cmd="$flatpakAliasCreator -h"
	unset stdOut errOut rtOut
	eval "$( (eval $cmd) \
		2> >(errOut=$(cat); typeset -p errOut) \
		 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
	assert_equals 0 $rtOut
}

#/ DESCRIPTION:
#/	The point of this test is to ensure that the function doc is returned, so
#/	test just ensures the first line of the doc is returned.
#/
#/ TODO(S):
#/	- Create another method that verifies the return value.
test__--help() {
	assert_equals \
		"#/" \
		$($flatpakAliasCreator --help)
}

#/ DESCRIPTION:
#/	Ensure exit code is `0`.
#/
#/ TODO(S):
#/	- NoOp
test__--help__valid_return_code() {
	cmd="$flatpakAliasCreator --help"
	unset stdOut errOut rtOut
	eval "$( (eval $cmd) \
		2> >(errOut=$(cat); typeset -p errOut) \
		 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
	assert_equals 0 $rtOut
}
