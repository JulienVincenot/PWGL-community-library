/* $Id: sdif.h,v 1.54 2006/05/03 15:06:23 schwarz Exp $
 *
 * IRCAM SDIF Library (http://www.ircam.fr/sdif)
 *
 * Copyright (C) 1998-2002 by IRCAM-Centre Georges Pompidou, Paris, France.
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * See file COPYING for further informations on licensing terms.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 * For any information regarding this and other IRCAM software, please
 * send email to:
 *                            sdif@ircam.fr
 *
 *
 * This file contains types and declarations that form the 
 * externally visible API of the IRCAM SDIF library (http://www.ircam.fr/sdif).
 *
 *
 * $Log: sdif.h,v $
 * Revision 1.54  2006/05/03 15:06:23  schwarz
 * add SDIF_API (for windows dll)
 * untabify
 *
 * Revision 1.53  2006/05/03 14:33:29  schwarz
 * correct doc and remove function sketch (is now implemented)
 *
 * Revision 1.52  2005/12/05 16:39:40  schwarz
 * export SdifSelectGetIntMask
 *
 * Revision 1.51  2005/05/24 09:32:39  roebel
 * Fixed last checkin comment which turned out to be the start of
 * a c-comment.
 * Synchronized the extended ErrorTagET with the new
 * table of error messages.
 *
 * Revision 1.50  2005/05/23 19:17:52  schwarz
 * - Sdiffread* / Sdiffwrite* functions with SdifFileT instead of FILE *

 *   -> eof error reporting makes more sense
 * - more cleanup of sdif.h, above functions are private in SdifRWLowLevel.h
 * - eEof becomes error 4 to be distinguishable from ascii chars
 * - SdifFScanNameValueLCurrNVT reimplemented for ascii only
 *
 * Revision 1.49  2005/05/23 17:52:52  schwarz
 * Unified error handling:
 * - SdifErrorEnum (global errors) integrated into SdifErrorTagET (file errors)
 * - no more SdifError.[ch], everything done by SdifErrMess.[ch]
 *
 * Revision 1.48  2005/05/20 21:13:54  roebel
 * corrected detection seekablility of sdif file.
 * files are not seekable only if they are pipes!
 *
 * Revision 1.47  2005/05/13 15:35:01  schwarz
 * make it possible that global errors from SdifError be passed through
 * the SdifErrMsg functions as file errors
 *
 * Revision 1.46  2005/04/19 15:30:13  schwarz
 * make sdifcpp compile again for easdif:
 * - removed deleted files from makefiles
 * - fixed some includes that were missing (but only for C++ compilation!?)
 *
 * Revision 1.45  2005/04/07 15:58:52  schwarz
 * removed unused SdifMr stuff
 *
 * Revision 1.44  2004/09/14 15:45:47  schwarz
 * SdifMinMaxT with double
 *
 * Revision 1.43  2004/09/13 13:06:27  schwarz
 * SdifReadSimple even simpler, SdifReadFile for full-scale callback reading.
 * Moving the functionality of querysdif into the library with SdifQuery,
 * result in SdifQueryTreeT.
 *
 * Revision 1.42  2004/09/09 18:02:00  schwarz
 * - Changed SdifMatrixDataT to something sensible that allows to read
 *   and store a whole matrix's data as one block into field CurrMtrxData
 *   of SdifFileT with SdifFReadMatrixData and accessed with the
 *   functions SdifFCurrMatrixData, SdifFCurrMatrixDataPointer, with
 *   automatic reallocation.
 * - SdifReadSimple: simple callback-based reading of an entire SDIF file.
 * - SdifListConcat function
 * - SdifIsAReservedChar return value changed to boolean flag, much clearer.
 * - SdifSelectAppendList function
 * - Removed unimplemented prototypes drafted in sdif/SdifHighLevel.h
 *
 * Revision 1.41  2004/07/22 14:47:55  bogaards
 * removed many global variables, moved some into the thread-safe SdifGlobals structure, added HAVE_PTHREAD define, reorganized the code for selection, made some arguments const, new version 3.8.6
 *
 * Revision 1.40  2004/06/14 15:56:29  schwarz
 * Padding mask, other constants?
 * More doc for sdif_foralltypes macros.
 *
 * Revision 1.39  2004/06/03 11:39:57  schwarz
 * added array swapping and binary signature reading functions.
 *
 * Revision 1.38  2004/01/09 11:29:24  schwarz
 * Removed declaration of SdifFGetFrameType and SdifFGetMatrixType from
 * public API because they are misleading.
 * Use the correct SdifTestFrameType and SdifTestMatrixType instead.
 *
 * Revision 1.37  2003/12/15 13:13:44  schwarz
 * Added SdifFileT based functions SdifFSetPos, SdifFGetPos around the
 * Sdiff* Macros, to be callable from OpenMusic.
 *
 * Revision 1.36  2003/11/18 18:14:01  roebel
 * Added alias for typo in SdifErrorTagE.
 *
 * Revision 1.35  2003/11/07 12:09:07  ellis
 * Added the declaration of of two functions in the header file
 * SdifFAllFrameTypeToSdifString and SdifFAllMatrixTypeToSdifString
 *
 * Revision 1.34  2003/10/14 10:10:18  schwarz
 * SdifMatrixTypeGetColumnName returns pointer to name of column at index.
 *
 * Revision 1.33  2003/08/06 15:08:11  schwarz
 * SdifSelectIntMask added for all integer selections, new functions:
 * - SdifSelectTestIntMask
 * - SdifFNumStreamsSelected, SdifFNumRowsSelected, SdifFNumColumnsSelected
 * - SdifFRowIsSelected, SdifFColumnIsSelected
 * int value/range had to be changed to SdifUInt4 for this
 *
 * SdifCalloc now does what it appears to do: clear memory
 * Finally removed obsolete functions (like SdifSkip...).
 *
 * Revision 1.32  2003/07/21 15:46:47  roebel
 * Removed C++ comment.
 *
 * Revision 1.31  2003/07/07 10:27:01  roebel
 * Added support for eInt1 and eUInt1 data types
 *
 * Revision 1.30  2003/06/06 10:25:40  schwarz
 * Added eReadWriteFile that eventually opens a file in read-write mode.
 *
 * Revision 1.29  2003/05/30 17:42:04  schwarz
 * Added SdifFGetMatrixType and SdifFGetFrameType.
 *
 * Revision 1.28  2003/05/27 16:08:49  schwarz
 * Added SdifFGetMatrixTypesTable and SdifFGetFrameTypesTable.
 * Documented other type access functions.
 *
 * Revision 1.27  2003/05/01 18:48:41  roebel
 * SdifStringToSignature takes now const char * as argument.
 * Added missing declaration for SdifSkipASCIIUntilfromSdifString.
 *
 * Revision 1.26  2003/04/18 17:42:49  schwarz
 * Removed last warning from swig.
 *
 * Revision 1.25  2003/04/18 16:03:09  schwarz
 * Made parseable by swig (no generating macros).
 * Removed double definitions, reordered others.
 *
 * Revision 1.24  2002/11/28 19:56:21  roebel
 * Fixed some const arguments.
 * Make SdifFtruncte return SDIF_FTRUNCATE_NOT_AVAILABLE if
 * this is the case.
 *
 * Revision 1.23  2002/11/27 17:53:24  roebel
 * Improved documentation.
 *
 * Revision 1.22  2002/09/20 14:34:41  schwarz
 * New functions:
 * - SdifParseSignatureList Parse comma-separated list of signatures
 * - SdifKillSelectElement  now public
 *
 * Revision 1.21  2002/09/17 09:51:18  schwarz
 * Added copyright.
 *
 * Revision 1.20  2002/08/28 14:05:31  schwarz
 * New function SdifFRewind.
 * More documentation for positioning functions and truncate.
 *
 * Revision 1.19  2002/08/27 10:51:30  schwarz
 * New file truncate function.
 * Comments for file positioning macros.
 * String append from const char *
 *
 * Revision 1.18  2002/08/13 10:52:56  schwarz
 * Add SdifFReadNextSelectedFrameHeader (from SdifHighLevel.h).
 *
 * Revision 1.17  2002/08/05 14:22:42  roebel
 * Added support to replace a selection.
 *
 * Revision 1.16  2002/06/18 13:56:23  ftissera
 * Move SdifFGetAllTypefromSdifString declaration from SdifFGet.h to sdif.h
 *
 * Revision 1.15  2002/05/24 19:40:43  ftissera
 * Change code to be compatible with C++
 * Add two handlers for error and warning.
 * Create two default handlers and set functions
 *
 * Revision 1.14  2001/07/19 14:24:33  lefevre
 * Macintosh Compilation
 *
 * Revision 1.13  2001/07/12  14:11:48  roebel
 * Added include file holding library version defines to the distribution.
 *
 * Revision 1.12  2001/05/04 18:09:53  schwarz
 * Added function SdifNameValuesLPutCurrNVTTranslate.
 *
 * Revision 1.11  2001/05/04 14:07:28  tisseran
 * Liitle fix:
 * - Change a c++ commentary in a c one (sdif.h line:1532)
 * - Change publihs rules of main Makefile, now name of asrc archive on www.ircam.fr/sdif/download
 * is SDIF-(version)-src.tar.gz
 *
 * Revision 1.10  2001/04/26 14:47:02  tisseran
 * Correct a stupid error in previous log (arrggghh DON'T USE C COMMENTARY in cvs log).
 * Correct Makefile.am, change cvstag rules:
 * cvstags:
 *     cvs -F tags $(CVSTAGS)
 * Add some explication in file ChangeLog
 *
 * Revision 1.9  2001/04/25 11:29:10  tisseran
 * Change sdif_foralltype macro to compile on MacOS X.
 * Old version: sdif_foralltypes sdif__foralltypes(macro,)
 * New version; sdif_foralltypes sdif__foralltypes(macro, empty_definition)
 * with
 * #define empty_definition // empty definition
 *
 * Change AUTHORS to reflect people working on SDIF library
 *
 * Revision 1.8  2000/12/07 13:01:39  roebel
 * Fixed wrong enum datatype declarations for backward compatibility
 *
 * Revision 1.7  2000/11/21 16:34:48  roebel
 * New SdifSignatureConst builds integer signature according to
 * endianess of machine. Multicharacter constants are no longer
 * supported by the library. Cleaned up sdif.h/SdifGlobals.h a bit.
 * Test for Multicharacter conversion is removed from configure.in.
 *
 * Revision 1.6  2000/11/21 14:51:34  schwarz
 * - sdif.h is now included by all sdif/Sdif*.c files.
 * - Removed all public typedefs, enums, structs, and defines from the
 *   individual sdif/Sdif*.h files, because they were duplicated in sdif.h.
 * - Todo: Do the same for the function prototypes, decide which types and
 *   prototypes really need to be exported.
 * - Preliminary new version of SdiffGetPos, SdiffSetPos.  They used the
 *   type fpos_t, which is no longer a long on RedHat 7 Linux.
 *
 * Revision 1.5  2000/11/16 12:20:17  lefevre
 * no message
 *
 * Revision 1.4  2000/11/16  12:02:22  lefevre
 * no message
 *
 * Revision 1.3  2000/11/15  14:53:22  lefevre
 * no message
 *
 * Revision 1.2  2000/10/27  20:03:18  roebel
 * autoconf merged back to main trunk
 *
 * Revision 1.1.2.2  2000/08/21  21:34:52  tisseran
 * *** empty log message ***
 *
 * Revision 1.1.2.1  2000/08/21  17:08:40  tisseran
 * *** empty log message ***
 *
 * Revision 1.1.2.1  2000/08/21  13:07:41  tisseran
 * *** empty log message ***
 *
 * $Date: 2006/05/03 15:06:23 $
 *
 */

#ifndef _SDIF_H
#define _SDIF_H 1

#include "sdif_version.h"

#ifdef __cplusplus
extern "C" {
#endif


static const char _sdif_h_cvs_revision_ [] = "$Id: sdif.h,v 1.54 2006/05/03 15:06:23 schwarz Exp $";


#include <stdio.h>
#include <stdlib.h>
#include <float.h>


#ifdef WIN32
#   define SDIF_API __declspec(dllexport)
#else
#   define SDIF_API extern
#endif


/* SdifHash.h */
typedef enum SdifHashIndexTypeE
{
  eHashChar,
  eHashInt4
} SdifHashIndexTypeET;


typedef union SdifHashIndexU SdifHashIndexUT;

union SdifHashIndexU
{
  char* Char[1]; /* tab of one pointer to fixe union size at 4 or 8 bytes */
  unsigned int  Int4;
} ;


typedef struct SdifHashNS SdifHashNT;
typedef struct SdifFileS SdifFileT;

struct SdifHashNS 
{
  SdifHashNT *Next;
  SdifHashIndexUT Index;
  void* Data;
};


typedef struct SdifHashTableS SdifHashTableT;

struct SdifHashTableS
{
  SdifHashNT* *Table;
  unsigned int HashSize;
  SdifHashIndexTypeET IndexType;
  void (*Killer)(void *); 
  unsigned int NbOfData;
} ;




/*
//FUNCTION GROUP: File positioning
*/

/* SdifFile.c */

/*DOC:
  Rewind to start of file (before header!) 
  [return] 1 on success, 0 on error
*/
SDIF_API int SdifFRewind(SdifFileT *file);


#define SDIFFTRUNCATE_NOT_AVAILABLE -2
/*DOC:
  Truncate file at current position
  This function is only available on certain systems that have the
  ftruncate function in their system libraries. 
  [return] 1 on success, 0 for error (check errno),  
        MACRO SDIFFTRUNCATE_NOT_AVAILABLE if function is not available.
*/
SDIF_API int SdifFTruncate(SdifFileT *file);



/* Give documentation and fake prototype for positioning macros.
   Cocoon ignores the #if 0.
*/
#if 0

/*DOC:
  Get position in file.
  [return] file offset or -1 for error.
  SdiffPosT is actually long.
 */
int SdiffGetPos(SdifFileT *file, SdiffPosT *pos);

/*DOC:
  Set absolute position in file.
  SdiffPosT is actually long.
  [Return] 0 on success, 
          -1 on error (errno is set, see fseek(3) for details)

  On Mac or Windows, seeking on a stream is always considered
  successful (return 0), even if no seek was done!
 */
int SdiffSetPos(SdifFileT *file, SdiffPosT *pos);

#endif  /* if 0 */


/* to do fpos_t compatible on MacinTosh */
#if defined(MACINTOSH) || defined(WIN32)
    /* on mac or windows, seeking on a stream is always considered
       successful (return 0)! */
#   define SdiffPosT            long
#   define SdiffIsFile(f)       ((f)!=stdin && (f)!=stdout && (f)!=stderr)
#   define Sdiffftell(f)        (SdiffIsFile(f)  ?  ftell(f)  :  0)
#   define SdiffGetPos(f,p)     ((*(p) = Sdiffftell(f)) == -1  ?  -1  :  0)
#   define SdiffSetPos(f,p)     (SdiffIsFile(f)  \
                                    ?  fseek(f, (long)(*(p)), SEEK_SET)  :  0)
