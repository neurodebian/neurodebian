
WWW_UPLOAD_URI = elrond:/home/hanke/public_html/archive
WWW_DIR = build/_build/html


prep:
	mkdir -p build/src
	cp -r sphinx/* build/src


html: prep update-db
	cd build/src && $(MAKE) html BUILDDIR=$(CURDIR)/build


clean:
	-rm -rf build


update-db:
#		-r http://apsy.gse.uni-magdeburg.de/debian/dists/lenny/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/squeeze/Release \
#	rm -f build/db.db
	./reblender \
		--db build/db.db \
		--outdir build/src \
		--pkgaddenum pkgs \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/dapper/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/gutsy/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/hardy/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/intrepid/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/etch/Release \
		-r http://apsy.gse.uni-magdeburg.de/debian/dists/sid/Release \
		-t svn://svn.debian.org/blends/projects/med/trunk/debian-med/tasks/imaging \
		-t svn://svn.debian.org/blends/projects/med/trunk/debian-med/tasks/imaging-dev \
		-t svn://svn.debian.org/blends/projects/science/trunk/debian-science/tasks/neuroscience-cognitive \
		-f fsl-doc -f fslview-doc -f fsl-atlases -f fsl-possum-data \
		-f fsl-first-data -f fsl-feeds \
		-p svn://svn.debian.org/blends/projects/science/trunk/debian-science/tasks/neuroscience-cognitive


upload-website: html
	rsync -rvzlhp --delete --chmod=Dg+s,g+rw $(WWW_DIR) $(WWW_UPLOAD_URI)
