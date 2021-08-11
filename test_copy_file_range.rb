require 'fileutils'

# FileUtils.copy_file の中で使われている copy_file_range に問題があるようだ

# /tmp を経由するとコピーできない

# host filesystem -> docker overlay filesystem
FileUtils.copy_file('cat.jpg', '/tmp/copy.jpg')
# docker overlay filesystem -> host filesystem
FileUtils.copy_file('/tmp/copy.jpg', 'cat_c.jpg')

# host filesystem を経由する場合はコピーできる

# host filesystem -> host filesystem
FileUtils.copy_file('cat.jpg', 'tmp/copy.jpg')
# host filesystem -> host filesystem
FileUtils.copy_file('tmp/copy.jpg', 'cat_d.jpg')