#else
/*
#   define SdiffPosT            fpos_t
#   define SdiffGetPos(f,p)     fgetpos((f),(p))
#   define SdiffSetPos(f,p)     fsetpos((f),(p))

#   define SdiffGetPos(f,p)     ((*(p) = ftell(f)) == -1  ?  -1  :  0)
#   define SdiffSetPos(f,p)     (fseek(f, (long)(*(p)), SEEK_SET))
*/

/*DS: FORCE long fpos*/
/* ftell/fseek can be applied to stdin/out/err at least in a restricted manner
 * (same as fgetpos/fsetpos) so let's try */
#   define SdiffPosT            long
#   define SdiffGetPos(f,p)     ((*(p) = ftell(f)) == -1  ?  -1  :  0)
#   define SdiffSetPos(f,p)     (fseek(f, (long)(*(p)), SEEK_SET))
#endif



/*DOC:
  Get position in file.
  [return] file offset or -1 for error.
  SdiffPosT is actually long.
 */
SDIF_API int SdifFGetPos(SdifFileT *file, SdiffPosT *pos);

/*DOC:
  Set absolute position in file.
  SdiffPosT is actually long.
  [Return] 0 on success, 
          -1 on error (errno is set, see fseek(3) for details)

  On Mac or Windows, seeking on a stream is always considered
  successful (return 0), even if no seek was done!
 */
SDIF_API int SdifFSetPos(SdifFileT *file, SdiffPosT *pos);




/* SdifHard_OS.h */

typedef char           SdifChar;
typedef char           SdifInt1;
typedef short          SdifInt2;
typedef unsigned char  SdifUInt1;
typedef unsigned short SdifUInt2;
typedef int            SdifInt4;
typedef unsigned int   SdifUInt4;
typedef float          SdifFloat4;
typedef double         SdifFloat8;
typedef unsigned int   SdifSignature;


typedef enum SdifMachineE
{
  eUndefinedMachine,
  eBigEndian,
  eLittleEndian,
  eBigEndian64,
  eLittleEndian64,
  ePDPEndian
} SdifMachineET;

typedef enum SdifBinaryMode
{
  eBinaryModeUnknown,
  eBinaryModeWrite,
  eBinaryModeRead,
  eBinaryModeReadWrite,
  eBinaryModeStdInput,
  eBinaryModeStdOutput,
  eBinaryModeStdError
} SdifBinaryModeET ;

/* SdifGlobals.h */
/* DOC:

  Macro to generate an integer representation of the sequence of unsigned chars 
  for example :

  SdifSignature sig=SdifSignatureConst('A','B','C','D');

  Because integers are differently handled on little/big endian machines the
  signatures are swapped if read from a file to match internal format. */
  
#   define SdifSignatureConst(p1,p2,p3,p4) (((((unsigned int)(p1))&0xff)<<24)|((((unsigned int)(p2))&0xff)<<16)|((((unsigned int)(p3))&0xff)<<8)|(((unsigned int)(p4))&0xff))


#ifndef SWIG
typedef enum SdifSignatureE
{
  eSDIF = SdifSignatureConst('S','D','I','F'), /* SDIF header */
  e1NVT = SdifSignatureConst('1','N','V','T'), /* Name Value Table */
  e1TYP = SdifSignatureConst('1','T','Y','P'), /* TYPe declarations */
  e1MTD = SdifSignatureConst('1','M','T','D'), /* Matrix Type Declaration */
  e1FTD = SdifSignatureConst('1','F','T','D'), /* Frame Type Declaration */
  e1IDS = SdifSignatureConst('1','I','D','S'), /* ID Stream Table */
  eSDFC = SdifSignatureConst('S','D','F','C'), /* Start Data Frame Chunk (text files) */
  eENDC = SdifSignatureConst('E','N','D','C'), /* END Chunk (text files) */
  eENDF = SdifSignatureConst('E','N','D','F'), /* END File (text files) */
  eFORM = SdifSignatureConst('F','O','R','M'), /* FORM for IFF compatibility (obsolete ?) */
  eEmptySignature = SdifSignatureConst('\0','\0','\0','\0')
} SdifSignatureET;
#endif

typedef enum SdifModifModeE
{
  eNoModif,
  eCanModif
} SdifModifModeET;


/* DataTypeEnum

   On Matt Wright's visit at IRCAM June 1999, we defined a new
   encoding for the MatrixDataType field with the feature that the low
   order byte encodes the number of bytes taken by each matrix
   element.  

   Low order byte encodes the number of bytes 
   High order bytes come from this (extensible) enum:

        0 : Float
        1 : Signed integer
        2 : Unsigned integer
        3 : Text (UTF-8 when 1 byte)
        4 : arbitrary/void
*/
typedef enum SdifDataTypeE
{
  eText     = 0x0301,
  eChar     = 0x0301,
  eFloat4   = 0x0004,
  eFloat8   = 0x0008,
  eInt1     = 0x0101,
  eInt2     = 0x0102,
  eInt4     = 0x0104,
  eInt8     = 0x0108,
  eUInt1    = 0x0201,
  eUInt2    = 0x0202,
  eUInt4    = 0x0204,
  eUInt8    = 0x0208,
            
  eFloat4a  = 0x0001,   /* =  1 */    /* Backwards compatibility with old */
  eFloat4b  = 0x0020,   /* = 32 */    /* IRCAM versions < 3 of SDIF */
  eFloat8a  = 0x0002,   /* =  2 */    /* IN TEXT MODE ONLY! */
  eFloat8b  = 0x0040    /* = 64 */
} SdifDataTypeET;

/* SdifList.h */
typedef void (*KillerFT) (void *);

typedef struct SdifListNS SdifListNT;

struct SdifListNS 
{
  SdifListNT *Next;
  void* Data;
};


typedef struct SdifListNStockS SdifListNStockT;

struct SdifListNStockS
{
    SdifListNT*  StockList; /* list of arrays of nodes, the first node is used to chain arrays */
    unsigned int SizeOfOneStock; /* must be > 1 */
    unsigned int NbStock;

    unsigned int NbNodesUsedInCurrStock;

    SdifListNT* Trash; /* to recycle nodes */
};


/* lists management */

typedef struct SdifListS SdifListT;
typedef SdifListT       *SdifListP;

struct SdifListS
{
  /* fifo list */
  SdifListNT *Head;
  SdifListNT *Tail;
  SdifListNT *Curr;  /* pointer before the next */
  void (*Killer)(void *);  
  unsigned int NbData;
} ;

/* SdifNameValue.h */
typedef struct SdifNameValueS SdifNameValueT;
struct SdifNameValueS
{
  char *Name;
  char *Value;
} ;

typedef struct SdifNameValueTableS SdifNameValueTableT;
struct SdifNameValueTableS
{
    SdifHashTableT* NVHT;
    SdifUInt4       NumTable;
    SdifUInt4       StreamID;   /* id of stream the table belongs to */
} ;

typedef struct SdifNameValuesLS SdifNameValuesLT;
struct SdifNameValuesLS
{
    SdifListT*              NVTList;
    SdifNameValueTableT*    CurrNVT;
    SdifUInt4               HashSize;
};


/* SdifStreamID.h */

/*
// DATA GROUP:          Stream ID Table and Entries for 1IDS ASCII chunk
*/


/*DOC:
  Stream ID Table Entry */
typedef struct SdifStreamIDS SdifStreamIDT;
struct SdifStreamIDS
{
  SdifUInt4     NumID;
  char *Source;
  char *TreeWay; /* for the moment or to be general*/
} ;

/*DOC:
  Stream ID Table, holds SdifStreamIDT stream ID table entries */
typedef struct SdifStreamIDTableS SdifStreamIDTableT;
struct SdifStreamIDTableS
{
    SdifHashTableT* SIDHT;
    SdifUInt4       StreamID;
    SdifFloat8      Time;       /* always _SdifNoTime */
} ;


typedef struct SdifColumnDefS SdifColumnDefT;

struct SdifColumnDefS
{
  char *Name;
  SdifUInt4 Num;
} ;


/* SdifMatrixType.h */
typedef struct SdifMatrixTypeS SdifMatrixTypeT;

struct SdifMatrixTypeS
{
  SdifSignature     Signature;

  SdifMatrixTypeT*  MatrixTypePre;

  SdifListT*        ColumnUserList; /* List of columns added by user: 
                                       SdifMatrixTypeInsertTailColumn(MatrixTypeT *)
                                    */

  SdifUInt4       NbColumnDef; /* Number of columns created by user:
                                  SdifMatrixTypeInsertTailColumn(MatrixTypeT *)
                               */
  SdifModifModeET ModifMode;
};


/* SdifFrameType.h */
typedef struct SdifComponentS SdifComponentT;
struct SdifComponentS
{
  SdifSignature MtrxS;
  char *Name;
  SdifUInt4  Num;
} ;

typedef struct SdifFrameTypeS SdifFrameTypeT;
struct SdifFrameTypeS
{
  SdifSignature Signature;

  SdifFrameTypeT* FrameTypePre;

  SdifHashTableT *ComponentUseHT;
  SdifUInt4       NbComponentUse;

  SdifUInt4       NbComponent;
  SdifModifModeET ModifMode;
};


/* SdifMatrix.h */
typedef struct SdifMatrixHeaderS SdifMatrixHeaderT;

struct SdifMatrixHeaderS
{
  SdifSignature  Signature;
  SdifDataTypeET DataType; /* Low level data type */
  SdifUInt4      NbRow;
  SdifUInt4      NbCol;
} ;


typedef union DataTypeU DataTypeUT;

union DataTypeU
{
  SdifFloat4 *Float4;
  SdifFloat8 *Float8;
  SdifInt1   *Int1  ;
  SdifInt2   *Int2  ;
  SdifInt4   *Int4  ;
/*SdifInt8   *Int8  ;*/
  SdifUInt1  *UInt1 ;
  SdifUInt2  *UInt2 ;
  SdifUInt4  *UInt4 ;
/*SdifUInt8  *UInt8 ;*/
  SdifChar   *Char  ;
  void       *Void  ;   /* generic pointer */
} ;


typedef struct SdifOneRowS SdifOneRowT;

struct SdifOneRowS
{
  SdifDataTypeET DataType;
  SdifUInt4      NbData;
  DataTypeUT     Data;
  SdifUInt4      NbGranuleAlloc;
} ;

typedef struct SdifMatrixDataS SdifMatrixDataT;
struct SdifMatrixDataS
{
  SdifMatrixHeaderT *Header;
  int               ForeignHeader;  /* Header was not allocated by me */
  SdifUInt4         Size;       /* byte size of matrix on file */
  DataTypeUT        Data;       /* any type pointer to data */
  SdifUInt4         AllocSize;  /* allocated size of data in bytes */
};

/* SdifFrame.h */
typedef struct SdifFrameHeaderS SdifFrameHeaderT;
struct SdifFrameHeaderS
{
  SdifSignature Signature;
  SdifUInt4  Size;
  SdifUInt4  NbMatrix;
  SdifUInt4  NumID;
  SdifFloat8 Time;
} ;


typedef struct SdifFrameDataS SdifFrameDataT;
struct SdifFrameDataS
{
  SdifFrameHeaderT *Header;
  SdifMatrixDataT* *Matrix_s;
} ;



/* SdifTimePosition.h */
typedef struct SdifTimePositionS SdifTimePositionT;

struct SdifTimePositionS
{
  SdifFloat8    Time;
  SdiffPosT     Position;
};


typedef struct SdifTimePositionLS SdifTimePositionLT;

struct SdifTimePositionLS
{
    SdifListT*          TimePosList;
};


SdifTimePositionT* SdifCreateTimePosition(SdifFloat8 Time, SdiffPosT Position);
void               SdifKillTimePosition(void* TimePosition);

SdifTimePositionLT* SdifCreateTimePositionL(void);
void                SdifKillTimePositionL  (SdifTimePositionLT *TimePositionL);

SdifTimePositionLT* SdifTimePositionLPutTail(SdifTimePositionLT* TimePositionL,
                                             SdifFloat8 Time, SdiffPosT Position);
SdifTimePositionT*  SdifTimePositionLGetTail(SdifTimePositionLT* TimePositionL);



/* SdifSignatureTab.h */
typedef struct SdifSignatureTabS SdifSignatureTabT;
struct SdifSignatureTabS
{
  SdifUInt4 NbSignMax;
  SdifUInt4 NbSign;
  SdifSignature* Tab;
};


/* SdifSelect.h */

/* 
// DATA GROUP:  SDIF Selection
*/

/* tokens (numerical ids) for sdifspec separators */
typedef enum { sst_specsep, sst_stream, sst_frame, sst_matrix, sst_column, 
               sst_row,     sst_time,   sst_list,  sst_range,  sst_delta,
               sst_num  /* number of tokens */,    sst_norange = 0
} SdifSelectTokens;

/*DOC: 
  Selection element interface (returned by SdifGetNextSelection*):
  One basic data element value, with optional range.  
  The meaning of range is determined by rangetype: 

  [] 0          no range
  [] sst_range  range is value..range
  [] sst_delta  range is value-range..value+range
*/

typedef struct 
{
    SdifUInt4          value, range;
    SdifSelectTokens   rangetype; /* 0 for not present, sst_range, sst_delta */
} SdifSelectElementIntT;

typedef struct 
{
    double             value, range;
    SdifSelectTokens   rangetype; /* 0 for not present, sst_range, sst_delta */
} SdifSelectElementRealT;

/* no SdifSelectElementSignatureT or string range, since it makes no sense */



/*DOC:
  Internal: one value of different possible types in a selection
  element (the element list determines which type is actually used).  
*/
typedef union SdifSelectValueS 
{
    SdifUInt4      integer;
    double         real;
    char           *string;
    SdifSignature  signature;
} SdifSelectValueT;

