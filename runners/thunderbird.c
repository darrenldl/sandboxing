#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <sys/types.h>

int main(int _argc, char * argv[]) {
  struct rlimit lim = { .rlim_cur = 209715200, .rlim_max = 209715200};
  if (setrlimit(RLIMIT_DATA, &lim) != 0) { return 1; }
  return execv("/usr/lib/thunderbird/thunderbird", argv);
}

