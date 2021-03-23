/* $Id: SdifFWrite.h,v 1.2 2000/10/27 20:02:58 roebel Exp $
 *
 *               Copyright (c) 1998 by IRCAM - Centre Pompidou
 *                          All rights reserved.
 *
 *  For any information regarding this and other IRCAM software, please
 *  send email to:
 *                            manager@ircam.fr
 *
 *
LIBRARY
 * SdifFWrite.h
 *
 * F : SdifFileT* SdifF, Write : sdif file write (SdifF->Stream)
 *
 *
 * author: Dominique Virolle 1997
 *
EXAMPLE

L'exemple suivant essaye de montrer l'ordonnancement des appels
de fonction. Biens�r ce code devrait �tre plus modulaire. En effet,
il devrait y avoir une fonction par niveau structurel d'�criture:
une(plus) fonction(s) d'�criture de matrice, une(plus fonction(s)
d'�criture de frame...

<pre>
#include "sdif.h"

void main(void)
{
  SdifFileT   *SdifF;
  SdifUInt4    NbMatrix = 3;
  SdifUInt4    NumID = 0;
  SdifFloat8   Time = 0.0;
  SdifFloat4   TabValue[] = {1,2,3,4,5,6,7};
  SdifFloat4  *pTabValue;
  size_t       SizeFrameW;
  size_t       SizeMatrixW;

  pTabValue = TabValue; // pour permettre le cast par pointeur 

  SdifGenInit("SdifTypes.STYP");

  SdifF = SdifOpenFile("NewFile.sdif",      eWriteFile);


  // remplir les tables NameValues, MatrixTypesTable,
  // FrameTypesTable et StreamIDsTable.
   
  [ ..... ]

  // �criture de l'ent�te 
  SdifFWriteGeneralHeader (SdifF);
  // �criture des chunks ASCII 
  SdifFWriteAllASCIIChunks (SdifF)


  // ***FRAME HEADER****
  // Mise � jour le l'ent�te de frame � �crire 
  SdifSetCurrFrameHeader (SdifF, '1FOB', _SdifUnknownSize, NbMatrix, NumID, Time);
  // �criture de l'ent�te de frame 
  SizeFrameW = SdifFWriteFrameHeader (SdifF);


  // ***FIRST MATRIX**
  // Mise � jour le l'ent�te de matrice � �crire : 1 ligne, 1 colonne
  SdifSetCurrMatrixHeader (SdifF, '1FQ0', eFloat4, 1, 1);
  // �criture de l'ent�te de frame 
  SizeMatrixW = SdifFWriteMatrixHeader (SdifF);

  // Mise � jour de la ligne-buffer de SdifF
  // La largeur des donn�es est conserv�e par le eFloat4 de l'ent�te de matrice
  SdifSetCurrOneRow (SdifF, (void*) pTabValue);
  // �criture de la ligne 
  SizeMatrixW += SdifFWriteOneRow (SdifF);
  // Si on a d'autres lignes � �crire alors
  // on r�pette SdifSetCurrOneRow et SizeMatrixW += SdifFWriteOneRow...

  // �criture du Padding en fin de matrice et ajout de la taille de la matrice �crite
  // � la taile du frame.
   
  SizeMatrixW += SdifFWritePadding(SdifF,
                       SdifFPaddingCalculate(SdifF->Stream, SizeMatrixW))  
  SizeFrameW += SizeMatrixW;


  // * MATRIX 2 & 3
  [. 2 matrices � �crire
   .
   .]

   
  // pas de padding en fin de frame car on est d�j� align� 

  // la taille �crite ne doit pas compter la signature et la taille===> -8 
  SizeFrameW -= 8;
  SdifFUpdateChunkSize(SdifF, SizeFrameW);

  SdifCloseFile(SdifF);

  SdifGenKill();
}
</pre>

LOG
 * $Log: SdifFWrite.h,v $
 * Revision 1.2  2000/10/27 20:02:58  roebel
 * autoconf merged back to main trunk
 *
 * Revision 1.1.2.1  2000/08/21  17:48:01  tisseran
 * *** empty log message ***
 *
 * Revision 3.7  2000/07/18  15:08:35  tisseran
 * This release implements the New SDIF Specification (june 1999):
 * - Name Values Table are written in a 1NVT frame which contains a 1NVT matrix
 * - Frame and matrix type declaration are written in a 1TYP frame which contains a 1TYP matrix.
 * - Stream ID are written in a 1IDS frame which contains a 1IDS matrix.
 *
 * Read function accept the previous version of the specification (read a text frame without matrix) to be compatible with older SDIF files.
 *
 * SdifString.h and SdifString.c implements some string mangement (creation, destruction, append, test of end of string, getc, ungetc).
 *
 * WATCH OUT:
 *      We don't care about the old SDIF Specification (_SdifFormatVersion < 3)
 * To use _SdifFormatVersion < 3, get the previous release.
 *
 * Revision 3.6  2000/05/10  15:32:13  schwarz
 * Added functions to calculate the Size argument for SdifFSetCurrFrameHeader:
 * SdifSizeOfFrameHeader and SdifSizeOfMatrix
 *
 * Revision 3.5  2000/04/11  14:31:57  schwarz
 * SdifFWriteTextMatrix
 *
 * Revision 3.4  2000/03/01  11:19:46  schwarz
 * Added functions for matrix-wise writing:  SdifUpdateFrameHeader,
 * SdifFWriteMatrixData, SdifFWriteMatrix, SdifFWriteFrameAndOneMatrix
 *
 * Revision 3.3  1999/09/28  13:08:56  schwarz
 * Included #include <preincluded.h> for cross-platform uniformisation,
 * which in turn includes host_architecture.h and SDIF's project_preinclude.h.
 *
 * Revision 3.2  1999/08/25  18:32:35  schwarz
 * Added cocoon-able comments with sentinel "DOC:" (on a single line).
 *
 * Revision 3.1  1999/03/14  10:56:48  virolle
 * SdifStdErr add
 *
 * Revision 2.3  1999/01/23  15:55:47  virolle
 * add querysdif.dsp, delete '\r' chars from previous commit
 *
 * Revision 2.2  1999/01/23  13:57:31  virolle
 * General Lists, and special chunk preparation to become frames
 *
 * Revision 2.1  1998/12/21  18:27:14  schwarz
 * Inserted copyright message.
 *
 * Revision 2.0  1998/11/29  11:41:39  virolle
 * - New management of interpretation errors.
 * - Alignement of frames with CNMAT (execpt specials Chunk 1NVT, 1TYP, 1IDS).
 * _ Sdif Header File has a Sdif format version.
 * - Matrices order in frames is not important now. (only one occurence of
 *   a Matrix Type in a Frame Type declaration )
 * - Hard coded predefined types more dynamic management.
 * - Standart streams (stdin, stdout, stderr) set as binary for Windows32 to
 *   have exactly the same result on each plateforme.
 *
 * Revision 1.2  1998/11/10  15:31:44  schwarz
 * Removed all 'extern' keywords for prototypes, since this is redundant
 * (function prototypes are automatically linked extern), and it
 * prohibits cocoon from generating an entry in the HTML documentation
 * for this function.
 *
 */


