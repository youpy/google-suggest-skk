require 'rubygems'
require 'socialskk'
require 'cgi'
require 'json'

class GoogleSuggestSkk < SocialSKK
  VERSION_STRING   = "GoogleSuggestSKK0.1"

  def encode_to_utf8(text, from_encoding)
    if String.new.respond_to?(:encode)
      text.encode('utf-8', from_encoding)
    else
      require 'kconv'
      Kconv.toutf8(text)
    end
  end

  def encode_to_eucjp(text)
    if String.new.respond_to?(:encode)
      text.encode('euc-jp', 'utf-8', {:invaild => true, :replace => '?'})
    else
      require 'kconv'
      Kconv.toeuc(text)
    end
  end

  def social_ime_search(text)
    text = encode_to_utf8(text, 'euc-jp')
    uri = URI.parse 'http://clients1.google.co.jp/'
    http = Net::HTTP.new(uri.host, uri.port)
    http = Net::HTTP.new(uri.host, uri.port, @proxy.host, @proxy.port) if @proxy
    begin
      http.read_timeout = 1
      http.open_timeout = 1
      http.start do |h|
        # encoding of the response is Shift_JIS
        res = h.get("/complete/search?client=hp&hl=ja&q=" + CGI.escape(text))
        content = encode_to_utf8(res.body, 'Shift_JIS').sub(/^[^\(]+\((.+)\)$/, '\1')
        puts content
        obj = JSON.parse(content)
        obj.shift
        encode_to_eucjp(obj[0].map do |item|
            puts item[0]
            item[0]
          end.join('/'))
      end
    rescue => e
      warn e
      return ""
    end
  end
end

