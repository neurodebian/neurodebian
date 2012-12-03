#WWW_UPLOAD_URI = neuro.debian.net:/home/www/neuro.debian.net/www
WWW_UPLOAD_URI = ../www
WWW_DIR = build/html/

WWW_UPLOAD_URI_STATIC=$(WWW_UPLOAD_URI)/_static

# Lentghy one due to updatedb
all: updatedb upload-website mirmon
# Quick one -- just rebuilds html if new changes and adjusts the status of the mirrors
refresh: upload-website-stamp mirmon


pics:
	$(MAKE) -C artwork


html: pics source
	rsync -rvlhpt sphinx/ build/src
	cd artwork;	cp button_w200.png logo_tuned/fmri_w200.png ../build/src/_static; cd ..
	cp 3rd/jquery.livetwitter/jquery.livetwitter.min.js build/src/_static
	cp neurodebian.cfg build/src/_static
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build 2>&1
	mv $(WWW_DIR)/_static/robots.txt $(WWW_DIR)/
	cp -r build/src/lists $(WWW_DIR)/
	cp -r sphinx/survey/2011/figures/* $(WWW_DIR)/_images/
	@echo "I: extracting header/trailer to be reused in non-sphinx pages"
	sed -ne '1,/<!-- HEADNOTES -->/p' $(WWW_DIR)/index.html >| $(WWW_DIR)/_static/index-header.ihtml
	sed -ne '/<h2>Comments<\/h2>/,$$p' $(WWW_DIR)/index.html >| $(WWW_DIR)/_static/index-trailer.ihtml

clean:
	-rm html-stamp source-stamp upload-website-stamp
	$(MAKE) -C artwork clean


distclean: clean
	-rm -rf build


source: source-stamp
source-stamp: build/db.db
	PYTHONPATH=.:$(PYTHONPATH) python neurodebian/dde.py \
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
	PYTHONPATH=.:$(PYTHONPATH) python neurodebian/dde.py \
		--cfg neurodebian.cfg \
		--db build/db.db \
		updatedb
	-rm -f source-stamp


upload-website: html
	rsync -rvzlhp --delete \
        --exclude=debian --exclude=debian-local --exclude=_files \
        --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)
	: # Touch stamp here so we get it updated on every upload
	touch $@-stamp

# call upload iff .git/index was modified, i.e. new changes got pulled in
upload-website-stamp: .git/index
	$(MAKE) upload-website

mirmon:
	# update and generate mirrors report
	[ -x /usr/bin/mirmon ] && mirmon -q -get update -c mirmon-neurodebian.conf 2>&1 \
        | grep -v 'date: invalid date.*DOCTYPE' || :
	# [ -x $(WWW_UPLOAD_URI_STATIC)/mirrors-check.ihtml ] &&
	# everything must be in place!
	cat $(WWW_UPLOAD_URI_STATIC)/{index-header,mirrors-status,index-trailer}.ihtml \
	 >| $(WWW_UPLOAD_URI)/mirrors-status.html

.PHONY: removedb removecache updatedb upload-website clean distclean pics html mirmon

