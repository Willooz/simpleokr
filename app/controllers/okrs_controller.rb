class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :edit]

  def show
  end

  def new
    @okr = Okr.new
  end

  def define
    @okr = Okr.new(okr_params)
    if @okr.valid?
      objective = @okr.objectives.build(description: " ")
      objective.key_results.build(description: " ")
      render 'define'
    else
      render 'new'
    end
  end

  def create
    # Generate models from params
    @okr = Okr.new(okr_params)
    # IF add/remove buttons...
    if params[:button]
      case params[:button][/\D*/]
        when "add_o"
          objective = @okr.objectives.build(description: " ")
          objective.key_results.build(description: " ")
          render 'define'
        when "remove_o"
          objective_to_remove = @okr.objectives.last
          @okr.objectives.delete(objective_to_remove)
          render 'define'
        when "add_kr_"
          index = params[:button][/\d*$/].to_i + 1
          objective_to_change = @okr.objectives.find(index)
          raise
          # objective_to_change = @okr.objectives.last
          render 'define'
        when "remove_kr_"
        else
      end
    # IF create button, proceed to savind...
    else
      if @okr.valid?
        @okr.public_url = SecureRandom.hex(10)
        @okr.admin_url = SecureRandom.hex(16)
        @okr.save
        @okr.objectives.each do |o|
          o.key_results.save
          o.save
        end
        edirect_to share_okr_path, notice: "OKR successfully created"
      else
        render 'define'
      end
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
    if params[:url].length < 21
      @okr = Okr.find_by public_url: params[:url]
    else
      @okr = Okr.find_by admin_url: params[:url]
    end
  end
end
