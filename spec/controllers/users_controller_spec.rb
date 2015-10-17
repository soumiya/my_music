require 'spec_helper'

describe UsersController do

  describe "GET 'share'" do
    it "should be successful" do
      get 'share'
      response.should be_success
    end
   

  end

end
