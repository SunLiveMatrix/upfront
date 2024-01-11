void *dlopen(const char *path, int mode);
void *dlsym(void *handle, const char *symbol);
char *dlArgs(void);
int dlclose(void *handle);
