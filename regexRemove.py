#!/usr/bin/python3

# Copyright (C) 2018 by Keith Pedersen (Keith.David.Pedersen@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# This file defines a python function which opens a file and removes 
# any regular expressions matching the supplied patterns
import re
import sys

def regexRemove(patternList, requiredExtension = ""):
	if ((type(patternList) == str) or (type(patternList) == bytes)):
		patternList = [patternList,]
	
	if (type(patternList) != list):
		raise TypeError("patternList should be a string or a list of strings")
	
	lines = list()
	
	filePath = sys.argv[1] if (len(sys.argv) > 1) else "."
	
	if((filePath == ".") or (filePath.find(requiredExtension) < 0)):
		print("\n", "No *." + requiredExtension + "  file supplied, exiting.")
		exit()

	# Open the file, read the lines, and remove citations
	try:
		with open(filePath, "r") as file:			
			lines = file.readlines()
			
			for i in range(len(lines)): # must do by index, otherwise it's not a reference
				for pattern in patternList:
					# Replace pattern with blank space	
					lines[i] = re.sub(pattern, b"", lines[i].encode()).decode()
		
		# Open the file for writing, deleting existing file, and write corrected lines
		with open(filePath, "w") as file:
			file.writelines(lines)

	# Catch the exception if the file could not be opened
	except FileNotFoundError:
		print("\n", "File <" + filePath + "> could not be found, exiting.")
		exit()
