# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require "open-uri"

puts "cleaning database"

Coordinate.destroy_all
Itinerary.destroy_all
Bera.destroy_all
Mountain.destroy_all
User.destroy_all

puts "creating mountain ranges"

mountains = ["Thabor", "Pelvoux", "Queyras", "Champsaur", "Devoluy", "Embrunais Parpaillon", "Chablais"]

mountains.each do |mountain|
	Mountain.create!(name: mountain)
end


 puts "generating users"

avatar1 = URI.open('https://avatars3.githubusercontent.com/u/58790438?v=4')
avatar2 = URI.open('https://avatars0.githubusercontent.com/u/28073539?v=4')
avatar3 = URI.open('https://avatars1.githubusercontent.com/u/59839816?v=4')
avatar4 = URI.open('https://i0.wp.com/www.lechotouristique.com/wp-content/uploads/2018/02/alix-gauthier.jpg?resize=300%2C300&ssl=1')
user1 = User.create({
  username: 'Jerome',
  email: 'jerome.crest@gmail.com',
  password: 'password',
  admin: true,
})
user1.avatar.attach(io: avatar1, filename: 'jerome.jpeg', content_type: 'image/jpeg')

user2 = User.create({
  username: 'Gaetan',
  email: 'malletgaetantmp@gmail.com',
  password: 'password',
  admin: true,
})
user2.avatar.attach(io: avatar2, filename: 'gaetan.jpeg', content_type: 'image/jpeg')

user3 = User.create({
  username: 'Tib',
  email: 'thibault.adet@gmail.com',
  password: 'password',
  admin: true,
})
user3.avatar.attach(io: avatar3, filename: 'tib.jpeg', content_type: 'image/jpeg')

user4 = User.create({
  username: 'Alix',
  email: 'gauthieralix@gmail.com',
  password: 'password',
  admin: true,
})
user4.avatar.attach(io: avatar4, filename: 'alix.jpeg', content_type: 'image/jpeg')

puts "users generated!"


puts "generating itineraries"

itinerary1_photo = URI.open('https://www.refugesclareethabor.com/InfoliveImages/itineraires/buffere/baude12_01_09.jpg')
itinerary2_photo  = URI.open('http://www.skitour.fr/photos_topos/3452.jpg')
itinerary3_photo_1 = URI.open('http://www.skitour.fr/photos_topos/2471.jpg')
itinerary3_photo_2 = URI.open('http://www.skitour.fr/photos_topos/2524.jpg')


itinerary1 = Itinerary.create({
  name: 'Pic du lac Blanc',
  elevation: 1380,
  departure: 'Névache (05100)',
  arrival: 'Névache (05100)',
  ascent_difficulty: 'R',
  ski_difficulty: '3.1 E2',
  description: "Une belle et longue boucle panoramique où l'on peut profiter de la variété des paysages avec un joli sommet panoramique offrant une superbe vue sur les Ecrins. Pour le retour sur Névache par contre, il faut aimer le ski de fond! De Névache, suivre la route sur environ 900m avant de séchapper sur le droite plein N en direction du vallon qui monte en direction du Lac Blanc que lon suit jusqu'à celui-ci (long). Ensuite, soit prendre l'arête (parfois soufflé, à pied) qui monte en haut de la crête de la Gardiole puis au sommet du Pic de Lac Blanc, soit la face E pour atteindre le sommet directement (100m à 35°, attention aux plaques, mais nombreux rochers émergents).
Au sommet, traverser plein S en visant le collu 2905. Ensuite prendre le vallon orienté W et le descendre tout du long (pente faible, nombreux plats) jusquà atteindre le route de ski de fond un peu en dessous du refuge de Laval.
La descendre jusquà Névache (long et beaucoup de plat : faut aimer le skating!)",
  duration: 6,
  mountain: Mountain.find_by(name: 'Thabor'),
  user: user1
  })
itinerary1.photos.attach(io: itinerary1_photo, filename: 'pic_lac_blanc.jpeg', content_type: 'image/jpeg')


