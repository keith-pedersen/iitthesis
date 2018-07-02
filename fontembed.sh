#!/bin/bash

# Copyright (C) 2018 by Keith Pedersen (Keith.David.Pedersen@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# This script uses ghostscript to take a PDF and embed all fonts.
# If a font is not found on the system, then a suitable replacement is found.
# If the same font is embedded multiple times (e.g. embedded figures), it is consolidated.
# This script is particularly useful when:
# (i) your pdflatex PDF has embedded PDF figures with non-embedded fonts
# (ii) your pdflatex PDF has embedded PDF figures which repeatedly re-embed the same fonts

# Bash builtin key:
# $# = number of arguments.
# $@ = what parameters were passed.
# $? = exit condition of last command (0 == success)

if [ $# -ne 0 ] # must pass an argument (the PDF file path)
	then
		
		# Check for file existence
		if ! [ -e $1 ]
			then 
			echo
			echo "fontembed: error ... file not found"
			exit 1
		fi
		
		# Check that file is a PDF. Thanks to Adam Bellaire and Jan Taylor for testing for substrings
		#    https://stackoverflow.com/questions/229551/string-contains-a-substring-in-bash
		fileType=$(file --mime-type $1)
		if ! [[ $fileType = *"pdf"* ]]
			then 
			echo
			echo "fontembed: error ... file not a PDF (or no read permission)"
			exit 2 
		fi
		
		inputFile=$1
		outputFile=$1
		
		if [ $# -gt 1 ]
			then # second argument is target, otherwise source is target
				outputFile=$2
			else
				# If source is target, must move to different file as gs writes in place.
				# However, this also allows file restore if ghostscript has an error, 
				# and keeps the original file around (in case ghostscript mangles it)
				mv $1 $1.orig
				inputFile=$1.orig
		fi
		
		# Thanks to Karl Rupp for this GhostScript command
		#    https://www.karlrupp.net/2016/01/embed-all-fonts-in-pdfs-latex-pdflatex/
		gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -dEmbedAllFonts=true -sOutputFile=$outputFile -f $inputFile
		
		# Catch gs error and restore original
		gsError=$?
		if [ "$gsError" -ne 0 ]
			
			then 
			echo
			echo "fontembed: error ... restoring original file"
			
			if [ $# = 1 ] # source is target; we moved source, restore it
				then
					mv $1.orig $1 
			fi
			
			exit gsError # return gs 
		fi
fi
