# Setup required environment variable(s).
% DEFAULT_LINE_LENGTH:10
readonly DEFAULT_LINE_LENGTH
% DEFAULT_INDENT:0
readonly DEFAULT_INDENT
% TRACE_CHAR:'.'
readonly TRACE_CHAR

Describe "Output:" output
	Describe "output():" output:output
		# Track path to file that contains CUT.
		cutPath=$PWD/src/shell/functions/output/output.sh
		# Source CUT function file so function may be called directly.
		sourceCut() { . $cutPath; }
		BeforeAll 'sourceCut'
		
		Describe "Optional option:" outputOutput:optionalOption
			Describe "Trace:" outputOutputOptionalOption:trace
				It "-t" outputOutputOptionalOptionTrace:t
					When run output -m=m --pp -t
					The stderr should not be present
					The lines of stdout should equal 1
					The stdout line 1 should equal ". m ."
					The status should be success
				End
				It "--trace" outputOutputOptionalOptionTrace:trace
					When run output -m=m --pp --trace
					The stderr should not be present
					The lines of stdout should equal 1
					The stdout line 1 should equal ". m ."
					The status should be success
				End
			End
		End
	End
End

