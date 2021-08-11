#define _GNU_SOURCE
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <unistd.h>

void copy(const char* src, const char* dest) {
  int fd_in, fd_out;
  struct stat stat;
  off64_t len, ret;

  printf("copy: %s -> %s\n", src, dest);

  fd_in = open(src, O_RDONLY);
  if (fd_in < 0) {
    perror("open src");
    exit(EXIT_FAILURE);
  }

  fd_out = open(dest, O_WRONLY | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH);
  if (fd_out < 0) {
    perror("open dest");
    exit(EXIT_FAILURE);
  }

  if (fstat(fd_in, &stat) == -1) {
    perror("fstat");
    exit(EXIT_FAILURE);
  }

  len = stat.st_size;
  do {
    ret = copy_file_range(fd_in, NULL, fd_out, NULL, len, 0);
    if (ret == -1) {
      perror("open_file_range");
      exit(EXIT_FAILURE);;
    }
    len -= ret;
  } while(len > 0 && ret > 0);

  close(fd_in);
  close(fd_out);
}

int main(int argc, char** argv) {
  if (argc != 4) {
    fprintf(stderr, "usage: test_copy_file_range INFILE TMPFILE OUTFILE\n");
    return 1;
  }

  const char* in_file = argv[1];
  const char* tmp_file = argv[2];
  const char* out_file = argv[3];

  copy(in_file, tmp_file);
  copy(tmp_file, out_file);

  return 0;
}
