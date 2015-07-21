class OkrsController < ApplicationController
  before_action :find_by_url, only: [:show, :edit, :review]
  before_action :find_by_id, only: [:update, :destroy]

  def show
    @admin_access = admin_access
    track_event(current_user, 'viewed okr')
  end

  def new
    @okr = Okr.new
    track_event(current_user, 'started okr')
  end

  def define
    okr_attributes = okr_params
    okr_attributes[:year] = okr_attributes[:year].to_i
    okr_attributes[:quarter] = okr_attributes[:quarter][/\d/].to_i
    @okr = Okr.new(okr_attributes)
    if @okr.valid?
      track_event(current_user, 'registered')
      record_user_info(session[:user_id], {
        '$name' => okr_attributes[:admin_name],
        '$email' => okr_attributes[:admin_email]
        })
      objective = @okr.objectives.build()
      objective.key_results.build()
      render 'define'
    else
      @okr.errors
      render 'new', alert: "Oops! Verify the fields highlighted below."
    end
  end

  def create
    # Generate okr, objectives and kr instances from params
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
        track_event(current_user, 'created okr')
        record_user_info(session[:user_id], {
          '$okr_admin_url' => @okr.admin_url,
          '$okr_public_url' => @okr.public_url,
          '$okr_obj_count' => count[:ob],
          '$okr_kr_count' => count[:kr]
        })
        UserMailer.welcome(@okr).deliver_now
        redirect_to show_okr_path(@okr.admin_url), notice: "Congratulations on creating you OKR!"
      else
        render 'define', alert: "OKR format invalid. Check highlighted fields."
      end
    end
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
    if params[:commit]=="Save Review"
      okr_attributes[:reviewed] = true
      if @okr.valid?
        track_event(current_user, 'reviewed okr')
        @okr.update(okr_attributes)
        redirect_to show_okr_path(@okr.admin_url), notice: "Congratulations on reviewing your OKR!"
      else
        render 'review', alert: "Oops! We couldn't save your review. Please contact support."
      end
    else
      if @okr.valid?
        @okr.update(okr_attributes)
        if params[:button]
          case params[:button][/\D*/]
            when "add_o"
              objective = @okr.objectives.create(description: "New objective...")
              objective.key_results.create(description: "New key result...")
              redirect_to edit_okr_path(@okr.admin_url)
            when "remove_o"
              @okr.objectives.last.destroy
              redirect_to edit_okr_path(@okr.admin_url)
            when "add_kr_"
              index = params[:button][/\d*$/].to_i
              objective_to_change = @okr.objectives.find(index)
              objective_to_change.key_results.create(description: "New key result...")
              redirect_to edit_okr_path(@okr.admin_url)
            when "remove_kr_"
              index = params[:button][/\d*$/].to_i
              @okr.objectives.find(index).key_results.last.destroy
              redirect_to edit_okr_path(@okr.admin_url)
          end
        else
          redirect_to show_okr_path(@okr.admin_url), notice: "Your OKR were updated."
        end
      else
        render 'review', alert: "Oops! We couldn't save your modifications. Please contact support."
      end
    end
  end

  def review
  end

  def destroy
    @okr.delete
    redirect_to root_path
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