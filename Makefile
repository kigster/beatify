# vim: ft=make

.PHONY: help

BEETIFIED_MUSIC="$(HOME)/Music/Beetified"
BEETIFIED_LOG:="$(BEETIFIED_MUSIC)/.beets-runtime.log"
BEETIFIED_DB:="$(BEETIFIED_MUSIC)/.beets-database.db"

BEETIFIED_HOME:=$(shell pwd -P)
BEETIFIED_CONFIG:="$(BEETIFIED_HOME)/config.yaml"

MUSIC_SOURCES:="$(HOME)/Music/DJ"

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

init: ## Clone beets locally and run its installer
	@bash -c '[[ -d beets ]] || git clone https://github.com/beetbox/beets.git'
	@echo "Installing beets into /usr/local/bin/beets"
	@bash -c 'cd beets && python3 setup.py install >/dev/null 2>&1'
	@echo "Ensuring target music folder $(BEETIFIED_MUSIC) exists..."
	@mkdir -p $(BEETIFIED_MUSIC)

clean: ## Wipe out the folder organized by Beets $(BEETS)
	@echo "Cleaning previous Beetified music folders..."
	rm -rf $(BEETIFIED_MUSIC) 

wipe:
	rm -rf $(BEETIFIED_HOME)/beets

import: init ## Import Music Folders into ~/Music/Beets
	@echo "Importing from $(MUSIC_SOURCES) to $(BEETIFIED_MUSIC)..."
	beet --directory=$(BEETIFIED_MUSIC) \
		--config=$(BEETIFIED_CONFIG) \
		import \
		--noautotag \
		--from-scratch  \
		--log=$(BEETIFIED_LOG) \
		--copy \
		--resume \
		--singletons \
		--noincremental \
		--quiet \
		$(MUSIC_SOURCES)


reimport: clean import ## Clean previous import, and do it again.


#————————————————————————————————————————————————————————————————
# ❯ beet -h
# Usage: 
#   beet COMMAND [ARGS...]
#   beet help COMMAND
#
# Options:
#   --format-item=FORMAT_ITEM
#                         print with custom format
#   --format-album=FORMAT_ALBUM
#                         print with custom format
#   -l LIBRARY, --library=LIBRARY
#                         library database file to use
#   -d DIRECTORY, --directory=DIRECTORY
#                         destination music directory
#   -v, --verbose         log more details (use twice for even more)
#   -c CONFIG, --config=CONFIG
#                         path to configuration file
#   -p PLUGINS, --plugins=PLUGINS
#                         a comma-separated list of plugins to load
#   -h, --help            show this help message and exit

# Commands:
#   bpm               determine bpm of a song by pressing a key to the rhythm
#   clearart          remove images from file metadata
#   config            show or edit the user configuration
#   duplicates (dup)  List duplicate tracks or albums.
#   embedart          embed image files into file metadata
#   extractart        extract an image from file metadata
#   fields            show fields available for queries and format strings
#   help (?)          give detailed help on a specific sub-command
#   import (imp, im)  import new music
#   info              show file metadata
#   list (ls)         query the library
#   missing (miss)    List missing tracks.
#   modify (mod)      change metadata fields
#   move (mv)         move or copy items
#   remove (rm)       remove matching items from the library
#   stats             show statistics about the library or a query
#   update (upd, up)  update the library
#   version           output version information
#   write             write tag information to files
# #————————————————————————————————————————————————————————————————
# ❯ beet import -h
# Usage: beet import [options]

# Options:
#   -h, --help            show this help message and exit
#   -c, --copy            copy tracks into library directory (default)
#   -C, --nocopy          don't copy tracks (opposite of -c)
#   -m, --move            move tracks into the library (overrides -c)
#   -w, --write           write new metadata to files' tags (default)
#   -W, --nowrite         don't write metadata (opposite of -w)
#   -a, --autotag         infer tags for imported files (default)
#   -A, --noautotag       don't infer tags for imported files (opposite of -a)
#   -p, --resume          resume importing if interrupted
#   -P, --noresume        do not try to resume importing
#   -q, --quiet           never prompt for input: skip albums instead
#   -l LOG, --log=LOG     file to log untaggable albums for later review
#   -s, --singletons      import individual tracks instead of full albums
#   -t, --timid           always confirm all actions
#   -L, --library         retag items matching a query
#   -i, --incremental     skip already-imported directories
#   -I, --noincremental   do not skip already-imported directories
#   --from-scratch        erase existing metadata before applying new metadata
#   --flat                import an entire tree as a single album
#   -g, --group-albums    group tracks in a folder into separate albums
#   --pretend             just print the files to import
#   -S ID, --search-id=ID
#                         restrict matching to a specific metadata backend ID
#   --set=FIELD=VALUE     set the given fields to the supplied values
