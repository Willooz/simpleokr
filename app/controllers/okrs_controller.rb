class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :share, :edit, :review]
  before_action :find_by_id, only: [:update, :finalize, :delete]

  def show
    @admin_access = admin_access
  end

  def new
    @okr = Okr.new
    meta_events_tracker.event!(:user, :start, {})
  end

  def define
    okr_attributes = okr_params
    okr_attributes[:year] = okr_attributes[:year].to_i
    okr_attributes[:quarter] = okr_attributes[:quarter][/\d/].to_i
    @okr = Okr.new(okr_attributes)
    if @okr.valid?
      meta_events_tracker.event!(:user, :registration, { user_name: okr_attributes[:admin_name], user_email: okr_attributes[:admin_email] })
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
    # IF create button, proceed to save ...
    else
      if @okr.valid?
        @okr.public_url = SecureRandom.hex(5)
        @okr.admin_url = SecureRandom.hex(8)
        @okr.save
        count = { ob: 0, kr: 0 }
        @okr.objectives.each do |o|
          count[:ob] += 1
          o.key_results.each do |kr|
            count[:kr] += 1
            kr.save
          end
          o.save
        end
        meta_events_tracker.event!(:user, :creation, { link: @okr.admin_url, objectives: count[:ob], kr: count[:kr] })
        redirect_to share_okr_path(@okr.admin_url), notice: "Congratulations on creating you OKR!"
      else
        render 'define', alert: "OKR format invalid. Check highlighted fields."
      end
    end
  end

  def share
    @public_url = "http://simpleokr.net/#{@okr.public_url}"
    @admin_url = "http://simpleokr.net/#{@okr.admin_url}"
  end

  def edit
    if @okr.reviewed
      render 'review'
    else
      render 'edit'
    end
  end

  def update
    okr_attributes = okr_params
    if params[:commit]=="Submit Review"
      okr_attributes[:reviewed] = true
    end
    if @okr.valid?
      @okr.update(okr_attributes)
      redirect_to show_okr_path(@okr.admin_url), notice: "Congratulations on reviewing your OKR!"
    else
      render 'review', alert: "There was a problem with saving your review. Please contact support."
    end
   end

  def review
  end

  def finalize
  end

  def destroy
  end

  private

  def okr_params
    params.require(:okr).permit(:id, :admin_name, :admin_email, :owner, :year, :quarter,
      objectives_attributes: [
        :id, :description, :score,
        key_results_attributes: [
          :id, :description, :score
          ]
        ]
      )
  end

  def find_by_url
    if admin_access
      @okr = Okr.find_by(admin_url: params[:url])
    else
      @okr = Okr.find_by(public_url: params[:url])
    end
  end

  def find_by_id
    @okr = Okr.find(params[:id])
  end

  def admin_access
    if params[:url].length > 12
      return true
    else
      return false
    end
  end
end
