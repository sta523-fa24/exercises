all: paper.html

paper.html: paper.qmd fig1/fig.png fig2/fig.png
	quarto render paper.qmd

fig%/fig.png: fig%/fig.R
	cd $(<D);Rscript $(<F)

clean: 
	rm -f paper.html
	rm -f paper.pdf

.PHONY: all clean
