class Items < Netzke::Basepack::BorderLayoutPanel
  def configuration
    super.merge(
      :header => false,
      :items => [{
        :name => "categories",
        :title => "Categories",
        :region => :center,
        :class_name => "Netzke::Basepack::GridPanel",
        :model => "Category"
      },{
        :region => :east,
        :title => "Details",
        :name => "info",
        :class_name => "Netzke::Basepack::Panel",
        :width => 240,
        :split => true
      },:details.component(
        :region => :south,
        :title => "Items",
        #:columns => [:location_id, :category__category_name, :model, :name, :serial_number],
        :height => 250,
        :split => true
      )]
    )
  end

  component :details do
    {
       :class_name => "Netzke::Basepack::GridPanel",
       :model => "Item",

       # do not load data initially
       :load_inline_data => false,
       
       # limit the scope to the selected category (see below)
       :scope => {:category_id => component_session[:selected_category_id]},
       # always set category_id
       :strong_default_attrs => {:category_id => component_session[:selected_category_id]}
    }
  end

  # Overriding initComponent
   js_method :init_component, <<-JS
     function(){
       // calling superclass's initComponent
       #{js_full_class_name}.superclass.initComponent.call(this);

      // setting the 'rowclick' event
      this.getChildComponent('categories').on('rowclick', this.onCategorySelectionChanged, this);
     }
  JS

 # Event handler
   js_method :on_category_selection_changed, <<-JS
     function(self, rowIndex){
      this.selectCategory({category_id: self.store.getAt(rowIndex).get('id')});
      // alert("Category id: " + self.store.getAt(rowIndex).get('id'));
     }
   JS

   endpoint :select_category do |params|
#    logger.info "!!! params[:category_id]: #{params[:category_id]}\n"
    component_session[:selected_category_id] = params[:category_id]

    # selected category
    category = Category.find(params[:category_id])
  
    details_grid = component_instance(:details)
    details_data = details_grid.get_data
  
    {
      :details => {:load_store_data => details_data, :set_title => "Items for #{category.category_name}"},
      :info => {:update_body_html => category_info_html(category), :set_title => "#{category.category_name}"}
    }  
  end

  def category_info_html(category)
    res = "<h1>Category details...</h1>"
    res << "Name: #{category.category_name}<br/>"
    res << "More to come...."
    res
  end

end
