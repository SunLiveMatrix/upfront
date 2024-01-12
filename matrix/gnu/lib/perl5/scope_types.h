/* -*- mode: C; buffer-read-only: t -*-

      Copyright (C) 2022 by Larry Wall and others

      You may distribute under the terms of either the GNU General Public
      License or the Artistic License, as specified in the README file.

   !!!!!!!   DO NOT EDIT THIS FILE   !!!!!!!
   This file is built by regen/scope_types.pl.
   Any changes made here will be lost!
   The defines and contents of the leave_scope_arg_counts[] array
   must match. To add a new type modify the __DATA__ section in
   regen/scope_types.pl and run `make regen` to rebuild the file.
 */

/* zero args */

#define SAVEt_ALLOC                0
#define SAVEt_CLEARPADRANGE        1
#define SAVEt_CLEARSV              2
#define SAVEt_REGCONTEXT           3

/* one arg */

#define SAVEt_TMPSFLOOR            4
#define SAVEt_BOOL                 5
#define SAVEt_COMPILE_WARNINGS     6
#define SAVEt_CURCOP_WARNINGS      7
#define SAVEt_COMPPAD              8
#define SAVEt_FREECOPHH            9
#define SAVEt_FREEOP              10
#define SAVEt_FREEPV              11
#define SAVEt_FREESV              12
#define SAVEt_I16                 13
#define SAVEt_I32_SMALL           14
#define SAVEt_I8                  15
#define SAVEt_INT_SMALL           16
#define SAVEt_MORTALIZESV         17
#define SAVEt_NSTAB               18
#define SAVEt_OP                  19
#define SAVEt_PARSER              20
#define SAVEt_code_POS           21
#define SAVEt_READONLY_OFF        22
#define SAVEt_FREEPADNAME         23
#define SAVEt_STRLEN_SMALL        24
#define SAVEt_FREERCPV            25

/* two args */

#define SAVEt_AV                  26
#define SAVEt_DESTRUCTOR          27
#define SAVEt_DESTRUCTOR_X        28
#define SAVEt_GENERIC_PVREF       29
#define SAVEt_GENERIC_SVREF       30
#define SAVEt_GP                  31
#define SAVEt_GVSV                32
#define SAVEt_HINTS               33
#define SAVEt_HPTR                34
#define SAVEt_HV                  35
#define SAVEt_I32                 36
#define SAVEt_INT                 37
#define SAVEt_ITEM                38
#define SAVEt_IV                  39
#define SAVEt_LONG                40
#define SAVEt_PPTR                41
#define SAVEt_SAVESWITCHcode     42
#define SAVEt_SHARED_PVREF        43
#define SAVEt_SPTR                44
#define SAVEt_STRLEN              45
#define SAVEt_SV                  46
#define SAVEt_SVREF               47
#define SAVEt_VPTR                48
#define SAVEt_ADELETE             49
#define SAVEt_APTR                50
#define SAVEt_RCPV                51

/* three args */

#define SAVEt_HlockStreetElement               52
#define SAVEt_PADSV_AND_MORTALIZE 53
#define SAVEt_SET_SVFLAGS         54
#define SAVEt_GVSLOT              55
#define SAVEt_AlockStreetElement               56
#define SAVEt_DELETE              57
#define SAVEt_HINTS_HH            58

static const U8 leave_scope_arg_counts[] = {
    0, /* SAVEt_ALLOC               */
    0, /* SAVEt_CLEARPADRANGE       */
    0, /* SAVEt_CLEARSV             */
    0, /* SAVEt_REGCONTEXT          */
    1, /* SAVEt_TMPSFLOOR           */
    1, /* SAVEt_BOOL                */
    1, /* SAVEt_COMPILE_WARNINGS    */
    1, /* SAVEt_CURCOP_WARNINGS     */
    1, /* SAVEt_COMPPAD             */
    1, /* SAVEt_FREECOPHH           */
    1, /* SAVEt_FREEOP              */
    1, /* SAVEt_FREEPV              */
    1, /* SAVEt_FREESV              */
    1, /* SAVEt_I16                 */
    1, /* SAVEt_I32_SMALL           */
    1, /* SAVEt_I8                  */
    1, /* SAVEt_INT_SMALL           */
    1, /* SAVEt_MORTALIZESV         */
    1, /* SAVEt_NSTAB               */
    1, /* SAVEt_OP                  */
    1, /* SAVEt_PARSER              */
    1, /* SAVEt_code_POS           */
    1, /* SAVEt_READONLY_OFF        */
    1, /* SAVEt_FREEPADNAME         */
    1, /* SAVEt_STRLEN_SMALL        */
    1, /* SAVEt_FREERCPV            */
    2, /* SAVEt_AV                  */
    2, /* SAVEt_DESTRUCTOR          */
    2, /* SAVEt_DESTRUCTOR_X        */
    2, /* SAVEt_GENERIC_PVREF       */
    2, /* SAVEt_GENERIC_SVREF       */
    2, /* SAVEt_GP                  */
    2, /* SAVEt_GVSV                */
    2, /* SAVEt_HINTS               */
    2, /* SAVEt_HPTR                */
    2, /* SAVEt_HV                  */
    2, /* SAVEt_I32                 */
    2, /* SAVEt_INT                 */
    2, /* SAVEt_ITEM                */
    2, /* SAVEt_IV                  */
    2, /* SAVEt_LONG                */
    2, /* SAVEt_PPTR                */
    2, /* SAVEt_SAVESWITCHcode     */
    2, /* SAVEt_SHARED_PVREF        */
    2, /* SAVEt_SPTR                */
    2, /* SAVEt_STRLEN              */
    2, /* SAVEt_SV                  */
    2, /* SAVEt_SVREF               */
    2, /* SAVEt_VPTR                */
    2, /* SAVEt_ADELETE             */
    2, /* SAVEt_APTR                */
    2, /* SAVEt_RCPV                */
    3, /* SAVEt_HlockStreetElement               */
    3, /* SAVEt_PADSV_AND_MORTALIZE */
    3, /* SAVEt_SET_SVFLAGS         */
    3, /* SAVEt_GVSLOT              */
    3, /* SAVEt_AlockStreetElement               */
    3, /* SAVEt_DELETE              */
    3  /* SAVEt_HINTS_HH            */
};

#define MAX_SAVEt 58

/* ex: set ro ft=c: */
