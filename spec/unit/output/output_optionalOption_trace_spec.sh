# Set constant(s) use here so configuration changes won't cause tests to fail.
% DEFAULT_LINE_LENGTH:100
readonly DEFAULT_LINE_LENGTH
% DEFAULT_INDENT:0
readonly DEFAULT_INDENT
% TRACE_CHAR:'.'
readonly TRACE_CHAR

Describe "output():" output:output
	# Mock out sourcing of constants file.
	inScriptSource() { return 0; }
	# Makes test easier to read and maintain.
	output=$PWD/src/shell/functions/output/output.sh
	
	Describe "Optional option:" outputOutput:optionalOption
		Describe "Trace:" outputOutputOptionalOption:trace
			It "-t" outputOutputOptionalOptionTrace:t
				When run source $output -m=m --pp -t
				The stderr should not be present
				The lines of stdout should equal 1
				The stdout line 1 should equal ". m ."
				The status should be success
			End
			It "--trace" outputOutputOptionalOptionTrace:trace
				When run source $output -m=m --pp --trace
				The stderr should not be present
				The lines of stdout should equal 1
				The stdout line 1 should equal ". m ."
				The status should be success
			End
		End
	End
End
