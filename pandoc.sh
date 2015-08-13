pandoc --latex-engine=xelatex --latexmathml -H preamble.tex -V fontsize=12pt  -V papersize:a4paper output.md -o "final.pdf"






pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=11pt -V documentclass:article -V papersize:a4paper -V classoption:openright --bibliography=library2.bib --csl="csl/biomed-central.csl" Background.md -o "background.pdf"
 
pandoc --latex-engine=xelatex --latexmathml  -H preamble.tex -V fontsize=12pt  -V papersize:a4paper sup_file2.md -o "sup2.pdf"
