class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :share, :edit, :review]

  def show
    if params[:url].length < 21
      @admin_access = false
    else
      @admin_access = true
    end
  end

  def new
    @okr = Okr.new
  end

  def define
    @okr = Okr.new(okr_params)
    if @okr.valid?
      objective = @okr.objectives.build()
      objective.key_results.build()
      render 'define'
    else
      @okr.errors
      render 'new', alert: "Oops! Verify the fields highlighted below."
    end
  end

  def create
    # Generate okr, objectives and kr models from params
    @okr = Okr.new(okr_params)
    # IF post request from add/remove buttons...
    if params[:button]
      case params[:button][/\D*/]
        when "add_o"
          objective = @okr.objectives.build()
          objective.key_results.build()
          render 'define'
        when "remove_o"
          objective_to_remove = @okr.objectives.last
          @okr.objectives.delete(objective_to_remove)
          render 'define'
        when "add_kr_"
          index = params[:button][/\d*$/].to_i
          objective_to_change = @okr.objectives[index]
          objective_to_change.key_results.build()
          render 'define'
        when "remove_kr_"
          index = params[:button][/\d*$/].to_i
          objective_to_change = @okr.objectives[index]
          kr_to_remove = objective_to_change.key_results.last
          objective_to_change.key_results.delete(kr_to_remove)
          render 'define'
        else
      end
    # IF create button, proceed to savind...
    else
      if @okr.valid?
        @okr.public_url = SecureRandom.hex(10)
        @okr.admin_url = SecureRandom.hex(16)
        @okr.save
        @okr.objectives.each do |o|
          o.key_results.each do |kr|
            kr.save
          end
          o.save
        end
        redirect_to share_okr_path(@okr.admin_url), notice: "OKR successfully created"
      else
        render 'define', alert: "OKR format invalid. Check highlighted fields."
      end
    end
  end

  def share
    @public_url = "http://www.simpleokr.com/#{@okr.public_url}"
    @admin_url = "http://www.simpleokr.com/#{@okr.admin_url}"
  end

  def edit
  end

  def update
  end

  def review
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
