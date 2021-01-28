#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/types.h>

int main(int _argc, char * argv[]) {
  struct rlimit lim_nproc = { .rlim_cur = 2000, .rlim_max = 2000};
  if (setrlimit(RLIMIT_NPROC, &lim_nproc) != 0) { return 1; }
  struct rlimit lim_data = { .rlim_cur = 4294967296, .rlim_max = 4294967296};
  if (setrlimit(RLIMIT_DATA, &lim_data) != 0) { return 1; }
  return execv("/usr/lib/firefox/firefox", argv);
}

