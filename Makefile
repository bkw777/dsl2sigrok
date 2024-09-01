# Makefile for dsl2sigrock

OS ?= $(shell uname)
CC ?= gcc
#CFLAGS += -O3 -Wall -Wextra -Werror
CFLAGS += -O3 -Wall
PREFIX ?= /usr/local
NAME := dsl2sigrok
APP_NAME := $(NAME)
APP_VERSION := $(shell git describe --long 2>&-)
DOCS := README.md LICENSE
SOURCES := main.c zip_helper.c
LDLIBS := -lm -lzip

ifdef DEBUG
 CFLAGS += -g
endif

INSTALLOWNER = -o root
ifeq ($(OS),Windows_NT)
 INSTALLOWNER =
 CFLAGS += -D_WIN
endif

DEFINES := \
	-DAPP_NAME=\"$(APP_NAME)\" \
	-DAPP_VERSION=\"$(APP_VERSION)\"

DOCDIR = $(PREFIX)/share/doc/$(NAME)
BINDIR = $(PREFIX)/bin

.PHONY: all
all: $(NAME)

$(NAME): $(SOURCES)
	$(CC) $(CFLAGS) $(CXXFLAGS) $(DEFINES) $(SOURCES) $(LDLIBS) -o $(@)

install: $(NAME) # $(DOCS)
	mkdir -p $(DOCDIR)
	for s in $(DOCS) ;do \
		install $(INSTALLOWNER) -m 0644 $${s} $(DOCDIR) ; \
	done
	mkdir -p $(BINDIR)
	install $(INSTALLOWNER) -m 0755 $(NAME) $(BINDIR)

uninstall:
	rm -rf $(BINDIR)/$(NAME) $(DOCDIR) 

clean:
	rm -f $(NAME)
