# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Category.create!(name: "News de l'Institut", description: "Communication officielle de l'institut")
Category.create!(name: "News du réseau", description: "Reportages, communiqués de l'équipe com'")
Category.create!(name: "Carnet de Vie", description: "Mariage, naissance, entrée dans les ordres, etc... d'anciens")
Category.create!(name: "L'agora des anciens", description: "Tous types d'annonces, cherche/propose etc...")
Category.create!(name: "Retrouvons nous", description: "Annonce sur les rencontres prévu en régions")

# # # create admin
user = User.create(:email => "philanthropos@angeltech.io",:d_adresse=> 123, :password => "12341234", :password_confirmation => "12341234", :nom => "Adnan", :prenom => "Yousaf", :picture_url => "", :ident_sexe => 1, :promo => 1, :ident_date_naissance => "04-01-1987", :ident_nationalite => "Pakistani", :role => 0, :active => true, :about => "Ruby on Rails Engineer", :ident_activite => "development", :industry => "Culture", :occupation => "Etudiant")
cf = ContactInfo.new(:adresse => "Sample addresse", :npa_localite => "SAMPLE LOCALITE", :pays => "AE", :tel_home=> "23123123", :current_postcode => "54000", :current_town => "Lyon", :current_country => "France", :tel_natel => "23123123", :current_postcode => "54000", :current_address => "Sample address")
cf.save
user.contact_info = cf
user.create_right
# # create staff
# user = User.create!({:email => "staff.adnan@gmail.com", :password => "12341234", :password_confirmation => "12341234", :nom => "Stagg", :prenom => "Sample", :picture_url => "", :ident_sexe => "homme", :promo => 1, :ident_date_naissance => "04-01-1987", :ident_nationalite => "Pakistani", :role => 1, :active => true, :about => "Ruby on Rails Engineer", :ident_activite => "development", :industry => "Culture", :occupation => "Etudiant"})
# user.create_contact_info(:adresse => "Sample addresse", :npa_localite => "SAMPLE LOCALITE", :pays => "AE", :tel_home=> "23123123", :current_postcode => "54000", :current_town => "Lyon", :current_country => "France", :tel_natel => "23123123")
# user.create_right
# # create normal user
# user = User.create!({:email => "geo_code123.adnan@gmail.com", :password => "12341234", :password_confirmation => "12341234", :nom => "Stagg", :prenom => "Sample", :picture_url => "", :ident_sexe => "homme", :promo => 1, :ident_date_naissance => "04-01-1987", :ident_nationalite => "Pakistani", :role => 3, :active => true, :about => "Ruby on Rails Engineer", :ident_activite => "development", :industry => "Culture", :occupation => "Etudiant"})
# user.create_contact_info(:adresse => "Sample addresse", :npa_localite => "SAMPLE LOCALITE", :pays => "FR", :tel_home=> "23123123", :current_postcode => "75001", :current_town => "Paris", :current_country => "France", :tel_natel => "23123123")
# user.create_right
# user = User.create!({:email => "geo_code111.adnan@gmail.com", :password => "12341234", :password_confirmation => "12341234", :nom => "Stagg", :prenom => "Sample", :picture_url => "", :ident_sexe => "homme", :promo => 1, :ident_date_naissance => "04-01-1987", :ident_nationalite => "Pakistani", :role => 3, :active => true, :about => "Ruby on Rails Engineer", :ident_activite => "development", :industry => "Culture", :occupation => "Etudiant"})
# user.create_contact_info(:adresse => "Sample addresse", :npa_localite => "SAMPLE LOCALITE", :pays => "FR", :tel_home=> "23123123", :current_postcode => "18000", :current_town => "Bourges", :current_country => "France", :tel_natel => "23123123")
# user.create_right
# user = User.create!({:email => "geo_code122.adnan@gmail.com", :password => "12341234", :password_confirmation => "12341234", :nom => "Stagg", :prenom => "Sample", :picture_url => "", :ident_sexe => "homme", :promo => 1, :ident_date_naissance => "04-01-1987", :ident_nationalite => "Pakistani", :role => 3, :active => true, :about => "Ruby on Rails Engineer", :ident_activite => "development", :industry => "Culture", :occupation => "Etudiant"})
# user.create_contact_info(:adresse => "Sample addresse", :npa_localite => "SAMPLE LOCALITE", :pays => "FR", :tel_home=> "23123123", :current_postcode => "64200", :current_town => "Biarritz", :current_country => "France", :tel_natel => "23123123")
# user.create_right

#Creating viewing rights for each user
# User.all.each do |user|
#   user.create_right
# end  

# Creating subcategories
category = Category.find(4)
category.subcategories.create!(name: "Emploi", category_id: 4)
category.subcategories.create!(name: "Achat/Vente", category_id: 4)
category.subcategories.create!(name: "Propositions ponctuelles Spi / Services", category_id: 4)
category.subcategories.create!(name: "Actualité", category_id: 4)
category.subcategories.create!(name: "Logement", category_id: 4)
category.subcategories.create!(name: "Propositions d'activités dans l'année", category_id: 4)
category.subcategories.create!(name: "Autre", category_id: 4)

