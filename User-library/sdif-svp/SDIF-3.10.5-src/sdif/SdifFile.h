
SdifMatrixTypeT *SdifFGetMatrixType(SdifFileT *file, SdifSignature sig);


SdifFrameTypeT* SdifFGetFrameType(SdifFileT *file, SdifSignature sig);


/*
// FUNCTION GROUP:	Error flag for file
*/

/*DOC: 
  Return number of errors present for file of level upto or more
  severe.  Example: SdifFNumErrors(f, eError) is true if an error or a
  fatal error occurred since opening the file, false if there were
  only warnings or remarks. */
int SdifFNumErrors (SdifFileT *SdifF, SdifErrorLevelET upto);


//#endif /* _SdifFile_ */
