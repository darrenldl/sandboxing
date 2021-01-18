#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/types.h>

int main(int _argc, char * argv[]) {
  struct rlimit lim = { .rlim_cur = 1073741824, .rlim_max = 1073741824};
  if (setrlimit(RLIMIT_DATA, &lim) != 0) { return 1; }
  return execv("/usr/bin/discord", argv);
}

