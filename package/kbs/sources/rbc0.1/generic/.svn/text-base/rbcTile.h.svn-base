/*
 * rbcTile.h --
 *
 *      TODO: Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCTILE
#define _RBCTILE

#define TILE_THREAD_KEY	"Rbc Tile Data"
#define TILE_MAGIC ((unsigned int) 0x46170277)

typedef struct Rbc_TileClientStruct *Rbc_Tile; /* Opaque type for tiles */

typedef void (Rbc_TileChangedProc) _ANSI_ARGS_((ClientData clientData,
        Rbc_Tile tile));

int Rbc_GetTile _ANSI_ARGS_((Tcl_Interp *interp, Tk_Window tkwin,
                             char *imageName, Rbc_Tile *tilePtr));

void Rbc_FreeTile _ANSI_ARGS_((Rbc_Tile tile));

char *Rbc_NameOfTile _ANSI_ARGS_((Rbc_Tile tile));

void Rbc_SetTileChangedProc _ANSI_ARGS_((Rbc_Tile tile,
                                        Rbc_TileChangedProc *changeProc, ClientData clientData));

void Rbc_TileRectangle _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                    Rbc_Tile tile, int x, int y, unsigned int width, unsigned int height));
void Rbc_TileRectangles _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                     Rbc_Tile tile, XRectangle *rectArr, int nRects));
void Rbc_TilePolygon _ANSI_ARGS_((Tk_Window tkwin, Drawable drawable,
                                  Rbc_Tile tile, XPoint *pointArr, int nPoints));
Pixmap Rbc_PixmapOfTile _ANSI_ARGS_((Rbc_Tile tile));

void Rbc_SizeOfTile _ANSI_ARGS_((Rbc_Tile tile, int *widthPtr,
                                 int *heightPtr));

void Rbc_SetTileOrigin _ANSI_ARGS_((Tk_Window tkwin, Rbc_Tile tile,
                                    int x, int y));

void Rbc_SetTSOrigin _ANSI_ARGS_((Tk_Window tkwin, Rbc_Tile tile,
                                  int x, int y));

#endif /* _RBCTILE */
