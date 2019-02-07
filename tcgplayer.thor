class Card < Thor
  include Thor::Actions

  desc 'lookup', 'Look up card info using TCGPlayer API'
  long_desc <<-LONGDESC
     `card:lookup` will print out the info for the first card
     that matches the card name entered.

     Set the search language using the `--language=[LANGUAGE] -l` option. Notice
     this defaults to English if no option is supplied. If you set the option
     without supplying an option English is again defaulted.

     To search for a specific edition use the `--edition=[EDITION NAME] [-e]` option
     passing in the edition you are searching for.

     To display the card image url along with results use the `--image [-i]` flags.

     To display available card seached price use the `--price [-p]` flag.

     To display available cards for sale that are foreign language
     use the `--foreign_lang [-f]` flag.
  LONGDESC
  method_option :language, desc: 'set the language as the default for search',
                           type: :string,
                           required: false,
                           default: 'English',
                           lazy_default: 'English',
                           aliases: '-l'
  method_option :edition, desc: 'edition of card to lookup',
                          type: :string,
                          required: false,
                          aliases: '-e'
  method_option :image, desc: 'display image of card with result',
                        type: :boolean,
                        required: false,
                        aliases: '-i'
  method_option :price, desc: 'display price',
                        type: :boolean,
                        required: false,
                        aliases: '-p'
  method_option :foreign_lang, desc: 'display available foreign language cards for sale',
                               type: :boolean,
                               required: false,
                               aliases: '-f'
  def lookup
    card = ask('Card to search?')
    api_requester = TCG.new
    token = api_requester.auth_request
    card_info = api_requester.get_card_info(token, card)

    pp_extended_options = card_info['extendedData'].map{|data| "#{data['name']}: #{data['value']}"}.join("\n\n      ")
    formatted_output = %{
      #{card_info['productName']}
      ----------------------------------------------------------
      URL: #{card_info['url']}

      #{pp_extended_options}

      #{"Image Link: #{card_info['image']}" if options[:image]}
    }

    puts formatted_output

    if options[:price]
      choices = card_info["productConditions"].to_a
      if options[:foreign_lang]
        choices = choices.map.with_index { |a, i| [i, *a]}.compact
      else
        choices = choices.map { |a| a if a["language"] == options[:language].capitalize}.compact.map.with_index {|a, i| [i, *a]}
      end
      print_table choices
      selected_option = ask('Condition for pricing? Pick one:').to_i

      productConditionId = choices[selected_option][1][1]
      token = api_requester.auth_request

      puts api_requester.get_product_price_by_condition(token, productConditionId)
    end
  end
end



class TCG
  require 'uri'
  require 'net/http'
  require 'json'

  def initialize
    @base_url = 'https://api.tcgplayer.com'
    @private_key = ENV['TCG_PRIVATE_KEY']
    @public_key = ENV['TCG_PUBLIC_KEY']
  end

  def auth_request
    url = URI("#{@base_url}/token")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/json'
    request["Cache-Control"] = 'no-cache'
    request.body = "grant_type=client_credentials&client_id=#{@public_key}&client_secret=#{@private_key}"
    response = http.request(request)
    return response.read_body
  end

  def get_card_info(token, card, edition: false)
    category = 1 #magic category
    query_params = "categoryId=#{category}&productName=#{card}&getExtendedFields=true&productTypes=Cards"
    url = URI("#{@base_url}/catalog/products?#{query_params}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    parsed_token = JSON.parse(token)
    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{parsed_token['access_token']}"

    response = http.request(request)
    return JSON.parse(response.read_body)['results'][0]
  end

  def get_product_price_by_condition(token, productListId)
    url = URI("#{@base_url}/pricing/marketprices/#{productListId}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    parsed_token = JSON.parse(token)
    request = Net::HTTP::Get.new(url)
    request['Authorization'] = "Bearer #{parsed_token['access_token']}"

    response = http.request(request)
    return response.read_body
  end
end
