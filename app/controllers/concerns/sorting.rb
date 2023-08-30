module Sorting
  extend ActiveSupport::Concern

  included do
    private

    def sort_column(column = 'name', model = nil)
      if model
        model.capitalize.constantize.column_names.include?(params[:sort]) ? params[:sort] : "#{column}"
      else
        model = controller_name.singularize.constantize
        model.column_names.include?(params[:sort]) ? params[:sort] : "#{column}"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
  end
end