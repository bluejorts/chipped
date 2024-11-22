class SpeciesController < ApplicationController
  def search
    query = params[:query].to_s.strip
    @species = if query.present?
      Species.search(query)
    else
      Species.none
    end

    render json: @species.map { |s| { id: s.id, name: s.name } }
  end

  def create
    @species = Species.find_or_create_by!(name: params[:name].to_s.strip)
    render json: { id: @species.id, name: @species.name }
  rescue ActiveRecord::RecordInvalid
    render json: { error: "Invalid species name" }, status: :unprocessable_entity
  end
end
