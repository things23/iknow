class SearchController < ApplicationController
  skip_authorization_check

  before_action :set_search

  def index
    respond_with(@results)
  end

  protected

  def set_search
    return if params[:search].blank?
    @results = if params[:type].present?
                model = params[:type][0..-2].capitalize.constantize
                model.search params[:search]
              else
                ThinkingSphinx.search params[:search]
              end
  end

end