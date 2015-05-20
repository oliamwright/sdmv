class PersonValuesController < ApplicationController

  skip_before_action :verify_authenticity_token

  def create
    PersonValue.create permit_params

    respond_to do |format|
      @person_values = PersonValue.all
      format.js { render action: "show"}
    end
  end

  def update
    person_value = PersonValue.find(params["id"])
    person_value.update_attributes permit_params

    respond_to do |format|  
      @person_values = PersonValue.all
      format.js { render action: "show"}
    end
  end

  def destroy
    PersonValue.destroy(params["id"])

    respond_to do |format|
      @person_values = PersonValue.all
      format.js { render action: "show"}
    end
  end

  private

  def permit_params
    params.require(:person_value).permit :x, :y, :influence, :availability_from, :availability_to, :keywords
  end
end