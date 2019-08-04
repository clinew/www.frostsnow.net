file=website
graph_files=files/blog/2019_03_31_tree_growth_in_minetest/2019_03_31_growth
graphs=${graph_files:=.png}
l2hflags=-local_icons -white -top_navigation -info 0
segments=about blurbs

all: ${graphs} index ${segments} blog contact tutor

index:
	latex ${file}.tex
	latex2html ${l2hflags} -link 0 ${file}

${graphs}: %.png: %.gpi
	gnuplot $<  > $@

${segments}: %: %.tex
	mkdir -p website/$@
	latex2html ${l2hflags} -split 2 -link 0 -dir website/$@ $@

blog: ${graphs} blog.tex
	mkdir -p website/blog
	latex2html ${l2hflags} -split 4 -link 1 -custom_titles -reuse 1 -dir website/blog blog.tex
	cp files/blog/2019_08_04_flashing_the_librem5_from_a_32bit_machine/2019_08_04_32bitarm.mp4 website/blog/

contact: contact.tex
	mkdir -p website/contact
	latex2html ${l2hflags} -split 2 -link 0 -dir website/contact contact.tex
	cp files/irc.pdf website/contact/irc.pdf

tutor: tutor.tex
	mkdir -p website/tutor
	latex2html ${l2hflags} -split 2 -link 0 -dir website/tutor tutor.tex
	cp files/1000_element_merge_sort.ps website/tutor/mergesort.ps
	#cp files/flyer.pdf website/tutor/flyer.pdf # Super-sekrit

install: tidy
	cp -rv website/* /var/www/localhost/htdocs/

clean:
	rm -rf website/
	rm -f ${graphs}

tidy:
	find website -name WARNINGS -delete
	find website -name labels.pl -delete
	find website -name images.aux -delete
	find website -name images.tex -delete
	find website -name images.log -delete
