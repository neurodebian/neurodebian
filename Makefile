
WWW_UPLOAD_URI = elrond:/home/hanke/public_html/archive
WWW_DIR = build/html


prep:
	mkdir -p build/src
	cp -r sphinx/* build/src


html: prep source
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build


clean:
	-rm -rf build


distclean: clean
	-rm -rf cache


source:
	./reblender generate \
		--cfg debneuro.cfg \
		--db build/db.db \
		--outdir build/src \
		--pkgaddenum pkgs


refresh-db:
	mkdir -p build
#	rm -f build/db.db
	./reblender refreshdb \
		--cfg debneuro.cfg \
		--db build/db.db


upload-website: html
	rsync -rvzlhp --delete --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)
