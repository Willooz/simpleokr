class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :edit]

  def show
  end

  def new
    @okr = Okr.new
    @objective = @okr.objectives.build
    @kr = @objective.key_results.build
  end

  def renew
    # Rebuild the entire nested data tree with current param values
    # @okr = Okr.new(okr_params)
    # @objectives
    # @key_results
    respond_to do |format|
      format.html { render 'new' }
    end
  end

  def create
    @okr = Okr.new(okr_params)
    @okr.public_url = SecureRandom.hex(10)
    @okr.admin_url = SecureRandom.hex(16)
    if @okr.save
      okr_params[:objectives_attributes].each do |o|
        @objective = @okr.objectives.create(o[1])
        o[1][:key_results_attributes].each do |kr|
          @key_result = @objective.key_results.create(kr[1])
        end
      end
      redirect_to show_okr_path(@okr.public_url), notice: "OKR successfully created"
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
    if params[:url].length < 21
      @okr = Okr.find_by public_url: params[:url]
    else
      @okr = Okr.find_by admin_url: params[:url]
    end
  end
end
