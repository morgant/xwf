PREFIX=/usr/local

all: xat xcp xfi xwf

xat: xat-src/main.c xat-src/callbacks.c xat-src/gui.c xat-src/support.c
	${CC} ${CFLAGS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DDATA_DIR=\"${PREFIX}/share\" \
		-DXWF_RC=\"xwf.rc\" \
		lib-src/*.c \
		xat-src/*.c \
		-o $@

xcp: xcp-src/xcp.c xcp-src/xcp_gui.c
	${CC} ${CFLAGS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DDATA_DIR=\"${PREFIX}/share\" \
		lib-src/*.c \
		xcp-src/*.c \
		-o $@

xfi: xfi-src/main.c xfi-src/callbacks.c xfi-src/gui.c xfi-src/support.c
	${CC} ${CFLAFS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DDATA_DIR=\"${PREFIX}/share\" \
		-DXWF_RC=\"xwf.rc\" \
		-DPLUGINDIR=\"${PREFIX}/lib/xwf\" \
		-DINSTDIR=\"${PREFIX}\" \
		lib-src/*.c \
		xfi-src/*.c \
		-o $@

xwf: xwf-src/xwf.c xwf-src/gtk_get.c xwf-src/history.c xwf-src/top.c xwf-src/xwf_dnd.c xwf-src/xwf_gui.c xwf-src/xwf_icon.c xwf-src/xwf_misc.c
	${CC} ${CFLAGS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DVERSION=\"0.9.7\" \
		-DDATA_DIR=\"${PREFIX}/share\" \
		-DXWF_RC=\"xwf.rc\" \
		-DPLUGINDIR=\"${PREFIX}/lib/xwf\" \
		-DINSTDIR=\"${PREFIX}\" \
		-DTERMINAL=\"xterm\" \
		lib-src/*.c \
		xwf-src/*.c \
		-o $@

install: xat xcp xwf
	install xat ${PREFIX}/bin
	install xcp ${PREFIX}/bin
	install xfi ${PREFIX}/bin
	install xwf ${PREFIX}/bin

clean:
	rm xat xcp xfi xwf