itinerary2 = Itinerary.create({
  name: 'le Gilly, combe Nord en boucle',
  elevation: 800,
  departure: 'le Roux dAbriès (05460)',
  arrival: 'le Roux dAbriès (05460)',
  ascent_difficulty: 'R',
  ski_difficulty: '3.1 E1',
  description: "Stationner au niveau du pont qui franchit le Torrent du Bouchet, juste avant la Chapelle St Barthélémy.
Remonter les clairières derrière la Chapelle St Barthélémy pour rejoindre la piste forestière du Bois de la Brune et la suivre quelques instants vers le SW.
La quitter vers 1800m pour remonter une (ancienne?) piste de ski tracée dans le versant NW du Bois de la Brune et qui mène au sommet de Gilly.
Du sommet, descendre par la combe Nord jusque dans le Bois Noir puis obliquer légèrement à droite pour rejoindre Valpréveyre.
Le retour vers le parking se fait par la route enneigée.",
  duration: 5,
  mountain: Mountain.find_by(name: 'Queyras'),
  user: user2
  })
itinerary2.photos.attach(io: itinerary2_photo, filename: 'gilly_versant_nord.jpeg', content_type: 'image/jpeg')


itinerary3 = Itinerary.create({
  name: 'Pic du Jaillon, Couloir NE',
  elevation: 1125,
  departure: 'Arvieux (05350)',
  arrival: 'Arvieux (05350)',
  ascent_difficulty: 'AD',
  ski_difficulty: '5.1 E3',
  description: "Suivre le fond du vallon de torrent de Combe Bonne, en direction de lac du Lauzon, jusqu’au point 1890, après de Cabane de la Gardère. Puis monter en direction ouest vers le point 2067. Après ce point, pour dépasser la première barre rocheuse, il faut prendre le couloir le plus a droite, toujours en direction ouest. Le centre du couloir avait une barre d’une dizaine de mètres, mais nous avons trouvé une voie qui passe du côté droit. Après on se trouve sur un épaule et le couloir est évident droit devant.",
  duration: 6,
  mountain: Mountain.find_by(name: 'Queyras'),
  user: user3
  })
itinerary3.photos.attach(io: itinerary3_photo_1, filename: 'pic_jaillon_1.jpeg', content_type: 'image/jpeg')
itinerary3.photos.attach(io: itinerary3_photo_2, filename: 'pic_jaillon_2.jpeg', content_type: 'image/jpeg')


puts "itineraries generated!"

puts "generating coordinates"

def coordinates(filename, itinerary)
	url = Dir.pwd + "/db/" + filename
	doc = Nokogiri::XML(open(url))
	trackpoints = doc.xpath('//xmlns:trkpt')
	array = []
	doc.search('trkpt').each_with_index do |trkpt, index|
	  ele = trkpt.search('ele').text
	  array <<  [trkpt.attribute("lon").value, trkpt.attribute("lat").value, ele ]
	end
	reduce_value = (array.size.to_f / 300).round
	array = array.select.with_index do |coordinate, index|
	  index % reduce_value == 0
	end
  for i in (0...array.size)
    coord = Coordinate.create!(longitude: array[i][0].to_f, latitude: array[i][1].to_f, altitude: array[i][2].to_f, order: i, itinerary: itinerary, color: "#CAFF66")
  end
end

filenames = ["skitour_topo3707_jaillon.gpx", "skitour_topo4771_Gilly.gpx", "skitour_topo8041_lacblanc.gpx"]

Itinerary.all.each_with_index do |itinerary, index|
	coordinates(filenames[index], itinerary)
end

puts "coordinates created!"

puts "parsing bera"

BeraParseJob.perform_now('app/assets/bera_files/BRA.CHABLAIS.20200317144018.xml')
BeraParseJob.perform_now('app/assets/bera_files/BRA.QUEYRAS.20200318150126.xml')
BeraParseJob.perform_now('app/assets/bera_files/BRA.THABOR.20200319151122.xml')

puts "parsing done!"
