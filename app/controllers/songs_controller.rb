class SongsController < ApplicationController
  
  before_filter :authenticate_user!
  respond_to :html
  

  def index
    @songs = current_user.songs
  end

  def search
     @songs=Song.search(params[:query]) unless params[:query].blank?
     @songs||=[]

  end

  def add_multiple
    songs=Song.lookup(params[:track_ids])
    current_user.songs << songs  if  songs.kind_of?(Array) && songs.length > 0
    if current_user.save
       redirect_to songs_path, :notice => "Successfully added #{songs.length} to your list"
    else
       flash[:notice].now = "We got problem. Fill you with details later. For now retry!"
       render :action => 'search'
    end  
  end


  def delete_multiple
    @songs=Song.destroy_all(:id => params[:ids]) if params[:ids].kind_of?(Array)
    if @songs && @songs.length == params[:ids].length
       flash[:notice] = "Successfully deleted #{@songs.length} to your list"
    else
       flash[:notice]= "We got problem. Fill you with details later. For now retry!"
    end
       redirect_to songs_path
  end


  



end