#ifndef _SdifFWrite_
#define _SdifFWrite_

#include "SdifGlobals.h"
#include "SdifFileStruct.h"

#include <stdio.h>
#include "SdifNameValue.h"
#include "SdifMatrixType.h"
#include "SdifFrameType.h"
#include "SdifMatrix.h"
#include "SdifFrame.h"

#include "SdifString.h"
 

/*
//FUNCTION GROUP:	Writing Header and Init-Frames
*/

/*DOC: 
  �crit sur le fichier 'SDIF' puis 4 bytes chunk size.  */
size_t  SdifFWriteGeneralHeader   (SdifFileT *SdifF);

size_t  SdifFWriteChunkHeader     (SdifFileT *SdifF, SdifSignature ChunkSignature, size_t ChunkSize);
size_t  SdifFWriteNameValueLCurrNVT (SdifFileT *SdifF);
size_t  SdifFWriteAllNameValueNVT   (SdifFileT *SdifF);


size_t  SdifFWriteOneNameValue    (SdifFileT *SdifF, SdifNameValueT  *NameValue);
size_t  SdifFWriteOneMatrixType   (SdifFileT *SdifF, SdifMatrixTypeT *MatrixType);
size_t  SdifFWriteOneComponent    (SdifFileT *SdifF, SdifComponentT  *Component);
size_t  SdifFWriteOneFrameType    (SdifFileT *SdifF, SdifFrameTypeT  *FrameType);
size_t  SdifFWriteOneStreamID     (SdifFileT *SdifF, SdifStreamIDT   *StreamID);



size_t  SdifFWriteAllMatrixType   (SdifFileT* SdifF);
size_t  SdifFWriteAllFrameType    (SdifFileT *SdifF);
size_t  SdifFWriteAllType         (SdifFileT *SdifF);

/*DOC:
  Remark:
         This function implements the new SDIF Specification (June 1999):
	 Name Value Table, Matrix and Frame Type declaration, Stream ID declaration are
	 defined in text matrix:
	 1NVT 1NVT
	 1TYP 1TYP
	 1IDS 1IDS
  Removed test for _SdifFormatVersion
  Now we write type in 1IDS frame which contains a 1IDS matrix
*/
size_t  SdifFWriteAllStreamID     (SdifFileT *SdifF);

/*DOC: 
  �crit tous les chunks ASCII. C'est � dire: les tables de names
  values, les types cr��s ou compl�t�s, et les Stream ID. Il faut donc
  au pr�alable avoir rempli compl�tement les tables avant de la
  lancer. Cette fonction de peut donc pas �tre executer une 2nd fois
  durant une �criture.  */
