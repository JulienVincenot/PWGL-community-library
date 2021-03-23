/* $Id: SdifFRead.h,v 1.2 2000/10/27 20:02:57 roebel Exp $
 *
 *               Copyright (c) 1998 by IRCAM - Centre Pompidou
 *                          All rights reserved.
 *
 *  For any information regarding this and other IRCAM software, please
 *  send email to:
 *                            manager@ircam.fr

LIBRARY
 * SdifFRead.h
 *
 * F : SdifFileT* SdifF, Read : binary read (SdifF->Stream)
 *
 * author: Dominique Virolle 1997

LOG
 * $Log: SdifFRead.h,v $
 * Revision 1.2  2000/10/27 20:02:57  roebel
 * autoconf merged back to main trunk
 *
 * Revision 1.1.2.1  2000/08/21  17:47:59  tisseran
 * *** empty log message ***
 *
 * Revision 3.6  2000/07/18  15:08:33  tisseran
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
 * Revision 3.5  2000/05/15  16:23:07  schwarz
 * Avoided avoidable warnings.
 *
 * Revision 3.4  2000/03/01  11:19:58  schwarz
 * Assert Padding, added SdifFReadAndIgnore.
 * SdiffSetPos checks for pipe and then uses SdifFReadAndIgnore to seek forward.
 *
 * Revision 3.3  1999/09/28  13:08:54  schwarz
 * Included #include <preincluded.h> for cross-platform uniformisation,
 * which in turn includes host_architecture.h and SDIF's project_preinclude.h.
 *
 * Revision 3.2  1999/08/25  18:32:34  schwarz
 * Added cocoon-able comments with sentinel "DOC:" (on a single line).
 *
 * Revision 3.1  1999/03/14  10:56:44  virolle
 * SdifStdErr add
 *
 * Revision 2.3  1999/01/23  15:55:43  virolle
 * add querysdif.dsp, delete '\r' chars from previous commit
 *
 * Revision 2.2  1999/01/23  13:57:28  virolle
 * General Lists, and special chunk preparation to become frames
 *
 * Revision 2.1  1998/12/21  18:27:11  schwarz
 * Inserted copyright message.
 *
 * Revision 2.0  1998/11/29  11:41:34  virolle
 * - New management of interpretation errors.
 * - Alignement of frames with CNMAT (execpt specials Chunk 1NVT, 1TYP, 1IDS).
 * _ Sdif Header File has a Sdif format version.
 * - Matrices order in frames is not important now. (only one occurence of
 *   a Matrix Type in a Frame Type declaration )
 * - Hard coded predefined types more dynamic management.
 * - Standart streams (stdin, stdout, stderr) set as binary for Windows32 to
 *   have exactly the same result on each plateforme.
 *
 * Revision 1.2  1998/11/10  15:31:42  schwarz
 * Removed all 'extern' keywords for prototypes, since this is redundant
 * (function prototypes are automatically linked extern), and it
 * prohibits cocoon from generating an entry in the HTML documentation
 * for this function.
 */


#ifndef _SdifFRead_
#define _SdifFRead_

#include "SdifGlobals.h"
#include "SdifFileStruct.h"
#include <stdio.h>
#include "SdifMatrix.h"
#include "SdifFrame.h"
#include "SdifFGet.h"

#include "SdifString.h" /* Need for SdifStringT definition */

/*DOC: 
  Lit l'ent�te du fichier, c'est � dire 'SDIF' puis 4 bytes.  affiche
  un message en cas de non reconnaissance du format.  */
size_t SdifFReadGeneralHeader    (SdifFileT *SdifF);

size_t SdifFReadChunkSize        (SdifFileT *SdifF);
size_t SdifFReadNameValueLCurrNVT(SdifFileT *SdifF);
size_t SdifFReadAllType          (SdifFileT *SdifF);
size_t SdifFReadAllStreamID      (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de lire tous les Chunk ASCII qui se
  trouveraient en d�but de fichier juste apr�s l'ent�te g�n�rale. Elle
  s'arr�te lorsqu'elle ne reconna�t pas la signature de chunk comme un
  ASCII Chunk. Cette signature est donc normalement celle d'un
  frame. Elle est stock�e dans SdifF->CurrSignature. <strong>Il n'est
  donc pas n�cessaire de la relire</strong>.  */
size_t SdifFReadAllASCIIChunks   (SdifFileT *SdifF);

/*DOC: 
  Cette fonction lit une ent�te de matrice <strong>signature
  incluse</strong>.  Elle v�rifie le type de matrice, le champ
  DataType. Toute les donn�es se trouvent stock�es dans
  SdifF->CurrMtrxH. La plupart de ses champs sont directement
  accessible par les fonctions ind�pendantes du mode d'ouverture du
  fichier.  <strong>Elle effectue une mise � jour de l'allocation
  m�moire de SdifF->CurrOneRow en fonction des param�tres de l'ent�te
  de matrice.</strong> Ainsi, on est normalement pr�s pour lire chaque
  ligne de la matrice courrante.  */
size_t SdifFReadMatrixHeader     (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de lire 1 ligne de matrice. Les donn�es lues
  sont stock�es dans SdifF->CurrOneRow (jusqu'� une prochaine lecture
  d'ent�te de matrice qui r�initialise ses param�tres).  */
size_t SdifFReadOneRow           (SdifFileT *SdifF);

/*DOC: 
  Cette fonction lit l'ent�te d'un frame � partir de la taille et
  jusqu'au temps. Donc <strong>elle ne lit pas la signature</strong>
  mais donne � SdifF->CurrFramH->Signature la valeur de
  SdifF->CurrSignature.  La lecture doit se faire avant, avec
  SdifFGetSignature.  */
size_t SdifFReadFrameHeader      (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de passer une matrice toute enti�re ent�te
  incluse. Elle est utile lorsque qu'un frame contient plus de
  matrices que le programme lecteur n'en conna�t. Il peut ainsi les
  passer pour retomber sur un autre frame.  */
size_t SdifSkipMatrix            (SdifFileT *SdifF);

/*DOC: 
  Cette fonction permet de passer une matrice mais apr�s la lecture de
  l'ent�te. On s'en sert lorsque le type de matrice est mauvais,
  inconnu, non interpr�table par le programme lecteur.

  Note:  The matrix padding is skipped also. */
size_t SdifSkipMatrixData        (SdifFileT *SdifF);

/*DOC: 
  Cette fonction � le m�me sens que SdifSkipMatrixData mais pour les
  frames. Il faut donc pour l'utiliser avoir au pr�alable lu la
  signature et l'ent�te.  */
size_t SdifSkipFrameData         (SdifFileT *SdifF);

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
size_t SdifFReadUndeterminatedPadding (SdifFileT *SdifF);

/*DOC:
  Read and throw away <i>num</i> bytes from the file. */
size_t SdifFReadAndIgnore (SdifFileT *SdifF, size_t bytes);

size_t SdifFReadOneMatrixType    (SdifFileT *SdifF);
size_t SdifFReadOneFrameType     (SdifFileT *SdifF);

/*DOC:
  Function to read text matrix.
  Read header.
  Read data.
  Read padding.
*/
size_t SdifFReadTextMatrix(SdifFileT *SdifF, SdifStringT *SdifString);

/*DOC:
  Function to read text matrix data.
  Make reallocation.
  Read data.
  Read padding.
*/
size_t SdifFReadTextMatrixData(SdifFileT *SdifF, SdifStringT *SdifString);

/*
 * obsolete
 */
size_t SdifFReadNameValueCurrHT  (SdifFileT *SdifF);

#endif /* _SdifFRead_ */
