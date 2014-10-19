require 'nokogiri'
module Spree
  class AlipayXmlReturn
    attr_accessor :parsed_xml 
    def initialize( returned_xml_data )
      self.parsed_xml = Nokogiri::XML returned_xml_data      
    end
    
    def success?
      parsed_xml.css('is_success').text == 'T'
    end
    
    def trade_status
      parsed_xml.css('trade_status').text
    end
  end
end