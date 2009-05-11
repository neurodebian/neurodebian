all:: pics

SVGIS=$(shell /bin/ls *.svgtune | sed -e 's/.svgtune/_tuned/g')

pics: $(SVGIS)

clean::
	for p in *.svg; do rm -f $${p%*.svg}.{pdf,eps,png}; done
	rm -rf *_tuned

ignore-%:
	@grep -q "^$*$$" .gitignore || { \
	  echo "$*" >> .gitignore; echo "Ignore $@"; }

%_tuned: %.svgtune ignore-%_tuned
	@echo "Splitting SVG using $<"
	@svgtune $<

%.pdf: %.svg ignore-%.pdf
	@echo "Rendering $@"
	@inkscape -z -f "$<" -A "$@"

%.png: %.svg ignore-%.png
	@echo "Rendering $@"
	@inkscape -z -f "$<" -e "$@" -d 150

%_w200.png: %.svg ignore-%_w200.png
	@echo "Rendering $@"
	@inkscape -z -f "$<" -e "$@" -w 200


# Some enforced conversions to overcome problems with transparency issues
# in PDFs
all:: logo_tuned/fmri_w200.png


.PHONY: all pics
