require 'open-uri'

class BeraScrapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = 'https://donneespubliques.meteofrance.fr/donnees_libres/Pdf/BRA/BRA.CHABLAIS.20200319145759.xml'
    download = open(url)

    IO.copy_stream(download, 'app/assets/bera_files/BRA_CHABLAIS_20200317.xml')
  end
end
