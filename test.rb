in_f = ARGV.shift
out_f = ARGV.shift
mode = ARGV.shift

copy_stream_mode = mode != 'read_write'

# Rack::Test::UploadedFile の関連部分だけ抜き出したクラス
# https://github.com/rack/rack-test/blob/v1.1.0/lib/rack/test/uploaded_file.rb
class TempFileWrapper
  attr_reader :tempfile

  def initialize(path)
    require 'tempfile'
    require 'fileutils'
    original_filename = ::File.basename(path)
    extension = ::File.extname(original_filename)
    @tempfile = Tempfile.new([::File.basename(original_filename, extension), extension])
    @tempfile.set_encoding(Encoding::BINARY) if @tempfile.respond_to?(:set_encoding)
    # Tempfile で作られたパスにTempfileのインスタンスを通さずにファイルをコピーしている
    FileUtils.copy_file(path, @tempfile.path)
    puts "@tempfile.size: #{@tempfile.size}"
  end

  def path
    tempfile.path
  end
end

file = TempFileWrapper.new(in_f)

# # TempFileWrapper ではなく rack-test を使っても同じ結果になる
# require 'rack/test'
# file = Rack::Test::UploadedFile.new(in_f, 'image/jpeg')

# carrierwave は FileUtils.cp でファイルをコピーしてるので
# https://github.com/carrierwaveuploader/carrierwave/blob/v2.2.1/lib/carrierwave/sanitized_file.rb#L229
# FileUtils.cp の内部実装を模したコードで検証する
# https://github.com/ruby/ruby/blob/v2_6_5/lib/fileutils.rb#L1384-L1390
File.open(file.path) do |s|
  File.open(out_f, 'wb', s.stat.mode) do |f|
    if copy_stream_mode
      # FileUtils.cp と同様に IO.copy_stream を使うと
      # 環境によってはサイズ0のファイルになる
      IO.copy_stream(s, f)
    else
      # 一度全部読んでから書き込むと正しくコピーされる
      f.write(s.read)
    end
  end
end

puts "output size: #{File.size(out_f)}"
