#!/bin/bash

# Copyright (C) 2018 by Keith Pedersen (Keith.David.Pedersen@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# This script is for compiling the main thesis *.tex file, which begins with "\documentclass{iitthesis}"
# The compilation creates a list of figures file *.lof and table of contents *.toc
# that will be used the NEXT time pdflatex is run (i.e., you have to run pdflatex at least twice).
# By immediately running a script that corrects these files after each call to pdflatex, 
# we can ensure that our PDF will always appear as desired.

if [ $# -ne 0 ] # Ensure that a file path is supplied as an argument
	then
		# Comments assume you called this script with the argument: myThesis.tex
		filename=$(basename -- $1) # Extract any leading directories (though if there are any, this script won't work, so I don't know why I wrote this line)
		extension="${filename##*.}" # From myThesis.tex, extract the extension (tex)
		rootname="${filename%.*}" # From myThesis.tex, extract the root name (myThesis)

		if [ "$extension" = "tex" ] # The file path should point to a tex file
			then 
				pdflatex --file-line-error-style "$filename" # compile the thesis
				bibtex "$rootname.aux" # I assume you are using a *.bib file, so run bibtex
				
				# Now correct the two auxiliary files created by pdflatex
				python3 removeCitations_ListOfFigures.py "$rootname.lof"
				python3 removeBoldSymbol_TableOfContents.py "$rootname.toc"
			else
				echo 
				echo "Expecting a *.tex file, exiting"
		fi
	else
		echo 
		echo "Usage: MakeThesis.sh myThesis.tex"
		echo "No \"*.tex\" file supplied, exiting"		
fi
