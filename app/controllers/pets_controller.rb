class PetsController < ApplicationController
  before_action :require_login
  before_action :set_pet, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_owner, only: [ :edit, :update, :destroy ]

  def index
    @selected_species = params[:species_query]

    @pets = Pet.all.includes(:species)
    if @selected_species.present?
      species_ids = Species.search(@selected_species).pluck(:id)
      @pets = @pets.where(species_id: species_ids)
    end

    @user_pets = @pets.where(user: current_user)
    @other_pets = @pets.where.not(user: current_user)
  end

  def show
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = current_user.pets.build(pet_params)
    if @pet.save
      redirect_to @pet, notice: "Pet was successfully registered."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @pet.update(pet_params)
      redirect_to @pet, notice: "Pet information was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    redirect_to pets_path, notice: "Pet was successfully removed.", status: :see_other
  end

  private

  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.require(:pet).permit(:chip_id, :name, :adopted_at,
                              :species_id, :vaccination_status, :image_link)
  end

  def ensure_owner
    unless @pet.user == current_user
      flash[:error] = "You don't have permission to edit this pet"
      redirect_to pets_path
    end
  end
end
