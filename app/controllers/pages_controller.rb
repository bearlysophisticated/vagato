class PagesController < ApplicationController
  def home
    @accommodations = Accommodation.all
  end

  def about
  end

  def contact
  end
end
