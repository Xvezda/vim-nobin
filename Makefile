VIMRC_PATH = $(shell vim -u NONE -n -es --noplugin -c 'verbose echo get(split(&rtp, ","), 0)' -c 'qall' 2>&1)


all: install

install:
	mkdir -p $(VIMRC_PATH)/plugin
	cp plugin/nobin.vim $(VIMRC_PATH)/plugin/

clean:
	rm $(VIMRC_PATH)/plugin/nobin.vim
