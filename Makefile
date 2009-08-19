WWW_UPLOAD_URI = neuro.debian.net:/home/www/neuro.debian.net/www
WWW_DIR = build/html

all: html


prep:
	if [ ! -d build ]; then mkdir build; fi
	rsync -rvlhp sphinx/ build/src


pics:
	$(MAKE) -C artwork


html: html-stamp
html-stamp: pics prep source
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build
	touch $@


clean:
	-rm html-stamp source-stamp
	$(MAKE) -C artwork clean


distclean: clean
	-rm -rf build
	-rm -rf cache


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


removedb:
	-rm build/db.db


updatedb: distclean build/db.db


build/db.db:
	mkdir -p build
	PYTHONPATH=. python neurodebian/dde.py \
		--cfg neurodebian.cfg \
		--db build/db.db \
		updatedb


upload-website: html
	rsync -rvzlhp --delete --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)

.PHONY: prep
