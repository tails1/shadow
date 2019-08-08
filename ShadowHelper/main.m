#include <stdio.h>
#include <spawn.h>
#include <sys/wait.h>
#include <sys/stat.h>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

int mount_apfs_snapshot(char *snapshot, char *volume, char *directory) {
	pid_t pid;
	char *argv[] = {"mount_apfs", "-s", snapshot, volume, directory, NULL};
	int ret;

	if(posix_spawn(&pid, "/sbin/mount_apfs", NULL, NULL, argv, NULL) == 0) {
		waitpid(pid, &ret, WEXITED);
		return ret;
	}

	return -1;
}

int main(int argc, char *argv[], char *envp[]) {
	if(getuid() != 0) {
		// Attempt to setuid.
		setuid(0);
		setuid(0);

		if(getuid() != 0) {
			// Failed.
			printf("error: failed to get root privileges.\n");
		}
	}

	if(mount_apfs_snapshot("orig-fs", "/", "/var/MobileSoftwareUpdate/mnt1") != 0) {
		printf("error: failed to mount orig-fs.\n");
		return -1;
	}

	return 0;
}
