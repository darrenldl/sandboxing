#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/types.h>

int main(int _argc, char * argv[]) {
  struct rlimit lim_nproc = { .rlim_cur = 2000, .rlim_max = 2000};
  if (setrlimit(RLIMIT_NPROC, &lim_nproc) != 0) { return 1; }
  return execv("/usr/lib/chromium/chromium", argv);
}

