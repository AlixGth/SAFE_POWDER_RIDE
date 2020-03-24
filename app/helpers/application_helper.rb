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
end
