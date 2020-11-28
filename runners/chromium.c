#include <stdio.h>
#include <unistd.h>

int main(int _argc, char * argv[]) {
  return execv("/usr/lib/chromium/chromium", argv);
}

