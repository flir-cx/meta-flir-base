/*
 *  RS485 port test utility
 *
 *  Author: Mats Karrman, South Pole Consulting AB
 *
 *  Copyright (C) 2018, Flir Systems AB
 */

#include <fcntl.h>
#include <getopt.h>
#include <linux/serial.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

/* Driver-specific ioctls: */
#define TIOCGRS485      0x542E
#define TIOCSRS485      0x542F

#define DEV_NODE	"/dev/ttymxc2"

enum cmd {
	CMD_INFO,
	CMD_ENABLE,
	CMD_DISABLE,
	CMD_SEND,
	CMD_RECEIVE,
};

static struct serial_rs485 rs485conf;

static struct {
	unsigned delay_rts_after_send_s:1;
	unsigned delay_rts_before_send_s:1;
	unsigned rts_on_send_s:1;
	unsigned rts_on_send_v:1;
	unsigned rts_after_send_s:1;
	unsigned rts_after_send_v:1;
	unsigned rx_during_tx_s:1;
	unsigned rx_during_tx_v:1;
	unsigned hex:1;
	unsigned debug:1;
	unsigned delay_rts_after_send_v;
	unsigned delay_rts_before_send_v;
	int poll_tmo;
	const char * dev_node;
	const char * send_str;
} args = {
	.dev_node = DEV_NODE,
};

