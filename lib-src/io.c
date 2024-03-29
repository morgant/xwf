/*
 * io.c
 *
 * Copyright (C) 1998 - 2000 Rasca, Berlin
 * EMail: thron@gmx.de
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/resource.h>
#include "config.h"
#ifdef HAVE_LIMITS_H
#include <limits.h>
#endif
#include <errno.h>
#include "io.h"

extern char **environ;

/*
 * check is named file is an executable
 * return the mode field, so we don't have to stat() again if
 * we need some further informations
 */
int
io_is_exec (char *file)
{
	struct stat file_stat;
	if (stat (file, &file_stat) != -1) {
		if ((!S_ISDIR (file_stat.st_mode)) && (
			file_stat.st_mode & S_IXUSR ||
			file_stat.st_mode & S_IXGRP ||
			file_stat.st_mode & S_IXOTH )
			)
			return (file_stat.st_mode);
	}
	return (0);
}

/*
 * is given file a directory?
 */
int
io_is_directory (char *path)
{
	struct stat file_stat;
	if (!path || !*path)
		return 0;
	if (stat (path, &file_stat) == 0) {
		if (S_ISDIR (file_stat.st_mode)) {
			return (1);
		}
	}
	return (0);
}

/*
 * is named file a directory
 */
int
io_is_file (char *path)
{
	struct stat file_stat;
	if (!path || !*path)
		return 0;
	if (stat (path, &file_stat) != -1) {
		if (S_ISREG (file_stat.st_mode))
			return (file_stat.st_mode);
	}
	return (0);
}

/*
 * is named file a directory
 */
int
io_is_link (char *path)
{
	struct stat file_stat;
	if (!path || !*path)
		return 0;
	if (lstat (path, &file_stat) != -1) {
		if (S_ISLNK (file_stat.st_mode))
			return (1);
	}
	return (0);
}

/*
 */
int
io_can_exec (char *file)
{
	if (!file || !*file)
		return 0;
	if (access (file, X_OK) != -1)
		return (1);
	return (0);
}

/*
 */
int
io_can_write_to_parent (char *file)
{
	char *p;
	char path[PATH_MAX+1];
	p = strrchr (file, '/');
	if (p) {
		strncpy (path, file, p-file+1);
		path[p-file+1] = '\0';
	} else
		strcpy (path, ".");
	if (access (path, W_OK|X_OK) == -1)
		return (0);
	return (1);
}


/*
 */
int
io_system_nice (char *cmd, int niceval)
{
	pid_t pid;
	int status;

	if (cmd == NULL)
		return (-1);
#ifdef DEBUG_IO
	printf ("%s: io_system() cmd=%s\n", __FILE__, cmd);
#endif
	pid = fork();
	if (pid == -1)
		return (-1);
	if (pid == 0) {
		/* child */
		char *argv[4];
		if (setpriority (PRIO_PROCESS, 0, niceval) == -1)
			fprintf (stderr, "%s: Warning: setpriority() failed!\n", __FILE__);
		argv[0] = SHELL;
		argv[1] = "-c";
		argv[2] = cmd;
		argv[3] = NULL;
		if (execve (SHELL, argv, environ) == -1)
			perror (SHELL);
		_exit (127);
	}
	do {
		if (waitpid (pid, &status, 0) == -1) {
			if (errno != EINTR)
				return (-1);
		} else
			return status;
	} while (1);
}

/*
 */
/*
static void
sig_seg (int signum)
{
	fprintf (stderr, "segmention fault (pid=%d)\n", getpid());
	exit (127);
}
*/

/*
 * wait for childs
 */
void
sig_child (int num)
{
	int status = 0;
	pid_t pid;
#ifdef DEBUG_IO
	printf ("%s: sig_child(%d)\n", __FILE__, num);
#endif
	/* ensure we have no zombies
	 */
	/* pid = wait (&status); */
	pid = waitpid (-1, &status, WNOHANG);
#ifdef DEBUG_IO
	printf ("%s:  pid = %d, status = %d\n", __FILE__, pid, status);
	if (pid == -1)
		perror ("wait()");
#endif
}

/*
 * find command in path
 */
int
io_find_in_path (char *cmd, char *path, size_t path_size)
{
	int found = 0;
	char *dup = strdup (getenv("PATH"));
	char *s = dup;
	char *p = NULL;

	// check cwd or cmd path first
	if (access(cmd, X_OK) == 0) {
		snprintf(path, path_size, "%s", cmd);
		found = 1;
	// otherwise check each path entry
	} else {
		do {
			char *fullpath;
			size_t fullpath_len;

			p = strchr (s, ':');
			if (p != NULL)
				p[0] = 0;

			fullpath_len = strlen(s) + strlen(cmd) + 2;
			fullpath = calloc(fullpath_len, sizeof(char));
			snprintf(fullpath, fullpath_len, "%s/%s", s, cmd);

			if (access(fullpath, X_OK) == 0) {
				snprintf(path, path_size, "%s", fullpath);
				found = 1;
			}
			free(fullpath);
			s = p + 1;
		} while (p != NULL && found == 0);
  }
	free (dup);

	return found;
}

/*
 * exec a program with all the arguments
 */
int
io_system_var (char **arg, int len)
{
	pid_t pid;
	int status, i, rc;
	static void *oldsigfunc = NULL;
	char path[PATH_MAX+1];

	if ((arg == NULL) || (len == 0))
		return -1;

#ifdef DEBUG_IO
	printf ("%s: io_system_var(arg=%s, .., len=%d)\n", __FILE__, *arg, len);
#endif

	if (!io_find_in_path(arg[0], &path, PATH_MAX+1))
		return -1;

	if ((pid = fork()) == -1) {
		perror ("fork()");
		return (-1);
	}

	if (pid == 0) {
		/* this is the child process
		 */
		char **argv = (char **) malloc (sizeof(char *) * (len + 1));
#ifdef	DEBUG_IO
		printf ("%s:  new pid = %d\n", __FILE__, getpid());
#endif
		if (!argv)
			_exit (127);
		argv[0] = path;
		for (i = 1; i < len; i++) {
			argv[i] = arg[i];
		}
		argv[len] = NULL;
		if (execve (argv[0], argv, environ) == -1) {
			_exit (errno);
		}
	}

	/* parent process
	 */
	if (!oldsigfunc)
		oldsigfunc = signal (SIGCHLD, sig_child);
	usleep (200000); /* 0.2 sec */
	do {
		rc = waitpid (pid, &status, WNOHANG);
		if (rc == -1) {
			if (errno == ECHILD) {
				return 0;
			}
			if (errno != EINTR) {
				perror (arg[0]);
				return (-1);
			}
		} else {
			if (WIFEXITED(status)) {
				if (WEXITSTATUS(status) != 0) {
					perror ("exit?");
					return -1;
				}
			}
			return 0;
		}
	} while (1);
}

/*
 */
int
io_item_exists (char *path)
{
	struct stat s;
	if (stat (path, &s) != -1) {
		return (s.st_mode);
	}
	return (0);
}