/*DOC: 
  Selection element internal data structure:
  One basic data element, with optional <ul>
  <li> range (value is lower, range is upper bound) or 
  <li> delta (value-range is lower, value+range is upper bound)
  </ul>
*/
typedef struct SdifSelectElementS
{
    SdifSelectValueT value;
    SdifSelectValueT range;
    SdifSelectTokens rangetype; /* 0 for not present, sst_range, sst_delta */
} SdifSelectElementT, *SdifSelectElementP;

typedef struct SdifSelectIntMaskS
{
    SdifUInt4   num;            /* number of ints selected */
    SdifUInt4   max;            /* max given int, #elems in mask */
    int        *mask;           /* selection bit mask */
    int         openend;        /* are elems > max included? */
} SdifSelectIntMaskT, *SdifSelectIntMaskP;

/*DOC: 
  Holds a selection of what data to access in an SDIF file,
  parsed from a simple regular expression.  
*/
typedef struct
{
    char        *filename,      /* allocated / freed by 
                                   SdifInitSelection / SdifFreeSelection */
                *basename;      /* points into filename */
    SdifListP   stream, frame, matrix, column, row, time;

    SdifSelectIntMaskT streammask;
    SdifSelectIntMaskT rowmask;
    SdifSelectIntMaskT colmask;
} SdifSelectionT;

/* TODO: array of select elements
     struct { 
        SdifListP list; 
        SdifSelectElementT minmax; 
        SdifSelectIntMaskP mask;
     } elem [eSelNum];
     indexed by
     enum   { eTime, eStream, eFrame, eMatrix, eColumn, eRow, eSelNum }
   to use in all API functions instead of SdifListP.
*/



/* SdifErrMess.h */
typedef enum SdifErrorTagE
{
    eFalse   = 0,
    eUnknown = 0,
    eTrue    = 1,
    eNoError = 1,
    eTypeDataNotSupported,
    eNameLength,
    eEof,       /* 4 */
    eReDefined,
    eUnDefined,
    eSyntax,
    eBadTypesFile,
    eBadType,
    eBadHeader,
    eRecursiveDetect,
    eUnInterpreted,
    eOnlyOneChunkOf,
    eUserDefInFileYet,
    eBadMode,
    eBadStdFile,
    eReadWriteOnSameFile,
    eBadFormatVersion,
    eMtrxUsedYet,
    eMtrxNotInFrame,
/* from here on global errors that don't always have an SdifFileT attached */
    eGlobalError,
    eFreeNull = eGlobalError,
    eAllocFail,
    eArrayPosition,
    eFileNotFound,
    eInvalidPreType,
    eAffectationOrder,
    eNoModifErr,
    eNotInDataTypeUnion,
    eNotFound,
    eExistYet,
    eWordCut,
    eTokenLength
} SdifErrorTagET;


/*DOC:
  Level of Error */
typedef enum SdifErrorLevelE
{
        eFatal,
        eError,
        eWarning,
        eRemark,
        eNoLevel,
        eNumLevels      /* level count, must always be last */
} SdifErrorLevelET;


typedef struct SdifErrorS SdifErrorT;
struct SdifErrorS
{
        SdifErrorTagET          Tag;
        SdifErrorLevelET        Level;
        char*                   UserMess;
};

typedef struct SdifErrorLS SdifErrorLT;
struct SdifErrorLS
{
  SdifListT*    ErrorList;
  SdifFileT*    SdifF; /* only a link */
};



/*DOC:
  Exit function type (See SdifSetExitFunc). */
typedef void (*SdifExitFuncT) (void);

/*DOC:
 Exception function type (See SdifSetErrorFunc and SdifSetWarningFunc). */
typedef void (*SdifExceptionFuncT) (SdifErrorTagET   error_tag, 
                                    SdifErrorLevelET error_level, 
                                    char *error_message, 
                                    SdifFileT *error_file, 
                                    SdifErrorT *error_ptr, 
                                    char *source_file, int source_line);



/* SdifFileStruct.h */

/*
// DATA GROUP:  SDIF File Structure
*/

/*DOC:
  File mode argument for SdifFOpen. */
typedef enum SdifFileModeE
{
  eUnknownFileMode,     /* 0 */
  eWriteFile,
  eReadFile,
  eReadWriteFile,
  ePredefinedTypes,     /* 4 */

  eModeMask = 7,        /* get rid of flags */

  /* from here on we have flags that can be or'ed with the previous modes */
  eParseSelection = 8
} SdifFileModeET ;



enum SdifPassE
{
  eNotPass,
  eReadPass,
  eWritePass
};


/*
// DATA GROUP:          SDIF File Structure
*/

#define MaxUserData     10
/*DOC:
  THE SDIF File Structure! */
struct SdifFileS
{
  char               *Name;             /* Name of the file, can be "stdin, stdout, stderr */
  SdifFileModeET     Mode;              /* eWriteFile or eReadFile or ePredefinedTypes */
  int                isSeekable;        /* file is not pipe i/o */

  SdifUInt4          FormatVersion;     /* version of the SDIF format itself */
  SdifUInt4          TypesVersion;      /* version of the description type collection */

  SdifNameValuesLT   *NameValues;       /* DataBase of Names Values */
  SdifHashTableT     *MatrixTypesTable; /* DataBase of Matrix Types */
  SdifHashTableT     *FrameTypesTable;  /* DataBase of Frame Types */
/*  SdifHashTableT     *StreamIDsTable;    DataBase of Stream IDs */
  SdifStreamIDTableT *StreamIDsTable;   /* DataBase of Stream IDs */
  SdifTimePositionLT *TimePositions;    /* List of (Time, Position in file) */
  SdifSelectionT     *Selection;        /* default selection parsed from Name */

  FILE *Stream;                         /* Stream to read or to write */

  SdifSignature      CurrSignature;
  SdifFrameHeaderT   *CurrFramH;        /* Current Frame Header can be NULL */
  SdifMatrixHeaderT  *CurrMtrxH;        /* Current Matrix Header can be NULL */

  SdifFrameTypeT     *CurrFramT;
  SdifMatrixTypeT    *CurrMtrxT;
  SdifFloat8         PrevTime;
  SdifSignatureTabT  *MtrxUsed;

  SdifOneRowT        *CurrOneRow;
  /* Current OneRow allocated memory in function
   * of _SdifGranule, use SdifReInitOneRow(SdifOneRowT *OneRow, SdifDataTypeET DataType, SdifUInt4 NbData)
   * to assure NbData (=NbColumns) objects memory allocated
   */

  /* data pointer used by SdifFReadMatrixData, never uses the Header field */
  SdifMatrixDataT    *CurrMtrxData;

  size_t  FileSize;
  size_t  ChunkSize;

  SdiffPosT  CurrFramPos;
  SdiffPosT  StartChunkPos;
  SdiffPosT  Pos;
  
  SdifUInt2  TypeDefPass;
  SdifUInt2  StreamIDPass;

  char *TextStreamName;                 /* Name of the text file corresponding to the sdif file */
  FILE *TextStream;                     /* Stream text */

  SdifUInt4     ErrorCount [eNumLevels];/* Error count per level of severity */
  SdifErrorLT  *Errors;                 /* List of errors or warnings */

  int           NbUserData;             /* todo: hash table */
  void          *UserData [MaxUserData];
};      /* end struct SdifFileS */







/* SdifString.h */

typedef struct SdifStringS SdifStringT;
struct SdifStringS
{
  char   *str; 
  size_t TotalSize; /* Memory size allocated for str */
  size_t SizeW; /* Memory size actually used */
  int    NbCharRead; /* Number of char read */
};


/*DOC: 
  Test if file is an SDIF file.

  [] Returns:   0 if not an SDIF file (the first 4 chars are not "SDIF"),
                or file can not be opened, else 1.  

  Warning: This function doesn't work with stdio. */
SDIF_API int SdifCheckFileFormat (const char *name);


/*DOC: 
  Test if file contains frames of certain types.

  [in]  name    Filename + selection
        frames  Table of frame signatures to look for
  []    return  The first signature from frames found, or eEmptySignature if 
                no frames could be found (or if file is not SDIF).

  Warning: This function doesn't work with stdio. */
SDIF_API SdifSignature SdifCheckFileFramesTab (const char              *name, 
                                               const SdifSignatureTabT *frames);

/*DOC: 
  Test if file contains frames of certain types.

  [in]  name    Filename + selection
        frames  Array of frame signatures to look for, terminated with 
                eEmptySignature.
  []    return  The index in frames of the first signature found, or -1
                if no frames could be found (or if file is not SDIF).

  Warning: This function doesn't work with stdio. */
SDIF_API int  SdifCheckFileFramesIndex (const char              *name, 
                                        const SdifSignature     *frames);

/*DOC: 
  Test if file contains frames of certain types.

  [in]  in      open SDIF file
        frames  Table of frame signatures to look for
  [out] index   If the int pointer index is not NULL, it will receive
                the index in frames of the first signature found, or -1
                if no frames could be found (or if file is not SDIF).
  []    return  The first signature from frames found, or eEmptySignature if 
                no frames could be found (or if file is not SDIF).

  Warning: This function doesn't work with stdio. */
SDIF_API SdifSignature SdifCheckNextFrame (SdifFileT               *in, 
                                           const SdifSignatureTabT *frames,
                                           int                     *index);

/*DOC: 
  TODO: Test if file is an SDIF file (only when opening for read or
  append) and open it.

  [Return] NULL if not an SDIF file (the first 4 chars are not "SDIF"),
  or file can not be opened.  */
SDIF_API SdifFileT* SdifFTryOpen (const char *Name, SdifFileModeET Mode);


/*DOC: 
  Converti un fichier texte pseudo-SDIF de nom TextStreamName en un
  fichier SDIF binaire de non SdifF->Name. Le fichier doit avoir �t�
  ouvert en �criture (eWriteFile).  */
size_t SdifToText (SdifFileT *SdifF, char *TextStreamName);


/*#include "SdifFile.h"
 */


/*DOC:
  Switch output of error messages on stderr by _SdifFError on. 
*/
SDIF_API void   SdifEnableErrorOutput  (void);

/*DOC:
  Switch output of error messages on stderr by _SdifFError off. 
*/
SDIF_API void   SdifDisableErrorOutput (void);


/* global variables to control error output */
extern int              gSdifErrorOutputEnabled;
extern char            *SdifErrorFile;
extern int              SdifErrorLine;
extern FILE            *SdifStdErr;



/*DOC: 
  Lit 4 bytes, les consid�re comme une signature qui est plac�e dans
  SdifF->CurrSignature, incr�mente NbCharRead du nombre de bytes lus
  et renvoie le dernier caract�re lu convert en int (-1 si erreur).  */
SDIF_API int    SdifFGetSignature       (SdifFileT *SdifF, size_t *NbCharRead);


/*DOC: 
  Lit l'ent�te du fichier, c'est � dire 'SDIF' puis 4 bytes.  affiche
  un message en cas de non reconnaissance du format.  */
SDIF_API size_t SdifFReadGeneralHeader    (SdifFileT *SdifF);

SDIF_API size_t SdifFReadAllASCIIChunks   (SdifFileT *SdifF);

