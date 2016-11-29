/*
 * rbcSwitch.h --
 *
 *      This module implements command/argument switch parsing
 *      procedures for the rbc toolkit.
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCSWITCH
#define _RBCSWITCH

#ifdef offsetof
#define Rbc_Offset(type, field) ((int) offsetof(type, field))
#else
#define Rbc_Offset(type, field) ((int) ((char *) &((type *) 0)->field))
#endif

typedef int (Rbc_SwitchParseProc) _ANSI_ARGS_((ClientData clientData,
        Tcl_Interp *interp, char *switchName, char *value, char *record,
        int offset));

typedef void (Rbc_SwitchFreeProc) _ANSI_ARGS_((char *ptr));

typedef struct {
    Rbc_SwitchParseProc *parseProc;	/* Procedure to parse a switch value
					 * and store it in its converted
					 * form in the data record. */
    Rbc_SwitchFreeProc *freeProc;	/* Procedure to free a switch. */
    ClientData clientData;		/* Arbitrary one-word value
					 * used by switch parser,
					 * passed to parseProc. */
} Rbc_SwitchCustom;

/*
 * Type values for Rbc_SwitchSpec structures.  See the user
 * documentation for details.
 */
typedef enum {
    RBC_SWITCH_BOOLEAN, RBC_SWITCH_INT, RBC_SWITCH_INT_POSITIVE,
    RBC_SWITCH_INT_NONNEGATIVE, RBC_SWITCH_DOUBLE, RBC_SWITCH_STRING,
    RBC_SWITCH_LIST, RBC_SWITCH_FLAG, RBC_SWITCH_VALUE, RBC_SWITCH_CUSTOM,
    RBC_SWITCH_END
} Rbc_SwitchTypes;

typedef struct {
    Rbc_SwitchTypes type;	/* Type of option, such as RBC_SWITCH_DOUBLE;
				 * see definitions above.  Last option in
				 * table must have type RBC_SWITCH_END. */
    char *switchName;		/* Switch used to specify option in argv.
				 * NULL means this spec is part of a group. */
    int offset;			/* Where in widget record to store value;
				 * use Rbc_Offset macro to generate values
				 * for this. */
    int flags;			/* Any combination of the values defined
				 * below. */
    Rbc_SwitchCustom *customPtr; /* If type is RBC_SWITCH_CUSTOM then this is
				 * a pointer to info about how to parse and
				 * print the option.  Otherwise it is
				 * irrelevant. */
    int value;
} Rbc_SwitchSpec;

#define RBC_SWITCH_ARGV_ONLY		(1<<0)
#define RBC_SWITCH_OBJV_ONLY		(1<<0)
#define RBC_SWITCH_ARGV_PARTIAL		(1<<1)
#define RBC_SWITCH_OBJV_PARTIAL		(1<<1)
/*
 * Possible flag values for Rbc_SwitchSpec structures.  Any bits at
 * or above RBC_SWITCH_USER_BIT may be used by clients for selecting
 * certain entries.
 */
#define RBC_SWITCH_NULL_OK		(1<<0)
#define RBC_SWITCH_DONT_SET_DEFAULT	(1<<3)
#define RBC_SWITCH_SPECIFIED		(1<<4)
#define RBC_SWITCH_USER_BIT		(1<<8)

int Rbc_ProcessSwitches _ANSI_ARGS_((Tcl_Interp *interp, Rbc_SwitchSpec *specs, int argc, char **argv, char *record, int flags));
void Rbc_FreeSwitches _ANSI_ARGS_((Rbc_SwitchSpec *specs, char *record, int flags));
int Rbc_SwitchChanged _ANSI_ARGS_(TCL_VARARGS(Rbc_SwitchSpec *, specs));
int Rbc_ProcessObjSwitches _ANSI_ARGS_((Tcl_Interp *interp, Rbc_SwitchSpec *specPtr, int objc, Tcl_Obj *CONST *objv, char *record, int flags));

#endif /* _RBCSWITCH */
