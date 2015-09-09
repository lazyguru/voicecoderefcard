# Texinfo Web Publisher.
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
# See file 'COPYING' for more information.

SHELL = /bin/sh
DIRS = *

# The prefix filename 'Website' is controlled in several places.
# Change the Makefile variable 'Manual = Website' to something like
# 'Manual = YourName'. Rename the Manual.texi on the command line
# with 'mv Website.texi YourName.texi'
# You must also change the '@set Manual Website' inside the .texi file to
# '@set Manual YourName'
Manual = LaTeXreferenceCard-1.0

# Other TEXI2DVI_FLAGS that can be used are
#-D XML -D POSTSCRIPT -D DVI -D INFO -D DOCBOOK -D DJVU
TEXI2DVI_FLAGS = -D SPLIT -D NOSPLIT -D PDF -D TEXT

# The EPUB format needs command dbtoepub to be created
dbtoepub_exists = $(shell { type dbtoepub; } 2>/dev/null)
ifneq ($(dbtoepub_exists),)
	TEXI2DVI_FLAGS += -D EPUB
endif

zip_exists = $(shell { type zip; } 2>/dev/null)
ifneq ($(zip_exists),)
	TEXI2DVI_FLAGS += -D ZIP
endif

ifneq (,$(findstring PDF,$(TEXI2DVI_FLAGS)))
	PRE_BODY_CLOSE = 'PRE_BODY_CLOSE=<a href="$(Manual).pdf">PDF content of this website</a>'
	AFTER_BODY_OPEN = 'AFTER_BODY_OPEN=<a href="$(Manual).pdf">PDF content of this website</a>'
else
	PRE_BODY_CLOSE = ''
	AFTER_BODY_OPEN = ''
endif

ifneq (,$(findstring DJVU,$(TEXI2DVI_FLAGS)))
	ifeq (,$(findstring PDF,$(TEXI2DVI_FLAGS)))
		ALT_TEXI2DVI_FLAGS += -D PDF
	endif
endif

ifneq (,$(findstring EPUB,$(TEXI2DVI_FLAGS)))
	ifeq (,$(findstring DOCBOOK,$(TEXI2DVI_FLAGS)))
		ALT_TEXI2DVI_FLAGS += -D DOCBOOK
	endif
endif

