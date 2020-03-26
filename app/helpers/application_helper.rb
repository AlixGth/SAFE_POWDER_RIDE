module ApplicationHelper


	def risk_text(risk)
  	risks = { "5" => "Risque très fort. Il est formellement déconseillé de sortir faire cette randonnée. L'instabilité du manteau neigeux est généralisée. De nombreux départs spontanés d'avalanche, parfois de grande ampleur, sont à attendre, y compris en terrains peu raides.",
  	          "4" => "Risque fort. Il est fortement déconseillé de sortir faire cette randonnée. Le manteau neigeux est faiblement stabilisé dans la plupart des pentes suffisamment raides. Les déclenchements d'avalanches sont probables, même par faible surcharges.",
              "3" => "Risque marqué. Il vous est recommandé d'analyser précisemment les segments de cette course et d'éviter les tronçons les plus exposés. Dans certaines pentes, le manteau neigeux n'est que modérement à faiblement stabilisé. Des déclenchements d'avalanche sont possibles, sur les pentes indiquées en risque marqué. Des départ spontanés peuvent se produire. ",
              "2" => "Risque limité. Seules les pentes les plus raides peuvent présenter un manteau neigeux non stabilisé. Les déclenchements sont possibles principalement par forte surcharge (groupe de skieurs sans distance de sécurité, chute).",
              "1" => "Risque faible. Le manteau neigeux est bien stabilisé dans la plupart des pentes. Les déclenchements d'avalanche ne sont possibles "}
  	risks[risk]
  end

  def title(text)
    content_for :title, text
  end

  def ascent_difficuly_text(difficulty)
    asc_difficulties = { "D" => "Alpinisme difficile.",
              "AD" => "Alpinisme assez difficile.",
              "PD" => "Peu difficile. Une maitrise de techniques d'alpinisme est nécessaire. ",
              "F" => "Alpinisme facile, mais le matériel est souvent nécessaire (crampons et piolet).",
              "R" => "Pour 'randonnée' ou 'raquettes'. Hors conditions exceptionnelles, pas besoin d’équipements particuliers (crampons, piolet,…)."}
    asc_difficulties[difficulty]
  end

  def ski_difficuly_text(difficulty)
    ski_difficulties = { 
      "1.1" => "C'est le niveau initiation. Pas de pentes supérieures à 30°. Les passages, même en forêt sont assez larges. Le dénivelé est inférieur à 800m. L'exposition n'est pas importante.",
      "1.2" => "C'est le niveau initiation. Pas de pentes supérieures à 30°. Les passages, même en forêt sont assez larges. Le dénivelé est inférieur à 800m. L'exposition n'est pas importante.",
      "1.3" => "C'est le niveau initiation. Pas de pentes supérieures à 30°. Les passages, même en forêt sont assez larges. Le dénivelé est inférieur à 800m. L'exposition n'est pas importante.",
      "2.1" => "Pas de difficultés techniques particulières. Pente à 35° maximum. Mais le dénivelé et l'exposition peuvent être importants.",
      "2.2" => "Pas de difficultés techniques particulières. Pente à 35° maximum. Mais le dénivelé et l'exposition peuvent être importants.",
      "2.3" => "Pas de difficultés techniques particulières. Pente à 35° maximum. Mais le dénivelé et l'exposition peuvent être importants.",
      "3.1" => "Début du ski-alpinisme. Passages techniques et pentes longues à 35°. Il peut y avoir de courts passages à 40°/45°, des forêts denses, des chemins forestiers raides.",
      "3.2" => "Début du ski-alpinisme. Passages techniques et pentes longues à 35°. Il peut y avoir de courts passages à 40°/45°, des forêts denses, des chemins forestiers raides.",
      "3.3" => "Début du ski-alpinisme. Passages techniques et pentes longues à 35°. Il peut y avoir de courts passages à 40°/45°, des forêts denses, des chemins forestiers raides.",
      "4.1" => "Ski de couloir ou de pente raide : pente à 40° /45° très longue (plus de 200 m), forêts très denses (la pente peut être faible).",
      "4.2" => "Ski de couloir ou de pente raide : pente à 40° /45° très longue (plus de 200 m), forêts très denses (la pente peut être faible).",
      "4.3" => "Ski de couloir ou de pente raide : pente à 40° /45° très longue (plus de 200 m), forêts très denses (la pente peut être faible).",
      "5.1" => "Pente à partir de 45°/50° et très longue (plus de 300 m). Sinon à partir de 50° sur 100 m. En plus de la pente, il faut aussi tenir compte de la configuration du terrain (étroitures, ...).",
      "5.2" => "Pente à partir de 45°/50° et très longue (plus de 300 m). Sinon à partir de 50° sur 100 m. En plus de la pente, il faut aussi tenir compte de la configuration du terrain (étroitures, ...).",
      "5.3" => "Pente à partir de 45°/50° et très longue (plus de 300 m). Sinon à partir de 50° sur 100 m. En plus de la pente, il faut aussi tenir compte de la configuration du terrain (étroitures, ...)."         
         }
    ski_difficulties[difficulty]
  end

  def terrain_difficuly_text(difficulty)
    terrain_difficulties = { 
      "E1" => "L’exposition est celle de la pente elle-même, il n’y a pas d’obstacle majeur, uniquement des arbres et des cailloux. Attention, pour une pente raide et/ou une neige dure, le risque de blessure en cas de chute est important.",
      "E2" => "Barre rocheuse dans l’axe de la pente qui aggraverait les risques de blessures en cas de chute, ou couloir légèrement tournant.",
      "E3" => "En cas de chute, saut de falaises importantes ou couloir tortueux avec risque de percussion. Mort probable.",
      "E4" => "Paroi très haute, rebonds multiples, percussions garanties. Mort certaine.",
       }
    terrain_difficulties[difficulty]
  end

end
