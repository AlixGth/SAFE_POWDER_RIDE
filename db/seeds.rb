# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# require "open-uri"

puts "cleaning database"
# Product.destroy_all
# User.destroy_all
# Booking.destroy_all
# Review.destroy_all
Mountain.destroy_all

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


# puts "generating products"

# product1_photo = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2016/01/28/16244/location-ski_rossignol-1049574906.jpg?itok=8f7wdso6')
# product2_photo  = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2017/11/06/33683/location-skis_salomon_xwing_cruiser_158m-1816326028.jpg?itok=6mwG8PjU')
# product3_photo = URI.open('https://app.sportyrent.com/uploads/quentin%20snow%200.jpg')
# product4_photo = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2015/01/29/558/location-chaussures_de_ski_enfant_taille_19.5_tecnica-1243604997.jpg?itok=KgkX5iyH')
# product5_photo_1 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2018/03/27/4298/location-combinaison_de_ski_enfant_6_ans_quechua-809203567.jpg?itok=t9Y9tiht')
# product5_photo_2 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2018/03/27/4298/location-combinaison_de_ski_enfant_6_ans_quechua-1135021784.jpg?itok=oGwcaS3U')
# product6_photo_1 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2016/11/04/3475/location-skis_batons_chaussures-1441558497.jpg?itok=_GcLXjR5')
# product6_photo_2 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2016/11/04/3475/location-skis_batons_chaussures-1043309082.jpg?itok=yXPAZjKf')
# product7_photo_1 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2014/12/30/3930/location-casque_de_ski-456068682.jpg?itok=UXk1SEd6')
# product7_photo_2 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2014/12/30/3930/location-casque_de_ski-1041133703.jpg?itok=t4ybRY8m')
# product7_photo_3 = URI.open('https://www.placedelaloc.com/sites/default/files/styles/annonce_detail/public/annonces/2014/12/30/3930/location-casque_de_ski-1467289711.jpg?itok=UT0cA6wo')


# product1 = Product.create({
#   name: 'Skis Rossignol 170',
#   address: 'Saint-Chaffrey (05330)',
#   description: 'Skis Rossignol 170 de 2020 état neuf',
#   price: 10,
#   category: 'skis',
#   user: user1
# })
# product1.photos.attach(io: product1_photo, filename: 'ski_rossignol.jpeg', content_type: 'image/jpeg')

# product2 = Product.create({
#   name: 'Skis Salomon 160',
#   address: 'La Clusaz (74220)',
#   description: 'Skis Salomon 160 de 2019 en très bon état',
#   price: 15,
#   category: 'skis',
#   user: user1
# })
# product2.photos.attach(io: product2_photo, filename: 'ski_salomon.jpeg', content_type: 'image/jpeg')


# product3 = Product.create({
#   name: 'Snowboard Salomon 150',
#   address: 'Rue des Ecrins, Orcières (05170)',
#   description: 'Snowboard freeride',
#   price: 10,
#   category: 'snowboard',
#   user: user4
# })
# product3.photos.attach(io: product3_photo, filename: 'snow_rossignol.jpeg', content_type: 'image/jpeg')

# product4 = Product.create({
#   name: 'Chaussures de ski enfant taille 19.5 TECNICA',
#   address: 'Menthon-Saint-Bernard (74290)',
#   description: 'Chaussures TECNICA taille 19.5, soit 203 mm, couleur orange',
#   price: 4,
#   category: "chaussures de ski",
#   user: user4
# })
# product4.photos.attach(io: product4_photo, filename: 'chaussuresorange.jpeg', content_type: 'image/jpeg')

# product5 = Product.create({
#   name: 'Combinaison de ski enfant 6 ans quechua',
#   address: 'Sevran (93270)',
#   description: "Combinaison de ski Quechua. taille 6 ans. C'est une combinaison avec capuche, très étanche qui maintient bien au chaud. La combi s'ouvre et se ferme par devant, avec fermeture éclair et skratch. Elle possede deux poches latérales.",
#   price: 4,
#   category: "vêtements",
#   user: user2
# })
# product5.photos.attach(io: product5_photo_1, filename: 'combi1.jpeg', content_type: 'image/jpeg')
# product5.photos.attach(io: product5_photo_2, filename: 'combi2.jpeg', content_type: 'image/jpeg')

# product6 = Product.create({
#   name: 'Skis batons et chaussures',
#   address: 'Pont-Noyelles (80115)',
#   description: "IDEAL POUR SKIEUR OCCASIONNEL OU DEBUTANT. SKI 170 CHAUSSURES 43/44",
#   price: 9,
#   category: "skis + batons + chaussures",
#   user: user3
# })
# product6.photos.attach(io: product6_photo_1, filename: 'pack1.jpeg', content_type: 'image/jpeg')
# product6.photos.attach(io: product6_photo_2, filename: 'pack2.jpeg', content_type: 'image/jpeg')



# product7 = Product.create({
#   name: 'Casque de Ski',
#   address: 'Villelaure (84530)',
#   description: "Loue casque de ski. peu utilisé. Taille de 54 à 60cm de tour de tête",
#   price: 3,
#   category: "casque",
#   user: user3
# })
# product7.photos.attach(io: product7_photo_1, filename: 'casque1.jpeg', content_type: 'image/jpeg')
# product7.photos.attach(io: product7_photo_2, filename: 'casque2.jpeg', content_type: 'image/jpeg')
# product7.photos.attach(io: product7_photo_3, filename: 'casque3.jpeg', content_type: 'image/jpeg')

# puts "product generated!"

# booking1_own = Booking.create({
#     product_id: product6.id,
#     user_id: user4.id,
#     start_date: Date.new(2020, 3, 18),
#     end_date: Date.new(2020, 3, 20),
#     status: "Confirmée"
# })

# booking2_own = Booking.create({
#     product_id: product7.id,
#     user_id: user4.id,
#     start_date: Date.new(2020, 3, 18),
#     end_date: Date.new(2020, 3, 20),
#     status: "Confirmée"
# })

# booking3_own = Booking.create({
#     product_id: product1.id,
#     user_id: user4.id,
#     start_date: Date.new(2020, 3, 20),
#     end_date: Date.new(2020, 3, 22)
# })

# booking4_other = Booking.create({
#     product_id: product3.id,
#     user_id: user1.id,
#     start_date: Date.new(2020, 3, 20),
#     end_date: Date.new(2020, 3, 22),
#     status: "Confirmée"
# })

# booking5_other = Booking.create({
#     product_id: product4.id,
#     user_id: user1.id,
#     start_date: Date.new(2020, 3, 25),
#     end_date: Date.new(2020, 3, 27),
#     status: "Confirmée"
# })

# puts "bookings generated for Alix user!"

# review1 = Review.create({
#     content: "Très satisfait du produit",
#     rating: 5,
#     product_id: product3.id,
#     user_id: user1.id
# })

# review2 = Review.create({
#     content: "Bon produit",
#     rating: 4,
#     product_id: product3.id,
#     user_id: user2.id
# })

# review3 = Review.create({
#     content: "Très content",
#     rating: 4,
#     product_id: product4.id,
#     user_id: user3.id
# })


# puts "reviews generated"