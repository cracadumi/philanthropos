class User < ActiveRecord::Base
  include PgSearch
  require 'csv'
  require "i18n"
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  has_one :contact_info, dependent: :destroy
  has_one :right, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments
  has_many :notifications
  accepts_nested_attributes_for :contact_info
  accepts_nested_attributes_for :right
  mount_uploader :picture_url, UserImageUploader


  
  validates :email, presence: true
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i } 
  validates :nom, presence: true
  # validates :ident_date_naissance, :date => true
  validates_format_of :nom, :with => /\A[^0-9!.@#\$%\^&*+_=]+\z/
  validates_format_of :prenom, :with => /\A[^0-9!.@#\$%\^&*+_=]+\z/
  validates_format_of :ident_nationalite, :with => /\A[^0-9!.@#\$%\^&*+_=]+\z/

  validates_numericality_of :d_adresse, on: :create
  validates_numericality_of :promo, on: :create
  
  # validates_numericality_of :role

  # setting up full text search for about column
  pg_search_scope :search_by_about, :against => [:about,:ident_activite]


  # constant values for gender, roles, industries and occupations
  enum role: { admin: 0, staff: 1, correspondant: 2, user: 3}
  INDUSTRIES = ["Agriculture", "Art – Culture - Audiovisuel", "Eglise", "BTP – Architecture – Immobilier", "Droit", "Commerce - Economie – Gestion - Finance", "Enseignement - Recherche", "Environnement - Aménagement", "Hôtellerie – Restauration - Tourisme", "Industries", "Information - Communication", "Informatique - Télécoms - Internet", "Lettres – Langues - Sciences humaines", "Santé – Social", "Sport", "Autre"]
  OCCUPATIONS = ["Etudiant","En recherche d'emploi","En activité professionelle", "Eglise","En activité familiale", "Autre"]
  SEXE = ["homme","femme"]

  # import user data from csv
  def self.import_user_data(file)
    new_user_count = 0
    begin
      spreadsheet = open_spreadsheet(file)
      new_user_count = spreadsheet if spreadsheet == false
      spreadsheet.default_sheet = spreadsheet.sheets[0]
      headers = Hash.new
      spreadsheet.row(1).each_with_index {|header,i|
      headers[header] = i
      }
      new_user_count = create_user(spreadsheet,headers, new_user_count)
    rescue Exception => e
      
    end  
    new_user_count
  end 

  def self.search(search)
    if search
        if !/\A\d+\z/.match(search)
          User.where("nom LIKE ? OR prenom LIKE ?", "%#{search}%","%#{search}%")
        else  
          User.where("CAST(promo AS TEXT) LIKE ?", "%#{search}%")  
        end
    else
      find(:all)
    end
  end

  def is?( requested_role )
    self.role == requested_role
  end

  def get_pre_nom_and_nom
    full_name = [self.prenom, self.nom].reject(&:empty?).join(' ')

    if self.ident_sexe == 'femme' and self.maiden_name.present?
      full_name = "#{full_name} (#{maiden_name})"
    end

    full_name
  end  

  def get_age
    now = Time.now.utc.to_date
    dob = Date.parse(self.ident_date_naissance).to_date
    now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
  end 

  def self.search_philanthropotes( params ) 
      philanthropotes = get_user_by_params(params)
      philanthropotes = philanthropotes.where("lower(nom) LIKE ? OR lower(maiden_name) LIKE ?", "%#{params[:nom].downcase}%", "%#{params[:nom].downcase}%") if params[:nom].present?
      philanthropotes = philanthropotes.where("lower(prenom) LIKE ?", "%#{params[:prenom].downcase}%") if params[:prenom].present?
      philanthropotes = philanthropotes.where(ident_sexe: params[:ident_sexe]) if params[:ident_sexe].present?
      philanthropotes = philanthropotes.where(industry: params[:industry]) if params[:industry].present?
      philanthropotes = philanthropotes.where(promo: params[:promo]) if params[:promo].present?
      philanthropotes = philanthropotes.where(occupation: params[:occupation]) if params[:occupation].present?
      philanthropotes = philanthropotes.joins(:contact_info).where("contact_infos.current_country = ?", params[:current_country]) if params[:current_country].present?
      philanthropotes = philanthropotes.joins(:contact_info).where("lower(contact_infos.current_town) LIKE ?", "%#{params[:current_town].downcase}%") if params[:current_town].present? 

      philanthropotes
  end  

  def check_previous_image image_params
    if self.picture_url.file.nil? ==  false and image_params.present?
      true
    else
      false
    end    
  end  

  # removing previous image from S3
  def remove_previous_image
    self.picture_url.remove!
    self.picture_url.thumb.remove!
    self.update_column(:picture_url, '')
  end  

  def self.search_user search_params
    if numeric(search_params)
      searched_users = User.where(promo: search_params)
    else
      unless search_params =~ /\s/
        searched_users = User.where("lower(translate(nom
     , '¹²³áàâãäåāăąÀÁÂÃÄÅĀĂĄÆćčç©ĆČÇĐÐèéêёëēĕėęěÈÊËЁĒĔĖĘĚ€ğĞıìíîïìĩīĭÌÍÎÏЇÌĨĪĬłŁńňñŃŇÑòóôõöōŏőøÒÓÔÕÖŌŎŐØŒř®ŘšşșßŠŞȘùúûüũūŭůÙÚÛÜŨŪŬŮýÿÝŸžżźŽŻŹ'
     , '123aaaaaaaaaaaaaaaaaaacccccccddeeeeeeeeeeeeeeeeeeeeggiiiiiiiiiiiiiiiiiillnnnnnnooooooooooooooooooorrrsssssssuuuuuuuuuuuuuuuuyyyyzzzzzz'
     )) LIKE ? OR lower(translate(prenom
     , '¹²³áàâãäåāăąÀÁÂÃÄÅĀĂĄÆćčç©ĆČÇĐÐèéêёëēĕėęěÈÊËЁĒĔĖĘĚ€ğĞıìíîïìĩīĭÌÍÎÏЇÌĨĪĬłŁńňñŃŇÑòóôõöōŏőøÒÓÔÕÖŌŎŐØŒř®ŘšşșßŠŞȘùúûüũūŭůÙÚÛÜŨŪŬŮýÿÝŸžżźŽŻŹ'
     , '123aaaaaaaaaaaaaaaaaaacccccccddeeeeeeeeeeeeeeeeeeeeggiiiiiiiiiiiiiiiiiillnnnnnnooooooooooooooooooorrrsssssssuuuuuuuuuuuuuuuuyyyyzzzzzz'
     )) LIKE? OR lower(translate(maiden_name
     , '¹²³áàâãäåāăąÀÁÂÃÄÅĀĂĄÆćčç©ĆČÇĐÐèéêёëēĕėęěÈÊËЁĒĔĖĘĚ€ğĞıìíîïìĩīĭÌÍÎÏЇÌĨĪĬłŁńňñŃŇÑòóôõöōŏőøÒÓÔÕÖŌŎŐØŒř®ŘšşșßŠŞȘùúûüũūŭůÙÚÛÜŨŪŬŮýÿÝŸžżźŽŻŹ'
     , '123aaaaaaaaaaaaaaaaaaacccccccddeeeeeeeeeeeeeeeeeeeeggiiiiiiiiiiiiiiiiiillnnnnnnooooooooooooooooooorrrsssssssuuuuuuuuuuuuuuuuyyyyzzzzzz'
     )) LIKE?", "%#{I18n.transliterate(search_params).downcase}%", "%#{I18n.transliterate(search_params).downcase}%", "%#{I18n.transliterate(search_params).downcase}%")
      else
        searched_users = []
        User.all.each do |user|
          if I18n.transliterate(user.get_pre_nom_and_nom.to_s.gsub(/\s+/, "")).downcase.include?(I18n.transliterate(search_params.to_s.gsub(/\s+/, "")).downcase) || I18n.transliterate(user.nom.to_s.gsub(/\s+/, "")).downcase.include?(I18n.transliterate(search_params.to_s.gsub(/\s+/, "")).downcase) || I18n.transliterate(user.prenom.to_s.gsub(/\s+/, "")).downcase.include?(I18n.transliterate(search_params.to_s.gsub(/\s+/, "")).downcase) || I18n.transliterate(user.maiden_name.to_s.gsub(/\s+/, "")).downcase.include?(I18n.transliterate(search_params.to_s.gsub(/\s+/, "")).downcase) 
            searched_users << user
          end  
        end  
      end  
    end 
    
    searched_users
  end  

  # getting user date modif
  def get_last_modified_date
    if self.date_modif.present?
      return self.date_modif
    else
      return ""  
    end  
  end

  # export user name and emails
  def self.to_csv_mail
    CSV.generate(headers: true) do |csv|
      csv << ["nom;email"]
      User.all.each do |user|
        a = []
        a.push "#{user.nom};#{user.email}"
        csv << a
      end
    end
  end

  # exporting the green fields in google docs
  def self.to_csv_user_info
    CSV.generate(headers: true) do |csv|
      csv << ["d_adresse;nom;email;adresse;npa_localite;pays;tel_home;tel_natel;ident_activite;date_modif;date_import"]
      User.all.each do |user|
        a = []
        a.push "#{user.d_adresse};#{user.nom};#{user.email};#{user.contact_info.adresse};#{user.contact_info.npa_localite};#{user.contact_info.pays};#{user.contact_info.tel_home};#{user.contact_info.tel_natel};#{user.ident_activite};#{user.get_last_modified_date};#{user.created_at}"
        csv << a
      end  
    end  
  end

  # exporting entire db in csv
  def self.to_csv_full_db
    connection = ActiveRecord::Base.connection
    CSV.generate(headers: true) do |csv|
      ActiveRecord::Base.connection.tables.each do |table|    
        result = connection.exec_query('select * from '+table+'')        
        csv << [get_col_names(result.columns).to_s] 
        result.rows.each do |row|
          a = []
          a.push get_row_vals(row)
          csv << a
        end  
      end   
    end
  end 
  # get column names of a table
  def self.get_col_names col_array
    col_array = []
    col_array.each do |column_name|
      col_array << column_name
    end 

    return col_array
  end  

  # login activated users only and admin user only
  def active_for_authentication?
    unless self.role == "admin"
      super && self.active 
    else
      super
    end
  end

  def inactive_message
    "Désolé, ce compte a été désactivé ."
  end

  def update_date_modif
    self.update_column(:date_modif,Time.now)
  end

  def self.get_users_to_export
    export_users = []
    User.where('date_modif is NOT NULL').each do |user|
      if (Date.today - 40..Date.today).include?(user.date_modif.to_date)
        export_users << user
      end  
    end  

    export_users
  end

  private
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    # when '.csv' then Roo::CSV.new(file.path, csv_options: {encoding: "iso-8859-15:euro"})
    when '.xls' then Roo::Excel.new(file.path)
    when '.xlsx' then Roo::Excelx.new(file.path)
    # else raise "Unknown file type: #{file.original_filename}"
    else false
    end
  end

  def self.create_user(spreadsheet, headers, new_user_count)
    ((spreadsheet.first_row + 1)..spreadsheet.last_row).each do |row|
      unless User.exists?(:email => spreadsheet.row(row)[headers['mail']])
        if spreadsheet.row(row)[headers['Ident_sexe']].to_i == 1
          gender = 'homme'
        end  
        if spreadsheet.row(row)[headers['Ident_sexe']].to_i == 2
          gender = 'femme'
        end 
        begin
          user = User.new(:d_adresse => spreadsheet.row(row)[headers['Id_adresse']],
            :email => spreadsheet.row(row)[headers['mail']].to_s,
            :password => generate_password(spreadsheet.row(row)[headers['Ident_date_naissance']]),
            :password_confirmation => generate_password(spreadsheet.row(row)[headers['Ident_date_naissance']]),
            :nom => spreadsheet.row(row)[headers['Nom']].to_s, :prenom => spreadsheet.row(row)[headers['Prénom']].to_s,
            :ident_sexe => gender, :promo => spreadsheet.row(row)[headers['Promo']],
            :ident_date_naissance => spreadsheet.row(row)[headers['Ident_date_naissance']].to_s,
            :ident_nationalite => spreadsheet.row(row)[headers['Ident_nationalité']].to_s, :role => 3,
            :active => true, :ident_activite => spreadsheet.row(row)[headers['Ident_activité']].to_s)
          contact_info = ContactInfo.new(:adresse => spreadsheet.row(row)[headers['Adresse']].to_s, :npa_localite => spreadsheet.row(row)[headers['NPA_localite']].to_s, :pays => spreadsheet.row(row)[headers['Pays']].to_s, :current_country => Country[spreadsheet.row(row)[headers['Pays']].to_s].name.to_s, :current_town =>  get_town_name(spreadsheet.row(row)[headers['NPA_localite']].to_s), :current_postcode => get_current_post_code(spreadsheet.row(row)[headers['NPA_localite']].to_s), :tel_home=> spreadsheet.row(row)[headers['Tel_home']].to_s, :tel_natel => spreadsheet.row(row)[headers['Tel_natel']].to_s, :current_address => spreadsheet.row(row)[headers['Adresse']].to_s )
          right = Right.new
          if contact_info.save and right.save
            if user.save 
              user.contact_info = contact_info
              user.right = right
              new_user_count = new_user_count + 1
            else
              contact_info.destroy if contact_info.present?
              right.destroy if right.present?
            end  
          else
            contact_info.destroy if contact_info.present?
            right.destroy if right.present?
          end  
        rescue Exception => exc

        end   
      end 
    end
    new_user_count 
  end 

  def self.get_user_by_params params
    users = params[:keywords].present? ? User.search_by_about(params[:keywords]) : User.all
    users 
  end 

  def self.country_options_for_search
      countries = Array.new()
      User.all.each do |user|
        if user.contact_info.present? and user.contact_info.current_country.present?
          unless countries.detect {|f| f[:name] ==  user.contact_info.current_country }.present?
            c = ISO3166::Country.find_country_by_name(user.contact_info.current_country)
            if c.name == 'Netherlands Antilles'
              countries << {:name => c.name, :french_name => 'Antilles néerlandaises'}
            else
              countries << {:name => c.name, :french_name => c.translations["fr"]}
            end
          end
        end  
      end 

      countries 
  end  

  def self.get_town_name npa_localite
    town = npa_localite.split(" ",2).last

    town
  end

  def self.get_current_post_code npa_localite
    post_code = npa_localite.scan(/\d+/).first
    
    post_code
  end  

  def self.get_row_vals row
    row_val = ""
    if row.size > 1
      row.each do |value|
        row_val = row_val + "#{value}"
        row_val = row_val + ";" unless value == row.last 
      end
    else
      row_val = row_val + "#{row.first}"
    end
    row_val     
  end   

  def self.numeric params
    if params.to_i.to_s == params
      return true
    else
      return false
    end
  end   

  def self.generate_password date
    if date.class == "Date"
      return date.strftime("%F").to_s.scan(/\d/).join('')
    else
      return date.to_s.scan(/\d/).join('')
    end  
  end 

      
end
