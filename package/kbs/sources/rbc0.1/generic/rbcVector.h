/*
 * rbcVector.h --
 *
 *      TODO:Description
 *
 * Copyright (c) 2009 Samuel Green, Nicholas Hudson, Stanton Sievers, Jarrod Stormo
 * All rights reserved.
 *
 * See "license.terms" for details.
 */

#ifndef _RBCVECTOR
#define _RBCVECTOR

#include <ctype.h>
#include "rbcInt.h"
#include "rbcChain.h"

typedef struct {
    double *valueArr; /* Array of values (possibly malloc-ed) */
    int numValues; /* Number of values in the array */
    int arraySize; /* Size of the allocated space */
    double min, max; /* Minimum and maximum values in the vector */
    int dirty; /* Indicates if the vector has been updated */
    int reserved; /* Reserved for future use */
} Rbc_Vector;

#define Rbc_VecData(v)		((v)->valueArr)
#define Rbc_VecLength(v)	((v)->numValues)
#define Rbc_VecSize(v)		((v)->arraySize)
#define Rbc_VecDirty(v)		((v)->dirty)

#ifdef HAVE_FINITE
#define FINITE(x)	finite(x)
#else
#ifdef HAVE_ISFINITE
#define FINITE(x)	isfinite(x)
#else
#ifdef HAVE_ISNAN
#define FINITE(x)	(!isnan(x))
#else
#define FINITE(x)	(TRUE)
#endif /* HAVE_ISNAN */
#endif /* HAVE_ISFINITE */
#endif /* HAVE_FINITE */


#define VECTOR_THREAD_KEY	"Rbc Vector Data"
#define VECTOR_MAGIC		((unsigned int) 0x46170277)
#define MAX_ERR_MSG	1023
#define DEF_ARRAY_SIZE		64
#define BUFFER_SIZE 1024
#define STATIC_STRING_SPACE 150

#define TRACE_ALL  (TCL_TRACE_WRITES | TCL_TRACE_READS | TCL_TRACE_UNSETS)

/* These defines allow parsing of different types of indices */

/* Recognize "min", "max", and "++end" as valid indices */
#define INDEX_SPECIAL	(1<<0)
/* Also recognize a range of indices separated by a colon */
#define INDEX_COLON	(1<<1)
/* Verify that the specified index or range of indices are within limits */
#define INDEX_CHECK	(1<<2)
#define INDEX_ALL_FLAGS    (INDEX_SPECIAL | INDEX_COLON | INDEX_CHECK)
#define SPECIAL_INDEX		-2

/* Never notify clients of updates to the vector */
#define NOTIFY_NEVER		(1<<3)
/* Notify clients after each update of the vector is made */
#define NOTIFY_ALWAYS		(1<<4)
/* Notify clients at the next idle point that the vector has been updated. */
#define NOTIFY_WHENIDLE		(1<<5)
/* A do-when-idle notification of the vector's clients is pending. */
#define NOTIFY_PENDING		(1<<6)
#define NOTIFY_UPDATED		((int) RBC_VECTOR_NOTIFY_UPDATE)
#define NOTIFY_DESTROYED	((int) RBC_VECTOR_NOTIFY_DESTROY)
/* The data of the vector has changed.  Update the min and max limits when they are needed */
#define UPDATE_RANGE		(1<<9)

#define UCHAR(c) ((unsigned char) (c))
#define VECTOR_CHAR(c)	((isalnum(UCHAR(c))) || \
	(c == '_') || (c == ':') || (c == '@') || (c == '.'))


#define NS_SEARCH_NONE		(0)
#define NS_SEARCH_CURRENT	(1<<0)
#define NS_SEARCH_GLOBAL	(1<<1)
#define NS_SEARCH_BOTH		(NS_SEARCH_GLOBAL | NS_SEARCH_CURRENT)

extern double rbcNaN;
#ifdef __BORLANDC__
static double
MakeNaN(void)
{
    union Real {
        struct DoubleWord {
            int lo, hi;
        } doubleWord;
    double number;
} real;

real.doubleWord.lo = real.doubleWord.hi = 0x7FFFFFFF;
return real.number;
}
#endif /* __BORLANDC__ */

#ifdef _MSC_VER
static double
MakeNaN(void)
{
    return sqrt(-1.0); /* Generate IEEE 754 Quiet Not-A-Number. */
}
#endif /* _MSC_VER */

