#~ Wherever you place the git repo directory <iithesis/>,
#~ you will need links to the class and font files in your main compilation directory (MCD)
#~ (i.e. where "YourThesis.tex" lives). I place my <iithesis/> folder directly in my MCD. 
#~ If you do the same, you can run the this script in the MCD to make the required links.
ln -s iitthesis/iitthesis.cls 
ln -s iitthesis/font11.clo 
ln -s iitthesis/font12.clo
ln -s iitthesis/makeThesis.sh
ln -s iitthesis/fontembed.sh
ln -s iitthesis/regexRemove.py
ln -s iitthesis/removeCitations_ListOfFigures.py
ln -s iitthesis/removeBoldSymbol_TableOfContents.py
cp iitthesis/MakeMyThesis.sh .
