#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/types.h>

int main(int _argc, char * argv[]) {
  struct rlimit lim_nproc = { .rlim_cur = 500, .rlim_max = 500};
  if (setrlimit(RLIMIT_NPROC, &lim_nproc) != 0) { return 1; }
  struct rlimit lim_data = { .rlim_cur = 2147483648, .rlim_max = 2147483648};
  if (setrlimit(RLIMIT_DATA, &lim_data) != 0) { return 1; }
  return execv("/usr/bin/bash", argv);
}