#if !defined(__BORLANDC__) && !defined(_MSC_VER)
static double
MakeNaN(void)
{
	/* Generate IEEE 754 Not-A-Number. */
    return 0.0 / 0.0;
}
#endif /* !__BORLANDC__  && !_MSC_VER */

typedef struct {
    Tcl_HashTable vectorTable; /* Table of vectors */
    Tcl_HashTable mathProcTable; /* Table of vector math functions */
    Tcl_HashTable indexProcTable;
    Tcl_Interp *interp;
    unsigned int nextId;
} VectorInterpData;

/*
 *	A vector is an array of double precision values.  It can be
 *	accessed through a Tcl command, a Tcl array variable, or C
 *	API. The storage for the array points initially to a
 *	statically allocated buffer, but to malloc-ed memory if more
 *	is necessary.
 *
 *	Vectors can be shared by several clients (for example, two
 *	different graph widgets).  The data is shared. When a client
 *	wants to use a vector, it allocates a vector identifier, which
 *	identifies the client.  Clients use this ID to specify a
 *	callback routine to be invoked whenever the vector is modified
 *	or destroyed.  Whenever the vector is updated or destroyed,
 *	each client is notified of the change by their callback
 *	routine.
 */
typedef struct {
    /*
     * If you change these fields, make sure you change the definition
     * of Rbc_Vector in rbcVector.h too.
     */
    double *valueArr; /* Array of values (malloc-ed) */
    int length; /* Current number of values in the array. */
    int size; /* Maximum number of values that can be stored
               * in the value array. */
    double min, max; /* Minimum and maximum values in the vector */
    int dirty; /* Indicates if the vector has been updated */
    int reserved;

    /* The following fields are local to this module  */
    char *name; /* The namespace-qualified name of the vector command.
                 * It points to the hash key allocated for the
                 * entry in the vector hash table. */
    VectorInterpData *dataPtr;
    Tcl_Interp *interp; /* Interpreter associated with the vector */
    Tcl_HashEntry *hashPtr; /* If non-NULL, pointer in a hash table to
                             * track the vectors in use. */
    Tcl_FreeProc *freeProc; /* Address of procedure to call to
                             * release storage for the value
                             * array, Optionally can be one of the
                             * following: TCL_STATIC, TCL_DYNAMIC,
                             * or TCL_VOLATILE. */
    char *arrayName; /* The namespace-qualified name of the
                      * Tcl array variable
                      * mapped to the vector
                      * (malloc'ed). If NULL, indicates
                      * that the vector isn't mapped to any variable */
    int offset; /* Offset from zero of the vector's
                 * starting index */
    Tcl_Command cmdToken; /* Token for vector's Tcl command. */
    Rbc_Chain *chainPtr; /* List of clients using this vector */
    int notifyFlags; /* Notification flags. See definitions
                      * below */
    int varFlags; /* Indicate if the variable is global,
                   * namespace, or local */
    int freeOnUnset; /* For backward compatibility only: If
                      * non-zero, free the vector when its
                      * variable is unset. */
    int flush;
    int first, last; /* Selected region of vector. This is used
                      * mostly for the math routines */
} VectorObject;

typedef struct Rbc_VectorIdStruct *Rbc_VectorId;

typedef enum {
    RBC_VECTOR_NOTIFY_UPDATE = 1, /* The vector's values has been updated */
    RBC_VECTOR_NOTIFY_DESTROY /* The vector has been destroyed and the client
                               * should no longer use its data (calling
                               * Rbc_FreeVectorId) */
} Rbc_VectorNotify;

typedef void (Rbc_VectorChangedProc) _ANSI_ARGS_((Tcl_Interp *interp, ClientData clientData, Rbc_VectorNotify notify));

typedef double (Rbc_VectorIndexProc) _ANSI_ARGS_((Rbc_Vector * vecPtr));

/*
 *	A vector can be shared by several clients.  Each client
 *	allocates this structure that acts as its key for using the
 *	vector.  Clients can also designate a callback routine that is
 *	executed whenever the vector is updated or destroyed.
 *
 */
