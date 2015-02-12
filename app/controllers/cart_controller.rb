class CartController < ApplicationController
  def index
    @cart = CartHelper.get_cart_for(current_user.role)
  end

  def add
  end

  def remove
  end

  def clear
  end

  def book
  end
end
