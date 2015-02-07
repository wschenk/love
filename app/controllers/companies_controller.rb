 
 
class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json, :js

  def index
    @companies = Company.all
  end 

  def show
  end 

  def new 
    @company = Company.new
  end 

  def edit
  end 

  def create
    @company = Company.new(company_params)
    @company.save
    respond_with(@company)
  end 

  def update
    @company.update(company_params)
    flash[:notice] = 'Company was successfully updated.'
    respond_with(@company)
  end 

  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully destroyed.'
  end 

  private
    def set_company
      @company = Company.find(params[:id])
    end 

    def company_params
      params.require(:company).permit(:name, :domain) 
    end 
end
 
