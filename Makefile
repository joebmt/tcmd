# --- 
# Makefile - QA Makefile to create bin/tcmd binary from python bin/tcmd.py
# --- 
SHELL := /bin/bash

ls:
	@echo "make <target> where <target> is one of:"
	@echo 
	@grep '^[a-zA-Z_]*:' Makefile | sed 's/:.*//' |sed 's/^/	/'
	@echo 

cat:
	@cat Makefile

tcmd_binary:
	@echo "--- Makefile: Creating tcmd binary from tcmd.py ---"
	bin/build_tcmd.sh --binary

tcmd_python:
	@echo "--- Makefile: Creating tcmd python from tcmd.py ---"
	bin/build_tcmd.sh --python

installreq:
	@echo "--- Makefile: Installing python dependencies: pip install -r inc/requirements.txt ---"
	pip install -r inc/requirements.txt

install_tcmdpy:
	@echo "--- Makefile: Installing tcmd.py to /usr/local/bin ---"
	cp -f bin/tcmd.py /usr/local/bin/tcmd
	ls -alt /usr/local/bin/tcmd

install_tcmdbin:
	@echo "--- Makefile: Installing tcmd.bin to /usr/local/bin ---"
	cp -f bin/tcmd.bin /usr/local/bin/tcmd
	ls -alt /usr/local/bin/tcmd

buildpydoc:
	@echo "--- Makefile: Making new pydoc file ---"
	# cd bin
	bin/build_pydoc.sh
