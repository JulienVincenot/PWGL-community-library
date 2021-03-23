/* $Id: querysdif.c,v 1.11 2006/05/05 10:31:40 schwarz Exp $
 
                Copyright (c) 1998 by IRCAM - Centre Pompidou
                           All rights reserved.
 
   For any information regarding this and other IRCAM software, please
   send email to:
                             sdif@ircam.fr
 

   querysdif.c		10.12.1998	Diemo Schwarz
   
   View summary of data in an SDIF-file.  
   

   $Log: querysdif.c,v $
   Revision 1.11  2006/05/05 10:31:40  schwarz
   exit on invalid sdif header

   Revision 1.10  2006/05/03 15:46:51  schwarz
   added brief output option

   Revision 1.9  2004/06/03 11:34:17  schwarz
   Enable profiling compilation.
   Don't read padding when skipping matrices!

   Revision 1.8  2003/11/07 22:12:45  roebel
   Removed XpGuiCalls remainings.

   Revision 1.7  2003/11/07 21:47:19  roebel
   removed XpGuiCalls.h and replaced preinclude.h  by local files

   Revision 1.6  2003/06/04 20:32:25  schwarz
   Finally: do statistics about matrix sizes.

   Revision 1.5  2002/05/24 19:41:51  ftissera
   Change code to be compatible with C++

   Revision 1.4  2000/12/06 13:43:43  lefevre
   Mix HostArchiteture and AutoConfigure mechanisms

   Revision 1.3  2000/11/16  12:02:23  lefevre
   no message
  
   Revision 1.2  2000/11/15  14:53:40  lefevre
   no message
  
   Revision 1.1  2000/10/30  14:44:03  roebel
   Moved all tool sources into central tools directory and added config.h to sources
  
   Revision 1.2  2000/10/27  20:04:18  roebel
   autoconf merged back to main trunk
  
   Revision 1.1.2.3  2000/08/21  18:48:49  tisseran
   Use SdifFSkipFrameData
  
   Revision 1.1.2.2  2000/08/21  16:42:12  tisseran
   *** empty log message ***
  
   Revision 1.1.2.1  2000/08/21  13:42:24  tisseran
   *** empty log message ***
  
   Revision 3.2  1999/06/18  16:20:28  schwarz
   In SigEqual: SdifSignatureCmpNoVersion (s, sigs [i].sig) dropped LAST byte
   on alpha (this is fixed now), and anyway, we want to compare the whole sig.

   Revision 3.1  1999/03/14  10:56:24  virolle
   SdifStdErr add

   Revision 1.3  1999/02/28  12:16:31  virolle
   memory report

   Revision 1.2  1998/12/21  18:26:54  schwarz
   Inserted copyright message.

   Revision 1.1  1998/12/10  18:55:40  schwarz
   Added utility program querysdif to view the summary of data in
   an SDIF-file.
*/


#include "sdif_portability.h"

#include "sdif.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void usage (void)
{
    fprintf (SdifStdErr, "\nquerysdif, %s\n\n", VERSION);
    SdifPrintVersion();
    fprintf (SdifStdErr, "\n"
"Usage: querysdif [options] [sdif-file]\n"
"\n"
"Options:\n"
"	-a	view ASCII chunks\n"
"	-d	view data\n"
"	-b	view data brief (output in SDIF selection syntax)\n"
/* todo:
"	-n	view NVTs (name value tables)\n"
"	-T	view type declarations in sdif-file\n"
"	-D	view all type declarations in effect\n"
"	-s	view stream id table\n"
*/
"	-t <sdif types file>  specify file with additional sdif types\n"
"	-h	this help\n"
"\n"
"View summary of data in an SDIF-file.  Per default, all ASCII chunks are\n"
"printed, followed by a count of the frames and the matrices occuring in\n"
"the file.\n"
"\n");

    exit(1);
}


typedef struct
{ 
    float min, max;
} minmax;

