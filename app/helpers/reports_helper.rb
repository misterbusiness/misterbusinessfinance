module ReportsHelper
  def chart_tag (action, height, float, params = {})
    params[:format] ||= :json
    path = '/lancamentos/reports/' + action
    content_tag(:div, :'data-chart' => path, :style => "height: #{height}px; float: #{float}") do
      image_tag('spinner.gif', :size => '24x24', :class => 'spinner')
    end
  end
end
