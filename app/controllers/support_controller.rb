class SupportController < ApplicationController

  def datestring
    @datavencimento = params[:datavencimento] unless params[:datavencimento].blank?
    @freqAgendamentos = params[:freqAgendamentos] unless params[:freqAgendamentos].blank?
    @numAgendamentos = Integer(params[:numAgendamentos]) unless params[:numAgendamentos].blank?


    @dateString = case @freqAgendamentos
                    when 'Semanal' then
                      @datavencimento + (@numAgendamentos-1).weeks
                    when 'Mensal' then
                      @datavencimento + (@numAgendamentos-1).months
                    when 'Semestral' then
                      @datavencimento + ((@numAgendamentos-1)*6).months
                    when 'Anual' then
                      @datavencimento + (@numAgendamentos-1).years
                    else
                      @datavencimento
                  end
    respond_to do |format|
      format.json { render json: @dateString }
    end
  end

  def show
    @datavencimento = params[:datavencimento] unless params[:datavencimento].blank?
    @freqAgendamentos = params[:freqRepeticoes] unless params[:freqRepeticoes].blank?
    @numAgendamentos = Integer(params[:numRepeticoes]) unless params[:numRepeticoess].blank?

    @data = @datavencimento.strftime("%d-%m-%Y")

    @dateString = case @freqAgendamentos
                    when 'Semanal' then
                      @datavencimento + (@numAgendamentos-1).weeks
                    when 'Mensal' then
                      @datavencimento + (@numAgendamentos-1).months
                    when 'Semestral' then
                      @datavencimento + ((@numAgendamentos-1)*6).months
                    when 'Anual' then
                      @datavencimento + (@numAgendamentos-1).years
                    else
                      @datavencimento
                  end
    respond_to do |format|
      format.json { render json: @dateString }
    end
  end
end
