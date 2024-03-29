CREATE_HEADER_FOOTER_DOC=$(
	cat <<"EOF"
#/ DESCRIPTION:
#/	Returns text intended to be used as a header or footer in stdout. Upon
#/	failure, a non-zero code will be returned and output will be produced to
#/	stderr.
#/
#/ USAGE: createHeaderFooter [SPECIAL_OPTION] [OPTIONS...] --line-length=<maxMsgLength> [OPTIONS...]
#/
#/ NOTE(S):
#/	- Diffrent shells render special characters, like tab and new line,
#/		diffrently. Thus if this doc contains any special characters that have
#/		two backslashes, know that only one is intended.
#/	- Method may not use the log() function because this is used by that method.
#/
#/ SPECIAL OPTION(S):
#/	-h, --help
#/		Print this help message. Function will return code of '0'. No processing will be done.
#/		(OPTIONAL)
#/
#/ OPTION(S):
#/	-f=<formattingCharacter>, --formatting-character=<formattingCharacter>
#/		Sets character used to create header and footer.
#/			- Note: Default value: $DEFAULT_CHAR.
#/			- Note: Some special characters may require two to be given.
#/			- Note: Some characters may require quotes (ex. `>`).
#/			- Note: Given value may not include a back slash.
#/		(OPTIONAL)
#/	-l=<maxMsgLength>, --line-length=<maxMsgLength>
#/		Max number of characters in any line of message. Used to determine how
#/		long header/footer should be.
#/			- Note: This value should only include characters in message.
#/			- Note: Value must be a positive integer.
#/		(REQUIRED)
#/	--prefix
#/		Length of header/footer changes depending on if a prefix is being used.
#/			- Note: Should *always* be given if header/footer is used with a prefix.
#/		(REQUIRED/OPTIONAL)
#/
#/ RETURN CODE(S):
#/	- 0: Returned when:
#/		- Help message is requested and produced.
#/		- Processing is successful.
#/	- 140: Returned when given option name is invalid.
#/	- 141: Returned when given value of line length is invalid.
#/	- 142: Returned when line length option isn't provided.
#/
#/ EXAMPLE(S):
#/	createHeaderFooter --help
#/	createHeaderFooter -l=10
#/	createHeaderFooter -l=96 --prefix -f='#'
#/	createHeaderFooter -l=10 -f="@@"
#/	createHeaderFooter -l=12 -f=!
#/
#/ AUTHOR(S):
#/	- Reed Clanton
#/
#/ TODO(S):
#/	- None
EOF
)

createHeaderFooter() {
	################################
	## Reset/Set Local Variable(s) ##
	################################
	# Tracks header/footer text.
	headerFooter=""
	# Tracks character used for formatting.
	fChar=$DEFAULT_CHAR
	# Tracks desired total length of header/footer.
	len=0
	# Tracks if prefix is being used.
	prefixUsed=false
	# Error prefix added to error output messages.
	createHeaderFooterLogPrefix="ERROR createHeaderFooter():"
	if command -v date >/dev/null; then
		createHeaderFooterLogPrefix="$($(command -v date) +'%Y/%m/%d %H:%M:%S %Z') $createHeaderFooterLogPrefix"
	fi

	######################
	## Process Option(s) ##
	######################
	for fullArg in "$@"; do
		# Tracks value of current option.
		arg=${fullArg#*=}

		# Determine what option user gave.
		case $fullArg in
			--prefix)
				headerFooter="$headerFooter "
				prefixUsed=true
				len=$(($len + 3))
				;;
			-l=* | --line-length=*)
				# Strip space character(s) from argument.
				arg=$(echo $arg | tr -d '[:space:]')
				# Ensure provided line length is valid.
				case "$arg" in
					# TODO #45: Figure out how to remove this hard coded line length digit limit. Then update tests to verify it.
					[1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9] | [1-9][0-9][0-9][0-9][0-9])
						len=$(($arg + $len))
						;;
					*)
						echo "$createHeaderFooterLogPrefix Line length must be a positive integer, was '$arg', see doc:" >&2
						echo "$CREATE_HEADER_FOOTER_DOC" >&2
						return 141
						;;
				esac
				;;
			-f=* | --formatting-character=*)
				# Ensure a valid value was provided.
				case "$arg" in
					*\\* | "")
						echo "$createHeaderFooterLogPrefix Formatting character may not be blank or a special character (ex. new line, tab), was '$arg', see doc:" >&2
						echo "$CREATE_HEADER_FOOTER_DOC" >&2
						return 141
						;;
					*)
						# Track user desired formatting character(s).
						fChar=$arg
						;;
				esac
				;;
			-h | --help)
				echo "$CREATE_HEADER_FOOTER_DOC"
				return 0
				;;
			*)
				echo "$createHeaderFooterLogPrefix Caller provided invalid option: '$fullArg', see doc:" >&2
				echo "$CREATE_HEADER_FOOTER_DOC" >&2
				return 140
				;;
		esac
	done

	#########################
	## Error Check Input(s) ##
	#########################
	if [ $len -le 0 ]; then
		echo "$createHeaderFooterLogPrefix Line length must be provided, see doc:" >&2
		echo "$CREATE_HEADER_FOOTER_DOC" >&2
		return 142
	fi

	#########################################
	## Post Processing of Provided Value(s) ##
	#########################################
	# Account for additional header/footer length required when a prefix is being used.
	if $prefixUsed; then
		len=$(($(($((${#fChar} - 1)) * 2)) + $len))
	fi

	###########################
	## Generate Header/Footer ##
	###########################
	while [ ${#headerFooter} -lt $len ]; do
		# When near the end, given formatting character(s) may need to be split up.
		if [ $((${#headerFooter} + ${#fChar})) -gt $len ]; then
			# Note: POSIX doesn't support slicing, so a loop must be used.
			# Loop consumes variable.
			tmp=$fChar
			# Shortened formatting character.
			# Resulting shortened formatting character(s).
			shortFChar=""
			i=0
			while [ -n "$tmp" ]; do
				# Check if another character can fit in the line.
				if [ "$(($len - ${#headerFooter}))" = "$i" ]; then
					break
				fi
				i=$(($i + 1))

				# All but the first character of the string.
				rest=${tmp#?}
				# Append next character from formatting string to header/footer.
				shortFChar=$shortFChar${tmp%"$rest"}
				# Track remaining formatting string character(s).
				tmp=$rest
			done

			headerFooter=$headerFooter$shortFChar
		else
			headerFooter=$headerFooter$fChar
		fi
	done

	# Add new line and return.
	echo "$headerFooter"
}