#define initminmax(m)	((m).min = FLT_MAX, (m).max = FLT_MIN)
#define minmax(m, v)	{ if ((v) < (m).min)   (m).min = (v); \
			  if ((v) > (m).max)   (m).max = (v); }


/* Count occurence of signatures as frame or matrix under
   different parent frames. */
#define	MaxSignatures	1024
int	nsig	  = 0;

struct TwoLevelTree 
{
    /* common fields */
    SdifSignature sig;
    int	      count;
    int	      parent;	/* 0 for frames, index to parent frame for matrices */

    /* frame fields */
    int	      stream;
    minmax    time, nmatrix;

    /* matrix fields */
    minmax    ncol, nrow;

}   sigs [MaxSignatures];


int SigEqual (SdifSignature s, int parent, int stream, int i)
{
    return sigs [i].sig    == s
       &&  sigs [i].stream == stream
       &&  sigs [i].parent == parent;
}

int GetSigIndex (SdifSignature s, int parent, int stream)
{
    int i = 0;
    
    while (i < nsig  &&  !SigEqual (s, parent, stream, i))
	i++;

    if (i == nsig)
    {   /* add new signature */
	if (nsig >= MaxSignatures)
	{
	    fprintf (SdifStdErr, "Too many different signatures, "
		     "can't handle more than %d!\n", MaxSignatures);
	    exit (1);
	}

	sigs [i].sig    = s;
	sigs [i].parent = parent;
	sigs [i].stream = stream;
	sigs [i].count  = 0;
	initminmax(sigs [i].time);
	initminmax(sigs [i].nmatrix);
	initminmax(sigs [i].ncol);
	initminmax(sigs [i].nrow);

	nsig++;
    }

    return (i);
}

int CountFrame (SdifSignature s, int stream, float time, int nmatrix)
{
    int i = GetSigIndex (s, -1, stream);

    sigs [i].count++;
    minmax(sigs [i].time,    time);
    minmax(sigs [i].nmatrix, nmatrix);

    return (i);
}

void CountMatrix (SdifSignature s, int parent, int nrow, float ncol)
{
    int i = GetSigIndex (s, parent, -1);

    sigs [i].count++;
    minmax(sigs [i].nrow, nrow);
    minmax(sigs [i].ncol, ncol);
}


/*--------------------------------------------------------------------------*/
/*	KERmain / main															*/
/*--------------------------------------------------------------------------*/

#if HOST_OS_MAC

int KERmain(int argc, char** argv);
int KERmain(int argc, char** argv)

#else

int main(int argc, char** argv);
int main(int argc, char** argv)

