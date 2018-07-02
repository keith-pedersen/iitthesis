#!/usr/bin/python3

# Copyright (C) 2018 by Keith Pedersen (Keith.David.Pedersen@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# 
# This script fixes the *.lof file produced by iitthesis.cls when compiling a thesis
# This *.lof contains the list of figures that will be used the next time pdflatex is run
# The *.lof file contains any citations that are in the captions, 
# which will screw up the reference numbering (reference [1] will be 
# the first figure in the list of figures, even if that's 10 pages deep in the thesis).
# To fix this problem, we go through the *.lof and remove all citations.
# This is done with regular expressions, so we use the re package

# depending on how the user cited the figure, we have two patterns to look for
##############################################################################

# non-breaking space

# "$N_\text{ch}^\text{reco}$)~\cite{TheATLAScollaboration:2015uzr}."
# 		will show up as
# "$N_\text {ch}^\text {reco}$)\nobreakspace {}\cite {TheATLAScollaboration:2015uzr}."

# normal space

# "$N_\text{ch}^\text{reco}$) \cite{TheATLAScollaboration:2015uzr}."
# 		will show up as 
# "$N_\text {ch}^\text {reco}$) \cite {TheATLAScollaboration:2015uzr}."

# no space

# "$N_\text{ch}^\text{reco}$)\cite{TheATLAScollaboration:2015uzr}."
# 		will show up as
# "$N_\text {ch}^\text {reco}$)\cite {TheATLAScollaboration:2015uzr}."

# package re highly recommends using byte strings, since that is what is 
# used under the hood. So we need to work with byte strings.
 
# When Python reads in our file, it will convert "\cite" in the file to str("\\cite"),
# with the extra escape character. 
# To get two back-slashes to the regex byte string, we have to use FOUR back-slahes when we create it

# A few notes:
# * When we match \cite{whatever}, we use ? to choose the minimal (non-greedy) match, 
#   Otherwise we match too-many closing curly brackets, which need to remain.

pattern_noBreak = b"\\\\nobreakspace {}\\\\cite {.*?}" # match the non-breaking space
pattern_norm = b"( )*\\\\cite {.*?}" # match a cite without the non-breaking space, preceded by as many normal spaces as exist.

from regexRemove import *
import sys

regexRemove([pattern_noBreak, pattern_norm], "lof")
