rm output.md
touch output.md
for f in Abstract.md Background.md Methods.md Results.md Tables.md figures.md References.md Additional_figures.md
do
	cat $f >> output.md
done