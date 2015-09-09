# LaTeX Reference Card Creator
# Copyright (C) Anthony Bradford 2012.

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This is free and unencumbered software released into the public domain.
# See file 'COPYING' for more information.

SHELL = /bin/sh
DIRS = *

# Change the name of the reference card here.
# Set LaTeXreferenceCard = YourName
# Must also 'mv LaTeXreferenceCard-1.0.tex YourName.tex' on the command line.
LaTeXreferenceCard = VoiceCodeRefcard-1.0

IMAGES_DIR := images
FIND_EPS_FILES = $(basename $(wildcard $(IMAGES_DIR)/*.eps))
EPS_FILES := $(foreach dir,$(IMAGES_DIR),$(FIND_EPS_FILES))

FIND_PNG_FILES = $(basename $(wildcard $(IMAGES_DIR)/*.png))
PNG_FILES := $(foreach dir,$(IMAGES_DIR),$(FIND_PNG_FILES))

FIND_JPG_FILES = $(basename $(wildcard $(IMAGES_DIR)/*.jpg))
JPG_FILES := $(foreach dir,$(IMAGES_DIR),$(FIND_JPG_FILES))

FIND_GIF_FILES = $(basename $(wildcard $(IMAGES_DIR)/*.gif))
GIF_FILES := $(foreach dir,$(IMAGES_DIR),$(FIND_GIF_FILES))

FIND_PDF_FILES = $(basename $(wildcard $(IMAGES_DIR)/*.pdf))
PDF_FILES := $(foreach dir,$(IMAGES_DIR),$(FIND_PDF_FILES))

latex_exists = $(shell { type latex; } 2>/dev/null)
dvips_exists = $(shell { type dvips; } 2>/dev/null)
dvi2ps_exists = $(shell { type dvi2ps; } 2>/dev/null)
dvipdfm_exists = $(shell { type dvipdfm; } 2>/dev/null)
ps2pdf_exists = $(shell { type ps2pdf; } 2>/dev/null)
epstopdf_exists = $(shell { type epstopdf; } 2>/dev/null)
pdflatex_exists = $(shell { type pdflatex; } 2>/dev/null)
convert_exists = $(shell { type convert; } 2>/dev/null)
aspell_exists = $(shell { type aspell; } 2>/dev/null)
latex2html_exists = $(shell { type latex2html; } 2>/dev/null)
htlatex_exists = $(shell { type htlatex; } 2>/dev/null)
dvi2tty_exists = $(shell { type dvi2tty; } 2>/dev/null)
diction_exists = $(shell { type diction; } 2>/dev/null)
style_exists = $(shell { type style; } 2>/dev/null)
zip_exists = $(shell { type zip; } 2>/dev/null)
linkchecker_exists = $(shell { type linkchecker; } 2>/dev/null)
pdf2djvu_exists = $(shell { type pdf2djvu; } 2>/dev/null)

CLEAN_OBJECTS = *.html *.zip *.pdf *.djvu *.djv *.aux *.cp *.cps *.fn *.ky *.log *.op *.pg *.toc *.tp *.vr *.txt *.xml *.dbk *.hhc *.hhk *.hhp *.htmlhelp/docbook-xsl.css *.htmlhelp/*html *.htmlhelp/images/* *.epub *.proc *.dvi *.ps *.info *.tar.gz *.out *.lg *.idv *~ *.png *.4ct *.4tc *.tmp *.xref *.css

.PHONY: all
all: $(LaTeXreferenceCard).pdf
	if [ ! -d bak ]; then \
		(mkdir bak ); \
	fi;
	if [ -d doc/files ]; then \
		(cp $(LaTeXreferenceCard).pdf doc/files/LaTeXreferenceCardExample.pdf ); \
	fi;
	if [ -d doc/images ]; then \
		(cp $(LaTeXreferenceCard).pdf doc/images/LaTeXreferenceCard.pdf ); \
	fi;
	cp $(LaTeXreferenceCard).tex bak/"$(LaTeXreferenceCard).tex.`date '+%Y%m%d'`"
	cp Makefile bak/"Makefile.`date '+%Y%m%d'`"
	@echo
	@echo "To view type:"
	@echo "               nautilus .    (GNOME Desktop)"
	@echo "               kde-open .    (KDE)"
	@echo "               explorer .    (Windows/Cygwin)"
	@echo "               open     .    (OSX)"
	@echo

.PHONY: html
html:
ifeq ($(latex2html_exists),)
	$(error Program \"latex2html\" missing.)
endif
	latex2html $(LaTeXreferenceCard).tex
	@echo
	@echo See directory $(LaTeXreferenceCard)
	@echo

.PHONY: html2 
html2:
ifeq ($(htlatex_exists),)
	$(error Program \"htlatex\" missing.)
endif
	htlatex $(LaTeXreferenceCard).tex
	@echo
	@echo See file $(LaTeXreferenceCard).html
	@echo

$(LaTeXreferenceCard).pdf: dvi $(LaTeXreferenceCard).ps $(LaTeXreferenceCard).tex
ifeq ($(ps2pdf_exists),)
	$(error Program \"ps2pdf\" missing.)
endif
	ps2pdf $(LaTeXreferenceCard).ps

.PHONY: djvu
djvu: $(LaTeXreferenceCard).djvu
$(LaTeXreferenceCard).djvu: $(LaTeXreferenceCard).pdf
ifneq ($(pdf2djvu_exists),)
	pdf2djvu -o $(LaTeXreferenceCard).djvu $(LaTeXreferenceCard).pdf
	@echo
	@echo See file $(LaTeXreferenceCard).djvu
	@echo
else
	@echo "Program \"pdf2djvu\" missing."
	@echo "Try: sudo apt-get install pdf2djvu"
endif

.PHONY: pdflatex
pdflatex: eps2pdf
ifneq ($(pdflatex_exists),)
	pdflatex $(LaTeXreferenceCard).tex
	@echo
	@echo See file $(LaTeXreferenceCard).pdf
	@echo
else
	$(error Program \"pdflatex\" missing.)
endif

.PHONY: dist
dist: $(LaTeXreferenceCard).tar.gz
$(LaTeXreferenceCard).tar.gz:
	cd .. && tar -czvf $(LaTeXreferenceCard).tar.gz $(notdir $(shell pwd))
	mv ../$(LaTeXreferenceCard).tar.gz .
	@echo
	@echo See file $(LaTeXreferenceCard).tar.gz
	@echo

# Run spelling checker on .tex content
.PHONY: spelling
spelling:
ifneq ($(aspell_exists),)
	aspell --mode=tex -c $(LaTeXreferenceCard).tex
else
	@echo "Program \"aspell\" missing."
	@echo "Try: sudo apt-get install aspell"
endif

# Resize images for HTML publishing
# Backup all ./images to ./images/bak
# resize all JPEG images in ./images to 640x480
.PHONY: resizejpg
resizejpg: backup_images
ifneq ($(convert_exists),)
	find ./images/ -maxdepth 1 -name "*.jpg" -type f -exec convert {} -resize 640x480 {} \;
	@echo
	@echo All JPEGs resized to 640x480 for HTML display
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

# Resize images for HTML publishing
# Backup all ./images to ./images/bak
# resize all PNG images in ./images to 640x480
.PHONY: resizepng
resizepng: backup_images
ifneq ($(convert_exists),)
	find ./images/ -maxdepth 1 -name "*.png" -type f -exec convert {} -resize 640x480 {} \;
	@echo
	@echo All PNGs resized to 640x480 for HTML display
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: backup_images
backup_images:
	if [ ! -d images/bak ]; then \
		(mkdir images/bak ) ; \
	fi;
	find ./images/ -maxdepth 1 -type f -exec cp {} ./images/bak \;
	@echo All images in ./images backed up to ./images/bak

.PHONY: png2eps
png2eps: backup_images
ifneq ($(convert_exists),)
	for file in $(PNG_FILES); do \
		if [ -e "$$file.eps" ]; then \
			echo "$$file.eps exists"; \
		else \
			convert $$file.png $$file.eps; \
			echo "Creating $$file.eps"; \
		fi; \
	done
	@echo
	@echo All .png files converted to .eps
	@echo Original .png files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: eps2png
eps2png: backup_images
ifneq ($(convert_exists),)
	for file in $(EPS_FILES); do \
		if [ -e "$$file.png" ]; then \
			echo "$$file.png exists"; \
		else \
			convert $$file.eps $$file.png; \
			echo "Creating $$file.png"; \
		fi; \
	done
	@echo
	@echo All .png files converted to .eps
	@echo Original .eps files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: jpg2eps
jpg2eps: backup_images
ifneq ($(convert_exists),)
	for file in $(JPG_FILES); do \
		if [ -e "$$file.eps" ]; then \
			echo "$$file.eps exists"; \
		else \
			convert $$file.jpg $$file.eps; \
			echo "Creating $$file.eps"; \
		fi; \
	done
	@echo
	@echo All .jpg files converted to .eps
	@echo Original .jpg files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: gif2eps
gif2eps: backup_images
ifneq ($(convert_exists),)
	for file in $(GIF_FILES); do \
		if [ -e "$$file.eps" ]; then \
			echo "$$file.eps exists"; \
		else \
			convert $$file.gif $$file.eps; \
			echo "Creating $$file.eps"; \
		fi; \
	done
	@echo
	@echo All .gif files converted to .eps
	@echo Original .gif files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: gif2png
gif2png:
ifneq ($(convert_exists),)
	for file in $(GIF_FILES); do \
		if [ -e "$$file.png" ]; then \
			echo "$$file.png exists"; \
		else \
			convert $$file.gif $$file.png; \
			echo "Creating $$file.png"; \
		fi; \
	done
	@echo
	@echo All .gif files converted to .png
	@echo Original .gif files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: gif2jpg
gif2jpg:
ifneq ($(convert_exists),)
	for file in $(GIF_FILES); do \
		if [ -e "$$file.jpg" ]; then \
			echo "$$file.jpg exists"; \
		else \
			convert $$file.gif $$file.jpg; \
			echo "Creating $$file.jpg"; \
		fi; \
	done
	@echo
	@echo All .gif files converted to .jpg
	@echo Original .gif files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: jpg2png
jpg2png:
ifneq ($(convert_exists),)
	for file in $(JPG_FILES); do \
		if [ -e "$$file.png" ]; then \
			echo "$$file.png exists"; \
		else \
			convert $$file.jpg $$file.png; \
			echo "Creating $$file.png"; \
		fi; \
	done
	@echo
	@echo All .jpg files converted to .png
	@echo Original .jpg files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: eps2pdf
eps2pdf:
ifneq ($(epstopdf_exists),)
	for file in $(EPS_FILES); do \
		if [ -e "$$file.pdf" ]; then \
			echo "$$file.pdf exists"; \
		else \
			epstopdf $$file.eps; \
			echo "Creating $$file.pdf"; \
		fi; \
	done
	@echo
	@echo All .eps files converted to .pdf
	@echo Original .eps files remain
	@echo
else
	@echo "Program \"epstopdf\" missing."
	@echo "Try: sudo apt-get install epstopdf"
endif

.PHONY: pdf2eps
pdf2eps: backup_images
ifneq ($(convert_exists),)
	for file in $(PDF_FILES); do \
		if [ -e "$$file.eps" ]; then \
			echo "$$file.eps exists"; \
		else \
			convert $$file.pdf $$file.eps; \
			echo "Creating $$file.eps"; \
		fi; \
	done
	@echo
	@echo All .pdf files converted to .eps
	@echo Original .pdf files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: pdf2png
pdf2png:
ifneq ($(convert_exists),)
	for file in $(PDF_FILES); do \
		if [ -e "$$file.png" ]; then \
			echo "$$file.png exists"; \
		else \
			convert $$file.pdf $$file.png; \
			echo "Creating $$file.png"; \
		fi; \
	done
	@echo
	@echo All .pdf files converted to .png
	@echo Original .pdf files remain
	@echo
else
	@echo "Program \"convert\" missing."
	@echo "Try: sudo apt-get install convert"
endif

.PHONY: dvi
dvi: gif2eps png2eps jpg2eps $(LaTeXreferenceCard).dvi
$(LaTeXreferenceCard).dvi: $(LaTeXreferenceCard).tex
ifneq ($(latex_exists),)
	latex $(LaTeXreferenceCard).tex
	@echo
	@echo See file $(LaTeXreferenceCard).dvi
	@echo
else
	$(error Program \"latex\" missing.)
endif

.PHONY: ps
ps: $(LaTeXreferenceCard).ps
$(LaTeXreferenceCard).ps: $(LaTeXreferenceCard).dvi
ifneq ($(dvips_exists),)
	dvips -P pdf -t landscape $(LaTeXreferenceCard).dvi
	@echo
	@echo See file $(LaTeXreferenceCard).ps
	@echo
else
	$(error Program \"dvips\" missing.)
endif

.PHONY: ps2
ps2: gif2eps png2eps jpg2eps $(LaTeXreferenceCard).dvi
ifneq ($(dvi2ps_exists),)
	dvi2ps  -c $(LaTeXreferenceCard).ps $(LaTeXreferenceCard).dvi
	@echo
	@echo See file $(LaTeXreferenceCard).ps
	@echo
else
	$(error Program \"dvi2ps\" missing.)
endif

.PHONY: dvipdfm
dvipdfm: dvi $(LaTeXreferenceCard).dvi
ifneq ($(dvipdfm_exists),)
	dvipdfm $(LaTeXreferenceCard).dvi
	@echo
	@echo See file $(LaTeXreferenceCard).pdf
	@echo
else
	$(error Program \"dvipdfm\" missing.)
endif

.PHONY: pdf
pdf: $(LaTeXreferenceCard).ps
ifneq ($(ps2pdf_exists),)
	ps2pdf $(LaTeXreferenceCard).ps
	@echo
	@echo See file $(LaTeXreferenceCard).pdf
	@echo
else
	$(error Program \"ps2pdf\" missing.)
endif

.PHONY: text
text: $(LaTeXreferenceCard).txt
$(LaTeXreferenceCard).txt: dvi
ifneq ($(dvi2tty_exists),)
	dvi2tty $(LaTeXreferenceCard).dvi > $(LaTeXreferenceCard).txt
	@echo
	@echo See file $(LaTeXreferenceCard).txt
	@echo
else
	@echo "Program \"dvi2tty\" missing."
endif

# Check diction. See 'man diction'
.PHONY: diction
diction: text
ifneq ($(diction_exists),)
	diction < $(LaTeXreferenceCard).txt
else
	@echo "Program \"diction\" missing."
	@echo "Try: sudo apt-get install diction"
endif

# Check style. See 'man style'
.PHONY: style
style: text
ifneq ($(style_exists),)
	style < $(LaTeXreferenceCard).txt
else
	@echo "Program \"style\" missing."
	@echo "Try: sudo apt-get install style"
endif

# Check for bad links
.PHONY: linkchecker
linkchecker: html2
ifneq ($(linkchecker_exists),)
	linkchecker -Fhtml $(LaTeXreferenceCard).html
	@echo
	@echo
	@echo
	@echo See file: linkchecker-out.html
	@echo
	@echo
	@echo
else
	@echo "Program \"linkchecker\" missing."
	@echo "Try: sudo apt-get install linkchecker"
endif

# Print help information
.PHONY: help
help:
	if [ -e README ]; then \
		(less README ); \
	else \
		(echo "No help available") ; \
	fi;

.PHONY: zip
zip: all $(LaTeXreferenceCard).zip
$(LaTeXreferenceCard).zip: $(LaTeXreferenceCard).tex
ifneq ($(zip_exists),)
	zip -r $(LaTeXreferenceCard).zip * --exclude bak/* images/bak/*
	@echo
	@echo See file $(LaTeXreferenceCard).zip
	@echo
else
	@echo "Program \"zip\" missing."
	@echo "Try: sudo apt-get install zip"
endif

.PHONY: distclean
distclean:
	@-rm -f bak/*
	@-rm -f images/bak/*
	@-rm -f $(CLEAN_OBJECTS)
	for d in $(DIRS); do\
		if [ -d $$d ] && [ -e "$$d/Makefile" ]; then\
			(cd $$d; $(MAKE) distclean );\
		fi;\
	done

.PHONY: clean
clean:
	@-rm -f $(CLEAN_OBJECTS)
	@-rm -f $(LaTeXreferenceCard)/*
	for d in $(DIRS); do\
		if [ -d $$d ] && [ -e "$$d/Makefile" ]; then\
			(cd $$d; $(MAKE) clean );\
		fi;\
	done