typedef struct {
    unsigned int magic;			/* Magic value designating whether this
								 * really is a vector token or not */
    VectorObject *serverPtr;	/* Pointer to the master record of the
								 * vector.  If NULL, indicates that the
								 * vector has been destroyed but as of
								 * yet, this client hasn't recognized
								 * it. */
    Rbc_VectorChangedProc *proc;/* Routine to call when the contents
								 * of the vector change or the vector
								 * is deleted. */
    ClientData clientData;		/* Data passed whenever the vector
								 * change procedure is called. */
    Rbc_ChainLink *linkPtr;		/* Used to quickly remove this entry from
								 * its server's client chain. */
} VectorClient;

/*
 *	The token types are defined below.  In addition, there is a
 *	table associating a precedence with each operator.  The order
 *	of types is important.  Consult the code before changing it.
 */
enum Tokens {
    VALUE,
    OPEN_PAREN,
    CLOSE_PAREN,
    COMMA,
    END,
    UNKNOWN,
    MULT = 8,
    DIVIDE,
    MOD,
    PLUS,
    MINUS,
    LEFT_SHIFT,
    RIGHT_SHIFT,
    LESS,
    GREATER,
    LEQ,
    GEQ,
    EQUAL,
    NEQ,
    OLD_BIT_AND,
    EXPONENT,
    OLD_BIT_OR,
    OLD_QUESTY,
    OLD_COLON,
    AND,
    OR,
    UNARY_MINUS,
    OLD_UNARY_PLUS,
    NOT,
    OLD_BIT_NOT
};

typedef struct ParseValueStruct ParseValue;

struct ParseValueStruct {
    char *buffer; /* Address of first character in
                   * output buffer. */
    char *next; /* Place to store next character in
	             * output buffer. */
    char *end; /* Address of the last usable character
	            * in the buffer. */
    void (*expandProc)_ANSI_ARGS_((ParseValue *pvPtr, int needed)); /* Procedure to call when space runs out;
                                                                     * it will make more space. */
    ClientData clientData; /* Arbitrary information for use of
                            * expandProc. */
    };

typedef struct {
    VectorObject *vPtr;
    char staticSpace[STATIC_STRING_SPACE];
    ParseValue pv; /* Used to hold a string value, if any. */
} Value;

/*
 *	The data structure below describes the state of parsing an
 *	expression.  It's passed among the routines in this module.
 */
typedef struct {
    char *expr; /* The entire right-hand side of the
                 * expression, as originally passed to
                 * Rbc_ExprVector. */
    char *nextPtr; /* Position of the next character to
                    * be scanned from the expression
                    * string. */
    enum Tokens token; /* Type of the last token to be parsed
                        * from nextPtr.  See below for
                        * definitions.  Corresponds to the
                        * characters just before nextPtr. */
} ParseInfo;

