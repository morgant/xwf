PREFIX=/usr/local

all: xat xcp xfi xwf

lib-src/adouble.o: lib-src/adouble.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/entry.o: lib-src/entry.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/gtk_dlg.o: lib-src/gtk_dlg.c
	$(CC) $(CFLAGS) \
		-I. \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_dnd.o: lib-src/gtk_dnd.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_exec.o: lib-src/gtk_exec.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/gtk_util.o: lib-src/gtk_util.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0 gtk+-2.0` \
		-c $? -o $@

lib-src/io.o: lib-src/io.c
	$(CC) $(CFLAGS) -c $? -o $@

lib-src/lnk.o: lib-src/lnk.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/mailcap.o: lib-src/mailcap.c
	$(CC) $(CFLAGS) -c $? -o $@

lib-src/reg.o: lib-src/reg.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

lib-src/uri.o: lib-src/uri.c
	$(CC) $(CFLAGS) \
		`pkg-config --cflags glib-2.0` \
		-c $? -o $@

xat: lib-src/entry.o lib-src/mailcap.o lib-src/gtk_util.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o xat-src/main.c xat-src/callbacks.c xat-src/gui.c xat-src/support.c
	${CC} ${CFLAGS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DDATA_DIR=\"${PREFIX}/share\" \
		-DXWF_RC=\"xwf.rc\" \
		$? \
		-o $@

xcp: lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/io.o lib-src/adouble.o xcp-src/xcp.c xcp-src/xcp_gui.c
	${CC} ${CFLAGS} \
		-I/usr/X11R6/include \
		-Ilib-src \
		-I. \
		-L/usr/X11R6/lib \
		`pkg-config --cflags --libs glib-2.0 gtk+-2.0` \
		-DHAVE_CONFIG_H \
		-DDATA_DIR=\"${PREFIX}/share\" \
		$? \
		-o $@

xfi: lib-src/reg.o lib-src/uri.o lib-src/io.o lib-src/entry.o xfi-src/main.c xfi-src/callbacks.c xfi-src/gui.c xfi-src/support.c
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
		$? \
		-o $@

xwf: lib-src/uri.o lib-src/io.o lib-src/gtk_dlg.o lib-src/gtk_dnd.o lib-src/entry.o lib-src/gtk_util.o lib-src/reg.o lib-src/mailcap.o lib-src/gtk_exec.o lib-src/lnk.o xwf-src/xwf.c xwf-src/gtk_get.c xwf-src/history.c xwf-src/top.c xwf-src/xwf_dnd.c xwf-src/xwf_gui.c xwf-src/xwf_icon.c xwf-src/xwf_misc.c
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
		$? \
		-o $@

install: lib_src xat xcp xwf
	install -m 755 xat xcp xfi xwf ${PREFIX}/bin
	install -m 644 doc/xwf.1 ${PREFIX}/man/man1

clean:
	rm xat xcp xfi xwf lib-src/*.o
