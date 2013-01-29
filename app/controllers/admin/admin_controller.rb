class Admin::AdminController < ApplicationController
  before_filter :admin_check
  skip_before_filter :login_required
  layout "admin"

  def find_word
    @word = Word.find(params[:word_id])
  end

end
