# Set constant(s) use here so configuration changes won't cause tests to fail.
% DEFAULT_CHAR:'#'
readonly DEFAULT_CHAR

Describe "output():" output
	Describe "util:" output:util
		Describe "createHeaderFooter():" outputUtil:createHeaderFooter
			# Mock out 'cat' so it returns stdin.
			cat() { input=""; read input; echo $input; }
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
						End
					End
					Describe "Input special character:" outputUtilCreateHeaderFooterOptionalOptionLineLength:inputSpecialCharacter
						Describe "-l:" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacter:l
							It "Space before" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterL:spaceBefore
								When run createHeaderFooter -l="          7"
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#######\n"
								The status should be success
							End
							It "Space before and after" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterL:spaceBeforeAndAfter
								When run createHeaderFooter -l="          75              "
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "###########################################################################\n"
								The status should be success
							End
							It "Space after" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterL:spaceAfter
								When run createHeaderFooter -l="5              "
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#####\n"
								The status should be success
							End
						End
						Describe "--line-length:" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacter:lineLength
							It "Space before" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterLineLength:spaceBefore
								When run createHeaderFooter --line-length="          9"
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#########\n"
								The status should be success
							End
							It "Space before and after" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterLineLength:spaceBeforeAndAfter
								When run createHeaderFooter --line-length="          75              "
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "###########################################################################\n"
								The status should be success
							End
							It "Space after" outputUtilCreateHeaderFooterOptionalOptionLineLengthInputSpecialCharacterLineLength:spaceAfter
								When run createHeaderFooter --line-length="1              "
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#\n"
								The status should be success
							End
						End
					End
					Describe "Bound:" outputUtilCreateHeaderFooterOptionalOptionLineLength:bound
						Describe "-l:" outputUtilCreateHeaderFooterOptionalOptionLineLengthBound:l
							It "Far bellow lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundL:farBellowLower
								When run createHeaderFooter -l="-999999999"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Bellow lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundL:bellowLower
								When run createHeaderFooter -l="-1"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "At lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundL:atLower
								When run createHeaderFooter -l=0
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "\n"
								The status should be success
							End
							It "Above lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundL:aboveLower
								When run createHeaderFooter -l=1
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#\n"
								The status should be success
							End
							It "Far above lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundL:farAboveLower
								When run createHeaderFooter -l=1000
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "########################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################\n"
								The status should be success
							End
						End
						Describe "--line-length:" outputUtilCreateHeaderFooterOptionalOptionLineLengthBound:lineLength
							It "Far bellow lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundLineLength:farBellowLower
								When run createHeaderFooter --line-length="-999999999"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "Bellow lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundLineLength:bellowLower
								When run createHeaderFooter --line-length="-1"
								The stdout should not be present
								The stderr should include "DESCRIPTION:"
								The status should equal $OPTION_VALUE_INVALID_RT
							End
							It "At lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundLineLength:atLower
								When run createHeaderFooter --line-length=0
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "\n"
								The status should be success
							End
							It "Above lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundLineLength:aboveLower
								When run createHeaderFooter --line-length=1
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "#\n"
								The status should be success
							End
							It "Far above lower" outputUtilCreateHeaderFooterOptionalOptionLineLengthBoundLineLength:farAboveLower
								When run createHeaderFooter --line-length=10000
								The stderr should not be present
								The lines of stdout should equal 1
								The stdout line 1 should equal "################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################\n"
								The status should be success
							End
						End
					End
				End
			End
		End
	End
End

