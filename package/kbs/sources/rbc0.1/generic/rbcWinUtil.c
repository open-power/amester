/*
 * rbcWinUtil.c --
 *
 *      This module contains WIN32 routines not included in the Tcl/Tk
 *      libraries.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#include "rbcInt.h"

/*
 *--------------------------------------------------------------
 *
 * Rbc_GetPlatformId --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
int
Rbc_GetPlatformId()
{
    static int platformId = 0;

    if (platformId == 0) {
        OSVERSIONINFO opsysInfo;

        opsysInfo.dwOSVersionInfoSize = sizeof(OSVERSIONINFO);
        if (GetVersionEx(&opsysInfo)) {
            platformId = opsysInfo.dwPlatformId;
        }
    }
    return platformId;
}

/*
 *--------------------------------------------------------------
 *
 * Rbc_LastError --
 *
 *      TODO: Description
 *
 * Results:
 *      TODO: Results
 *
 * Side effects:
 *      TODO: Side Effects
 *
 *--------------------------------------------------------------
 */
char *
Rbc_LastError()
{
    static char buffer[1024];
    int length;

    FormatMessage(
        FORMAT_MESSAGE_FROM_SYSTEM,
        NULL,
        GetLastError(),
        MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),	/* Default language */
        buffer,
        1024,
        NULL);
    length = strlen(buffer);
    if (buffer[length - 2] == '\r') {
        buffer[length - 2] = '\0';
    }
    return buffer;
}

