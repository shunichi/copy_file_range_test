# test copy_file_range on docker overlay fs

```
$ docker run -it -w=/work -v $(pwd):/work ruby:3.0.2 sh test_copy_file_range.sh
copy: cat.jpg -> /tmp/cat.jpg
copy: /tmp/cat.jpg -> out/cat_overlay_fs.jpg
copy: cat.jpg -> tmp/cat.jpg
copy: tmp/cat.jpg -> out/cat_host_fs.jpg
total 76
-rw-r--r-- 1 root root 75571 Aug 11 04:45 cat_host_fs.jpg
-rw-r--r-- 1 root root     0 Aug 11 04:45 cat_overlay_fs.jpg
```
