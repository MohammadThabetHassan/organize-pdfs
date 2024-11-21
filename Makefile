PACKAGE_NAME = organize-pdfs
VERSION = 1.0.0
ARCH = all
BUILD_DIR = build
DEB_DIR = $(BUILD_DIR)/DEBIAN
BIN_DIR = $(BUILD_DIR)/usr/bin
all: clean build package
clean:
	rm -rf $(BUILD_DIR) *.deb
build:
	mkdir -p $(DEB_DIR)
	mkdir -p $(BIN_DIR)
	chmod +x $(BIN_DIR)/organize_pdfs
	mkdir -p $(DEB_DIR)
	echo "Package: $(PACKAGE_NAME)" > $(DEB_DIR)/control
	echo "Version: $(VERSION)" >> $(DEB_DIR)/control
	echo "Section: utils" >> $(DEB_DIR)/control
	echo "Priority: optional" >> $(DEB_DIR)/control
	echo "Architecture: $(ARCH)" >> $(DEB_DIR)/control
	echo "Depends: bash" >> $(DEB_DIR)/control
	echo "Maintainer: Your Name <youremail@example.com>" >> $(DEB_DIR)/control
	echo "Description: Multi-Level PDF File Organizer" >> $(DEB_DIR)/control
package:
	dpkg-deb --build $(BUILD_DIR)
	mv $(BUILD_DIR).deb $(PACKAGE_NAME)_$(VERSION)_$(ARCH).deb
install:
	sudo dpkg -i $(PACKAGE_NAME)_$(VERSION)_$(ARCH).deb
uninstall:
	sudo dpkg -r $(PACKAGE_NAME)
.PHONY: all clean build package install uninstall
