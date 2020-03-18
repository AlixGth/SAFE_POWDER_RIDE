class BeraScrapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = 'https://donneespubliques.meteofrance.fr/?fond=rubrique&id_rubrique=50'
    html_file = open(url).read
    html_doc = Nokogiri::HTML(html_file)

    html_doc.search('#from_bra p').each do |p|
      puts p
    end
  end
end
