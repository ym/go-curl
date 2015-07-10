TMP_PREFIX := XXXcurl
CURL_VERSION := 7.43.0

CURL_TAR_TEMP := $(shell mktemp -t $(TMP_PREFIX))
CURL_EXTRACT_TEMP := $(shell mktemp -dt $(TMP_PREFIX))
CURL_BUILD_TEMP := $(shell mktemp -dt $(TMP_PREFIX))

curl:
	wget -O $(CURL_TAR_TEMP) http://curl.haxx.se/download/curl-$(CURL_VERSION).tar.gz && \
	tar zxvf $(CURL_TAR_TEMP) -C $(CURL_EXTRACT_TEMP) && \
	cd $(CURL_EXTRACT_TEMP)/curl-$(CURL_VERSION) && \
	./configure \
	--prefix $(CURL_BUILD_TEMP) \
	--disable-shared \
	--enable-static \
	--enable-optimize \
	--with-ssl \
	--disable-manual \
	--disable-ldap \
	--disable-ldaps \
	--disable-rtsp \
	--disable-telnet \
	--disable-tftp \
	--disable-pop3 \
	--disable-imap \
	--disable-smb \
	--disable-smtp \
	--disable-gopher \
	--enable-ipv6 \
	--without-libssh2 \
	--with-libidn && \
	make && make install

cgo: curl
	mkdir libcurl && \
	cp -r $(CURL_BUILD_TEMP)/lib $(CURL_BUILD_TEMP)/include $(CURL_BUILD_TEMP)/bin ./libcurl && \
	go build -v .

test: cgo
	go test -v .

all: cgo curl

.PHONY: all
