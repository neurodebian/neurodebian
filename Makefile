# Makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
PAPER         =

# Internal variables.
SRCDIR = build/source
PAPEROPT_a4     = -D latex_paper_size=a4
PAPEROPT_letter = -D latex_paper_size=letter
ALLSPHINXOPTS   = -d build/doctrees $(PAPEROPT_$(PAPER)) $(SPHINXOPTS) $(SRCDIR)


WWW_UPLOAD_URI = elrond:/home/hanke/public_html/archive
WWW_DIR = build/html


.PHONY: help clean html web pickle htmlhelp latex changes linkcheck


prep:
	mkdir -p build
	cp -r source build/


clean:
	-rm -rf build

html: prep
	mkdir -p build/html build/doctrees
	$(SPHINXBUILD) -b html $(ALLSPHINXOPTS) build/html
	@echo
	@echo "Build finished. The HTML pages are in build/html."

pickle: prep
	mkdir -p build/pickle build/doctrees
	$(SPHINXBUILD) -b pickle $(ALLSPHINXOPTS) build/pickle
	@echo
	@echo "Build finished; now you can process the pickle files."

web: pickle

json: prep
	mkdir -p build/json build/doctrees
	$(SPHINXBUILD) -b json $(ALLSPHINXOPTS) build/json
	@echo
	@echo "Build finished; now you can process the JSON files."

htmlhelp: prep
	mkdir -p build/htmlhelp build/doctrees
	$(SPHINXBUILD) -b htmlhelp $(ALLSPHINXOPTS) build/htmlhelp
	@echo
	@echo "Build finished; now you can run HTML Help Workshop with the" \
	      ".hhp project file in build/htmlhelp."

latex: prep
	mkdir -p build/latex build/doctrees
	$(SPHINXBUILD) -b latex $(ALLSPHINXOPTS) build/latex
	@echo
	@echo "Build finished; the LaTeX files are in build/latex."
	@echo "Run \`make all-pdf' or \`make all-ps' in that directory to" \
	      "run these through (pdf)latex."

changes: prep
	mkdir -p build/changes build/doctrees
	$(SPHINXBUILD) -b changes $(ALLSPHINXOPTS) build/changes
	@echo
	@echo "The overview file is in build/changes."

linkcheck: prep
	mkdir -p build/linkcheck build/doctrees
	$(SPHINXBUILD) -b linkcheck $(ALLSPHINXOPTS) build/linkcheck
	@echo
	@echo "Link check complete; look for any errors in the above output " \
	"or in build/linkcheck/output.txt."


update-db:
	./reblender


upload-website: html
	rsync -rvzlhp --delete --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)
