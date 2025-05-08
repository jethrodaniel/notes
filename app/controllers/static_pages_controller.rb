class StaticPagesController < ApplicationController
  allow_unauthenticated_access only: %i[offline]

  def offline
  end
end
