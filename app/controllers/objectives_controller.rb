class ObjectivesController < ApplicationController

  def new
    @objective = Objective.new
    @kr = @objective.key_results.build
  end

  def edit
  end

  def destroy
  end
end
