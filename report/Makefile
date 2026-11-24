.PHONY: pdf tectonic

pdf:
	mkdir -p build output/pdf
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build report.tex
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=build report.tex
	cp build/report.pdf output/pdf/report-template.pdf

tectonic:
	mkdir -p build output/pdf
	tectonic --untrusted --keep-logs --keep-intermediates --outdir build report.tex
	cp build/report.pdf output/pdf/report-template.pdf
