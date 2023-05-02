/*
 * Tools to play with i.MX6 framebuffer overlay and alpha channels.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/kernel.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>		/* uintx_t */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>
#include <getopt.h>		/* getopt_long() */

/* #include <uapi/linux/mxcfb.h> ?? */
#define MXCFB_SET_GBL_ALPHA	_IOW('F', 0x21, struct mxcfb_gbl_alpha)
#define MXCFB_SET_CLR_KEY	_IOW('F', 0x22, struct mxcfb_color_key)
#define MXCFB_SET_LOC_ALPHA	_IOWR('F', 0x26, struct mxcfb_loc_alpha)
#define MXCFB_SET_OVERLAY_POS	_IOWR('F', 0x24, struct mxcfb_pos)

struct mxcfb_gbl_alpha {
	int enable;
	uint32_t alpha;
};

struct mxcfb_color_key {
	int enable;
	uint32_t color_key;
};

struct mxcfb_loc_alpha {
	int enable;
	int alpha_in_pixel;
	unsigned long alpha_phy_addr0;
	unsigned long alpha_phy_addr1;
};

struct mxcfb_pos {
	uint16_t x;
	uint16_t y;
};

static void usage(FILE * fp, int argc, char **argv)
{
	fprintf(fp,
		"Usage: %s [options]\n\n"
		"Options:\n"
		"  -a | --alpha value     Set value as alpha channel (when global alpha)\n"
		"  -d | --device name     Framebuffer device name [/dev/fb1]\n"
		"  -g | --global [0|1]    (De)Activate global alpha. When set please define alpha and key values\n"
		"  -h | --help            Print this message\n"
		"  -k | --key 0xAARRGGBB  ARGB value of color key (when global alpha)\n"
		"  -l | --local [0|1]     (De)Activate local alpha.\n"
		"  -x | --x_pos X         Use X as overlay position\n"
		"  -y | --y_pos Y         Use Y as overlay vertical position\n"
		"", argv[0]);
}

static const char short_options[] = "a:d:g:hk:l:x:y:";

static const struct option long_options[] = {
	{"alpha", required_argument, NULL, 'a'},
	{"device", required_argument, NULL, 'd'},
	{"global", required_argument, NULL, 'g'},
	{"help", no_argument, NULL, 'h'},
	{"key", required_argument, NULL, 'k'},
	{"local", required_argument, NULL, 'l'},
	{"x_pos", required_argument, NULL, 'x'},
	{"y_pos", required_argument, NULL, 'y'},
	{0, 0, 0, 0}
};

int main(int argc, char **argv)
{
	int fb_fd;
	struct mxcfb_gbl_alpha gbl_alpha;
	struct mxcfb_loc_alpha l_alpha;
	struct mxcfb_color_key key;
	char *fb_name = "/dev/fb1";
	char *endptr;
	struct mxcfb_pos fb_pos = { 100, 100 };

	if (argc < 3) {
		usage(stdout, argc, argv);
		return -1;
	}

	for (;;) {
		int index;
		int c;

		c = getopt_long(argc, argv,
				short_options, long_options, &index);

		if (-1 == c)
			break;

		switch (c) {
		case 0:	/* getopt_long() flag */
			break;

		case 'd':
			fb_name = optarg;
			break;

		case 'h':
			usage(stdout, argc, argv);
			exit(EXIT_SUCCESS);

		case 'x':
			fb_pos.x = atoi(optarg);
			break;

		case 'y':
			fb_pos.y = atoi(optarg);
			break;

		case 'g':
			gbl_alpha.enable = atoi(optarg);
			if (gbl_alpha.enable == 1) {
				printf("enabling");
				key.enable = 1;
			} else {
				printf("disabling");
				key.enable = 0;
			}
			printf(" global alpha blending\n");
			break;

		case 'a':
			gbl_alpha.alpha = atoi(optarg);
			break;

		case 'l':
			l_alpha.alpha_in_pixel = 1;
			l_alpha.enable = atoi(optarg);
			if (l_alpha.enable == 1) {
				printf("enabling");
			} else {
				printf("disabling");
			}
			printf(" local alpha blending\n");
			break;

		case 'k':
			key.color_key = strtol(optarg, &endptr, 16);
			printf("key = 0x%x\n", key.color_key);
			break;

		default:
			usage(stderr, argc, argv);
			exit(EXIT_FAILURE);
		}
	}

	printf("opening '%s'\n", fb_name);

	fb_fd = open(fb_name, O_RDWR, 0);

	if (fb_fd == -1) {
		perror("open");
		exit(1);
	}

	if (ioctl(fb_fd, MXCFB_SET_OVERLAY_POS, &fb_pos))
		perror("ioctl");

	if (gbl_alpha.enable == 1) {
		if (ioctl(fb_fd, MXCFB_SET_GBL_ALPHA, &gbl_alpha))
			perror("ioctl");
		if (ioctl(fb_fd, MXCFB_SET_CLR_KEY, &key))
			perror("ioctl");
	} else if (l_alpha.alpha_in_pixel == 1) {
		if (ioctl(fb_fd, MXCFB_SET_LOC_ALPHA, &l_alpha))
			perror("ioctl");
	}

	close(fb_fd);
	return 0;
}
