#WWW_UPLOAD_URI = neuro.debian.net:/home/www/neuro.debian.net/www
WWW_UPLOAD_URI = ../www
WWW_DIR = build/html/

all: updatedb upload-website


pics:
	$(MAKE) -C artwork


html: pics source
	rsync -rvlhp sphinx/ build/src
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build 2>&1
	mv $(WWW_DIR)/_static/robots.txt $(WWW_DIR)/


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
		commandisirrelevant
	rm -f html-stamp
	touch $@


removecache:
	-rm -rf build/cache

removedb:
	-rm build/db.db


updatedb: removedb removecache build/db.db


build/db.db:
	mkdir -p build
	PYTHONPATH=. python neurodebian/dde.py \
		--cfg neurodebian.cfg \
		--db build/db.db \
		updatedb
	-rm source-stamp


upload-website: html
	rsync -rvzlhp --delete --exclude=debian --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)

.PHONY: removedb removecache updatedb upload-website clean distclean pics html

