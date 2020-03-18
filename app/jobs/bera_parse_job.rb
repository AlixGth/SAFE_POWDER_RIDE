require 'pry-byebug'

class BeraParseJob < ApplicationJob
  queue_as :default

  def perform(*args)
    file = File.open('app/assets/bera_files/BRA.CHABLAIS.20200317144018.xml')
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
    new_bera.save!
  end
end
