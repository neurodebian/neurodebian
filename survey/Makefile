all: index.html

clean:
	-rm *.html *.js

jquery.form.js:
	wget --no-check-certificate http://github.com/malsup/form/raw/master/jquery.form.js

index.html: survey.rst
	rst2html --link-stylesheet --stylesheet-path=survey.css survey.rst > $@

upload: index.html jquery.form.js survey.css
	rsync -rvzlhp --delete  \
        --exclude=Makefile --exclude='*.inc' --exclude='*.rst' \
		--chmod=Dg+s,g+rw * neurodebian@www.pymvpa.org:/home/www/neuro.debian.net/www/survey/

