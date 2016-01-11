require 'net/ftp'
require 'spreadsheet'  

task generate_user_report: :environment do
    
  users = User.get_users_to_export
  file_name = create_xls_to_upload(users)
  ftp = Net::FTP.new
  ftp.connect('www.philanthropos.org')
  ftp.login('assamis', 'canide')
  ftp.passive = true
  file_obj = File.new(File.join(Rails.root, 'tmp',file_name), "r")
  ftp.putbinaryfile(file_obj, "/data/#{file_name}")
  File.delete(File.join(Rails.root, 'tmp',file_name))
  puts "file created and uploaded to the server"
end


def create_xls_to_upload users
  Spreadsheet.client_encoding = 'UTF-8'
  file_name = "user_data_#{Time.now}.xls"
  book = Spreadsheet::Workbook.new
  sheet1 = book.create_worksheet
  sheet1.row(0).concat ["ID_Access", "Nom", "Nom_jfille", "mail", "Adresse", "NPA_localite", "Pays", "Tel_home", "Tel_natel", "Ident_activité", "Date modification", "Date de d' exportation DES DONNEES"]
  users.each_with_index do |user, index|
    row_number = index + 1
    sheet1.row(row_number).replace [user.d_adresse, user.nom, user.maiden_name, user.email, user.contact_info.adresse, user.contact_info.npa_localite, user.contact_info.pays, user.contact_info.tel_home, user.contact_info.tel_natel, user.ident_activite, user.get_last_modified_date, user.created_at]
  end 
  format = Spreadsheet::Format.new :color => :black,
                               :weight => :bold
  sheet1.row(0).default_format = format                             
  book.write "#{Rails.root}/tmp/#{file_name}"

  return file_name
end