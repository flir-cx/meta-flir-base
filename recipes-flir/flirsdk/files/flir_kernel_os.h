/***********************************************************************
 *                                                                     
 * Project: Balthazar
 * $Date: 2018/09/12 $
 * $Author: upalmer $
 *
 * $Id: //depot/Alpha/mainWinCE/SDK/FLIR/Include/flir_kernel_os.h#1 $
 *
 * Description of file:
 *    OS-independent basic include file
 *
 * Last check-in changelist:
 * $Change: 256399 $
 *
 * 
 *
 *	Copyright:	FLIR Systems AB
 ***********************************************************************/

#ifndef _FLIROS_H
#define _FLIROS_H

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/cdev.h>
#include <linux/moduleparam.h>
#include <linux/time.h>
#include <linux/interrupt.h>
#include <asm/gpio.h>
#include <linux/workqueue.h>
#include <linux/delay.h>
#include <linux/slab.h>
#include <linux/syscalls.h>
#include <linux/version.h>
#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)
#include <../arch/arm/mach-imx/iomux-v3.h>
#else
#include <mach/iomux-v3.h>
#endif
#include <linux/ioctl.h>
#include <linux/device.h>

typedef unsigned char BYTE;
typedef unsigned char UCHAR;
typedef unsigned char UINT8;
typedef char CHAR;
typedef short SHORT;
typedef short INT16;
typedef unsigned short WORD;
typedef unsigned short USHORT;
typedef unsigned short UINT16;
typedef unsigned short *PUINT16;
typedef unsigned long DWORD;
typedef unsigned long UINT32;
typedef unsigned long UINT;
typedef unsigned long ULONG;
typedef unsigned long *PULONG;
typedef long INT;
typedef long LONG;
typedef long INT32;
typedef unsigned long long ULONGLONG;
typedef int BOOL;
typedef void *LPVOID;
typedef void *PVOID;
typedef BYTE *PBYTE;
typedef BYTE *PUCHAR;
typedef DWORD *PDWORD;
typedef DWORD *LPDWORD;
typedef struct timeval SYSTEMTIME;

#define ERROR_SUCCESS              0
#define ERROR_FILE_NOT_FOUND       2
#define ERROR_ACCESS_DENIED        5
#define ERROR_INVALID_HANDLE       6
#define ERROR_NOT_SUPPORTED       50
#define ERROR_FILE_EXISTS         80
#define ERROR_INVALID_PARAMETER   87
#define ERROR_ALREADY_EXISTS     183
#define	ERROR_TIMEOUT			1001
#define ERROR_OUT_OF_STRUCTURES	1002
#define ERROR_OUTOFMEMORY		1002
#define ERROR_INVALID_DATA		1003
#define ERROR_NOT_ENOUGH_MEMORY 1004
#define ERROR_IO_DEVICE			1005

#define TRUE  1
#define FALSE 0

typedef int DHANDLE;
#define INVALID_DHANDLE_VALUE ((int) -1)

#endif // _FLIROS_H
