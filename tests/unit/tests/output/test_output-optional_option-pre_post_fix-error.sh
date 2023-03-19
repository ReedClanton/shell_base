#/ DESCRIPTION:
#/	Contains unit test(s) of output.sh that only deals with the options that add
#/	a pre-fix and post-fix (`--pp` & `--pre-post-fix`) for debug level
#/	(`-e` & `--error`) provided message text.
#/
#/ USAGE: ./bash_unit [OPTIONS]... ./tests/output/<thisFileName>.sh
#/
#/ TODO(S):
#/	- Test with special characters.
#/	- Test when message text is spread out over multiple lines.
#/	- Test return values.
#/	- Figure out if/how I can move the sourcing of the constents file to a setup method.

#/ DESCRIPTION:
#/	Setup that's run once prior to all test(s) in this file.
#/
#/ TODO(S):
#/	- None
setup_suite() {
	# Allows tests to just call `output` rather than accessing the full path.
	function output() {
		../../../../src/bash/functions/output.sh "${@}"
	}
}

#/ DESCRIPTION:
#/	Ensure message text includes $ERROR_CHAR as pre-fix and post-fix when
#/	provided `--pp` and `-e`.
#/
#/ TODO(S):
#/	- Mock out method call(s).
#/	- Mock out constant(s).
test_output__single_line__--pp_-e() {
	source ../../../../src/bash/functions/constants/output.sh
 	assert_equals "$ERROR_CHAR 7zZ $ERROR_CHAR" "$(output -m='7zZ' --pp -e)"
}

#/ DESCRIPTION:
#/	Ensure message text includes $ERROR_CHAR as pre-fix and post-fix when
#/	provided `--pp` and `--error`.
#/
#/ TODO(S):
#/	- Mock out method call(s).
#/	- Mock out constant(s).
test_output__single_line__--pp_--error() {
	source ../../../../src/bash/functions/constants/output.sh
 	assert_equals "$ERROR_CHAR 8xX $ERROR_CHAR" "$(output -m='8xX' --pp --error)"
}

#/ DESCRIPTION:
#/	Ensure message text includes $ERROR_CHAR as pre-fix and post-fix when
#/	provided `--pre-post-fix` and `-e`.
#/
#/ TODO(S):
#/	- Mock out method call(s).
#/	- Mock out constant(s).
test_output__single_line__--pre-post-fix_-e() {
	source ../../../../src/bash/functions/constants/output.sh
 	assert_equals "$ERROR_CHAR 9cC $ERROR_CHAR" "$(output -m='9cC' --pre-post-fix -e)"
}

#/ DESCRIPTION:
#/	Ensure message text includes $ERROR_CHAR as pre-fix and post-fix when
#/	provided `--pre-post-fix` and `--error`.
#/
#/ TODO(S):
#/	- Mock out method call(s).
#/	- Mock out constant(s).
test_output__single_line__--pre-post-fix_--error() {
	source ../../../../src/bash/functions/constants/output.sh
 	assert_equals "$ERROR_CHAR 0vV $ERROR_CHAR" "$(output -m='0vV' --pre-post-fix --error)"
}
