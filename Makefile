SRC = src
DIAGRAMS = diagrams
ASSETS = assets
OUT = build
DIAGRAMFILES := $(wildcard $(SRC)/$(DIAGRAMS)/*.txt)

all: watch_document

watch_document: generate_diagrams
	latexmk -pdf -pvc -f -e '$$bibtex_fudge=1' -outdir=$(OUT) $(SRC)/main.tex

watch_slides: generate_diagrams
	latexmk -pdf -pvc -f -e '$$bibtex_fudge=1' -outdir=$(OUT)/slides $(SRC)/slides.tex

watch_diagram:
	@while inotifywait -r -e modify,create,delete ./$(SRC)/$(DIAGRAMS); do \
		make generate_diagrams; \
	done

generate_diagrams:
	mkdir -p $(ASSETS)/$(DIAGRAMS)
	@for file in $(DIAGRAMFILES); do \
		echo "Processing $$file..."; \
		plantuml $$file -o ../../$(ASSETS)/$(DIAGRAMS); \
	done

clean:
	rm -rf $(OUT)

.phony: all clean watch_document watch_diagram generate_diagrams