/*DOC: 
  Cette fonction lit une ent�te de matrice <strong>signature
  incluse</strong>.  Elle v�rifie le type de matrice, le champ
  DataType. Toute les donn�es se trouvent stock�es dans
  SdifF->CurrMtrxH. La plupart de ses champs sont directement
  accessible par les fonctions ind�pendantes du mode d'ouverture du
  fichier.  <strong>Elle effectue une mise � jour de l'allocation
  m�moire de SdifF->CurrOneRow en fonction des param�tres de l'ent�te
  de matrice.</strong> Ainsi, on est normalement pr�s pour lire chaque
  ligne de la matrice courrante.  

  @return       number of bytes read or 0 if error 
*/
SDIF_API size_t SdifFReadMatrixHeader     (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de lire 1 ligne de matrice. Les donn�es lues
  sont stock�es dans SdifF->CurrOneRow (jusqu'� une prochaine lecture
  d'ent�te de matrice qui r�initialise ses param�tres).  */
size_t SdifFReadOneRow           (SdifFileT *SdifF);

/*DOC:
  skip one matrix row, when reading row by row with SdifFReadOneRow */
size_t SdifFSkipOneRow(SdifFileT *SdifF);


/*DOC: 
  Cette fonction lit l'ent�te d'un frame � partir de la taille et
  jusqu'au temps. Donc <strong>elle ne lit pas la signature</strong>
  mais donne � SdifF->CurrFramH->Signature la valeur de
  SdifF->CurrSignature.  La lecture doit se faire avant, avec
  SdifFGetSignature.  */
SDIF_API size_t SdifFReadFrameHeader      (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de passer une matrice toute enti�re ent�te
  incluse. Elle est utile lorsque qu'un frame contient plus de
  matrices que le programme lecteur n'en conna�t. Il peut ainsi les
  passer pour retomber sur un autre frame.  */
SDIF_API size_t SdifFSkipMatrix          (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de passer une matrice mais apr�s la lecture de
  l'ent�te. On s'en sert lorsque le type de matrice est mauvais,
  inconnu, non interpr�table par le programme lecteur.

  Note:  The matrix padding is skipped also. */
SDIF_API size_t SdifFSkipMatrixData       (SdifFileT *SdifF);

/*DOC: 
  Cette fonction � le m�me sens que SdifSkipMatrixData mais pour les
  frames. Il faut donc pour l'utiliser avoir au pr�alable lu la
  signature et l'ent�te.  */
SDIF_API size_t SdifFSkipFrameData        (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de lire le Padding en fin de matrice.
  l'utilisation classique de cette fonctin est:<br> 
  <code> SizeR =  SdifFReadPadding(SdifF, SdifFPaddingCalculate(SdifF->Stream, SizeR));</code><br> 
  o� SizeR est la taille en bytes lue depuis le
  d�but de la matrice, c'est � dire NbRow*NbCol*DataWith. En r�alit�,
  pour que SdifFPaddingCalculate fonctionne, il est seulement
  n�cessaire que SizeR soit le nombre de bytes qui s'�pare la position
  actuelle dans le fichier et un byte, rep�re d'allignement sur 64
  bits.  */
size_t SdifFReadPadding          (SdifFileT *SdifF, size_t Padding);


/* skip given number of bytes, either by seeking or by reading bytes */
size_t SdifFSkip (SdifFileT *SdifF, size_t bytes);


/*DOC:
  Read and throw away <i>num</i> bytes from the file. */
size_t SdifFReadAndIgnore (SdifFileT *SdifF, size_t bytes);


/*DOC: 
  �crit sur le fichier 'SDIF' puis 4 bytes chunk size.  */
SDIF_API size_t  SdifFWriteGeneralHeader   (SdifFileT *SdifF);

/*DOC: 
  �crit tous les chunks ASCII. C'est � dire: les tables de names
  values, les types cr��s ou compl�t�s, et les Stream ID. Il faut donc
  au pr�alable avoir rempli compl�tement les tables avant de la
  lancer. Cette fonction de peut donc pas �tre executer une 2nd fois
  durant une �criture.  */
SDIF_API size_t  SdifFWriteAllASCIIChunks  (SdifFileT *SdifF);


/*
//FUNCTION GROUP:       Writing Matrices
*/

/*DOC: 
  Apr�s avoir donner une valeur � chaque champ de SdifF->CurrMtrxH
  gr�ce � la fonction SdifFSetCurrMatrixHeader, SdifFWriteMatrixHeader
  �crit toute l'ent�te de la matrice.  Cette fonction r�alise aussi
  une mise � jour de SdifF->CurrOneRow, tant au niveau de l'allocation
  m�moire que du type de donn�es.  */
SDIF_API size_t  SdifFWriteMatrixHeader    (SdifFileT *SdifF);

/*DOC: 
  Apr�s avoir donner les valeurs � chaque case de SdifF->CurrOneRow �
  l'aide de SdifFSetCurrOneRow ou de SdifFSetCurrOneRowCol (suivant
  que l'on poss�de d�j� un tableau flottant ou respectivement une
  m�thode pour retrouver une valeur de colonne), SdifFWriteOneRow
  �crit 1 ligne de matrice suivant les param�tres de SdifF->CurrMtrxH.  */
size_t  SdifFWriteOneRow          (SdifFileT *SdifF);

/*DOC: 
  Write whole matrix data, (after having set the matrix header with 
  SdifFSetCurrMatrixHeader (file, matrixsig, datatype, nrow, ncol).
  Data points to nbrow * nbcol * SdifSizeofDataType (datatype) bytes in 
  row-major order.  Padding still has to be written.  */
SDIF_API size_t SdifFWriteMatrixData (SdifFileT *SdifF, void *Data);

/*DOC:
  Write whole matrix: header, data, and padding.
  Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
  row-major order. */
SDIF_API size_t SdifFWriteMatrix (SdifFileT     *SdifF,
                                  SdifSignature  Signature,
                                  SdifDataTypeET DataType,
                                  SdifUInt4      NbRow,
                                  SdifUInt4      NbCol,
                                  void          *Data);

/*DOC:
  Write a matrix with datatype text (header, data, and padding).
  Data points to Length bytes(!) of UTF-8 encoded text.  Length
  includes the terminating '\0' character!!!  That is, to write a
  C-String, use SdifFWriteTextMatrix (f, sig, strlen (str) + 1, str);
  to include it. */
SDIF_API size_t SdifFWriteTextMatrix (SdifFileT     *SdifF,
                             SdifSignature  Signature,
                             SdifUInt4      Length,
                             char          *Data);

/*DOC: 
  TBI: Convert ASCII C-String to UTF-8 encoded string, returning
  length (including terminating null character). */
size_t SdifAsciiToUTF8 (char *ascii_in, char *utf8_out);

/*DOC: 
  Cette fonction permet en fin d'�criture de matrice d'ajouter le
  Padding n�cessaire. Il faut cependant avoir la taille de ce
  Padding. On utilise SdifFPaddingCalculate(SdifF->Stream,
  SizeSinceAlignement) o� SizeSinceAllignement est un
  <code>size_t</code> d�signant le nombre de bytes qui s�pare la
  position actuelle d'�criture avec une position connue o� le fichier
  est align� sur 64 bits (en g�n�ral, c'est la taille de la matrice en
  cours d'�criture: NbRow*NbCol*DatWitdh).  */
size_t  SdifFWritePadding         (SdifFileT *SdifF, size_t Padding);


/*
//FUNCTION GROUP:       Writing Frames
*/

/*DOC: 
  Apr�s avoir donner une valueur � chaque champ de SdifF->CurrFramH
  gr�ce � la fonction SdifFSetCurrFrameHeader, SdifFWriteFrameHeader
  �crit toute l'ent�te de frame.  Lorsque la taille est inconnue au
  moment de l'�criture, donner la valeur _SdifUnknownSize. Ensuite,
  compter le nombre de bytes �crit dans le frame et r�aliser un
  SdifUpdateChunkSize avec la taille calcul�e.  */
SDIF_API size_t  SdifFWriteFrameHeader     (SdifFileT *SdifF);

/*DOC: 
  Execute un retour fichier de ChunkSize bytes et l'�crit, donc on
  �crase la taille du chunk ou du frame.  Dans le cas o� le fichier
  est stderr ou stdout, l'action n'est pas r�alis�e.  */
void    SdifUpdateChunkSize       (SdifFileT *SdifF, size_t ChunkSize);

/*DOC: 
  Rewrite given frame size and number of matrices in frame header.
  Return -1 on error or if file is not seekable (stdout or stderr). */
int     SdifUpdateFrameHeader     (SdifFileT *SdifF, size_t ChunkSize, 
                                   SdifInt4 NumMatrix);

/*DOC:
  Write a whole frame containing one matrix: 
  frame header, matrix header, matrix data, and padding.
  Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
  row-major order. 

  This function has the big advantage that the frame size is known in
  advance, so there's no need to rewind and update after the matrix
  has been written.  */
SDIF_API size_t SdifFWriteFrameAndOneMatrix (SdifFileT     *SdifF,
                                             SdifSignature  FrameSignature,
                                             SdifUInt4      NumID,
                                             SdifFloat8     Time,
                                             SdifSignature  MatrixSignature,
                                             SdifDataTypeET DataType,
                                             SdifUInt4      NbRow,
                                             SdifUInt4      NbCol,
                                             void          *Data);


/*DOC:
  Return (constant) size of frame header after signature and size field. 
  Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
SDIF_API size_t SdifSizeOfFrameHeader (void);

/*DOC:
  Return size of matrix (header, data, padding).
  Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
SDIF_API size_t SdifSizeOfMatrix (SdifDataTypeET DataType,
                                  SdifUInt4      NbRow,
                                  SdifUInt4      NbCol);

/*DOC:
  Write a text matrix using a string.
  Return number of bytes written.
*/
SDIF_API size_t SdifFWriteTextFrame(SdifFileT     *SdifF,
                                    SdifSignature FrameSignature,
                                    SdifUInt4     NumID,
                                    SdifFloat8    Time,
                                    SdifSignature MatrixSignature,
                                    char          *str,
                                    size_t        length);

/*DOC:
  Write a text matrix using a SdifString.
  Return number of bytes written.
*/
SDIF_API size_t SdifFWriteTextFrameSdifString(SdifFileT     *SdifF,
                                              SdifSignature FrameSignature,
                                              SdifUInt4     NumID,
                                              SdifFloat8    Time,
                                              SdifSignature MatrixSignature,
                                              SdifStringT   *SdifString);


/*
// FUNCTION GROUP:      Opening and Closing of Files
*/

/*DOC:
 */
SDIF_API SdifFileT* SdifFOpen                   (const char *Name, SdifFileModeET Mode);

SdifFileT*         SdifFOpenText                (SdifFileT *SdifF, const char* Name, SdifFileModeET Mode);

/*DOC:
 */
SDIF_API void      SdifFClose                   (SdifFileT *SdifF);

SdifFrameHeaderT*  SdifFCreateCurrFramH         (SdifFileT *SdifF, SdifSignature Signature);
SdifMatrixHeaderT* SdifFCreateCurrMtrxH         (SdifFileT *SdifF);
FILE*              SdifFGetFILE_SwitchVerbose   (SdifFileT *SdifF, int Verbose);
void               SdifTakeCodedPredefinedTypes (SdifFileT *SdifF);
void               SdifFLoadPredefinedTypes     (SdifFileT *SdifF, const char *TypesFileName);

extern int        gSdifInitialised;
extern SdifFileT *gSdifPredefinedTypes;



/*
// FUNCTION GROUP:      Init/Deinit of the Library
*/

/*DOC: 
  Initialise the SDIF library, providing a name for an optional additional
  file with type definitions or "".
  <b>This function has to be called once and only once per process 
  before any other call to the SDIF library.</b> */
SDIF_API void SdifGenInit (const char *PredefinedTypesFile); 

/*DOC:
  Initialise the SDIF library if it has not been initialised before.
  This function has to be called at least once, but can be called as
  many times as desired.  Especially useful for dynamic libraries.

  [in] PredefinedTypesFile:
        name for an optional additional file with type definitions or "". */
SDIF_API void SdifGenInitCond (const char *PredefinedTypesFile);

/*DOC:
  Deinitialise the SDIF library */
SDIF_API void SdifGenKill (void); 

/*DOC:
  Set function that will be called after a grave error has occurred.  
  Default is exit(). */
SDIF_API void SdifSetExitFunc (SdifExitFuncT func);

/*DOC:
  Set function that will be called after an error has occured.
  make an exception. */
SDIF_API void SdifSetErrorFunc (SdifExceptionFuncT func);

/*DOC:
  Set function that will be called after a warning has occured.
  make an exception. */
SDIF_API void SdifSetWarningFunc (SdifExceptionFuncT func);

/*DOC:
  Print version information to standard error. */
SDIF_API void SdifPrintVersion(void);


/*
// FUNCTION GROUP:      Current Header Access Functions
*/

/*DOC: 
  Permet de donner des valeurs � chaque champ de l'ent�te de frame
  temporaire de SdifF.<p> 

  Exemple:
  <code>SdifSetCurrFrameHeader(SdifF, '1FOB', _SdifUnknownSize, 3, streamid, 1.0);</code> */
SDIF_API SdifFrameHeaderT* SdifFSetCurrFrameHeader (SdifFileT *SdifF, 
                                                    SdifSignature Signature, 
                                                    SdifUInt4 Size,
                                                    SdifUInt4 NbMatrix, 
                                                    SdifUInt4 NumID, 
                                                    SdifFloat8 Time);

/*DOC: 
  Permet de donner des valeurs � chaque champ de l'ent�te de matice
  temporaire de SdifF.<p>

  Exemple:
  <code>SdifSetCurrMatrixHeader(SdifF, '1FOF', eFloat4, NbFofs, 7);</code> */
SDIF_API SdifMatrixHeaderT* SdifFSetCurrMatrixHeader (SdifFileT *SdifF, 
                                                      SdifSignature Signature,
                                                      SdifDataTypeET DataType, 
                                                      SdifUInt4 NbRow, 
                                                      SdifUInt4 NbCol);


/*DOC: 
  Recopie la m�moire point�e par Values en fonction de l'ent�te de
  matrice courante.<p> 

  Exemple:<br>
<pre>
  #define NbCols = 10;<br>

  float t[NbCols] = { 1., 2., 3., 4., 5., 6., 7., 8., 9., 0.};<br>

  SdifFSetCurrMatrixHeader(SdifF, 'mtrx', eFloat4, 1, NbCols);<br>
  SdifFSetCurrOneRow      (SdifF, (void*) t);<br>
</pre>

  On connait la taille de la m�moire � recopier par le type de donn�e
  (ici: eFloat4) et le nombre de colonnes (ici: NbCols). Il faut que
  le type de donn�e de la matrice courante corresponde avec la taille
  d'un �l�ment de t. Si t est compos� de float sur 4 bytes, alors on
  doit avoir eFloat4. Si t est compos� de double float sur 8 bytes,
  alors c'est eFloat8.<br>

  En g�n�ral, les donn�es d'un programme ne se pr�sente pas sous cette
  forme et il faut r�aliser une transposition lors des transfert de
  Sdif � un programme. Le programme Diphone Ircam a un bon exemple de
  lecture avec transposition automatique, g�n�ralis�e pour tout type
  de matrice. */
SdifOneRowT*  SdifFSetCurrOneRow       (SdifFileT *SdifF, void *Values);


/*DOC: 
  Permet de donner la valeur Value dans la ligbe de matrice temporaire
  de SdifF � la colonne numCol (0<numCol<=SdifF->CurrMtrxH->NbCol).  */
SdifOneRowT* SdifFSetCurrOneRowCol (SdifFileT *SdifF, SdifUInt4
numCol, SdifFloat8 Value);


/*DOC: 
  Recup�re la valeur stock�e � la colonne numCol de la ligne
  temporaire.  C'est un SdifFloat8 donc un double!!  */ 
SdifFloat8 SdifFCurrOneRowCol (SdifFileT *SdifF, SdifUInt4 numCol);


/*DOC: 
  Idem que la fonction pr�c�dente mais en utilisant le type de la
  matrice et le nom de la colonne.  */
SdifFloat8    SdifFCurrOneRowColName   (SdifFileT *SdifF, 
                                        SdifMatrixTypeT *MatrixType, 
                                        char *NameCD);


/*DOC: 
  Renvoie la signature temporaire de Chunk ou de Frame.  */
SDIF_API SdifSignature SdifFCurrSignature       (SdifFileT *SdifF);


/*DOC: 
  Met � 0 tous les bits de la signature temporaire.  */
SdifSignature SdifFCleanCurrSignature  (SdifFileT *SdifF);

/*DOC: 
  Renvoie la signature temporaire du dernier Frame lu ou du prochain �
  �crire.  */
SDIF_API SdifSignature SdifFCurrFrameSignature  (SdifFileT *SdifF);

/*DOC: 
  Renvoie la signature temporaire de la dernier matrice lue ou de la
  prochaine � �crire.  */
SDIF_API SdifSignature SdifFCurrMatrixSignature (SdifFileT *SdifF);

/*DOC: 
  Renvoie SdifF->CurrMtrx->NbCol, nombre de colonnes de la matrice en
  cours de traitement.  */
SDIF_API SdifUInt4     SdifFCurrNbCol           (SdifFileT *SdifF);

/*DOC: 
  Renvoie SdifF->CurrMtrx->NbRow, nombre de lignes de la matrice en
  cours de traitement.  */
SDIF_API SdifUInt4     SdifFCurrNbRow           (SdifFileT *SdifF);

/*DOC: 
  Returns the data type of the current matrix. */
SDIF_API SdifDataTypeET SdifFCurrDataType (SdifFileT *SdifF);

/*DOC: 
  Renvoie SdifF->CurrFramH->NbMatrix, mombre de matrices du frame
  courant.  */
SDIF_API SdifUInt4     SdifFCurrNbMatrix        (SdifFileT *SdifF);

/*DOC: 
  Renvoie SdifF->CurrFramH->NumID, index de l'objet du frame courant.  */
SDIF_API SdifUInt4     SdifFCurrID              (SdifFileT *SdifF);

/*DOC: 
  Renvoie SdifF->CurrFramH->Time.  */
SDIF_API SdifFloat8    SdifFCurrTime            (SdifFileT *SdifF);




/*
// FUNCTION GROUP:      File Data Access Functions
*/

/*DOC: 
  Renvoie la ligne temporaire de SdifF.  */
SdifOneRowT*  SdifFCurrOneRow          (SdifFileT *SdifF);

/*DOC:
  Returns a pointer to the data of the current matrix row.  
  According to the matrix data type, it can be a pointer to float or double. */
void*        SdifFCurrOneRowData          (SdifFileT *SdifF);

/*DOC: 
  Return pointer to current matrix data structure, if read before with
  SdifFReadMatrixData. */
SDIF_API SdifMatrixDataT *SdifFCurrMatrixData (SdifFileT *file);

/*DOC: 
  Return pointer to current raw matrix data, if read before with
  SdifFReadMatrixData.  Data is specified by current matrix header */
SDIF_API void*        SdifFCurrMatrixDataPointer (SdifFileT *file);


/*DOC:
  Return list of NVTs for querying. 
  [] precondition NVTs have been read with SdifFReadAllASCIIChunks. */
SDIF_API SdifNameValuesLT *SdifFNameValueList (SdifFileT *file);

/*DOC:
  Return number of NVTs present.
  [] precondition NVTs have been read with SdifFReadAllASCIIChunks. */
SDIF_API int SdifFNameValueNum (SdifFileT *file);

/*DOC:
  Return the file's stream ID table, created automatically by SdifFOpen. */
SDIF_API SdifStreamIDTableT *SdifFStreamIDTable (SdifFileT *file);

/*DOC:
  Add user data, return index added */
SDIF_API int SdifFAddUserData (SdifFileT *file, void *data);

/*DOC:
  Get user data by index */
SDIF_API void *SdifFGetUserData (SdifFileT *file, int index);



SdifFileT*    SdifFReInitMtrxUsed (SdifFileT *SdifF);
SdifFileT*    SdifFPutInMtrxUsed  (SdifFileT *SdifF, SdifSignature Sign);
SdifSignature SdifFIsInMtrxUsed   (SdifFileT *SdifF, SdifSignature Sign);



/*
// FUNCTION GROUP:      Error flag for file
*/

/*DOC: 
  Return pointer to last error struct or NULL if no error present
  for this file. */
SDIF_API SdifErrorT*     SdifFLastError    (SdifFileT *SdifF);

/*DOC: 
  Return tag of last error or eNoError if no error present for this file. */
SDIF_API SdifErrorTagET  SdifFLastErrorTag (SdifFileT *SdifF);


#define _SdifFrameHeaderSize 16  /* (ID=4)+(size=4)+(time=8) */



SdifFrameHeaderT* SdifCreateFrameHeader(SdifSignature Signature,
                                               SdifUInt4 Size,
                                               SdifUInt4 NbMatrix,
                                               SdifUInt4 NumID,
                                               SdifFloat8 Time);

SdifFrameHeaderT* SdifCreateFrameHeaderEmpty(SdifSignature Signature);

void              SdifKillFrameHeader  (SdifFrameHeaderT *FrameHeader);

SdifFrameDataT* SdifCreateFrameData(SdifHashTableT *FrameTypesTable,
                                           SdifSignature FrameSignature,
                                           SdifUInt4 NumID,
                                           SdifFloat8 Time);

void            SdifKillFrameData   (SdifHashTableT *FrameTypesTable, SdifFrameDataT *FrameData);

SdifFrameDataT* SdifFrameDataPutNthMatrixData(SdifFrameDataT *FrameData, unsigned int NthMatrix,
                                                     SdifMatrixDataT *MatrixData);

SdifFrameDataT* SdifFrameDataPutComponentMatrixData(SdifHashTableT *FrameTypesTable,
                                                           SdifFrameDataT *FrameData,
                                                           char *CompoName, SdifMatrixDataT *MatrixData);

SdifMatrixDataT* SdifFrameDataGetNthMatrixData(SdifFrameDataT *FrameData, unsigned int NthMatrix);

SdifMatrixDataT* SdifFrameDataGetComponentMatrixData(SdifHashTableT *FrameTypesTable,
                                                            SdifFrameDataT *FrameData,
                                                     char *CompoName);



SdifComponentT* SdifCreateComponent (SdifSignature MtrxS, char *Name, SdifUInt4 Num);
void            SdifKillComponent   (SdifComponentT *Component);
SdifFrameTypeT* SdifCreateFrameType (SdifSignature FramS, SdifFrameTypeT *PredefinedFrameType);

void            SdifKillFrameType               (SdifFrameTypeT *FrameType);

/** 
 * Access a frame type definition by matrix component signature 
 */
SdifComponentT* SdifFrameTypeGetComponent_MtrxS (SdifFrameTypeT *FrameType, SdifSignature MtrxS);

/** 
 * Access a frame type definition by matrix component name 
 */
SdifComponentT* SdifFrameTypeGetComponent       (SdifFrameTypeT *FrameType, char *NameC);

/** 
 * Access a frame type definition by matrix component number 
 */
SdifComponentT* SdifFrameTypeGetNthComponent    (SdifFrameTypeT *FrameType, SdifUInt4 NumC);

SdifFrameTypeT* SdifFrameTypePutComponent       (SdifFrameTypeT *FrameType, SdifSignature MtrxS, char *NameC);


/**
 * Get frame type pointer from signature, given a frame type hash table.
 * Use SdifFGetFrameTypesTable to get this.
 */ 
SdifFrameTypeT* SdifGetFrameType       (SdifHashTableT *FrameTypeHT, SdifSignature FramS);

void            SdifPutFrameType       (SdifHashTableT *FrameTypeHT, SdifFrameTypeT *FrameType);
SdifUInt2       SdifExistUserFrameType (SdifHashTableT *FrameTypeHT);



/* set default if not overridden from makefile */
#ifndef _SdifFormatVersion
#define _SdifFormatVersion 3
#endif

#define _SdifTypesVersion  1


/* _SdifEnvVar : Environnement variable which contains the name
 * of the file which contains predefined types (the name contains the path).
 * _SdifEnvVar is used in SdifFile.c SdifGenInit, the user can
 * reference predefined types by this envvar name.
 */
#define _SdifEnvVar "SDIFTYPES"

/* Default predefined types : _SdifTypesFileName see SdifFile.c
 */

/* allocation constants
   TODO: should these be public? */
#define _SdifListNodeStockSize 0x400 /* 1024 */
#define _SdifGenHashSize         127 /* size of matrix/frame type table */
#define _SdifNameValueHashSize    31 /* size of hash table for NVTs */
#define _SdifUnknownSize  0xffffffff
#define _SdifGranule            1024 /* for OneRow allocation in bytes */
#define _SdifPadding               8
#define _SdifPaddingBitMask (_SdifPadding - 1)

#define _SdifFloat8Error  0xffffffff
#define _SdifNoTime       _Sdif_MIN_DOUBLE_     /* for header ASCII frames */
#define _SdifNoStreamID   0xfffffffe            /* used for 1TYP */
#define _SdifAllStreamID  0xffffffff            /* used for 1IDS */
#define _SdifUnknownUInt4 0xffffffff

/* CNMAT restriction: only one frame type per stream.  
   Therefore we have to use unique IDs for all 'header' frames. */
#define _SdifNVTStreamID  0xfffffffd            /* used for 1NVT */
#define _SdifIDSStreamID  0xfffffffc            /* unused */
#define _SdifTYPStreamID  0xfffffffb            /* unused */


#define _SdifFloatEps  FLT_EPSILON

/* DataTypeEnum

   On Matt Wright's visit at IRCAM June 1999, we defined a new
   encoding for the MatrixDataType field with the feature that the low
   order byte encodes the number of bytes taken by each matrix
   element.  

   Low order byte encodes the number of bytes 
   High order bytes come from this (extensible) enum:

        0 : Float
        1 : Signed integer
        2 : Unsigned integer
        3 : Text (UTF-8 when 1 byte)
        4 : arbitrary/void
*/


#ifndef SWIG
/* #ifdef STDC_HEADERS */  /* Is the compiler ANSI? */

/* generate template for all types, 
   called by sdif_foralltypes and sdif_proto_foralltypes. */
#define sdif__foralltypes(macro, post)  macro(Float4)post \
                                        macro(Float8)post \
                                        macro(Int1  )post \
                                        macro(Int2  )post \
                                        macro(Int4  )post \
                                        macro(UInt1 )post \
                                        macro(UInt2 )post \
                                        macro(UInt4 )post \
                                        macro(Char  )post \
                                     /* macro(Int8  )post \
                                        macro(UInt8 )post \
                                      */

#define sdif_foralltypes_post_body    /* this is empty */
#define sdif_foralltypes_post_proto ; /* this is a semicolon */


/* generate template for all types */
#define sdif_foralltypes(macro)         \
        sdif__foralltypes(macro,sdif_foralltypes_post_body)


/* generate prototype template for all types */
#define sdif_proto_foralltypes(macro)   \
        sdif__foralltypes(macro,sdif_foralltypes_post_proto)

/* #endif */ /* STDC_HEADERS */
#endif /* SWIG */


#define _SdifStringLen 1024

extern char gSdifString[_SdifStringLen];
extern char gSdifString2[_SdifStringLen];
extern char gSdifErrorMess[_SdifStringLen];

#define _SdifNbMaxPrintSignature 8
extern char gSdifStringSignature[_SdifNbMaxPrintSignature][5];
extern int  CurrStringPosSignature;


/*
// FUNCTION GROUP:      utility functions
*/

/*DOC:
*/
SDIF_API char*     SdifSignatureToString(SdifSignature Signature);

/*DOC: 
  Compare two signatures, ignoring the first character which
  encodes the type version.  Note that comparison of full signatures
  can be done simply with '=='. 
*/
int     SdifSignatureCmpNoVersion(SdifSignature Signature1, SdifSignature Signature2);

/*DOC: 
  Returns size of SDIF data type in bytes
  (which is always the low-order byte).  
*/
SDIF_API SdifUInt4 SdifSizeofDataType (SdifDataTypeET DataType);

/*DOC: 
  Returns true if DataType is in the list of known data types.
*/
int SdifDataTypeKnown (SdifDataTypeET DataType);

/*DOC:
*/
size_t    SdifPaddingCalculate  (size_t NbBytes);

/*DOC:
*/
size_t    SdifFPaddingCalculate (FILE *f, size_t NbBytes);

/* (double f1) == (double f2) with _SdifFloatEps for error */
int SdifFloat8Equ(SdifFloat8 f1, SdifFloat8 f2);


#ifndef MIN
#define MIN(a,b)        ((a) < (b)  ?  (a)  :  (b))
#endif

#ifndef MAX
#define MAX(a,b)        ((a) > (b)  ?  (a)  :  (b))
#endif



/* SdifHard_OS.h */

/* _Sdif_MIN_DOUBLE_ tested on SGI, DEC alpha, PCWin95 as 0xffefffffffffffff
 * include may be limits.h (float.h is sure with VisualC++5 Win 95 or NT)
 */
#define _Sdif_MIN_DOUBLE_ (- DBL_MAX)


int       SdifStrLen  (const char *s);

/* returns 0 if strings are equal */
int       SdifStrCmp  (const char *s1, const char *s2);

/* returns true if strings are equal */
int       SdifStrEq(const char *s1, const char *s2);
int       SdifStrNCmp (const char *s1, const char *s2, unsigned int n);
char*     SdifStrNCpy (char *s1, const char *s2, unsigned int n);
char*     SdifCreateStrNCpy (const char* Source, size_t Size);
void      SdifKillStr (char* String);


void     SdifSetStdIOBinary (void);
FILE*    SdiffBinOpen       (const char * Name, SdifBinaryModeET Mode);
SdifInt4 SdiffBinClose      (FILE *f);



SdifHashTableT* SdifCreateHashTable(unsigned int HashSize, SdifHashIndexTypeET IndexType, void (*Killer)(void *));

void SdifMakeEmptyHashTable (SdifHashTableT* HTable);
void SdifKillHashTable      (SdifHashTableT* HTable);



/******************  eHashChar ****************/

unsigned int SdifHashChar(const char* s, unsigned int nchar, unsigned int HashSize);

void*           SdifHashTableSearchChar(SdifHashTableT* HTable, const char *s, unsigned int nchar);
SdifHashTableT* SdifHashTablePutChar   (SdifHashTableT* HTable, const char *s, unsigned int nchar, void* Data);


/***************** eHashInt4 **********************/

unsigned int SdifHashInt4(unsigned int i, unsigned int HashSize);

void*           SdifHashTableSearchInt4(SdifHashTableT* HTable, unsigned int i);
SdifHashTableT* SdifHashTablePutInt4   (SdifHashTableT* HTable, const unsigned int i, void* Data);


/*************************** for all ***********************/

void*           SdifHashTableSearch (SdifHashTableT* HTable, void *ptr, unsigned int nobj);
SdifHashTableT* SdifHashTablePut    (SdifHashTableT* HTable, const void *ptr, unsigned int nobj, void* Data);




/*
//FUNCTION GROUP:  High-Level I/O Functions
*/

/*DOC:
  Definition of the callback function types, used for SdifReadSimple. 
  SdifOpenFileCallbackT returns flag if rest of file should be read.
*/
typedef int (*SdifOpenFileCallbackT)   (SdifFileT *file, void *userdata);
typedef int (*SdifCloseFileCallbackT)  (SdifFileT *file, void *userdata);
typedef int (*SdifFrameCallbackT)      (SdifFileT *file, void *userdata);
typedef int (*SdifMatrixCallbackT)     (SdifFileT *file, 
                                        int nummatrix,   void *userdata);
typedef int (*SdifMatrixDataCallbackT) (SdifFileT *file, 
                                        int nummatrix,   void *userdata);

/*DOC: 
  Reads an entire SDIF file, calling matrixfunc for each matrix in the
  SDIF selection taken from the filename.  Matrixfunc is called with
  the SDIF file pointer, the matrix count within the current frame,
  and the userdata unchanged. 

  no row/column selection yet!
  
  @return number of bytes read
*/
SDIF_API size_t SdifReadSimple (const char              *filename, 
                                SdifMatrixDataCallbackT  matrixfunc,
                                void                    *userdata);


SDIF_API size_t SdifReadFile   (const char              *filename, 
                                SdifOpenFileCallbackT    openfilefunc,
                                SdifFrameCallbackT       framefunc,
                                SdifMatrixCallbackT      matrixfunc,
                                SdifMatrixDataCallbackT  matrixdatafunc,
                                SdifCloseFileCallbackT   closefilefunc,
                                void                    *userdata);

/*DOC: 
  Reads matrix data and padding.  The data is stored in CurrMtrxData,
  for which the library will allocate enough space for the data of one
  matrix, accessible by SdifFCurrMatrixData().  
  
  @return       number of bytes read or 0 if error
                N.B. first of all that an error is signalled to the error callback
                set with SdifSetErrorFunc, and the library tries to exit via the 
                function set with SdifSetExitFunc.  So, if you have to check the
                return value, note that for matrices with 0 rows or 0 columns,
                a return value of 0 is correct.  
                You should thus check for this with:

  if (nread == 0  &&  (SdifFCurrNbRow(file) != 0  ||  SdifFCurrNbCol(file) != 0))
      --> read problem

  [Precondition:] 
  Matrix header must have been read with SdifFReadMatrixHeader.  
*/
SDIF_API size_t SdifFReadMatrixData   (SdifFileT *file);




/*
//FUNCTION GROUP:  Querying SDIF Files
*/

typedef struct
{ 
    double min, max;    /* use double even for int, doesn't harm */
} SdifMinMaxT;

/* two-level tree node for matrices in frames */
typedef struct SdifQueryTreeElemS
{
    /* common fields */
    SdifSignature sig;
    int           count;
    int           parent;/* -1 for frames, index to parent frame for matrices */

    /* frame fields */
    int           stream;
    SdifMinMaxT   time, nmatrix;

    /* matrix fields */
    SdifMinMaxT   ncol, nrow;

} SdifQueryTreeElemT;


/* SdifQueryTreeT counts occurence of signatures as frame or matrix under
   different parent frames. */
typedef struct
{
    int                 num;            /* number of elems used */
    int                 nummatrix;      /* number of leaf nodes */
    int                 current;        /* index of current frame */
    int                 allocated;      /* number of elems allocated */
    SdifQueryTreeElemT *elems;
    SdifMinMaxT         time;           /* frame times */
} SdifQueryTreeT;


/* allocate query tree for max elements */
SDIF_API SdifQueryTreeT *SdifCreateQueryTree(int max);

/* clean all elements from tree */
SDIF_API SdifQueryTreeT *SdifInitQueryTree(SdifQueryTreeT *tree);

/* create summary of file's data in query tree, return bytesize of file */
SDIF_API size_t SdifQuery (const char            *filename, 
                           SdifOpenFileCallbackT  openfilefunc,
                /*out*/    SdifQueryTreeT        *tree);





#if 0   /* TBI */

/*
//FUNCTION GROUP: to be implemented / TBI
*/


/*DOC: 
  Write whole matrix, given as separate columns in array "columns" of
  pointer to "DataType".  Each columns [i], i = 0..NbCol-1, points to 
  NbRow * SdifSizeofDataType (DataType) bytes.  
  TBI 
*/
SdifFWriteMatrixColumns (SdifFileT     *file,
                         SdifSignature  Signature,
                         SdifDataTypeET DataType,
                         SdifUInt4      NbRow,
                         SdifUInt4      NbCol,
                         void          *columns []);


/*DOC: 
  Reads matrix header and data into memory allocated by the library,
  accessible by SdifFCurrMatrixData (). */
int SdifFReadMatrix (SdifFileT *file);

void *SdifGetColumn ();



/*
 * Error handling (sketch TBI)
 */

int /*bool*/ SdifFCheckStatus (SdifFileT *file)
{
  return (SdifLastError (file->ErrorList)) == NULL);
}


int /*bool*/ SdifFCheckStatusPrint (SdifFileT *file)
{
  SdifError err = SdifLastError (file->ErrorList));
  if (err != eNoError)
     print (SdifFsPrintFirstError (..., file, ...);
  return err == NULL;
}


/* --> test in SdifFReadGeneralHeader  (file) + SdifFReadAllASCIIChunks (file)
   if (!SdifFCheckStatus (file))
      SdifWarningAdd ("Followup error");
*/

#endif /* TBI */



/* stocks management */

void        SdifInitListNStock      (SdifListNStockT *Stock, unsigned int SizeOfOneStock);
void        SdifNewStock            (SdifListNStockT *Stock);
SdifListNT* SdifGetNewNodeFromTrash (SdifListNStockT *Stock);
SdifListNT* SdifGetNewNodeFromStock (SdifListNStockT *Stock);
SdifListNT* SdifGetNewNode          (SdifListNStockT *Stock);
void        SdifPutNodeInTrash      (SdifListNStockT *Stock, SdifListNT* OldNode);
SdifListNT* SdifKillListNStock      (SdifListNT* OldStock);
void        SdifListNStockMakeEmpty (SdifListNStockT *Stock);

/* global variable gSdifListNodeStock */



extern  SdifListNStockT gSdifListNodeStock;
SdifListNStockT* SdifListNodeStock  (void);
void    SdifInitListNodeStock       (unsigned int SizeOfOneStock);
void    SdifDrainListNodeStock      (void);


/* nodes management */

SdifListNT* SdifCreateListNode  (SdifListNT *Next, void *Data);
SdifListNT* SdifKillListNode    (SdifListNT *Node, KillerFT Killer);



/* lists management */

SdifListT*  SdifCreateList      (KillerFT Killer);
SdifListT*  SdifKillListHead    (SdifListT* List);
SdifListT*  SdifKillListCurr    (SdifListT* List);
SdifListT*  SdifMakeEmptyList   (SdifListT* List);
void        SdifKillList        (SdifListT* List);

/*DOC:
  Init the function SdifListGetNext. 
  [Return] head of List. */
SDIF_API void*       SdifListGetHead     (SdifListT* List); 

SDIF_API void*       SdifListGetTail     (SdifListT* List);
SDIF_API int         SdifListIsNext      (SdifListT* List);
SDIF_API int         SdifListIsEmpty     (SdifListT* List);
SDIF_API unsigned int SdifListGetNbData  (SdifListT* List);

/*DOC:
  Init for function SdifListGetNext.
  [Returns] true if List has elements. */
SDIF_API int         SdifListInitLoop    (SdifListT* List);

/*DOC:
  Set Curr to Curr->Next and after return Curr->Data */
SDIF_API void*       SdifListGetNext     (SdifListT* List);

/*DOC:
  Only return Curr->Data. */
SDIF_API void*       SdifListGetCurr     (SdifListT* List);

SdifListT*  SdifListPutTail     (SdifListT* List, void *pData);
SdifListT*  SdifListPutHead     (SdifListT* List, void *pData);

/*DOC:
  append list b to list a 

  WARNING: This creates double references to the data! */
SdifListT *SdifListConcat(SdifListT *a, SdifListT *b);




SdifMatrixHeaderT* SdifCreateMatrixHeader    (SdifSignature Signature, 
                                              SdifDataTypeET DataType,
                                              SdifUInt4 NbRow, 
                                              SdifUInt4 NbCol);

SdifMatrixHeaderT* SdifCreateMatrixHeaderEmpty (void);
void               SdifKillMatrixHeader        (SdifMatrixHeaderT *MatrixHeader);


/*
 * OneRow class
 */

SdifOneRowT*       SdifCreateOneRow          (SdifDataTypeET DataType, SdifUInt4  NbGranuleAlloc);
SdifOneRowT*       SdifReInitOneRow          (SdifOneRowT *OneRow, SdifDataTypeET DataType, SdifUInt4 NbData);
void               SdifKillOneRow            (SdifOneRowT *OneRow);

/* row element access */

SdifOneRowT*       SdifOneRowPutValue        (SdifOneRowT *OneRow, SdifUInt4 numCol, SdifFloat8 Value);
SdifFloat8         SdifOneRowGetValue        (SdifOneRowT *OneRow, SdifUInt4 numCol);
SdifFloat8         SdifOneRowGetValueColName (SdifOneRowT *OneRow, SdifMatrixTypeT *MatrixType, char * NameCD);


/*
 * matrix data class 
 */

SdifMatrixDataT*   SdifCreateMatrixData      (SdifSignature Signature, 
                                              SdifDataTypeET DataType,
                                              SdifUInt4 NbRow, 
                                              SdifUInt4 NbCol);

void               SdifKillMatrixData        (SdifMatrixDataT *MatrixData);

/* see if there's enough space for data, if not, grow buffer */
int                SdifMatrixDataRealloc     (SdifMatrixDataT *data, 
                                              int newsize);

/* matrix data element access by index (starting from 1!) */

SdifMatrixDataT*   SdifMatrixDataPutValue    (SdifMatrixDataT *MatrixData,
                                              SdifUInt4  numRow, 
                                              SdifUInt4  numCol, 
                                              SdifFloat8 Value);

SdifFloat8         SdifMatrixDataGetValue    (SdifMatrixDataT *MatrixData,
                                              SdifUInt4  numRow, 
                                              SdifUInt4  numCol);

/* matrix data element access by column name */

SdifMatrixDataT *  SdifMatrixDataColNamePutValue (SdifHashTableT *MatrixTypesTable,
                                                  SdifMatrixDataT *MatrixData,
                                                  SdifUInt4  numRow,
                                                  char *ColName,
                                                  SdifFloat8 Value);

SdifFloat8         SdifMatrixDataColNameGetValue (SdifHashTableT *MatrixTypesTable,
                                                  SdifMatrixDataT *MatrixData,
                                                  SdifUInt4  numRow,
                                                  char *ColName);

SDIF_API void      SdifCopyMatrixDataToFloat4    (SdifMatrixDataT *data, 
                                                  SdifFloat4      *dest);


SdifColumnDefT*  SdifCreateColumnDef (char *Name,  unsigned int Num);
void             SdifKillColumnDef   (void *ColumnDef);

/*DOC: 
  premet de cr�er un objet 'type de matrice'. Le premier argument
  est la signature de ce type. Le second est l'objet 'type de matrice'
  pr�d�fini dans SDIF.<p>
  
  <strong>Important: Tous les types de matrices ou de frames utilis�s
  dans une instance de SdifFileT doivent �tre ajout�s aux tables de
  cette instance, de fa�on a cr�er le lien avec les types
  pr�d�finis.</strong> L'hors de la lecture des ent�tes avec les
  fonctions SdifFReadMatrixHeader et SdifFReadFrameHeader, cette mise
  � jour se fait automatiquement � l'aide des fonctions
  SdifTestMatrixType et SdifTestFrameType. */
SdifMatrixTypeT* SdifCreateMatrixType              (SdifSignature Signature,
                                                                           SdifMatrixTypeT *PredefinedMatrixType);
void             SdifKillMatrixType                (SdifMatrixTypeT *MatrixType);

/*DOC: 
  permet d'ajouter une colonne � un type (toujours la derni�re
  colonne).  */
SdifMatrixTypeT* SdifMatrixTypeInsertTailColumnDef (SdifMatrixTypeT *MatrixType, char *NameCD);

/*DOC: 
  renvoie la position de la colonne de nom NameCD.  (0 si elle
  n'existe pas) */
SdifUInt4        SdifMatrixTypeGetNumColumnDef     (SdifMatrixTypeT *MatrixType, char *NameCD);

/*DOC: 
  renvoie la d�finition de la colonne (num�ro, nom) en fonction
  du nom.(NULL si introuvable) */
SdifColumnDefT*  SdifMatrixTypeGetColumnDef        (SdifMatrixTypeT *MatrixType, char *NameCD);

/*DOC: 
  renvoie la d�finition de la colonne (num�ro, nom) en fonction
  du numero.(NULL si introuvable) */
SdifColumnDefT*  SdifMatrixTypeGetNthColumnDef     (SdifMatrixTypeT *MatrixType, SdifUInt4 NumCD);


/*DOC: 
  Return pointer to name of column at index, NULL if it doesn't exist. */
const char*  SdifMatrixTypeGetColumnName           (SdifMatrixTypeT *MatrixType, int index);


/*DOC: 
  renvoie le type de matrice en fonction de la Signature. Renvoie
  NULL si le type est introuvable. Attention, si Signature est la
  signature d'un type pr�d�fini,
  SdifGetMatrixType(SdifF->MatrixTypeTable,Signature) renvoie NULL si
  le lien avec entre SdifF et gSdifPredefinedType n'a pas �t� mis �
  jour.  

  Tip: use SdifFGetMatrixTypesTable to obtain the matrix types hash table.
*/
SdifMatrixTypeT* SdifGetMatrixType                 (SdifHashTableT *MatrixTypesTable, 
                                                    SdifSignature Signature);

/*DOC: 
  permet d'ajouter un type de matrice dans une table.  */
void             SdifPutMatrixType(SdifHashTableT *MatrixTypesTable, SdifMatrixTypeT* MatrixType);
SdifUInt2        SdifExistUserMatrixType(SdifHashTableT *MatrixTypesTable);

/*DOC:
  Remark:
         This function implements the new SDIF Specification (June 1999):
       Name Value Table, Matrix and Frame Type declaration, Stream ID declaration are
       defined in text matrix:
       1NVT 1NVT
       1TYP 1TYP
       1IDS 1IDS
  Get all types from a SdifStringT
*/
SDIF_API size_t SdifFGetAllTypefromSdifString (SdifFileT *SdifF, 
                                               SdifStringT *SdifString);



/**
 * Get table of matrix type definitions, 
 * useful for SdifGetMatrixType. 
 *
 * @ingroup types
 */
SdifHashTableT *SdifFGetMatrixTypesTable(SdifFileT *file);

/**
 * Get table of frame type definitions declare in this file's header only, 
 * useful for SdifGetFrameType. 
 *
 * @ingroup types
 */
SdifHashTableT *SdifFGetFrameTypesTable(SdifFileT *file);



/*
 * Memory allocation wrappers
 */

#define SdifMalloc(_type) (_type*) malloc(sizeof(_type))

#define SdifCalloc(_type, _nbobj) (_type*) calloc(_nbobj, sizeof(_type))

#define SdifRealloc(_ptr, _type, _nbobj) (_type*) realloc(_ptr, sizeof(_type) * _nbobj)

#define SdifFree(_ptr) free(_ptr)




/*
 * NameValue
 */


SdifNameValueT* SdifCreateNameValue(const char *Name,  const char *Value);
void            SdifKillNameValue(SdifNameValueT *NameValue);




/*
 * NameValueTable
 */

SdifNameValueTableT* SdifCreateNameValueTable(  SdifUInt4 StreamID, 
                                                SdifUInt4 HashSize, 
                                                SdifUInt4 NumTable);
void            SdifKillNameValueTable          (void* NVTable);
SdifNameValueT* SdifNameValueTableGetNV         (SdifNameValueTableT* NVTable, const char *Name);
SdifNameValueT* SdifNameValueTablePutNV         (SdifNameValueTableT* NVTable, const char *Name,  const char *Value);
SdifFloat8      SdifNameValueTableGetTime       (SdifNameValueTableT* NVTable);
SdifUInt4       SdifNameValueTableGetNumTable   (SdifNameValueTableT* NVTable);
SdifUInt4       SdifNameValueTableGetStreamID  (SdifNameValueTableT* NVTable);



/*
 * NameValueTableList
 */

SdifNameValuesLT*   SdifCreateNameValuesL       (SdifUInt4  HashSize);
void                SdifKillNameValuesL         (SdifNameValuesLT *NameValuesL);

/*DOC: 
  Cette fonction permet d'ajouter une nouvelle NVT dans la liste
  de tables pass�e par argument:
  <code>SdifNameValuesLNewHT(SdifF->NamefValues);</code><br>
  Attention, � l'ouverture de SdifF, il n'y a aucune table dans
  SdifF->NamefValues. Il faudra donc au moins en ajouter une pour
  pouvoir y mettre des NameValue.  */
SdifNameValuesLT*   SdifNameValuesLNewTable     (SdifNameValuesLT *NameValuesL, SdifUInt4 StreamID);

/*DOC: 
  Cette fonction permet de d�finir la ni�me NVT de la liste des
  tables comme NVT courante.  */
SdifNameValueTableT*SdifNameValuesLSetCurrNVT   (SdifNameValuesLT *NameValuesL, SdifUInt4 NumCurrNVT);


/*DOC:
  Kill current NVT from list of NVTs.  
  Warning: current nvt is no longer valid afterwards. 
           call SdifNameValuesLSetCurrNVT again */
void SdifNameValuesLKillCurrNVT(SdifNameValuesLT *NameValuesL);


/*DOC: 
  Cette fonction permet de r�cup�rer une Name-Value de la liste
  des NVTs en passant le Name en argument.  Dans le cas ou Name est
  r�f�renc� dans plusieurs NVT, alors c'est la premi�re NVT le
  contenant qui sera prise en compte.  Le pointeur retourn� est de
  type SdifNameValueT qui contient deux champs: Name et Value.  */
SdifNameValueT*     SdifNameValuesLGet          (SdifNameValuesLT *NameValuesL, char *Name);

/*DOC: 
  Cette fonction r�alise aussi une requ�te en fonction de Name
  mais uniquement dans la NVT courante.  */
SdifNameValueT*     SdifNameValuesLGetCurrNVT   (SdifNameValuesLT *NameValuesL, const char *Name);

/*DOC: 
  Cette fonction permet d'ajouter une NameValue � table courante
  qui est la derni�re table cr��e ou celle d�finie en tant que table
  courante. Name et Value doivent �tre des chaines caract�res ASCII
  sans espacements.  */
SdifNameValueT*     SdifNameValuesLPutCurrNVT   (SdifNameValuesLT *NameValuesL, const char *Name,  const char *Value);

/*DOC: 
  Add a Name-Value pair to the current Name-Value Table, while
  replacing reserved characters and spaces with underscores "_" 
  (using SdifStringToNV).  FYI: The strings are copied. */
SdifNameValueT*     SdifNameValuesLPutCurrNVTTranslate(SdifNameValuesLT *NameValuesL, const char *Name,  const char *Value);

SDIF_API SdifUInt2           SdifNameValuesLIsNotEmpty   (SdifNameValuesLT *NameValuesL);




#define   M_1FQ0_Frequency  "Frequency"
#define   M_1FQ0_Mode       "Mode"
#define   M_1FQ0_Hit        "Hit"

#define   M_1FOF_Frequency  "Frequency"
#define   M_1FOF_Amplitude  "Amplitude"
#define   M_1FOF_BandWidth  "BandWidth"
#define   M_1FOF_Tex        "Tex"
#define   M_1FOF_DebAtt     "DebAtt"
#define   M_1FOF_Atten      "Atten"
#define   M_1FOF_Phase      "Phase"

#define   M_1CHA_Channel1   "Channel1"
#define   M_1CHA_Channel2   "Channel2"
#define   M_1CHA_Channel3   "Channel3"
#define   M_1CHA_Channel4   "Channel4"

#define   M_1RES_Frequency  "Frequency"
#define   M_1RES_Amplitude  "Amplitude"
#define   M_1RES_BandWidth  "BandWidth"
#define   M_1RES_Saliance   "Saliance"
#define   M_1RES_Correction "Correction"

#define   M_1DIS_Distribution    "Distribution"
#define   M_1DIS_Amplitude  "Amplitude"

SdifFrameTypeT* CreateF_1FOB(void);
SdifFrameTypeT* CreateF_1REB(void);
SdifFrameTypeT* CreateF_1NOI(void);
void SdifCreatePredefinedTypes(SdifHashTableT *MatrixTypesHT,
                                      SdifHashTableT *FrameTypesHT);





/*************** Matrix Type ***************/

void SdifPrintMatrixType(FILE *fw, SdifMatrixTypeT *MatrixType);
void SdifPrintAllMatrixType(FILE *fw, SdifFileT *SdifF);

/*************** Frame Type ***************/

void SdifPrintFrameType(FILE *fw, SdifFrameTypeT *FrameType);
void SdifPrintAllFrameType(FILE *fw, SdifFileT *SdifF);

/********** Matrix **********/

void SdifPrintMatrixHeader(FILE *f, SdifMatrixHeaderT *MatrixHeader);
void SdifPrintOneRow(FILE *f, SdifOneRowT *OneRow);
void SdifPrintMatrixRows(FILE* f, SdifMatrixDataT *MatrixData);

/********** Frame ***********/

void SdifPrintFrameHeader(FILE *f, SdifFrameHeaderT* FrameHeader);

/************ High ***********/

void SdifPrintAllType(FILE *fw, SdifFileT *SdifF);




/*DOC:
  Return true if c is a reserved char. 
*/
int SdifIsAReservedChar (char c);

/*DOC: 
  Convert str <strong>in place</strong> so that it doesn't
  contain any reserved chars (these become '.') or spaces (these
  become '_').

  [] returns str
*/
SDIF_API char *SdifStringToNV (/*in out*/ char *str);

/* SdiffGetString lit un fichier jusqu'a un caractere reserve, ne
   rempli s que des caracteres non-espacement, renvoie le caractere
   reserve, saute les premiers caracteres espacement lus.  Il y a
   erreur si fin de fichier ou si un caractere non-espacement et
   non-reseve est lu apres un caractere espacement.  ncMax est
   typiquement strlen(s)+1.  
*/
int SdiffGetString      (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead);

/* retourne le caractere d'erreur */
int SdiffGetSignature   (FILE* fr, SdifSignature *Signature, size_t *NbCharRead);
/*DOC:
  Function return the signature in a SdifStringT
*/
int SdiffGetSignaturefromSdifString(SdifStringT *SdifString, SdifSignature *Signature);

int SdiffGetWordUntil   (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const char *CharsEnd);
/*DOC:
  Function return the word until in a SdifStringT
*/
int SdiffGetWordUntilfromSdifString(SdifStringT *SdifString, char* s, size_t ncMax,const char *CharsEnd);

int SdiffGetStringUntil (FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const char *CharsEnd);
/*DOC:
  Function return the string until in a SdifStringT
 */
int SdiffGetStringUntilfromSdifString(SdifStringT *SdifString, char *s, size_t ncMax,
                                     const char *CharsEnd);

int SdiffGetStringWeakUntil(FILE* fr, char* s, size_t ncMax, size_t *NbCharRead, const char *CharsEnd);
/*DOC:
  Return the weak string until in a SdifStringT
*/
int SdiffGetStringWeakUntilfromSdifString(SdifStringT *SdifString, char* s,
                                          size_t ncMax, const char *CharsEnd);

int SdifSkipASCIIUntil  (FILE* fr, size_t *NbCharRead, char *CharsEnd);
int SdifSkipASCIIUntilfromSdifString  (SdifStringT *SdifString, size_t *NbCharRead, char *CharsEnd);


#if 0   /* for cocoon's eyes only */
/* scan nobj items of TYPE from stream, return number sucessfully read */
size_t SdiffScan_TYPE   (FILE *stream, Sdif_TYPE  *ptr, size_t nobj);
size_t SdiffScanFloat4  (FILE *stream, SdifFloat4 *ptr, size_t nobj);
size_t SdiffScanFloat8  (FILE *stream, SdifFloat8 *ptr, size_t nobj);
#endif

#ifndef SWIG    /* are we scanned by SWIG? */

/* generate function prototypes for all types TYPE for the 
   SdiffScan<TYPE> functions */

#define sdif_scanproto(type) \
size_t SdiffScan##type (FILE *stream, Sdif##type *ptr, size_t nobj)

sdif_proto_foralltypes (sdif_scanproto)

#endif /* SWIG */


/* Unsafe but optimized version of SdifStringToSignature:
   Exactly 4 chars are considered, so make sure *str has at least that many! 
   The str pointer MUST be word (at least 4 byte or so) aligned.
*/
SdifSignature _SdifStringToSignature (char *str);

/*DOC:
  Convert a string to an SDIF signature (in proper endianness).
  str can point to any string position of any length.  
*/
SdifSignature SdifStringToSignature (const char *str);






/*DOC:
  Return pointer to start of filename component in path inPathFileName.
 */
char *SdifBaseName (const char* inPathFileName);


/* 
// FUNCTION GROUP:      Init/Deinit
 */

/* init module, called by SdifGenInit */
int SdifInitSelect (void);

/*DOC: 
  Allocate space for an sdif selection.
*/
SdifSelectionT *SdifCreateSelection (void);

/*DOC: 
*/
int SdifInitSelection (SdifSelectionT *sel, const char *filename, int namelen);

/*DOC: 
*/
int SdifFreeSelection (SdifSelectionT *sel);

/*DOC:
  Killer function for SdifKillList: free one SdifSelectElement 
*/
void SdifKillSelectElement (/*SdifSelectionT*/ void *victim);



/*
// FUNCTION GROUP:      Parse and Set Selection
*/


/*DOC: 
  Returns pointer to first char of select spec (starting with ::), 
  or NULL if not found.
*/
char *SdifSelectFindSelection (const char *filename);


/*DOC: 
*/
SDIF_API char *SdifGetFilenameAndSelection (/*in*/  const char *filename, 
                                            /*out*/ SdifSelectionT *sel);

/*DOC: 
  Replace current selection by new one given in first argument.
  The selection specification may contain all the parts of a filename
  based selection after the  selection indicator :: .
*/
void SdifReplaceSelection (/*in*/ const char* selectionstr,
                           /*out*/ SdifSelectionT *sel);


/*DOC: 
*/
void SdifPrintSelection (FILE *out, SdifSelectionT *sel, int options);



/*DOC:
  Parse comma-separated list of signatures into list of SdifSelectElementT
  [Return] true if ok 

  List has to be created before with
        list = SdifCreateList (SdifKillSelectElement)
*/
int SdifParseSignatureList (SdifListT *list, const char *str);



/*
// FUNCTION GROUP:      Add Selections to Element Lists
*/

/* Give documentation and fake prototype for _add... macro generated functions.
   Cocoon ignores the #if 0.
*/
#if 0

/*DOC:
  Create and add one value to selection element list.  There are four 
  functions generated automatically, with the meta type-variables _type_ and 
  _datatype_:
  [] _type_ is one of:  <br> Int, Real,   Signature,     String, for
  [] _datatype_ of:     <br> int, double, SdifSignature, char *, respectively.
*/
void SdifSelectAdd_TYPE_ (SdifListT *list, _datatype_ value);

/*DOC:
  Create and add one range to selection element list.  There are four 
  functions generated automatically, with the meta type-variables _type_ and 
  _datatype_:
  [] _type_ is one of:  <br> Int, Real,   Signature,     String, for
  [] _datatype_ of:     <br> int, double, SdifSignature, char *, respectively.

  Example: to add the time range (t1, t2) to the selection in file, call
        SdifSelectAddRealRange(file->Selection->time, t1, sst_range, t2);
*/
void SdifSelectAdd_TYPE_Range (SdifListT *list, 
                               _datatype_ value, 
                               SdifSelectTokens rt, 
                               _datatype_ range);

#endif  /* if 0 */


#define _addrangeproto(name, type, field) \
void SdifSelectAdd##name##Range (SdifListT *list, \
                                 type value, SdifSelectTokens rt, type range)

#define _addsimpleproto(name, type, field) \
void SdifSelectAdd##name (SdifListT *list, type value)

#define _addproto(name, type, field) \
_addsimpleproto (name, type, field); \
_addrangeproto  (name, type, field);

_addproto (Int,       int,              integer)
_addproto (Real,      double,           real)
_addproto (Signature, SdifSignature,    signature)
_addproto (String,    char *,           string)


/*DOC: 
  copy a selection list source, appending to an existing one dest
  the same but freshly allocated elements from source

  @return dest
*/
SdifListT *SdifSelectAppendList (SdifListT *dest, SdifListT *source);

/*DOC:
  convert list of int selections to mask 

  do this whenever elements have been added to an int selection list
*/
SDIF_API void SdifSelectGetIntMask (SdifListP list, SdifSelectIntMaskP mask);




/*
// FUNCTION GROUP:      Query parsed ranges (list of ranges).
*/

/*DOC:
  Query parsed ranges (list of ranges) for a selection element (one of
  the SdifListP lists in SdifSelectionT).  Init list traversal with
  SdifListInitLoop, then call SdifSelectGetNext<type>(list) until it
  returns 0.

  The number of selections in the list is SdifListGetNbData(list), if
  it is 0, or SdifListIsEmpty(list) is true, then there was no
  selection for that element.

  If force_range is 1, the out value is converted to a range in any
  case, with value <= range guaranteed.  
*/
int SdifSelectGetNextIntRange  (/*in*/  SdifListP list, 
                                /*out*/ SdifSelectElementIntT  *range, 
                                /*in*/  int force_range);

/*DOC: 
  See SdifSelectGetNextInt.
*/
int SdifSelectGetNextRealRange (/*in*/  SdifListP list, 
                                /*out*/ SdifSelectElementRealT *range, 
                                /*in*/  int force_range);

/*DOC: 
  Query list of parsed selection elements (one of the SdifListP
  lists in SdifSelectionT).  Init list traversal with
  SdifListInitLoop, then call SdifSelectGetNext<type>(list) until it
  returns 0.

  See also SdifSelectGetNextInt.  
*/
SdifSignature  SdifSelectGetNextSignature (/*in*/  SdifListP list);

/*DOC: 
  See SdifSelectGetNextSignature.
*/
char          *SdifSelectGetNextString    (/*in*/  SdifListP list);


/*DOC: 
  Return value of first selection (ignoring range).
*/
int            SdifSelectGetFirstInt       (SdifListP l, int defval);
double         SdifSelectGetFirstReal      (SdifListP l, double defval);
char          *SdifSelectGetFirstString    (SdifListP l, char *defval);
SdifSignature  SdifSelectGetFirstSignature (SdifListP l, SdifSignature defval);





/*
// FUNCTION GROUP:      Selection Testing Functions
*/

int SdifSelectTestIntMask (SdifSelectIntMaskT *mask, SdifUInt4 cand);

int SdifSelectTestIntRange  (SdifSelectElementT *elem, SdifUInt4 cand);
int SdifSelectTestRealRange (SdifSelectElementT *elem, double cand);

int SdifSelectTestInt (SdifListT *list, SdifUInt4 cand);
int SdifSelectTestReal (SdifListT *list, double cand);
int SdifSelectTestSignature (SdifListT *list, const SdifSignature cand);
int SdifSelectTestString (SdifListT *list, const char *cand);



/*
// FUNCTION GROUP:      Using a Selection in File I/O.
*/


/*DOC:
  Get number of selected streams in file selection, 0 for all  */
int SdifFNumStreamsSelected (SdifFileT *file);

/*DOC: 
  Get number of selected rows in file selection, or num rows in
  current matrix when all are selected.
  SdifFReadMatrixHeader must have been called before! */
int SdifFNumRowsSelected (SdifFileT *file);

/*DOC:
  Get number of selected columns in file selection, or num columns in
  current matrix when all are selected  
  SdifFReadMatrixHeader must have been called before! */
int SdifFNumColumnsSelected (SdifFileT *file);

/*DOC: 
  Read frame headers until a frame matching the file selection
  has been found or the end of the file has been reached.

  [Return] false if end of file was reached, true if data has been read. */
int SdifFReadNextSelectedFrameHeader (SdifFileT *f);



/*DOC: 
  Test the selection elements from sel applicable to frame FramH:
  time, stream, frame type. */
int SdifFrameIsSelected (SdifFrameHeaderT *FramH, SdifSelectionT *sel);

/*DOC:
  Test the selection elements from sel applicable to matrix MtrxH: 
  the matrix signature. */
int SdifMatrixIsSelected (SdifMatrixHeaderT *MtrxH, SdifSelectionT *sel);


/*DOC: 
  Test if the current frame header is in the file selection
  (automatically parsed from the filename).  
  Can be called after SdifFReadFrameHeader(). */
int SdifFCurrFrameIsSelected (SdifFileT *file);

/*DOC:
  Test if the current matrix header is in the file selection
  (automatically parsed from the filename).  
  Can be called after SdifFReadMatrixHeader(). */
int SdifFCurrMatrixIsSelected (SdifFileT *file);

/*DOC:
  Test file selection if a given row (starting from 1) is selected */
int SdifFRowIsSelected (SdifFileT *file, int row);

/*DOC:
  Test file selection if a given column (starting from 1) is selected */
int SdifFColumnIsSelected (SdifFileT *file, int col);




/*
// FUNCTION GROUP:      Handling of a Table of Signatures
*/

/*DOC:
  Create table for initially NbSignMax signatures. */
SdifSignatureTabT* SdifCreateSignatureTab (const SdifUInt4 NbSignMax);

/*DOC:
  Free signature table. */
void               SdifKillSignatureTab   (SdifSignatureTabT *SignTab);

/*DOC:
  Reallocate table to hold NewNbSignMax signatures. */
SdifSignatureTabT* SdifReAllocSignatureTab(SdifSignatureTabT *SignTab, 
                                           const SdifUInt4 NewNbSignMax);

/*DOC:
  Reallocate table to hold NewNbSignMax signatures and clear signatures. */
SdifSignatureTabT* SdifReInitSignatureTab (SdifSignatureTabT *SignTab, 
                                           const SdifUInt4 NewNbSignMax);

/*DOC:
  Add signature Sign, no overflow check. */
SdifSignatureTabT* SdifPutInSignatureTab  (SdifSignatureTabT *SignTab, 
                                           const SdifSignature Sign);

/*DOC:
  Add signature Sign, reallocate table if necessary. */
SdifSignatureTabT* SdifAddToSignatureTab  (SdifSignatureTabT *SignTab, 
                                           const SdifSignature Sign);

/*DOC:
  Get signature at position index.  
  Returns eEmptySignature if index out of bounds. */
SdifSignature      SdifGetFromSignatureTab(const SdifSignatureTabT* SignTab, 
                                           const int index);

/*DOC:
  Test if signature Sign is in table SignTab. 
  [] Returns Sign if yes, 0 (== eEmptySignature) if no. */
SdifSignature      SdifIsInSignatureTab   (const SdifSignatureTabT *SignTab, 
                                           const SdifSignature Sign);

/*DOC:
  Test if signature Sign is in table SignTab. 
  [] Returns index of Sign if yes, -1 if no. */
int                SdifFindInSignatureTab (const SdifSignatureTabT* SignTab, 
                                           const SdifSignature Sign);






/*
// DATA GROUP:          Stream ID Table and Entries for 1IDS ASCII chunk
*/


SdifStreamIDT* SdifCreateStreamID(SdifUInt4 NumID, char *Source, char *TreeWay);
void           SdifKillStreamID(SdifStreamIDT *StreamID);


/*DOC:
  Create a stream ID table.  <strong>The stream ID table of the SDIF
  file structure is created automatically by SdifFOpen().</strong> 
  It can be obtained by SdifFStreamIDTable(). */
SdifStreamIDTableT* SdifCreateStreamIDTable     (SdifUInt4 HashSize);

/*DOC:
  Deallocate a stream ID table.  <strong>The stream ID table of the SDIF
  file structure is killed automatically by SdifFClose.</strong>  
  It can be obtained by SdifFStreamIDTable. */
void                SdifKillStreamIDTable       (SdifStreamIDTableT *SIDTable);

/*DOC:
  Add an entry to a stream ID table.  The table will be written by
  SdifFWriteAllASCIIChunks.
  [in]  SIDTable pointer to stream ID table, e.g. obtained by SdifFStreamIDTable
  [in]  NumID   stream ID of the frames the stream ID table describes
  [in]  Source  Source identifier for the table (ex. "Chant")
  [in]  TreeWay Routing and parameters, separated by slashes
  [return]
                The stream ID table entry just created and added */
SdifStreamIDT*      SdifStreamIDTablePutSID     (SdifStreamIDTableT *SIDTable,
                                                 SdifUInt4           NumID, 
                                                 char               *Source, 
                                                 char               *TreeWay);

/*DOC:
  Retrieve an entry to a stream ID table.  The table has to have been
  read by SdifFReadAllASCIIChunks.

  [in]  SIDTable pointer to stream ID table, e.g. obtained by 
                 SdifFStreamIDTable
  [in]  NumID    stream ID of the frames the stream ID table describes
  [return]
                 pointer to stream ID table entry, or NULL if no entry for 
                 stream ID NumID exists. */
SdifStreamIDT*      SdifStreamIDTableGetSID     (SdifStreamIDTableT *SIDTable, 
                                                 SdifUInt4           NumID);

/*DOC:
  Return number of entries in stream ID table SIDTable */
SdifUInt4           SdifStreamIDTableGetNbData  (SdifStreamIDTableT *SIDTable);


/*DOC:
  Return stream ID field in stream ID table entry SID */
SdifUInt4           SdifStreamIDEntryGetSID     (SdifStreamIDT *SID);

/*DOC:
  Return source field in stream ID table entry SID */
char               *SdifStreamIDEntryGetSource  (SdifStreamIDT *SID);

/*DOC:
  Return "treeway" field in stream ID table entry SID */
char               *SdifStreamIDEntryGetTreeWay (SdifStreamIDT *SID);




/*
//FUNCTION GROUP: Sdif String Handling
*/

/* SdifString.h */

/* Function declaration */

/*DOC:
  Make a memory allocation for a SdifStringT structure.
*/
SdifStringT * SdifStringNew(void);


/*DOC:
  Free memory allocated for SdifString.
*/
void SdifStringFree(SdifStringT * SdifString);


/*DOC:
  Append a string to another one.
  Manage memory reallocation.
  [Return] a boolean for the succes of the function's call.
*/
int SdifStringAppend(SdifStringT * SdifString, const char *strToAppend);


/*DOC:
  Read the current char (= fgetc).
*/
int SdifStringGetC(SdifStringT * SdifString);


/*DOC:
  Equivalent of ungetc: put one character back into string, clear EOS condition
*/
int SdifStringUngetC(SdifStringT * SdifString);


/*DOC:
  Test the end of the string (= feof)
*/
int SdifStringIsEOS(SdifStringT *SdifString);



/*
typedef enum SdifInterpretationErrorE
{
  eTypeDataNotSupported= 300,
  eNameLength,
  eReDefined,
  eUnDefined,
  eSyntax,
  eRecursiveDetect,
  eBadTypesFile,
  eBadType,
  eBadHeader,
  eOnlyOneChunkOf,
  eUnInterpreted,
  eUserDefInFileYet,
  eBadMode,
  eBadStdFile,
  eBadNbData,
  eReadWriteOnSameFile
} SdifInterpretationErrorET;



void
SdifInterpretationError(SdifInterpretationErrorET Error, SdifFileT* SdifF, const void *ErrorMess);

#define _SdifFileMess(sdiff, error, mess) \
(SdifErrorFile = __FILE__, SdifErrorLine = __LINE__, SdifInterpretationError((error), (sdiff),(mess)))

*/

#define _SdifFileMess(sdiff, error, mess) 

/*DOC: 
  Cette fonction v�rifie si le type de matrice est r�pertori�
  dans SdifF.<br> S'il ne l'est pas, alors elle v�rifie si c'est un
  type pr�d�finis. S'il est pr�d�fini, elle cr�e le lien de SdifF vers
  le type pr�d�fini. Sinon, elle envoie un message sur l'erreur
  standart.  */
SdifMatrixTypeT* SdifTestMatrixType (SdifFileT *SdifF, SdifSignature Signature);
SdifFrameTypeT*  SdifTestFrameType  (SdifFileT *SdifF, SdifSignature Signature);



int SdifFTestMatrixWithFrameHeader (SdifFileT* SdifF);
int SdifFTestDataType              (SdifFileT* SdifF);
int SdifFTestNbColumns             (SdifFileT* SdifF);
int SdifFTestNotEmptyMatrix        (SdifFileT* SdifF);
int SdifFTestMatrixHeader          (SdifFileT* SdifF);



SdifColumnDefT*  SdifTestColumnDef (SdifFileT *SdifF, SdifMatrixTypeT *MtrxT, char *NameCD);
SdifComponentT*  SdifTestComponent (SdifFileT* SdifF, SdifFrameTypeT *FramT, char *NameCD);

int SdifTestSignature            (SdifFileT *SdifF, int CharEnd, SdifSignature Signature, char *Mess);
int SdifTestCharEnd              (SdifFileT *SdifF, int CharEnd, char MustBe,
                                           char *StringRead, int ErrCondition, char *Mess);


int SdifTestMatrixTypeModifMode  (SdifFileT *SdifF, SdifMatrixTypeT *MatrixType);
int SdifTestFrameTypeModifMode   (SdifFileT *SdifF, SdifFrameTypeT *FrameType);



size_t SdifFTextConvMatrixData     (SdifFileT *SdifF);
size_t SdifFTextConvMatrix         (SdifFileT *SdifF);
size_t SdifFTextConvFrameData      (SdifFileT *SdifF);
size_t SdifFTextConvFrameHeader    (SdifFileT *SdifF);
size_t SdifFTextConvFrame          (SdifFileT *SdifF);
size_t SdifFTextConvAllFrame       (SdifFileT *SdifF);
size_t SdifFTextConvFramesChunk    (SdifFileT *SdifF);
size_t SdifFTextConv               (SdifFileT *SdifF);

/* upper level : open the text in read mode */

/*DOC: 
  Converti un fichier SDIF ouvert en lecture (eReadFile) en un fichier
  texte pseudo-SDIF de nom TextStreamName.  */
size_t SdifTextToSdif (SdifFileT *SdifF, char *TextStreamName);




/* SdifFPrint */

size_t SdifFPrintGeneralHeader      (SdifFileT *SdifF);
size_t SdifFPrintNameValueLCurrNVT  (SdifFileT *SdifF);
size_t SdifFPrintAllNameValueNVT    (SdifFileT *SdifF);
size_t SdifFPrintAllType            (SdifFileT *SdifF);
size_t SdifFPrintAllStreamID        (SdifFileT *SdifF);
size_t SdifFPrintAllASCIIChunks     (SdifFileT *SdifF);
size_t SdifFPrintMatrixHeader       (SdifFileT *SdifF);
size_t SdifFPrintFrameHeader        (SdifFileT *SdifF);
size_t SdifFPrintOneRow             (SdifFileT *SdifF);

size_t SdifFPrintMatrixType         (SdifFileT *SdifF, SdifMatrixTypeT *MatrixType);
size_t SdifFPrintFrameType          (SdifFileT *SdifF, SdifFrameTypeT  *FrameType);

/* SdifFPut */

int SdifFAllFrameTypeToSdifString   (SdifFileT *SdifF, SdifStringT *SdifString);
int SdifFAllMatrixTypeToSdifString  (SdifFileT *SdifF, SdifStringT *SdifSTring);

#ifdef __cplusplus
}
#endif

#endif /* _SDIF_H */
