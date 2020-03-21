require 'watir'
require 'open-uri'

class BeraScrapJob < ApplicationJob
  queue_as :default

  def perform(*args)
    i = 0
    massifs = Mountain.all
    massifs.each do |massif|
      date_heure = scrap(massif)

      url = "https://donneespubliques.meteofrance.fr/donnees_libres/Pdf/BRA/BRA.#{massif.name.upcase}.#{date_heure}.xml"

      i = parse(url)

      sleep(5)
    end

    return "#{i} Beras created"
    # download = open(url)
    # IO.copy_stream(download, "app/assets/bera_files/BRA_#{massif}_#{date_heure}.xml")
  end

  private

  def scrap(massif)
    browser = Watir::Browser.new :chrome, headless: true
    browser.goto("https://donneespubliques.meteofrance.fr/?fond=produit&id_produit=265&id_rubrique=50")
    browser.h3(text: "Téléchargement").fire_event('click')

    select_massif = browser.select_list id: 'select_massif'
    heure = browser.select_list id: 'select_heures'
    sleep(1)

    select_massif.select massif.name.upcase
    sleep(1)

    date_heure = heure.value

    return date_heure
  end

  def parse(file_path)
    i = 0
    file = open(file_path)
    document = Nokogiri::XML(file)

    bra = document.root.xpath('BULLETINS_NEIGE_AVALANCHE')
    bra_date = bra.attr('DATEVALIDITE').value

    bra_massif = bra.attr('MASSIF').value
    massif = Mountain.find_by(name: bra_massif.capitalize)


    risque =  document.root.xpath('BULLETINS_NEIGE_AVALANCHE/CARTOUCHERISQUE/RISQUE')
    risk1 = risque.attr('RISQUE1').value
    evolrisk1 = risque.attr('EVOLURISQUE1').value
    altitude = risque.attr('ALTITUDE').value
    risk2 = risque.attr('RISQUE2').value
    evolrisk2 = risque.attr('EVOLURISQUE2').value
    risk_max = risque.attr('RISQUEMAXI').value
    comment = risque.attr('COMMENTAIRE').value

    exposure = document.root.xpath('BULLETINS_NEIGE_AVALANCHE/CARTOUCHERISQUE/PENTE')
    exposure_ne = exposure.attr('NE').value
    exposure_e = exposure.attr('E').value
    exposure_s = exposure.attr('S').value
    exposure_se = exposure.attr('SE').value
    exposure_sw = exposure.attr('SW').value
    exposure_n = exposure.attr('N').value
    exposure_nw = exposure.attr('NW').value
    exposure_w = exposure.attr('W').value

    accidentel_text = document.root.xpath('BULLETINS_NEIGE_AVALANCHE/CARTOUCHERISQUE/ACCIDENTEL').text
    naturel_text = document.root.xpath('BULLETINS_NEIGE_AVALANCHE/CARTOUCHERISQUE/NATUREL').text

    new_bera = Bera.new({
      bra_date: bra_date,
      risk1: risk1,
      evolrisk1: evolrisk1,
      altitude: altitude,
      risk2: risk2,
      evolrisk2: evolrisk2,
      risk_max: risk_max,
      comment: comment,
      exposure_ne: exposure_ne,
      exposure_e: exposure_e,
      exposure_s: exposure_s,
      exposure_se: exposure_se,
      exposure_sw: exposure_sw,
      exposure_n: exposure_n,
      exposure_nw: exposure_nw,
      exposure_w: exposure_w,
      accidentel_text: accidentel_text,
      naturel_text: naturel_text
    })
    new_bera.mountain = massif
    if new_bera.valid?
      new_bera.save
      i = 1
    end

    return i
  end
end



