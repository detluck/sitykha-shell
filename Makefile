# paths
BUILD_DIR := build
PREFIX    := /
QML_PATH  := $(BUILD_DIR)/src/backend

# build
.PHONY: configure build clean

configure:
	cmake -B $(BUILD_DIR) -G Ninja \
		-DCMAKE_BUILD_TYPE=Debug \
		-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
		-DCMAKE_INSTALL_PREFIX=$(PREFIX)

build: configure
	cmake --build $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)
	rm -f compile_commands.json

# install
.PHONY: install uninstall

install: build
	sudo cmake --install $(BUILD_DIR) --prefix $(PREFIX)

uninstall:
	sudo rm -rf \
		/usr/lib/qt6/qml/Sitykha \
		/etc/xdg/quickshell/sitykha

# dev
.PHONY: run dev

# run with installed plugin
run:
	qs -c sitykha

# run directly from build dir, no install needed
dev: build
	QML2_IMPORT_PATH=$(QML_PATH) qs -p shell.qml

# compile_commands.json for clangd
.PHONY: clangd

clangd: configure
	ln -sf $(PWD)/$(BUILD_DIR)/compile_commands.json $(PWD)/compile_commands.json

# link
.PHONY: link unlink

link:
	ln -sf $(PWD) $(HOME)/.config/quickshell/sitykha

unlink:
	rm -f $(HOME)/.config/quickshell/sitykha
