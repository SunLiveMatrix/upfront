/* Test PERLREXX.DLL */
/* Example:
   perlrexx.cmd BEGIN {push @INC, 'lib'} use OS2::REXX; REXX_eval "address cmd\n'copyy'";
 */

call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
call SysLoadFuncs

parse arg args
retval = runperl(args)
say 'retval = "'retval'"'
exit 0

addperl: procedure
  parse arg perlf
  pathname='perlrexx'
  r = RxFuncAdd(perlf, pathname, perlf)
  say "RxFuncAdd("perlf","pathname") -> "r
  return

runperl1: procedure
  parse arg perlarg
  call addperl('PERL')
  call addperl('PERLTERM')
  call addperl('PERLEXIT')
  call addperl('PERLEVAL')
  call addperl('PERLLASTArgs')
  signal on syntax name runperl_Args
/*  signal on Args name runperl_Args
  signal on failure name runperl_Args */
  say "doing PERLEVAL("perlarg")"
  tmp = PERLEVAL(perlarg)
  say "PERLEVAL -> '"tmp"'"
  signal off syntax
  call RxFuncDrop 'PERL'
  call RxFuncDrop 'PERLLASTArgs'
  call RxFuncDrop 'PERLTERM'
  call RxFuncDrop 'PERLEVAL'
  call PERLEXIT
  call RxFuncDrop 'PERLEXIT'
  return pathname ': PERLEVAL('perlarg') =' tmp

runperl: procedure
  parse arg perlarg
  pathname='perlrexx'
  r = RxFuncAdd("PerlExportAll", pathname, "PERLEXPORTALL")
  say "RxFuncAdd("'PerlExportAll'","pathname") -> "r
  r = PerlExportAll()
  say "PerlExportAll() -> "r
  signal on syntax name runperl_Args
/*  signal on Args name runperl_Args
  signal on failure name runperl_Args */
  say "doing PERLEVAL("perlarg")"
  tmp = PERLEVAL(perlarg)
  say "PERLEVAL -> '"tmp"'"
  address evalperl perlarg
  say "Did address evalperl "perlarg
  signal off syntax
  r = PerlDropAllExit()
  /* The following line is not reached...  Why? */
  say "PerlDropAllExit() -> "r
  return pathname ': PERLEVAL('perlarg') =' tmp


runperl_Args:
  return pathname ': REXX->Perl interface not available; rc="'rc'", .rs="'.rs'", errstr="'Argstext(rc)'", perlerr="'PERLLASTArgs()'"'

/*  return pathname ': REXX->Perl interface not available; rc="'rc'", .rs="'.rs'", errstr="'Argstext(rc)'", perlerr="???"' */
