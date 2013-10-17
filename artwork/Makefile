all:: pics

SVGIS=$(shell /bin/ls *.svgtune | sed -e 's/.svgtune/_tuned/g')
ICONSIZED=ccn-logo_h50.png uni-md-logo_h50.png dartmouth-logo_h50.png

pics: $(SVGIS) $(ICONSIZED)

clean::
	for p in *.svg; do rm -f $${p%*.svg}.{pdf,eps,png}; done
	rm -rf *_tuned
	rm -f  $(ICONSIZED)

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

# icon sized versions
%_h50.png: %.png ignore-%_h50.png
	@echo "Generating downscaled $@"
	@convert -geometry x50 "$<" "$@"

# Some enforced conversions to overcome problems with transparency issues
# in PDFs
all:: logo_tuned/fmri_w200.png button_w200.png


.PHONY: all pics
