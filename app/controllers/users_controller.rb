class UsersController < ApplicationController
  require 'json'
  before_action :load_user, except: [:get_search_info, :user_menu, :send_contact_mail, :update_password, :change_password, :search_philanthropotes, :send_contact_mail]
  authorize_resource
  skip_authorize_resource :only => [:get_search_info, :search_philanthropotes, :send_contact_mail]
  # authorize_resource

  def get_search_info
    searched_users = User.search_user(params[:query]).map do |u| 
      { :id => u.id, :nom => " #{u.nom}", :prenom => u.prenom, :maiden_name => u.maiden_name.present? ? " (#{u.maiden_name})" : "", :picture_url => u.picture_url.present? ? u.picture_url.url(:thumb) : "/assets/users/avatar.png", :promo => u.promo==0 ? "Institut" : "#{u.promo}"}
    end 
    respond_to do |format|
        format.json { render :json => searched_users }
    end
  end  

  def user_menu
    @user_list = User.search(params[:search]) 
  end  

  def search_philanthropotes
    @current_countries = User.country_options_for_search
    if params[:commit].present?
      if params[:quick_search].present?
        @philanthropotes = User.search_philanthropotes(changed_params(params))
      else
        @philanthropotes = User.search_philanthropotes(params)
      end  
      @map_data = map_info_array(@philanthropotes)
      @philanthropotes = @philanthropotes.paginate(:page => params[:page], :per_page => 10).order('id DESC')
      @geo_info = Array.new()
      @geo_info = @geo_info + get_geo_info(@philanthropotes)
    end  
  end 

  def show

  end  

  def send_contact_mail
    send_to =  User.find(params[:sender_id])
    AppMailer.contact_user_mail(send_to, current_user, params[:message]).deliver
    flash[:notice] = 'Votre message a été envoyé.'
    redirect_to :back
  end  

  def edit
    authorize! :edit, @user
    @pays_options = ContactInfo.translate_pays_to_french
    @current_countries = ContactInfo.translate_countries_to_french 
  end  

  def update
    @user.remove_previous_image if @user.check_previous_image(params[:user][:picture_url]) == true 
    if @user.update(user_params)
      @user.update_date_modif
      flash[:notice] = "Profil mis à jour avec succès"
      redirect_to user_path(@user)
    else
      flash[:alert] = "Désolé, une erreur inattendue est survenue"
      redirect_to :back
    end  
  end 

  def destroy
    if @user.destroy
      flash[:notice] = "L'utilisateur a été détruit"
    else
      flash[:alert] = "Désolé, une erreur inattendue est survenue"
    end
    redirect_to root_path  
  end  

  def change_password
    @user = current_user
  end  

  def update_password
    if params[:user][:password].present? || params[:user][:password_confirmation].present?
      @user = User.find(current_user.id)
      if @user.update_with_password(user_params)
        sign_in @user, :bypass => true
        flash[:notice] = "Votre mot de passe a été changé avec succès"
        redirect_to root_path
      else 
        render "change_password"
      end
    else
        flash[:alert] = "Mot de passe et mot de passe confirmantion peut pas être vide"
        redirect_to change_password_users_path
    end  
  end


  private 
  def get_geo_info(philanthropotes)
    geo_info = Array.new()
    philanthropotes.each do |user, index|
      if user.contact_info.latitude.present? && user.contact_info.longitude.present?   
        hash = {:latitude => user.contact_info.latitude, :longitude => user.contact_info.longitude.to_f}
        geo_info.push(hash)
      end
    end 
    geo_info 
  end 

  def user_params
    params.require(:user).permit!
  end 

  def changed_params params
    if params[:quick_search].to_i.to_s == params[:quick_search]
      params[:promo] = params[:quick_search]
    else
      if params[:quick_search].match(" ")
        params[:prenom] =  params[:quick_search].split(" ",2).first
        params[:nom] = params[:quick_search].split(" ",2).last
      else
        params[:prenom] = params[:quick_search]
      end  
    end  
    params.delete(:quick_search)
    

    params
  end  

  def map_info_array users
    map_data = users.map do |u|
      { id: u.id, nom: u.get_pre_nom_and_nom, picture_url: u.picture_url.present? ? u.picture_url.url(:thumb) : "/assets/users/avatar.png", promo: u.promo==0 ? "Institut" : "Promo #{u.promo}", ident_active: u.active? ? u.ident_activite.to_s.truncate(100) : '', address: "#{u.contact_info.current_town} (#{u.contact_info.current_country})", lat: u.contact_info.latitude,lng: u.contact_info.longitude}
    end

  map_data.to_json   
  end  

  def load_user
    @user = User.find(params[:id])
  end

end
