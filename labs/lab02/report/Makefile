all: pdf docx

pdf:
	quarto render lab02.qmd --to pdf --no-execute

docx:
	quarto render lab02.qmd --to docx --no-execute

clean:
	rm -rf _output .quarto

.PHONY: all pdf docx clean