/* Vector Operators Definitions (rbcVector.c) */
void               Rbc_VectorFlushCache     _ANSI_ARGS_((VectorObject *vPtr));
VectorObject *     Rbc_VectorParseElement   _ANSI_ARGS_((Tcl_Interp *interp, VectorInterpData *dataPtr, const char *start, char **endPtr, int flags));
int  	           Rbc_VectorChangeLength   _ANSI_ARGS_((VectorObject *vPtr, int length));
void               Rbc_VectorUpdateClients  _ANSI_ARGS_((VectorObject *vPtr));
int                Rbc_VectorMapVariable    _ANSI_ARGS_((Tcl_Interp *interp, VectorObject *vPtr, const char *name));
VectorObject *     Rbc_VectorCreate         _ANSI_ARGS_((VectorInterpData *dataPtr, const char *vecName, const char *cmdName, const char *varName, int *newPtr));
int                Rbc_VectorGetIndex       _ANSI_ARGS_((Tcl_Interp *interp, VectorObject *vPtr, const char *string, int *indexPtr, int flags, Rbc_VectorIndexProc **procPtrPtr));
int                Rbc_GetDouble            _ANSI_ARGS_((Tcl_Interp *interp, Tcl_Obj *objPtr, double *valuePtr));
void 		       Rbc_VectorFree		    _ANSI_ARGS_((VectorObject *vPtr));
int 		       Rbc_VectorGetIndexRange  _ANSI_ARGS_((Tcl_Interp *interp, VectorObject *vPtr, const char *string, int flags, Rbc_VectorIndexProc **procPtrPtr));
int                Rbc_VectorDuplicate      _ANSI_ARGS_((VectorObject *destPtr, VectorObject *srcPtr));
Tcl_Obj *          Rbc_GetValues            _ANSI_ARGS_((VectorObject *vPtr, int first, int last));
void               Rbc_ReplicateValue       _ANSI_ARGS_((VectorObject *vPtr, int first, int last, double value));
int                Rbc_VectorLookupName     _ANSI_ARGS_((VectorInterpData *dataPtr, char *vecName, VectorObject **vPtrPtr));
int                Rbc_VectorReset          _ANSI_ARGS_((VectorObject *vPtr, double *valueArr, int length, int size, Tcl_FreeProc *freeProc));
void               Rbc_VectorUpdateRange    _ANSI_ARGS_((VectorObject *vPtr));
VectorObject *     Rbc_VectorNew            _ANSI_ARGS_((VectorInterpData *dataPtr));
VectorInterpData * Rbc_VectorGetInterpData  _ANSI_ARGS_((Tcl_Interp *interp));
int                Rbc_VectorNotifyPending  _ANSI_ARGS_((Rbc_VectorId clientId));
void               Rbc_FreeVectorId         _ANSI_ARGS_((Rbc_VectorId clientId));
int                Rbc_GetVectorById        _ANSI_ARGS_((Tcl_Interp *interp, Rbc_VectorId clientId, Rbc_Vector **vecPtrPtr));
int                Rbc_VectorExists2        _ANSI_ARGS_((Tcl_Interp *interp, char *vecName));
Rbc_VectorId       Rbc_AllocVectorId        _ANSI_ARGS_((Tcl_Interp *interp, char *vecName));
void               Rbc_SetVectorChangedProc _ANSI_ARGS_((Rbc_VectorId clientId, Rbc_VectorChangedProc * proc, ClientData clientData));
char *             Rbc_NameOfVectorId       _ANSI_ARGS_((Rbc_VectorId clientId));
int                Rbc_GetVector            _ANSI_ARGS_((Tcl_Interp *interp, char *vecName, Rbc_Vector **vecPtrPtr));
int                Rbc_CreateVector         _ANSI_ARGS_((Tcl_Interp *interp, char *vecName, int size, Rbc_Vector ** vecPtrPtr));
int                Rbc_ResizeVector         _ANSI_ARGS_((Rbc_Vector *vecPtr, int nValues));
char *             Rbc_NameOfVector         _ANSI_ARGS_((Rbc_Vector *vecPtr));
int                Rbc_ResetVector          _ANSI_ARGS_((Rbc_Vector *vecPtr, double *dataArr, int nValues, int arraySize, Tcl_FreeProc *freeProc));
int                Rbc_VectorReset          _ANSI_ARGS_((VectorObject *vPtr, double *dataArr, int nValues, int arraySize, Tcl_FreeProc *freeProc));

/* Instance Functions Definitions (rbcVecObjCmd.c) */
int Rbc_AppendOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_ArithOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_BinreadOp   _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_ClearOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_DeleteOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_DupOp       _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_ExprOp      _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_IndexOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_LengthOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_MergeOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_NormalizeOp _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_OffsetOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_RandomOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_PopulateOp  _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_RangeOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_SearchOp    _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_SeqOp       _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_SetOp       _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_SortOp      _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_SplitOp     _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
int Rbc_VariableOp  _ANSI_ARGS_((VectorObject *vPtr, Tcl_Interp *interp, int objc, Tcl_Obj * const objv[]));
double drand48 _ANSI_ARGS_((void));

/* Vector Math Definitions (rbcVecMath.c) */
typedef double (ComponentProc) _ANSI_ARGS_((double value));
typedef int (VectorProc)       _ANSI_ARGS_((VectorObject *vPtr));
typedef double (ScalarProc)    _ANSI_ARGS_((VectorObject *vPtr));

double Rbc_VecMin                      _ANSI_ARGS_((Rbc_Vector *vecPtr));
double Rbc_VecMax                      _ANSI_ARGS_((Rbc_Vector *vecPtr));
int    Rbc_ExprVector                  _ANSI_ARGS_((Tcl_Interp *interp, char *string, Rbc_Vector *vecPtr));
void   Rbc_VectorInstallMathFunctions  _ANSI_ARGS_((Tcl_HashTable *tablePtr));
void   Rbc_VectorInstallSpecialIndices _ANSI_ARGS_((Tcl_HashTable *tablePtr));
int *  Rbc_VectorSortIndex             _ANSI_ARGS_((VectorObject **vPtrPtr, int nVectors));

#endif /* _RBCVECTOR */
