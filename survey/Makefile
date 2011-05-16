all: index.html

clean:
	-rm *.html *.js *.txt

jquery.form.js:
	wget --no-check-certificate http://github.com/malsup/form/raw/master/jquery.form.js

index.html: survey.rst
	rst2html --link-stylesheet --stylesheet-path=survey.css survey.rst > $@

results.html: results.rst figures/stats.txt
	rst2html --link-stylesheet --stylesheet-path=survey.css results.rst > $@

results_snippet.html: results.html
	head -n$$(echo "$$(grep -n '</body>' < results.html | cut -d ':' -f 1,1) - 1" \
		| bc ) results.html \
		| tail -n$$(echo "$$(wc -l < results.html) - $$(grep -n '<body>' \
		< results.html | cut -d ':' -f 1,1) - 2" | bc ) > $@

statfigures: oslist.txt swlist.txt datamodlist.txt
# create "lockfile'
	@touch $@
	@[ "$$(cat nsubmissions.stamp || true)" != "$$(ls -1 data |wc -l)" ] \
		&& ls -1 data |wc -l > nsubmissions.stamp \
		&& MVPA_MATPLOTLIB_BACKEND=agg ./makestats data figures || true
# remove lockfile
	@-rm $@

getdata:
	rsync -rvzlhp --delete \
		neurodebian@www.pymvpa.org:/home/neurodebian/surveydata .

oslist.txt: select_os_options.inc
	grep -v selected select_os_options.inc | sed -e 's/<option value="//' \
		-e 's/" label="/: "/' -e 's/">.*$$/"/' > $@

swlist.txt: survey.rst
	grep '"sw.*" value' survey.rst | sed -e 's/.*name="sw.*" value="//' -e 's," />,: ",' \
		-e 's,</td>$$,",' -e 's/ "$$/ "Other"/' > $@

datamodlist.txt: survey.rst
	grep '"bg_datamod"' survey.rst | sed -e 's/.*name="bg_datamod" value="//' \
		-e 's," />,: ",' -e 's,<br />$$,",' -e 's/ "$$/ "Other"/' > $@

upload: index.html results.html results_snippet.html jquery.form.js survey.css surveycollector.cgi
	rsync -rvzlhp --delete  \
        --exclude='*.txt' --exclude=surveydata --exclude='*.cgi' --exclude=figures \
		--chmod=Dg+s,g+rw * neurodebian@www.pymvpa.org:/home/neurodebian/survey/
	scp surveycollector.cgi neurodebian@www.pymvpa.org:/srv/neuro.debian.net/cgi-bin/

