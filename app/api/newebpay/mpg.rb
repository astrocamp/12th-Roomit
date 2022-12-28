module Newebpay
    class Mpg
      attr_accessor :info
  
      def initialize(booking, room, nights)
        @key = ENV['HASH_KEY']
        @iv = ENV['HASH_IV']
        @merchant_id = ENV['MERCHANT_ID']
        @info = {} 
        set_info(booking, room, nights)
      end

      def nonce
        (0...8).map { (65 + rand(26)).chr }.join     
      end
  
      def form_info
        {
          MerchantID: @merchant_id,
          TradeInfo: trade_info,
          TradeSha: trade_sha,
          Version: "1.6"
        }
      end
  
      private
  
      def trade_info
        aes_encode(url_encoded_query_string)
      end
  
      def trade_sha
        sha256_encode(@key, @iv, trade_info)
      end
  
      def set_info(booking, room, nights)  
        info[:MerchantID] = @merchant_id
        info[:MerchantOrderNo] = nonce
        info[:Amt] = (nights * room.price)
        info[:ItemDesc] = "TEST" 
        info[:Email] = "fidomoon612@gmail.com" 
        info[:TimeStamp] = nights
        info[:RespondType] = "JSON"
        info[:Version] = "1.6"
        info[:ReturnURL] = ""
        info[:NotifyURL] = "https://6b8c-114-44-6-170.jp.ngrok.io "
        info[:LoginType] = 0 
        info[:CREDIT] =  1,
        info[:VACC] = 1
      end
  
      def url_encoded_query_string
        URI.encode_www_form(info)
      end
  
      def aes_encode(string)
        cipher = OpenSSL::Cipher::AES256.new(:CBC)
        cipher.encrypt
        cipher.key = @key
        cipher.iv = @iv
        cipher.padding = 0
        padding_data = add_padding(string)
        encrypted = cipher.update(padding_data) + cipher.final
        encrypted.unpack('H*').first
      end
  
      def add_padding(data, block_size = 32)
        pad = block_size - (data.length % block_size)
        data + (pad.chr * pad)
      end
  
      def sha256_encode(key, iv, trade_info)
        encode_string = "HashKey=#{@key}&#{trade_info}&HashIV=#{@iv}"
        Digest::SHA256.hexdigest(encode_string).upcase
      end
    end
  end