static void die_errno(const char * msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static void die_argerr(const char * msg)
{
	fprintf(stderr, "Error: %s\nTry '-h' for help\n", msg);
	exit(EXIT_FAILURE);
}

static unsigned atobit(const char *str)
{
	if (str && str[0] == '0' && str[1] == '\0')
		return 0;
	else if (str && str[0] == '1' && str[1] == '\0')
		return 1;

	die_argerr("Invalid bit value!");
	return 1;  /* Never comes here! */
}

static void help(const char * progname)
{
	printf(
"RS485 port test utility.\n"
"\n"
"USAGE: %s [OPTIONS] COMMAND [MESSAGE]\n"
"\n"
"OPTIONS are:\n"
"  -a, --rts-after-send 0|1    Level of RTS after transmit complete.\n"
"  -A, --delay-after-send DEL  Delay from stop send to switching RTS (ms).\n"
"  -B, --delay-before-send DEL Delay from switching RTS to start send (ms).\n"
"  -d, --dev PATH              Device node to use, default: " DEV_NODE ".\n"
"  -g, --debug                 Enable extra debug output.\n"
"  -h, --help                  Print this help text.\n"
"  -o, --rts-on-send 0|1       Level of RTS during transmit.\n"
"  -p, --poll-tmo TMO          Receive poll time-out, default: 5000ms.\n"
"  -r, --rx-during-tx 0|1      Receive during transmit (0=no, 1=yes).\n"
"  -x, --hex                   Display messages as hex numbers, default: ASCII.\n"
"Default value for -aABor is driver dependent.\n"
"\n"
"COMMANDs are:\n"
"  info     Show current RS485 device settings (use with -d).\n"
"  enable   Put device in RS485 mode (use with -aABdgor).\n"
"  disable  Put device in RS232 mode (use with -dg).\n"
"  send     Send a message (use with -dp and MESSAGE). If -p is specified,\n"
"           data is read from port, right after send is completed.\n"
"  receive  Receive message (use with -dpx).\n"
"\n"
"NOTE:\n"
"  This program does not modify non-RS485 port settings so configre the port\n"
"  using something like the following command before use:\n"
"\n"
"    stty -F " DEV_NODE " raw 9600 cs8 -parenb -cstopb\n"
"\n"
	, progname);
	exit(EXIT_SUCCESS);
}

static enum cmd parse_cmdline(int argc, char *argv[])
{
	static const char *opts = "a:A:B:d:gho:p:r:s:x";
	static const struct option long_opts[] = {
		{ "rts-after-send", required_argument, NULL, 'a' },
		{ "delay-after-send", required_argument, NULL, 'A' },
		{ "delay-before-send", required_argument, NULL, 'B' },
		{ "dev", required_argument, NULL, 'd' },
		{ "debug", no_argument, NULL, 'g' },
		{ "help", no_argument, NULL, 'h' },
		{ "rts-on-send", required_argument, NULL, 'o' },
		{ "poll-tmo", required_argument, NULL, 'p' },
		{ "rx-during-tx", required_argument, NULL, 'r' },
		{ "hex", no_argument, NULL, 'x' },
	};

	int opt;
	int ix;
	enum cmd cmd;
	int extra_argc;

	while ((opt = getopt_long(argc, argv, opts, long_opts, &ix)) != -1) {
		switch (opt) {
		case 'a':
			args.rts_after_send_s = 1;
			args.rts_after_send_v = atobit(optarg);
			break;
		case 'A':
			args.delay_rts_after_send_s = 1;
			args.delay_rts_after_send_v = atoi(optarg);
			break;
		case 'B':
			args.delay_rts_before_send_s = 1;
			args.delay_rts_before_send_v = atoi(optarg);
			break;
		case 'd':
			args.dev_node = optarg;
			break;
		case 'g':
			args.debug = 1;
			break;
		case 'h':
			help(argv[0]);
			break;
		case 'o':
			args.rts_on_send_s = 1;
			args.rts_on_send_v = atobit(optarg);
			break;
		case 'p':
			args.poll_tmo = atoi(optarg);
			break;
		case 'r':
			args.rx_during_tx_s = 1;
			args.rx_during_tx_v = atobit(optarg);
			break;
		case 'x':
			args.hex = 1;
			break;
		}
	}

	if (optind >= argc)
		die_argerr("No command specified!");

	extra_argc = 0;
	if (!strcmp("info", argv[optind])) {
		cmd = CMD_INFO;
	} else if (!strcmp("enable", argv[optind])) {
		cmd = CMD_ENABLE;
	} else if (!strcmp("disable", argv[optind])) {
		cmd = CMD_DISABLE;
	} else if (!strcmp("send", argv[optind])) {
		cmd = CMD_SEND;
		extra_argc = 1;
	} else if (!strcmp("receive", argv[optind])) {
		cmd = CMD_RECEIVE;
	} else {
		die_argerr("Unknown command!");
	}
	++optind;

	if ((argc - optind) != extra_argc)
		die_argerr("Unexpected or missing extra argument!");

	if (cmd == CMD_SEND)
		args.send_str = argv[optind++];

	return cmd;
}

static int open_device_node(void)
{
	int fd = open(args.dev_node, O_RDWR);
	if (fd < 0)
		die_errno("Failed to open device node");
	return fd;
}

static void close_device_node(int fd)
{
	if (close(fd) < 0)
		die_errno("Failed to close device node");
}

static void ioctl_get_rs485(int fd)
{
	if (ioctl (fd, TIOCGRS485, &rs485conf) < 0)
		die_errno("Failed to get RS485 settings");
}

static void ioctl_set_rs485(int fd)
{
	if (ioctl (fd, TIOCSRS485, &rs485conf) < 0)
		die_errno("Failed to set RS485 settings");
}

static void read_device_data(int fd, int tmo)
{
	struct pollfd fds[1];
	int ret;
	char buffer[256];
	int rx_count;
	int i;

	fds[0].fd = fd;
	fds[0].events = POLLIN | POLLPRI;
	fds[0].revents = 0;
	ret = poll(fds, 1, tmo);

	if (ret < 0)
		die_errno("Failed to receive");
	if (!ret) {
		printf("RX timeout\n");
		return;
	}

	/* ret should be 1 then... */
	rx_count = read(fd, buffer, sizeof(buffer));
	if (rx_count < 0)
		die_errno("Failed to read");

	printf("RX[%d]:", rx_count);
	for (i=0; i<rx_count; ++i) {
		if (args.hex)
			printf(" %02x", buffer[i]);
		else
			putchar(buffer[i]);
	}
	putchar('\n');
}

static void show_rs485conf(void)
{
	printf("serial_rs485 {\n");
	printf("\tflags=0x%02u [ENABLED=%d, RTS_ON_SEND=%d, RTS_AFTER_SEND=%d, RX_DURING_TX=%d]\n",
		rs485conf.flags,
		(rs485conf.flags & SER_RS485_ENABLED)        ? 1 : 0,
		(rs485conf.flags & SER_RS485_RTS_ON_SEND)    ? 1 : 0,
		(rs485conf.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0,
		(rs485conf.flags & SER_RS485_RX_DURING_TX)   ? 1 : 0);
	printf("\tdelay_rts_before_send=%ums\n", rs485conf.delay_rts_before_send);
	printf("\tdelay_rts_after_send=%ums\n", rs485conf.delay_rts_after_send);
	printf("}\n");
}

static void set_rs485conf_flag(unsigned mask, unsigned val)
{
	if (val)
		rs485conf.flags |= mask;
	else
		rs485conf.flags &= ~mask;
}

static void cmd_info(void)
{
	int fd = open_device_node();

	ioctl_get_rs485(fd);
	show_rs485conf();
	close_device_node(fd);
}

static void cmd_enable(void)
{
	int fd = open_device_node();

	ioctl_get_rs485(fd);
	if (args.debug)
		show_rs485conf();

	rs485conf.flags |= SER_RS485_ENABLED;
	if (args.rts_on_send_s)
		set_rs485conf_flag(SER_RS485_RTS_ON_SEND, args.rts_on_send_v);
	if (args.rts_after_send_s)
		set_rs485conf_flag(SER_RS485_RTS_AFTER_SEND, args.rts_after_send_v);
	if (args.rx_during_tx_s)
		set_rs485conf_flag(SER_RS485_RX_DURING_TX, args.rx_during_tx_v);
	if (args.delay_rts_after_send_s)
		rs485conf.delay_rts_after_send = args.delay_rts_after_send_v;
	if (args.delay_rts_before_send_s)
		rs485conf.delay_rts_before_send = args.delay_rts_before_send_v;

	ioctl_set_rs485(fd);
	if (args.debug)
		show_rs485conf();
	close_device_node(fd);
}

static void cmd_disable(void)
{
	int fd = open_device_node();

	ioctl_get_rs485(fd);
	if (args.debug)
		show_rs485conf();
	rs485conf.flags &= ~SER_RS485_ENABLED;
	ioctl_set_rs485(fd);
	if (args.debug)
		show_rs485conf();
	close_device_node(fd);
}

static void cmd_send(void)
{
	int fd = open_device_node();

	if (write(fd, args.send_str, strlen(args.send_str)) < 0)
		die_errno("Failed to send");
	if (args.poll_tmo)
		read_device_data(fd, args.poll_tmo);
	close_device_node(fd);
}

static void cmd_receive(void)
{
	int fd = open_device_node();

	read_device_data(fd, args.poll_tmo ? : 5000);
	close_device_node(fd);
}

int main(int argc, char *argv[])
{
	enum cmd cmd;

	cmd = parse_cmdline(argc, argv);
	switch (cmd) {
		case CMD_INFO:
			cmd_info();
			break;
		case CMD_ENABLE:
			cmd_enable();
			break;
		case CMD_DISABLE:
			cmd_disable();
			break;
		case CMD_SEND:
			cmd_send();
			break;
		case CMD_RECEIVE:
			cmd_receive();
			break;
	}

	return EXIT_SUCCESS;
}
