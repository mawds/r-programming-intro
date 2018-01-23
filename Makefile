## ========================================
## Commands for both workshop and lesson websites.

# Settings
MAKEFILES=Makefile $(wildcard *.mk)
JEKYLL=jekyll
PARSER=bin/markdown_ast.rb
DST=_site
# Command to run an Rscript
# Set this to Rscript -e if you don't want to build 
# in Dockerised environment
RSCRIPT=docker run --rm --user "$$UID" -v "$$PWD":"$$PWD"  -w="$$PWD" -ti rg11  Rscript -e
DATAFILES=$(wildcard _episodes_rmd/data/*)
UNITTESTFILES=$(wildcard _episodes_rmd/tests/*.R)
# This is used in the substitutions to get relative paths in
# the data zip file:
RMDDIR=_episodes_rmd/

# Controls
.PHONY : commands clean files
.NOTPARALLEL:
all : commands

## commands         : show all commands.
commands :
	@grep -h -E '^##' ${MAKEFILES} | sed -e 's/## //g'

## serve-rmd        : run a local server, updating Rmd file automatically
serve-rmd: lesson-md lesson-watchrmd serve data

## serve            : run a local server.
serve : lesson-md
	${JEKYLL} serve

## site             : build files but do not run a server.
site : lesson-md
	${JEKYLL} build

# repo-check        : check repository settings.
repo-check :
	@bin/repo_check.py -s .

## clean            : clean up junk files.
clean :
	@rm -rf ${DST}
	@rm -rf .sass-cache
	@rm -rf bin/__pycache__
	@find . -name .DS_Store -exec rm {} \;
	@find . -name '*~' -exec rm {} \;
	@find . -name '*.pyc' -exec rm {} \;

## clean-rmd        : clean intermediate R files (that need to be committed to the repo).
clear-rmd :
	@rm -rf ${RMD_DST}
	@rm -rf fig/rmd-*

## ----------------------------------------
## Commands specific to workshop websites.

.PHONY : workshop-check

## workshop-check   : check workshop homepage.
workshop-check :
	@bin/workshop_check.py .

## data             : generate the course data download
data: data/data.zip

data/data.zip:	${DATAFILES} ${UNITTESTFILES}
	cd ${RMDDIR} && zip -u ../$@ $(subst ${RMDDIR},,$^)


## ----------------------------------------
## Command specific to lesson websites.

.PHONY : lesson-check lesson-md lesson-files lesson-fixme lesson-watchrmd

# RMarkdown files
RMD_SRC = $(sort $(wildcard _episodes_rmd/??-*.Rmd))
RMD_PP = $(patsubst _episodes_rmd/%.Rmd,_episodes_rmd/%.tmp,$(RMD_SRC))
RMD_DST = $(patsubst _episodes_rmd/%.tmp,_episodes/%.md,$(RMD_PP))

# Lesson source files in the order they appear in the navigation menu.
MARKDOWN_SRC = \
  index.md \
  CONDUCT.md \
  setup.md \
  $(sort $(wildcard _episodes/*.md)) \
  reference.md \
  $(sort $(wildcard _extras/*.md)) \
  LICENSE.md

# Generated lesson files in the order they appear in the navigation menu.
HTML_DST = \
  ${DST}/index.html \
  ${DST}/conduct/index.html \
  ${DST}/setup/index.html \
  $(patsubst _episodes/%.md,${DST}/%/index.html,$(sort $(wildcard _episodes/*.md))) \
  ${DST}/reference/index.html \
  $(patsubst _extras/%.md,${DST}/%/index.html,$(sort $(wildcard _extras/*.md))) \
  ${DST}/license/index.html

## lesson-md        : convert Rmarkdown files to markdown
lesson-md : ${RMD_DST}

lesson-watchrmd:
	@bin/watchRmd.sh &

_episodes/%.md: _episodes_rmd/%.tmp
	${RSCRIPT} 'knitr::knit("$<","$@")'

# Format challenges and solutions
# Without manually blockquoting them
_episodes_rmd/%.tmp : _episodes_rmd/%.Rmd
	bin/format_challenge.py $< $@

## lesson-check     : validate lesson Markdown.
lesson-check :
	@bin/lesson_check.py -s . -p ${PARSER} -r _includes/links.md

## lesson-check-all : validate lesson Markdown, checking line lengths and trailing whitespace.
lesson-check-all :
	@bin/lesson_check.py -s . -p ${PARSER} -l -w

## unittest         : run unit tests on checking tools.
unittest :
	python bin/test_lesson_check.py

## lesson-files     : show expected names of generated files for debugging.
lesson-files :
	@echo 'RMD_SRC:' ${RMD_SRC}
	@echo 'RMD_DST:' ${RMD_DST}
	@echo 'MARKDOWN_SRC:' ${MARKDOWN_SRC}
	@echo 'HTML_DST:' ${HTML_DST}

## lesson-fixme     : show FIXME markers embedded in source files.
lesson-fixme :
	@fgrep -i -n FIXME ${MARKDOWN_SRC} || true

#-------------------------------------------------------------------------------
# Include extra commands if available.
#-------------------------------------------------------------------------------

-include commands.mk
