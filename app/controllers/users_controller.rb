class UsersController < ApplicationController
  
  layout false
  
  def main

    render ("users/main")
  end

  def notes
  end
end
