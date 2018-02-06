namespace :tariff do
  namespace :support do
    desc "Check codes on EU website, put your codes in `codes` array"
    task check_codes_on_eu: %w[environment] do
      require 'net/http'
      codes = []
      not_on_eu = []
      codes.each do |code|
        puts "checking #{code}"
        url = "http://ec.europa.eu/taxation_customs/dds2/taric/measures.jsp?Lang=en&SimDate=20180105&Area=&MeasType=&StartPub=&EndPub=&MeasText=&GoodsText=&Taric=#{code}&search_text=goods&textSearch=&LangDescr=en&OrderNum=&Regulation=&measStartDat=&measEndDat="
        uri = URI(url)
        s = Net::HTTP.get(uri)
        not_on_eu << code unless s.include? "TARIC measure information"
      end
      puts "compeled"
      puts not_on_eu
    end
  end

  namespace :audit do
    desc "Traverse all TARIC tables and perform conformance validations on all the records"
    task verify: [:environment, :class_eager_load] do
      models = (ENV['MODELS']) ? ENV['MODELS'].split(',') : []

      TradeTariffBackend::Auditor.new(models, ENV["SINCE"], ENV["AUDIT_LOG"]).run
    end
  end
end