#endif
{
    int		i, m, eof = 0;
    size_t	bytesread = 0, nread = 0;
    SdifFileT	*in;
    int         result;

    /* arguments with default values */
    char	*infile   = NULL, 
		*types	  = NULL;
    int		vall	  = 1,
 		vascii	  = 0,
		vdata	  = 0,
		vbrief	  = 0,
		vnvt	  = 0,
		vtypes	  = 0,
		valltypes = 0,
		vstream	  = 0;


    SdifStdErr = stderr;
    for (i = 1; i < argc; i++)
    {
	if (argv [i][0] == '-')
	{
	    char *arg = argv [i] + 1;

	    while (*arg)
		switch (*arg++)
		{
		  case 'a': vall = 0;  vascii    = 1;  break;
		  case 'd': vall = 0;  vdata     = 1;  break;
		  case 'b': vall = 0;  vdata = vbrief = 1;  break;
/* todo:	  case 'n': vall = 0;  vnvt      = 1;  break;
		  case 'T': vall = 0;  vtypes    = 1;  break;
		  case 'D': vall = 0;  valltypes = 1;  break;
		  case 's': vall = 0;  vstream   = 1;  break;
*/		  case 't': /* no arg after last option, complain */
			    if (i == argc - 1)   
				usage ();
			    types = argv [++i];	       break;
		  default :  usage();		       break;
		}
	}
	else if (!infile)
	    infile = argv [i];
	else
	    usage();
    }


    /* do inits, open files */
    if (!types)
    {
	char types2[2] = "";
	SdifGenInit (types2);
    }
    else
    {
	SdifGenInit (types);
    }

    if (!infile)   
    	infile  = "stdin";

    if (!(in = SdifFOpen (infile, eReadFile)))
    {
	fprintf (SdifStdErr, "Can't open input file %s.\n", infile);
        SdifGenKill ();
        exit (1);
    }
    in->TextStream = stdout;	/* SdifFPrint* functions need this */

    if ((nread = SdifFReadGeneralHeader(in)) == 0)
    {
        SdifGenKill ();
	exit(1);
    }
    
    bytesread += SdifFReadAllASCIIChunks (in) + nread;
    eof = SdifFCurrSignature(in) == eEmptySignature;

    if (vall || vascii)
    {
	printf ("Ascii chunks of file %s:\n\n", infile);
	SdifFPrintGeneralHeader(in);
	SdifFPrintAllASCIIChunks(in);
    }

    if (vall || vdata)
    {
	/* 
	 * read, count frame loop 
	 */

	while (!eof)
	{
	    int frameidx;

	    /* Read frame header.  Current signature has already been read
	       by SdifFReadAllASCIIChunks or the last loop.) */
	    bytesread += SdifFReadFrameHeader (in);

	    /* count frame */
	    frameidx = CountFrame (SdifFCurrSignature(in), SdifFCurrID(in),
				   SdifFCurrTime(in), SdifFCurrNbMatrix(in));

	    /* for matrices loop */
	    for (m = 0; m < SdifFCurrNbMatrix (in); m++)
	    {
		int nbrows, nbcols;

		/* Read matrix header */
		bytesread += SdifFReadMatrixHeader (in);

		/* count matrix and do statistics about rows/columns */
		CountMatrix (SdifFCurrMatrixSignature (in), frameidx, 
			     SdifFCurrNbRow (in), SdifFCurrNbCol (in));

		/* We're not actually interested in the matrix data, 
		   so we skip it.  */
		bytesread += SdifFSkipMatrixData (in);
	    }   /* end for matrices */

	    eof = SdifFGetSignature (in, &bytesread) == eEof;
	}   /* end while frames */ 


	/* 
	 * print results 
	 */
	if (vbrief)
	{   /* brief selection-syntax output without counts */
	    for (i = 0; i < nsig; i++)
	    {
		if (sigs[i].parent == -1)
		{   /* search children matrices of this frame */
		    for (m = 0; m < nsig; m++)
		    {
			if (sigs[m].parent == i)
			    printf ("#%d:%s/%s@%f-%f\n", 
				    sigs[i].stream,
				    SdifSignatureToString (sigs[i].sig),
				    SdifSignatureToString (sigs[m].sig),
				    sigs[i].time.min,
				    sigs[i].time.max);
		    }
		} 
	    }
	}
	else
	{
	    printf ("Data in file %s (%d bytes):\n", infile, bytesread);

	    for (i = 0; i < nsig; i++)
	    {
		if (sigs [i].parent == -1)
		{   /* frames */
		    printf ("%5d %s frames in stream %d between time %f and %f containing\n", 
			    sigs [i].count, 
			    SdifSignatureToString (sigs [i].sig),
			    sigs [i].stream,
			    sigs [i].time.min,
			    sigs [i].time.max);

		    /* search children matrices of this frame */
		    for (m = 0; m < nsig; m++)
		    {
			if (sigs [m].parent == i)
			    printf ("   %5d %s matrices with %3g --%3g rows, %3g --%3g columns\n",
				    sigs [m].count, 
				    SdifSignatureToString (sigs [m].sig),
				    sigs [m].nrow.min,
				    sigs [m].nrow.max,
				    sigs [m].ncol.min,
				    sigs [m].ncol.max);
		    }
		}
	    }
	    printf ("\n");
	}
    }

    /* check for error */
    if (SdifFLastError(in) == NULL)
	result = 0;
    else
	result = 1;

    /* cleanup */
    SdifFClose (in);
    SdifGenKill ();

    return result;
}    
