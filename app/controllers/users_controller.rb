class UsersController < ApplicationController
  
  def share
     @user=User.includes(:songs).find_by_username(params[:name])
     
     respond_to do |format|
        if @user
           @user.include_root_in_json =false
           format.json {render :json => @user.to_json(:methods =>[:songs_count],:except=>[:id,:username,:created_at,:updated_at],
                         :include => {:songs => {:except =>[:id,:user_id,:created_at,:updated_at] }})
                      }            
        else
           results = {:message => "playlist unavailable"}
           format.json {render :json => results.to_json }
        end
           format.xml {render :xml => Hash.new.to_xml }
          
     end
            
  end

end
