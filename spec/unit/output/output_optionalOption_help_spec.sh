Describe "output():" output:output
	# Mock out sourcing of util (constants, globals, helper functions, etc).
	inScriptSource() { return 0; }
	# Makes test easier to read and maintain.
	output=$PWD/src/shell/functions/output/output.sh
	# createHeaderFooter() shouldn't be called, but mock it out just in case.
	createHeaderFooter() { return $CATCHALL_RT; }
	
	Describe "Optional option:" outputOutput:optionalOption
		Describe "Help:" outputOutputOptionalOption:help
			It "-h" outputOutputOptionalOptionHelp:h
				When run source $output -h
				The stderr should not be present
				The stdout should include "DESCRIPTION:"
				The status should be success
			End
			It "--help" outputOutputOptionalOptionHelp:help
				When run source $output --help
				The stderr should not be present
				The stdout should include "DESCRIPTION:"
				The status should be success
			End
		End
	End
End
