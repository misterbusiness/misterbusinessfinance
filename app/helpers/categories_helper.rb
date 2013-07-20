module CategoriesHelper

  def display_categories_tree(categories)

    ret = "<ul>"

    for category in categories
      if category.parent_id.nil?
        ret += "<li>"
        ret += category.descricao
        ret += '  '
        ret += link_to 'Editar', edit_category_path(category), :remote => true
        ret += find_all_subcategories(category)
        ret += "</li>"
      end

    end

    ret += "</ul>"

  end

  def find_all_subcategories(category)

    if category.children.size > 0

      ret = '<ul>'
       category.children.each {  |subcat|

         if subcat.children.size > 0
           ret +=  '<li>'
           ret += subcat.descricao
           ret += '  '
           ret += link_to 'Editar', edit_category_path(subcat), :remote => true
           ret += find_all_subcategories(subcat)

           ret +=  '</li>'

         else

           ret +=  '<li>'
           ret += subcat.descricao
           ret += '  '
           ret += link_to 'Editar', edit_category_path(subcat), :remote => true

           ret +=  '</li>'

         end




       }


      ret += '</ul>'

      else

        ret = ''

      end







    end


  end



