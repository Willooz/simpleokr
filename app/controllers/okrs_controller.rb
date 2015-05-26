class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :add_o, :edit]

  def show
    @objectives = @okr.objectives
  end

  def new
    @okr = Okr.new
    2.times do
      @objective = @okr.objectives.build
      2.times { @kr = @objective.key_results.build }
    end
  end

  # def add_o
  #   @okr = Okr.new(okr_params)
  #   params[:okr][:objectives_attributes].size.times do

  #     objective = Objective.new
  #     objective.each do |kr|
  #       key_result = objective.key_results.build(kr)
  #     end
  #   end
  # end

  # def delete_o
  # end

  # def add_kr
  # end

  # def delete_o
  # end

  # def define
  #   @okr = Okr.new(okr_params)
  #   @objective = @okr.objectives.build
  #   @key_result = @objective.key_results.build
  # end

  def create
    @okr = Okr.new(okr_params)
    @okr.public_url = "11"
    @okr.admin_url = "22"
    if @okr.save
      okr_params[:objectives_attributes].each do |o|
        @objective = @okr.objectives.create(o[1])
        o[1][:key_results_attributes].each do |kr|
          @key_result = @objective.key_results.create(kr[1])
        end
      end
      redirect_to root_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def okr_params
    params.require(:okr).permit(:admin_name, :admin_email, :owner, :period,
      objectives_attributes: [
        :description,
        key_results_attributes: :description
        ]
      )
  end

  def find_by_url
    if params[:url].length < 10
      @okr = Okr.find_by public_url: params[:url]
    else
      @okr = Okr.find_by admin_url: params[:url]
    end
  end
end