size_t  SdifFWriteAllASCIIChunks  (SdifFileT *SdifF);




/*
//FUNCTION GROUP:	Writing Matrices
*/

/*DOC: 
  Apr�s avoir donner une valeur � chaque champ de SdifF->CurrMtrxH
  gr�ce � la fonction SdifFSetCurrMatrixHeader, SdifFWriteMatrixHeader
  �crit toute l'ent�te de la matrice.  Cette fonction r�alise aussi
  une mise � jour de SdifF->CurrOneRow, tant au niveau de l'allocation
  m�moire que du type de donn�es.  */
size_t  SdifFWriteMatrixHeader    (SdifFileT *SdifF);

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
size_t SdifFWriteMatrixData (SdifFileT *SdifF, void *Data);

/*DOC:
  Write whole matrix: header, data, and padding.
  Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
  row-major order. */
size_t SdifFWriteMatrix (SdifFileT     *SdifF,
			 SdifSignature  Signature,
			 SdifDataTypeET DataType,
			 SdifUInt4      NbRow,
			 SdifUInt4      NbCol,
			 void	       *Data);

/*DOC:
  Write a matrix with datatype text (header, data, and padding).
  Data points to Length bytes(!) of UTF-8 encoded text.  Length
  includes the terminating '\0' character!!!  That is, to write a
  C-String, use SdifFWriteTextMatrix (f, sig, strlen (str) + 1, str);
  to include it. */
size_t SdifFWriteTextMatrix (SdifFileT     *SdifF,
			     SdifSignature  Signature,
			     SdifUInt4      Length,
			     char	   *Data);

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
//FUNCTION GROUP:	Writing Frames
*/

/*DOC: 
  Apr�s avoir donner une valueur � chaque champ de SdifF->CurrFramH
  gr�ce � la fonction SdifFSetCurrFrameHeader, SdifFWriteFrameHeader
  �crit toute l'ent�te de frame.  Lorsque la taille est inconnue au
  moment de l'�criture, donner la valeur _SdifUnknownSize. Ensuite,
  compter le nombre de bytes �crit dans le frame et r�aliser un
  SdifUpdateChunkSize avec la taille calcul�e.  */
size_t  SdifFWriteFrameHeader     (SdifFileT *SdifF);

/*DOC: 
  Execute un retour fichier de ChunkSize bytes et l'�crit, donc on
  �crase la taille du chunk ou du frame.  Dans le cas o� le fichier
  est stderr ou stdout, l'action n'est pas r�alis�e.  */
void    SdifUpdateChunkSize       (SdifFileT *SdifF, size_t ChunkSize);

/*DOC: 
  Rewrite given frame size and number of matrices in frame header.
  Return -1 on error or if file is not seekable (stdout or stderr). */
int     SdifUpdateFrameHeader	  (SdifFileT *SdifF, size_t ChunkSize, 
				   SdifInt4 NumMatrix);

/*DOC:
  Write a whole frame containing one matrix: 
  frame header, matrix header, matrix data, and padding.
  Data points to NbRow * NbCol * SdifSizeofDataType (DataType) bytes in
  row-major order. 

  This function has the big advantage that the frame size is known in
  advance, so there's no need to rewind and update after the matrix
  has been written.  */
size_t  SdifFWriteFrameAndOneMatrix (SdifFileT	    *SdifF,
				     SdifSignature  FrameSignature,
				     SdifUInt4      NumID,
				     SdifFloat8     Time,
				     SdifSignature  MatrixSignature,
				     SdifDataTypeET DataType,
				     SdifUInt4      NbRow,
				     SdifUInt4      NbCol,
				     void	    *Data);


/*DOC:
  Return (constant) size of frame header after signature and size field. 
  Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
size_t SdifSizeOfFrameHeader (void);

/*DOC:
  Return size of matrix (header, data, padding).
  Use this to calculate the Size argument for SdifFSetCurrFrameHeader. */
size_t SdifSizeOfMatrix (SdifDataTypeET DataType,
			 SdifUInt4      NbRow,
			 SdifUInt4      NbCol);

/*DOC:
  Write a text matrix using a string.
  Return number of bytes written.
*/
size_t SdifFWriteTextFrame(SdifFileT     *SdifF,
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
size_t SdifFWriteTextFrameSdifString(SdifFileT     *SdifF,
				     SdifSignature FrameSignature,
				     SdifUInt4     NumID,
				     SdifFloat8    Time,
				     SdifSignature MatrixSignature,
				     SdifStringT   *SdifString);


/*
 * obsolete
 */
size_t  SdifFWriteNameValueCurrHT (SdifFileT *SdifF);
size_t  SdifFWriteAllNameValueHT  (SdifFileT *SdifF);

#endif /* _SdifFWrite_ */

