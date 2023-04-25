# Setup required environment variable(s).
% DEFAULT_CHAR:'#'
readonly DEFAULT_CHAR

Describe "Output:" output
	Describe "util:" output:util
		Describe "createHeaderFooter():" outputUtil:createHeaderFooter
			# Source CUT function file so function may be called directly.
			sourceCut() { . $PWD/src/shell/functions/output/util/createHeaderFooter.sh; }
			BeforeAll 'sourceCut'
			
			Describe "Optional option:" outputUtilCreateHeaderFooter:optionalOption
				Describe "Line length:" outputUtilCreateHeaderFooterOptionalOption:lineLength
					Describe "Input invalid:" outputUtilCreateHeaderFooterOptionalOptionLineLength:inputInvalid
						Describe "-l:" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalid:l
							It "Blank" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:blank
								When run createHeaderFooter -l=""
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Null" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:null
								When run createHeaderFooter -l=
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Missing" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:missing
								When run createHeaderFooter -l
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_NAME_INVALID_RT
							End
							It "Float" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:float
								When run createHeaderFooter -l="1.1"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "'+'" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:plus
								When run createHeaderFooter -l="+50"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "'-'" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidL:minus
								When run createHeaderFooter -l="-50"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
						End
						Describe "--line-length:" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalid:lineLength
							It "Blank" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:blank
								When run createHeaderFooter --line-length=""
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Null" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:null
								When run createHeaderFooter --line-length=
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Missing" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:missing
								When run createHeaderFooter --line-length
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_NAME_INVALID_RT
							End
							It "Float" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:float
								When run createHeaderFooter --line-length="1.1"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "'+'" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:plus
								When run createHeaderFooter --line-length="+50"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "'-'" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputInvalidLineLength:minus
								When run createHeaderFooter --line-length="-50"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
						End
					End
				End
			End
		End
	End
End
