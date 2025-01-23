SRC = src
DIAGRAMS = diagrams
ASSETS = assets
OUT = build
DIAGRAMFILES := $(wildcard $(SRC)/$(DIAGRAMS)/*.txt)

all: build_document build_slides

build_document: generate_diagrams
	latexmk -pdf -f -e '$$bibtex_fudge=1' -outdir=$(OUT) $(SRC)/main.tex

build_slides: generate_diagrams
	latexmk -pdf -f -e '$$bibtex_fudge=1' -outdir=$(OUT)/slides $(SRC)/slides.tex

watch_document: generate_diagrams
	latexmk -pdf -pvc -f -e '$$bibtex_fudge=1' -outdir=$(OUT) $(SRC)/main.tex

watch_slides: generate_diagrams
	latexmk -pdf -pvc -f -e '$$bibtex_fudge=1' -outdir=$(OUT)/slides $(SRC)/slides.tex

watch_diagrams:
	@while inotifywait -r -e modify,create,delete ./$(SRC)/$(DIAGRAMS); do \
		${MAKE} generate_diagrams; \
	done

generate_diagrams:
	mkdir -p $(ASSETS)/$(DIAGRAMS)
	@for file in $(DIAGRAMFILES); do \
		echo "Processing $$file..."; \
		plantuml $$file -o ../../$(ASSETS)/$(DIAGRAMS); \
	done

clean:
	$(RM) -r $(OUT)

.phony: all clean

.phony: watch_document watch_diagrams watch_slides

.phony: build_document build_slides generate_diagrams
