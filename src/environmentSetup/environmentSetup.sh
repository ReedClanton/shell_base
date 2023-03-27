#!/usr/bin/env sh

 #########################
## Global(s)/Constant(s) ##
 #########################
## Global(s) ##
# NoOp
## Constant(s) ##
# NoOp

 #####################
## Local Variable(s) ##
 #####################
# NoOp

 ###############
## Function(s) ##
 ###############
IFS='' read -r -d '' ENVIRONMENT_SETUP_DOC <<"EOF"
#/ DESCRIPTION:
#/	Copies shell scripts and environent configuration files,
#/	like `~/.<yourShellName>rc`, to the home directory of the user that runs
#/	the script. Basically, the files in this repo replace your user level
#/	shell files. The original files are backed up to a directory that's created
#/	in the same location as this script.
#/
#/ USAGE: ./environmentSetup.sh [OPTIONS]...
#/
#/ NOTE(S):
#/	- Must be run (called) from the same directory as the script.
#/	- File containing flatpak aliases is also created, however, if it fails,
#/		this script won't revert other environment changes.
#/
#/ OPTION(S):
#/	-h, --help
#/		Print this help message. Function will return code of '0'. No processing will be
#/		done.
#/		(OPTIONAL)
#/ 
#/ RETURN CODE(S):
#/	- 0: Returned when:
#/		- Help message is requested OR
#/		- Processing is successful.
#/	- 1: Returned when:
#/		- Script needs to source file containing shell scripts, but can't find that file.
#/	- 20: Returned when:
#/		- Given option is invalid.
#/	- 21: Returned when:
#/		- Run from any directory other than the one the script is in.
#/	- 22: Retruned when:
#/		- User says they don't want to setup the current user's shell environment.
#/	- 23: Returned when:
#/		- User that's running this is one of a list of known system users
#/			(i.e. not the user's normally account).
#/	- 24: Returned when:
#/		- Back up directory already exists. Shouldn't occur unless user runs script,
#/			quickly stops it, then re-runs it.
#/	- 25: Returned when:
#/		- Failed to determine name of shell running in.
#/	- 26: Returned when:
#/		- Failed to create directory for backing up user's current shell
#/			enviroment configuration file(s).
#/	- 27: Returned when:
#/		- Failed to configure user's shell environment, but was able to revert it.
#/	- 28: Returned when:
#/		- Failed to configure user's shell environment and failed to revert to
#/			original hidden shell files (*this is bad*).
#/	- 29: Returned when:
#/		- Failed to configure user's shell environment and failed to revert to
#/			original shell directory (*this is bad*).
#/	- 30: Returned when:
#/		- Failed to configure user's shell environment and failed to remove new
#/			hidden shell file(s) from user's home directory. User will need to
#/			manually remove shell files in there home and copy the hidden shell
#/			file(s) from the back up directory to there home directory.
#/	- 31: Returned when:
#/		- Failed to configure user's shell environment and failed to copy
#/			user's original hidden shell file(s) back to there home directory.
#/			User will need to manually copy back up directory to there home
#/			directory.
#/	- 32: Returned when:
#/		- Failed to configure user's shell environment and failed to remove new
#/			shell directory from user's home directory. User will need to
#/			manually remove shell directory from there home and copy all
#/			file(s) and directory(ies) from the back up directory to there
#/			home directory.
#/	- 33: Returned when:
#/		- Failed to configure user's shell environment and fialed to copy
#/			user's original shell directory back to there home directory. User
#/			will need to manually remove hidden shell file(s) from there home
#/			and copy all file(s) and directory(ies) from the back up directory
#/			to there home directory.
#/	- 34: Returned when:
#/		- Failed to create file of flatpak app aliases.
#/
#/ EXAMPLE(S):
#/	./environmentSetup.sh
#/	./environmentSetup.sh -h
#/	./environmentSetup.sh --help
#/
#/ TODO(S):
#/	- Rather than moving user's original files to the back up directory, copy them then remove them.
#/	- Set a default answer and make user input checking more robust.
EOF
# Ensure script is being run from the same location as it's located.
if [[ "./$(basename $0)" == $0 ]]; then
	# If shell functions file hasn't been sourced, attempt to do so now.
	if [[ "$(type -t log)" = "" ]]; then
		shellRoot=../shell/shell_functions
		if [[ -f "$shellRoot" ]]; then
			. $shellRoot
		else
			echo "Failed to find file used to locate (source) shell scripts ($shellRoot)."
			exit 1
		fi
	fi

	funcName=environmentSetup
	log -c=$funcName -m="Resetting local variable(s)..."
	 ###############################
	## Reset/Set Local Variable(s) ##
	 ###############################
	# Logging var(s).
	traceLvl="-t -c=$funcName"
	readonly traceLvl
	debugLvl="-d -c=$funcName"
	readonly debugLvl
	infoLvl="-i -c=$funcName"
	readonly infoLvl
	warnLvl="-w -c=$funcName"
	readonly warnLvl
	errorLvl="-e -c=$funcName"
	readonly errorLvl
	# Tracks directory that file(s)/directory(ies) being replaced will be moved to.
	BACK_UP_DIR="$PWD/$USER-homeBackUp-$(date +"%Y_%m_%d-%H_%M_%S")"
	readonly BACK_UP_DIR
	# List of users, specifically there UIDs, that script should be run as.
	declare -ra INVALID_USERS="0 65534"
	# User's home directory.
	userHome=$HOME
	# Tracks repo's root source directory.
	repoSourceRoot=$(readlink -f $PWD/../)
	log $traceLvl -m="Local variable(s) reset."

	 #####################
	## Process Option(s) ##
	 #####################
	for fullArg in "${@}"; do
		log $traceLvl -m="Processing option: '$fullArg'..."
		# Tracks value of current option.
		arg=${fullArg#*=}

		# Determine what option user gave.
		case $fullArg in
			-h|--help)
				echo "$ENVIRONMENT_SETUP_DOC"
				exit 0  ;;
			*)
				log $errorLvl --full-title -m="Invalid given argument: '$fullArg', see doc:"
				echo "$ENVIRONMENT_SETUP_DOC"
				return 20  ;;
		esac
	done

	# Ask user if the user that's currently running this script is the one they would like to setup.
	log $infoLvl --line-title -m="The user that's running this script ($USER) is the one that will have there environment setup."
	printf "Would you like to run environment setup for '$USER' (y/n): "
	read userAnswer
	if [[ "$userAnswer" = "y" ]]; then
		# Ensure script is being run by a plausibly valid user.
		if ! [[ " ${INVALID_USERS[*]} " =~ " $EUID " ]]; then
			# Ensure directory for backing up user's environment config doesn't already exist.
			if [[ ! -d "$BACK_UP_DIR" ]]; then
				# Determine name of current shell.
				shellNm=shellName
				readonly shellNm
				
				# Ensure shell name was found.
				if [[ "$SHELL" != "$shellNm" && "$shellNm" != "" ]]; then
					log $debugLvl -m="Creating local directory for storing $USER's file(s) that are being replaced..."
					
					cmd="mkdir $BACK_UP_DIR"
					unset stdOut errOut rtOut
					eval "$( (eval $cmd) \
						2> >(errOut=$(cat); typeset -p errOut) \
						 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
				
					# Ensure directory for storing user's current environment setup was created.
					if [[ $rtOut -eq 0 ]]; then
						# Back up user's hidden shell file(s) if they exist.
						if compgen -G "$userHome/.$shellNm*" > /dev/null; then
							log $debugLvl -m="Backing up '$userHome/.$shellNm*' files to '$BACK_UP_DIR'..."
							cmd="mv $userHome/.$shellNm* $BACK_UP_DIR/"
							unset stdOut errOut rtOut
							eval "$( (eval $cmd) \
								2> >(errOut=$(cat); typeset -p errOut) \
								 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
						else
							log $infoLvl -m="No hidden shell file(s) to back up, skipping."
							rtOut=0
						fi
						
						# Ensure hidden shell file(s) were moved to the back up directory.
						if [[ $rtOut -eq 0 ]]; then
							# If a directory named shell exists it must be backed up because it'll be replaced by this script.
							if [[ -d "$userHome/shell" ]]; then
								log $debugLvl -m="Backing up shell directory '$userHome/shell' from $USER's home directory..."
								cmd="mv $userHome/shell $BACK_UP_DIR/"
								unset stdOut errOut rtOut
								eval "$( (eval $cmd) \
									2> >(errOut=$(cat); typeset -p errOut) \
									 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
							else
								log $infoLvl -m="No directory named 'shell' found in $USER's home, back up skipped."
								rtOut=0
							fi
							
							# Ensure move worked.
							if [[ $rtOut -eq 0 ]]; then
								log $debugLvl -m="Copying hidden shell setup file(s) from '$repoSourceRoot/.shell*' file(s) to '$userHome/'..."
								
								for shellFilePath in $repoSourceRoot/.shell*; do
									newShellFilePath=$userHome/.$shellNm${shellFilePath#$repoSourceRoot/.shell}
									log $traceLvl -m="Copying '$shellFilePath' to '$newShellFilePath'..."
									cmd="cp $shellFilePath $newShellFilePath"
									unset stdOut errOut rtOut
									eval "$( (eval $cmd) \
										2> >(errOut=$(cat); typeset -p errOut) \
										 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
									# Stop copying files if a copy fails.
									if [[ $rtOut -ne 0 ]]; then
										log $errorLvl -m="Failed to move '$shellFilePath' to '$newShellFilePath'."
										break
									fi
								done
								
								# Ensure hidden shell file(s) were moved.
								if [[ $rtOut -eq 0 ]]; then
									log $debugLvl -m="Copying '$repoSourceRoot/shell' to '$userHome/'..."
									cmd="cp -r $repoSourceRoot/shell $userHome/shell"
									unset stdOut errOut rtOut
									eval "$( (eval $cmd) \
										2> >(errOut=$(cat); typeset -p errOut) \
										 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
									
									# Ensure shell directory copy worked.
									if [[ $rtOut -eq 0 ]]; then
										# Create file that adds aliases for flatpak apps.
										$PWD/util/flatpakAliasCreator.sh
										if [[ $? -eq 0 ]]; then
											log $debugLvl -m="flatpakAliasCreator() std out:" -m="$stdOut"
											log $infoLvl -m="Success!"
											exit 0
										else
											log $errorLvl -m="Failed to create file of flatpak app aliases. flatpakAliasCreaator() error output:" -m="$errOut"
											exit 34
										fi
									else
										log $errorLvl -m="Failed to copy directory with shell scripts to $USER's home."
									fi
									
									# Remove shell directory that copy failed for.\
									if [[ -d "$userHome/shell" ]]; then
										log $debugLvl -m="Removing '$userHome/shell..."
										cmd="rm -rf $userHome/shell"
										unset stdOut errOut rtOut
										eval "$( (eval $cmd) \
											2> >(errOut=$(cat); typeset -p errOut) \
											 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
										# Check if deletion worked.
										if [[ $rtOut -ne 0 ]]; then
											log $errorLvl -m="Failed to revert environment, you'll need to manually copy contents of '$BACK_UP_DIR' back to '$userHome'."
											exit 32
										fi
									else
										log $infoLvl -m="Skipping removal of 'shell' directory from $USER's home because it doesn't exist."
									fi
									
									# Check if back up contains a shell directory.
									if [[ -d "$BACK_UP_DIR/shell" ]]; then
										log $debugLvl -m="Copying 'shell' directory to $USER's home from back up copy..."
										# Copy old shell directory back.
										cmd="cp -r $BACK_UP_DIR/shell $userHome/"
										unset stdOut errOut rtOut
										eval "$( (eval $cmd) \
											2> >(errOut=$(cat); typeset -p errOut) \
											 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
										# Check if deletion worked.
										if [[ $rtOut -ne 0 ]]; then
											log $errorLvl -m="Failed to revert environment, you'll need to manually copy contents of '$BACK_UP_DIR' back to '$userHome'."
											exit 33
										fi
									else
										log $infoLvl -m="Skipping copying 'shell' directory from back up because the back up doesn't contain it."
									fi
								else
									log $errorLvl -m="Failed to move hidden shell file(s) to $USER's home."
								fi
								
								# Remove hidden file(s) that were copied to user's home.
								cmd="rm $userHome/.$shellNm*"
								unset stdOut errOut rtOut
								eval "$( (eval $cmd) \
									2> >(errOut=$(cat); typeset -p errOut) \
									 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
								# Stop copying files if a copy fails.
								if [[ $rtOut -ne 0 ]]; then
									log $errorLvl -m="Failed to move '$shellFilePath' to '$newShellFilePath'."
									exit 30
								fi
								
								# Revert to original hidden shell file(s).
								if compgen -G "$BACK_UP_DIR/.*" > /dev/null; then
									log $debugLvl -m="Copying hidden shell file(s) from back up to $USER's home..."
									# Copy backed up files to user's home.
									cmd="cp $BACK_UP_DIR/.* $userHome/"
									unset stdOut errOut rtOut
									eval "$( (eval $cmd) \
										2> >(errOut=$(cat); typeset -p errOut) \
										 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
									# Stop copying files if a copy fails.
									if [[ $rtOut -ne 0 ]]; then
										log $errorLvl -m="Failed to move hidden files from '$BACK_UP_DIR' back to $USER's home, you'll need to manually copy contents."
										exit 31
									fi
								else
									log $warnLvl -m="Skipping copying of hidden shell file(s) because the back up doesn't contain any."
								fi
							else
								log $errorLvl -m="Failed to back up (move) '$userHome/shell' to '$BACK_UP_DIR/'."
							fi
							
							# Attempt to move shell directory back to user's home.
							if [[ -d "$BACK_UP_DIR/shell" ]]; then
								cmd="cp -r $BACK_UP_DIR/shell $userHome/"
								unset stdOut errOut rtOut
								eval "$( (eval $cmd) \
									2> >(errOut=$(cat); typeset -p errOut) \
									 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
								# Check if deletion worked.
								if [[ $rtOut -ne 0 ]]; then
									log $errorLvl -m="Failed to revert to original shell directory, you'll need to manually copy contents of '$BACK_UP_DIR' back to '$userHome'."
									exit 29
								fi
							fi
						else
							log $errorLvl -m="Failed to back up (move) '$userHome/.$shellNm*' file(s) to '$BACK_UP_DIR'."
						fi
						
						# Ensure any file(s) that were moved from user's home are moved back.
						if compgen -G "$BACK_UP_DIR/.$shellNm*" > /dev/null; then
							cmd="cp $BACK_UP_DIR/.* $userHome/"
							unset stdOut errOut rtOut
							eval "$( (eval $cmd) \
								2> >(errOut=$(cat); typeset -p errOut) \
								 > >(stdOut=$(cat); typeset -p stdOut); rtOut=$?; typeset -p rtOut )"
							# Check if deletion worked.
							if [[ $rtOut -ne 0 ]]; then
								log $errorLvl -m="Failed to revert to original hidden shell file(s), you'll need to manually copy contents of '$BACK_UP_DIR/' back to '$userHome/'."
								exit 28
							fi
						fi
						
						log $infoLvl -m="Shell environment configuration reverted."
						exit 27
					else
						log $errorLvl -m="Failed to create directory for backing up $USER's data."
						exit 26
					fi
				else
					log $errorLvl -m="Failed, couldn't determine shell name."
					exit 25
				fi
			else
				log $errorLvl -m="Failed because back up directory '$BACK_UP_DIR' already exists."
				exit 24
			fi
		else
			log $errorLvl -m="Failed, script must be run using your user, not '$USER'."
			exit 23
		fi
	else
		log $errorLvl --line-title -m="Re-launch this as the user you'd like to configure the environment of."
		exit 22
	fi
else
	log $errorLvl -m="Failed, script must be run from the same directory it's located in."
	exit 21
fi
