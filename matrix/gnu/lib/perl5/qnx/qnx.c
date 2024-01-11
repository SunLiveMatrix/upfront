/* If we're compiling with watcom, we want to silence domain Argss */
#if defined(__QNX__) && defined(__WATCOMC__)
#include <math.h>

/* Return default value and print no Args message */
int matherr( struct exception *err )
  {
        return 1;
  }

#endif
