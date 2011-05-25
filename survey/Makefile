all: index.html

clean:
	-rm *.html *.js *.txt

jquery.form.js:
	wget --no-check-certificate http://github.com/malsup/form/raw/master/jquery.form.js

#index.html: survey.rst
index.html: closed.rst
	rst2html --link-stylesheet --stylesheet-path=survey.css $< > $@

results.html: results.rst figures/stats.txt
	rst2html --link-stylesheet --stylesheet-path=survey.css results.rst > $@

results_snippet.html: results.html
	head -n$$(echo "$$(grep -n '</body>' < results.html | cut -d ':' -f 1,1) - 1" \
		| bc ) results.html \
		| tail -n$$(echo "$$(wc -l < results.html) - $$(grep -n '<body>' \
		< results.html | cut -d ':' -f 1,1) - 2" | bc ) > $@

figures/stats.txt: statfigures

statfigures: oslist.txt swlist.txt datamodlist.txt employer-dd-list.txt position-dd-list.txt ratingslist.txt vmlist.txt
# create "lockfile'
	@touch $@
	@[ "$$(cat nsubmissions.stamp 2>/dev/null || echo)" != "$$(ls -1 data |wc -l)" ] \
		&& echo "I: Re-generating stats figures" \
		&& ls -1 data |wc -l > nsubmissions.stamp \
		&& MVPA_MATPLOTLIB_BACKEND=agg ./makestats data figures || true
# remove lockfile
	@-rm $@

getdata:
	rsync -rvzlhp --delete \
		neurodebian@www.pymvpa.org:/home/neurodebian/survey/data .
	./postprocdata

oslist.txt: select_os_options.inc
	grep -v selected select_os_options.inc | sed -e 's/<option value="//' \
		-e 's/" label="/: "/' -e 's/">.*$$/"/' > $@

swlist.txt: survey.rst
	grep '"sw.*" value' survey.rst | sed -e 's/.*name="sw.*" value="//' -e 's," />,: ",' \
		-e 's,</td>$$,",' -e 's/ "$$/ "Other"/' > $@

vmlist.txt: survey.rst
	grep virt_prod survey.rst | sed -e 's/.*<input.*value="//' \
		-e 's," />,: ",' -e 's,<br />.*$$,,' -e 's/ "$$/ "Other VM"/' > $@

datamodlist.txt: survey.rst
	grep '"bg_datamod"' survey.rst | sed -e 's/.*name="bg_datamod" value="//' \
		-e 's," />,: ",' -e 's,<br />$$,",' -e 's/ "$$/ "Other"/' > $@

# Generic rule to extract from drop-down selections
%-dd-list.txt: survey.rst
	@echo "I: Extracting fields for $* into $@"
	@sed -n -e '/bg_$*/,/\/tr/p' survey.rst \
	| sed -ne '/option/s,.*value="\([^"]*\)" *label=\("[^"]*"\)>.*,\1: \2,gp' >| $@

ratingslist.txt: survey.rst
	@echo "I: Extracting fields for ratings into $@"
	@grep -B 6 -e 'radio.*_r.*value="3"' survey.rst \
	| grep -v -e '^\.\. raw' -e '^[ -]*$$' -e '<td' \
	| sed -e 's,.*name="\([^"]*\)" value.*,|\1#,g' \
	| tr '\n' ' ' \
	| sed -e 's,#,#\n,g' \
	| sed -e 's,\(.*\)|\(.*\)#,\2: "\1",g' >| $@

upload: upload-closed

upload-closed: index.html
	rsync -rvzlhp --delete  \
        --exclude='*.txt' --exclude=data --exclude=figures \
		--chmod=Dg+s,g+rw $^ neurodebian@www.pymvpa.org:/home/neurodebian/survey/
	ssh neurodebian@www.pymvpa.org rm /srv/neuro.debian.net/cgi-bin/surveycollector.cgi

upload-survey: index.html results.html results_snippet.html jquery.form.js survey.css surveycollector.cgi
	rsync -rvzlhp --delete  \
        --exclude='*.txt' --exclude=data --exclude='*.cgi' --exclude=figures \
		--chmod=Dg+s,g+rw $^ neurodebian@www.pymvpa.org:/home/neurodebian/survey/
	scp surveycollector.cgi neurodebian@www.pymvpa.org:/srv/neuro.debian.net/cgi-bin/

.PHONY: statfigures
