#!/bin/sh

gcc -o test_copy_file_range test_copy_file_range.c && \
  mkdir -p tmp && \
  mkdir -p out && \
  ./test_copy_file_range cat.jpg /tmp/cat.jpg out/cat_overlay_fs.jpg && \
  ./test_copy_file_range cat.jpg tmp/cat.jpg out/cat_host_fs.jpg && \
  ls -l out/

rm -rf tmp
rm -rf out