TEMPLATE_DIR := Templates
FIND_TEMPLATE_FILES = $(basename $(wildcard $(TEMPLATE_DIR)/*.texi))
TEMPLATE_FILES := $(foreach dir,$(TEMPLATE_DIR),$(FIND_TEMPLATE_FILES))

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

texi2any_exists = $(shell { type texi2any; } 2>/dev/null)
xmlto_exists = $(shell { type xmlto; } 2>/dev/null)
convert_exists = $(shell { type convert; } 2>/dev/null)
linkchecker_exists = $(shell { type linkchecker; } 2>/dev/null)
aspell_exists = $(shell { type aspell; } 2>/dev/null)
diction_exists = $(shell { type diction; } 2>/dev/null)
style_exists = $(shell { type style; } 2>/dev/null)
pdf2djvu_exists = $(shell { type pdf2djvu; } 2>/dev/null)
dblatex_exists = $(shell { type dblatex; } 2>/dev/null)
epstopdf_exists = $(shell { type epstopdf; } 2>/dev/null)
jp2a_exists = $(shell { type jp2a; } 2>/dev/null)

ifneq ($(convert_exists),)
	CONVERT_JP2A_EXISTS += Y
endif
ifneq ($(jp2a_exists),)
	CONVERT_JP2A_EXISTS += Y
endif

ifneq ($(texi2any_exists),)
	TEXI2ANY = texi2any
	TEXI2DVI = texi2any
	CUSTOM = --set-customization-variable
else
	TEXI2ANY = makeinfo
	TEXI2DVI = texi2dvi
	CUSTOM = -U CUST
endif

CLEAN_OBJECTS = *.html *.zip *.pdf *.djvu *.djv *.aux *.cp *.cps *.fn *.ky *.log *.op *.pg *.toc *.tp *.vr *.txt *.xml *.dbk *.hhc *.hhk *.hhp *.htmlhelp/docbook-xsl.css *.htmlhelp/*html *.htmlhelp/images/* *.epub *.proc *.dvi *.ps *.info *.info-* *.tar.gz *~

.PHONY: all
all: $(Manual).tar.gz index.html indexNoSplit.html $(Manual).pdf $(Manual).djvu $(Manual).info $(Manual).txt $(Manual).epub $(Manual).xml $(Manual).ps $(Manual).dvi $(Manual).zip
	if [ ! -d files ]; then \
		(mkdir files ); \
	fi;
	if [ ! -d bak ]; then \
		(mkdir bak ); \
	fi;
	@cp $(Manual).texi bak/"$(Manual).texi.`date '+%Y%m%d'`"
	@cp Makefile bak/"Makefile.`date '+%Y%m%d'`"
	@echo
	@echo "Publish to a network drive by adding"
	@echo "\"cp -rfv * <NetworkDrive>\" to the Makefile."
	@echo 
	@echo "To publish via ftp type:"
	@echo "               make website"
	@echo
	@echo "To view type:"
	@echo "               firefox index.html  (UNIX/Linux)"
	@echo "               nautilus .          (GNOME Desktop)"
	@echo "               kde-open index.html (KDE)"
	@echo "               explorer .          (Windows/Cygwin)"
	@echo "               explorer index.html (Windows/Cygwin)"
	@echo

# subdirs removed from last item all:
.PHONY: subdirs
subdirs:
	for d in $(DIRS); do \
		if [ -d $$d ]; then \
			($(MAKE) -C $$d) \
		fi; \
	done

.PHONY: dist
dist: clean $(Manual).tar.gz

$(Manual).tar.gz:
	if [ -d ../doc ]; then \
		(cd ../.. && tar -czvf $(Manual).tar.gz $(Manual) --exclude '*.eps'); \
		(mv -f ../../$(Manual).tar.gz .); \
	else \
		(cd .. && tar -czvf $(Manual).tar.gz $(notdir $(shell pwd)) --exclude '*.eps'); \
		(mv -f ../$(Manual).tar.gz .); \
	fi

index.html: $(Manual).texi
	@$(if $(findstring -D SPLIT,$(TEXI2DVI_FLAGS)),	\
	$(TEXI2ANY) -D LongContents $(TEXI2DVI_FLAGS) \
		$(CUSTOM) 'FRAMES=TRUE' \
		$(CUSTOM) TOP_NODE_UP_URL=.. \
		$(CUSTOM) $(PRE_BODY_CLOSE) \
		$(CUSTOM) $(AFTER_BODY_OPEN) \
		--html $(Manual).texi -o . \
	)

indexNoSplit.html: $(Manual).texi
	@$(if $(findstring -D NOSPLIT,$(TEXI2DVI_FLAGS)), \
	$(TEXI2ANY) -D LongContents $(TEXI2DVI_FLAGS) \
		$(CUSTOM) TOP_NODE_UP_URL=.. \
		--no-split --no-headers \
		$(CUSTOM) $(PRE_BODY_CLOSE) \
		$(CUSTOM) $(AFTER_BODY_OPEN) \
		--html $(Manual).texi -o indexNoSplit.html \
	)

.PHONY: frames
frames: $(Manual).texi
	@-rm -f *.html
	$(TEXI2ANY) \
		-D LongContents \
		$(TEXI2DVI_FLAGS) \
		$(CUSTOM) 'FRAMES=TRUE' \
		$(CUSTOM) TOP_NODE_UP_URL=.. \
		$(CUSTOM) $(PRE_BODY_CLOSE) \
		$(CUSTOM) $(AFTER_BODY_OPEN) \
		--html $(Manual).texi -o .
	@echo
	@echo
	@echo "Frame HTML created. See $(Manual)_frame.xml"
	@echo
	@echo

.PHONY:	templates
templates:
	for d in templates/$(DIRS); do\
		if [ -d $$d ]; then\
			($(MAKE) -C $$d)\
		fi;\
	done

.PHONY: pdf2
pdf2: docbook
ifneq ($(dblatex_exists),)
	dblatex --pdf $(Manual).dbk -o $(Manual).pdf
	@echo
	@echo
	@echo "Alternative form of PDF."
	@echo "PDF created. See $(Manual).pdf"
	@echo
	@echo
else
	@echo "Program \"dblatex\" missing."
	@echo "Try: sudo apt-get install dblatex"
endif

.PHONY: html2
html2: docbook
ifneq ($(xmlto_exists),)
	@-rm -f *.html
	xmlto --skip-validation html $(Manual).dbk
	@echo
	@echo
	@echo "Alternative form of HTML."
	@echo "Use \"make all\" for regular HTML."
	@echo "To view type:"
	@echo "               firefox index.html (UNIX/Linux)"
	@echo "               nautilus .          (GNOME Desktop)"
	@echo "               explorer .          (Windows/Cygwin)"
	@echo "               explorer index.html (Windows/Cygwin)"
	@echo
	@echo
else
	@echo "Program \"xmlto\" missing."
	@echo "Try: sudo apt-get install xmlto"
endif

.PHONY: xml
xml: TEXI2DVI_FLAGS += -D XML
xml: $(Manual).xml
$(Manual).xml: $(Manual).texi
	@$(if $(findstring -D XML,$(TEXI2DVI_FLAGS)), $(TEXI2ANY) --xml $(Manual).texi ; echo ; echo ; echo "XML created. See $(Manual).xml"; echo )

.PHONY: docbook
docbook: TEXI2DVI_FLAGS += -D DOCBOOK
docbook: $(Manual).dbk
$(Manual).dbk: $(Manual).texi
	@$(if $(findstring -D DOCBOOK,$(TEXI2DVI_FLAGS)), echo; echo; $(TEXI2ANY) --docbook $(Manual).texi -o $(Manual).dbk; echo ; echo "DocBook created. See $(Manual).dbk" ; echo )
	@$(if $(findstring -D DOCBOOK,$(ALT_TEXI2DVI_FLAGS)), echo; echo; $(TEXI2ANY) --docbook $(Manual).texi -o $(Manual).dbk; echo ; echo "DocBook created. See $(Manual).dbk" ; echo )

.PHONY: pdf
pdf: TEXI2DVI_FLAGS += -D PDF
pdf: $(Manual).pdf
$(Manual).pdf: $(Manual).texi
	@$(if $(findstring -D PDF,$(TEXI2DVI_FLAGS)), $(TEXI2DVI) --pdf $(Manual).texi -o $(Manual).pdf ; echo; echo "PDF created. See $(Manual).pdf" ; echo )
	@$(if $(findstring -D PDF,$(ALT_TEXI2DVI_FLAGS)), $(TEXI2DVI) --pdf $(Manual).texi -o $(Manual).pdf ; echo; echo "PDF created. See $(Manual).pdf" ; echo )

.PHONY: djvu
djvu: TEXI2DVI_FLAGS += -D PDF -D DJVU
djvu: $(Manual).djvu
$(Manual).djvu: $(Manual).pdf
ifneq ($(pdf2djvu_exists),)
	@$(if $(findstring -D DJVU,$(TEXI2DVI_FLAGS)), pdf2djvu -o $(Manual).djvu $(Manual).pdf ; echo; echo "DjVu file created. See $(Manual).djvu" ; echo )
else
	@echo "Program \"pdf2djvu\" missing."
	@echo "Try: sudo apt-get install pdf2djvu"
endif

.PHONY: epub
epub: TEXI2DVI_FLAGS += -D EPUB -D DOCBOOK
epub: $(Manual).epub
$(Manual).epub: $(Manual).dbk
ifneq ($(dbtoepub_exists),)
	@$(if $(findstring -D EPUB,$(TEXI2DVI_FLAGS)), dbtoepub $(Manual).dbk ; mv -f $(Manual).dbk.epub $(Manual).epub ; echo ; echo "EPUB created with images. See $(Manual).epub" ; echo "$(Manual).epub can be imported into a EPUB e-book" ; echo "editor such as sigil." ; echo )
else
	@echo
	@echo "Program \"dbtoepub\" missing."
	@echo "\"dbtoepub\" is needed to generate EPUB documents."
	@echo "Try: sudo apt-get install dbtoepub"
	@echo
endif

.PHONY: text
text: TEXI2DVI_FLAGS += -D TEXT
text: $(Manual).txt
$(Manual).txt: $(Manual).texi jpg2txt png2txt
	@$(if $(findstring -D TEXT,$(TEXI2DVI_FLAGS)), $(TEXI2ANY) --no-headers $(Manual).texi -o $(Manual).txt ; echo ; echo "Plain text created. See $(Manual).txt" ; echo )

.PHONY: zip
zip: TEXI2DVI_FLAGS += -D ZIP
zip: all $(Manual).zip
$(Manual).zip: $(Manual).texi
	@-rm -f $(Manual).aux $(Manual).cp $(Manual).cps $(Manual).fn $(Manual).ky $(Manual).op $(Manual).pg $(Manual).toc $(Manual).tp $(Manual).vr $(Manual).log
ifneq ($(zip_exists),)
	@$(if $(findstring -D ZIP,$(TEXI2DVI_FLAGS)), zip -r $(Manual).zip * --exclude *.zip bak/* images/bak/* images/*.eps *.tex *.texi $(Manual).tar.gz configure* )
else
	@echo "Program \"zip\" missing."
	@echo "Try: sudo apt-get install zip"
endif

.PHONY: info
info: TEXI2DVI_FLAGS += -D INFO
info: $(Manual).info
	@$(if $(findstring -D INFO,$(TEXI2DVI_FLAGS)), \
		$(TEXI2DVI) $(Manual).texi \
	)

.PHONY: postscript
.PHONY: ps
postscript: ps
ps: TEXI2DVI_FLAGS += -D POSTSCRIPT
ps: $(Manual).ps
$(Manual).ps: $(Manual).texi png2eps jpg2eps gif2eps
	@$(if $(findstring -D POSTSCRIPT,$(TEXI2DVI_FLAGS)), $(TEXI2DVI) --ps $(Manual).texi; echo ; echo "PostScript created. See $(Manual).ps"; echo )

.PHONY: dvi
dvi: TEXI2DVI_FLAGS += -D DVI
dvi: $(Manual).dvi
$(Manual).dvi: $(Manual).texi png2eps jpg2eps gif2eps
	@$(if $(findstring -D DVI,$(TEXI2DVI_FLAGS)), $(TEXI2DVI) --dvi $(Manual).texi ; echo; echo "Device independent file format (DVI) created. See $(Manual).dvi"; echo)

# Build Microsoft HTML Helper File (.chm)
# The HTML Helper only runs under Windows
.PHONY: htmlhelp
htmlhelp: $(Manual).texi $(Manual).dbk
	@mv -f $(Manual).dbk $(Manual).xml
	a2x -v -f htmlhelp --icons -D . $(Manual).xml
	@echo
	@echo
	@echo "Under Cygwin or MingGW download the Microsoft HTML Help Workshop."
	@echo "copy hhc.exe to this directory."
	@echo "run \"./hhc.exe $(Manual).hhp\" to generate Microsoft HTML Helper for Windows."
	@echo "The name of the created file will be \"$(Manual).chm\". Double click to run"
	@echo "this file under Windows. Microsoft HTML Helper files will not run from"
	@echo "network drives."
	@echo
	@echo

# Run spelling checker on .texi content
.PHONY: spell
.PHONY: spelling
spell: spelling
spelling:
ifneq ($(aspell_exists),)
	aspell --mode=texinfo -c $(Manual).texi
else
	@echo "Program \"aspell\" missing."
	@echo "Try: sudo apt-get install aspell"
endif

# Check diction. See 'man diction'
.PHONY: diction
diction:
ifneq ($(diction_exists),)
	$(TEXI2ANY)  --no-headers \
		$(Manual).texi -o $(Manual).txt
	diction < $(Manual).txt
else
	@echo "Program \"diction\" missing."
	@echo "Try: sudo apt-get install diction"
endif

# Check style. See 'man style'
.PHONY: style
style:
ifneq ($(style_exists),)
	$(TEXI2ANY)  --no-headers \
		$(Manual).texi -o $(Manual).txt
	style < $(Manual).txt
else
	@echo "Program \"style\" missing."
	@echo "Try: sudo apt-get install style"
endif

# Publish content to website
.PHONY: website
website:
	scripts/push_to_web.sh

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
	if [ ! -d images ]; then \
		(mkdir images ) ; \
	fi;
	if [ ! -d images/bak ]; then \
		(mkdir images/bak ) ; \
	fi;
	find ./images/ -maxdepth 1 -type f -exec cp {} ./images/bak \;
	@echo All images in ./images backed up to ./images/bak

.PHONY: png2eps
png2eps:
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

.PHONY: jpg2eps 
jpg2eps:
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
gif2eps:
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

.PHONY: eps2png
eps2png:
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

.PHONY: jpg2txt
jpg2txt:
ifneq ($(jp2a_exists),)
	for file in $(JPG_FILES); do \
		if [ -e "$$file.txt" ]; then \
			echo "$$file.txt exists"; \
		else \
			jp2a --width=155 $$file.jpg > $$file.txt; \
			echo "Creating $$file.txt"; \
		fi; \
	done
	@echo
	@echo All .jpg files converted to .txt
	@echo Original .jpg files remain
	@echo
else
	@echo "Program \"jp2a\" missing."
	@echo "Try: sudo apt-get install jp2a"
endif

.PHONY: png2txt
png2txt:
ifeq ($(CONVERT_JP2A_EXISTS),Y Y)
	for file in $(PNG_FILES); do \
		if [ -e "$$file.txt" ]; then \
			echo "$$file.txt exists"; \
		else \
			convert $$file.png jpg:- | jp2a - --width=155 > $$file.txt; \
			echo "Creating $$file.txt"; \
		fi; \
	done
	@echo
	@echo All .png files converted to .txt
	@echo Original .png files remain
	@echo
else
	@echo
	@echo "Program \"convert\" or \"jp2a\" missing."
	@echo "Try: sudo apt-get install imagemagick jp2a"
	@echo
endif

# Check for bad links
.PHONY: linkchecker
linkchecker: all
ifneq ($(linkchecker_exists),)
	linkchecker -Fhtml index.html
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
	for d in $(DIRS); do\
		if [ -d $$d ] && [ -e "$$d/Makefile" ]; then\
			(cd $$d; $(MAKE) clean );\
		fi;\
	done
