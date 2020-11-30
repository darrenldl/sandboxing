#include <stdio.h>
#include <unistd.h>

int main(int _argc, char * argv[]) {
  return execv("/usr/lib/firefox/firefox", argv);
}

