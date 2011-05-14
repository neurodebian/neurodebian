all: index.html

clean:
	-rm *.html *.js

jquery.form.js:
	wget --no-check-certificate http://github.com/malsup/form/raw/master/jquery.form.js

index.html: survey.rst
	rst2html --link-stylesheet --stylesheet-path=survey.css survey.rst > $@

getdata:
	rsync -rvzlhp --delete \
		neurodebian@www.pymvpa.org:/home/neurodebian/surveydata .

oslist.txt: select_os_options.inc
	grep -v selected select_os_options.inc | sed -e 's/<option value="//' \
		-e 's/" label="/: "/' -e 's/">.*$$/"/' > $@

swlist.txt: survey.rst
	grep '"sw"' survey.rst | sed -e 's/.*name="sw" value="//' -e 's," />,: ",' \
		-e 's,</td>$$,",' -e 's/ "$$/ "Other"/' > $@

datamodlist.txt: survey.rst
	grep '"bg_datamod"' survey.rst | sed -e 's/.*name="bg_datamod" value="//' \
		-e 's," />,: ",' -e 's,<br />$$,",' -e 's/ "$$/ "Other"/' > $@

upload: index.html jquery.form.js survey.css
	rsync -rvzlhp --delete  \
        --exclude=Makefile --exclude='*.inc' --exclude='*.rst' \
		--chmod=Dg+s,g+rw * neurodebian@www.pymvpa.org:/home/www/neuro.debian.net/www/survey/

