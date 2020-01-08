VIMRC_PATH = $(shell vim -u NONE -n -es --noplugin \
			 -c 'verbose echo get(split(&rtp, ","), 0)' -c 'qall' 2>&1)


all: install

install:
	mkdir -p $(VIMRC_PATH)/autoload
	mkdir -p $(VIMRC_PATH)/plugin
	cp autoload/veast.vim $(VIMRC_PATH)/autoload/
	cp plugin/nobin.vim $(VIMRC_PATH)/plugin/

clean:
	rm -f $(VIMRC_PATH)/autoload/veast.vim
	rm -f $(VIMRC_PATH)/plugin/nobin.vim
