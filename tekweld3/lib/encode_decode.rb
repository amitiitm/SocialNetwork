require 'hpricot'
module EncodeDecode
  def self.decode(doc, output = 'xml')
    begin
      doc = doc.to_s
      doc = (Hpricot::XML(doc)/"encoded")[0].inner_html if(doc[0..8] == '<encoded>' and doc[(doc.length - 10)..(doc.length - 1)] == '</encoded>')
      doc = Zlib::Inflate.inflate(Base64.decode64(doc.to_s))
      doc = doc[doc.index('<')..(doc.length-1)]
    rescue Zlib::Error
      #to ignore exceptions generates at time of decompression, so no code here.
    end
    doc = doc.to_s.gsub("&amp;","&") 
    doc = Hpricot::XML(doc) if(output.to_s.downcase == 'xml')
    return doc
  end
  
  def self.encode(doc, output = 'xml')
    if(output.to_s.downcase == 'xml')
      return '<encoded>' + Base64.encode64(Zlib::Deflate.deflate(doc.to_s)) + '</encoded>'
    else
      return Base64.encode64(Zlib::Deflate.deflate(doc.to_s))
    end
  end
end