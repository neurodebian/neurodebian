#WWW_UPLOAD_URI = neuro.debian.net:/home/www/neuro.debian.net/www
WWW_UPLOAD_URI = ../www
WWW_DIR = build/html/

all: updatedb upload-website


pics:
	$(MAKE) -C artwork


html: pics source
	rsync -rvlhp sphinx/ build/src
	cd artwork;	cp button_w200.png logo_tuned/fmri_w200.png ../build/src/_static; cd ..
	cp 3rd/jquery.livetwitter/jquery.livetwitter.min.js build/src/_static
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build 2>&1
	mv $(WWW_DIR)/_static/robots.txt $(WWW_DIR)/
	cp -r build/src/lists $(WWW_DIR)/
	cp -r sphinx/survey/2011/figures/* $(WWW_DIR)/_images/


clean:
	-rm html-stamp source-stamp
	$(MAKE) -C artwork clean


distclean: clean
	-rm -rf build


source: source-stamp
source-stamp: build/db.db
	PYTHONPATH=. python neurodebian/dde.py \
		--cfg neurodebian.cfg \
		--db build/db.db \
		--outdir build/src \
		--pkgaddenum pkgs \
		--extracts /home/www/neuro.debian.net/www/debian/extracts \
		commandisirrelevant
	rm -f html-stamp
	touch $@


removecache:
	-rm -rf build/cache

removedb:
	-rm -f build/db.db


updatedb: removedb removecache build/db.db


build/db.db:
	mkdir -p build
	PYTHONPATH=. python neurodebian/dde.py \
		--cfg neurodebian.cfg \
		--db build/db.db \
		updatedb
	-rm -f source-stamp


upload-website: html
	rsync -rvzlhp --delete \
        --exclude=debian --exclude=debian-local --exclude=_files \
        --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)

.PHONY: removedb removecache updatedb upload-website clean distclean pics html

