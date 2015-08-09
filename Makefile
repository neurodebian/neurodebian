WWW_UPLOAD_URI = neurodebian@neurodebian.ovgu.de:/home/neurodebian/www
#WWW_UPLOAD_URI = ../../www
WWW_DIR = build/html/

WWW_UPLOAD_URI_STATIC=$(WWW_UPLOAD_URI)/_static

BIGMESS_OPTS = -c neurodebian.cfg
BIGMESS_CMD = PYTHONPATH=.:3rd/bigmess:$(PYTHONPATH) 3rd/bigmess/bin/bigmess
BIGMESS = $(BIGMESS_CMD) $(BIGMESS_OPTS)

# Lentghy one due to updatedb
all: updatedb upload-website mirmon
# Quick one -- just rebuilds html if new changes and adjusts the status of the mirrors
refresh: upload-website-stamp mirmon

website-build-depends:
	: # Python modules
	sudo apt-get install python-sphinx python-argparse python-xdg python-debian python-html5lib
	: # JavaScripts
	sudo apt-get install libjs-jquery-easing libjs-jquery-mousewheel libjs-jquery-fancybox


pics:
	$(MAKE) -C artwork


html: pics source
	rsync -rvlhpt sphinx/ build/src
	cd artwork;	cp button_w200.png logo_tuned/fmri_w200.png *-logo_h50.png ../build/src/_static; cd ..
	cp 3rd/jquery.livetwitter/jquery.livetwitter.min.js build/src/_static
	cp neurodebian.cfg build/src/_static
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build 2>&1
	ln -fs /usr/share/javascript build/html/
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
source-stamp:
	mkdir -p build/src/pkgs/
	mkdir -p build/src/lists/
	mkdir -p build/src/_static/
	mkdir -p build/src/pkglists/
	$(BIGMESS) mkpkgs --template sphinx/_bigmess/binary_pkg.rst -d build/src/pkgs/
	$(BIGMESS) mkaptcfgs -d build/src/lists/
#	$(BIGMESS) mkmirrorsstat -d build/src
	$(BIGMESS) mkrepocfg --template sphinx/_bigmess/sources_lists.rst > build/src/sources_lists
	$(BIGMESS) mkpkgtocs --srcpkgtoc-template sphinx/_bigmess/pkg_toc.rst --binpkgtoc-template sphinx/_bigmess/pkg_toc.rst -d build/src/pkglists > build/src/pkgs.rst
	cp 3rd/nvd3/*.min.js build/src/_static/
	cp 3rd/nvd3/lib/d3*.min.js build/src/_static/
	cp 3rd/nvd3/src/nv*.css build/src/_static/
	touch $@

cachefiles:
	$(BIGMESS) cachefiles -f

updatedb: cachefiles
	$(BIGMESS) updatedb
	-rm source-stamp

upload-website: html
	rsync -rvzlhp --delete \
        --exclude=debian --exclude=debian-local --exclude=debian-devel --exclude=debian-custom --exclude=_files \
        --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)
	rsync -rvzlhp --chmod=Dg+s,g+rw tools/neurodebian-travis.sh $(WWW_UPLOAD_URI)/_files/
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

.PHONY: removedb removecache cachefiles updatedb upload-website clean distclean pics html mirmon

