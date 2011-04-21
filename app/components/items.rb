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
        :class_name => "Netzke::Basepack::Panel",
        :width => 240,
        :split => true
      },{
        :region => :south,
        :title => "Items",
        :class_name => "Netzke::Basepack::GridPanel",
        :model => "Item",
        #:columns => [:location_id, :category__category_name, :model, :name, :serial_number],
        :height => 250,
        :split => true
      }]
    )
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
      this.selectCategory({boss_id: 100});
      // alert("Category id: " + self.store.getAt(rowIndex).get('id'));
     }
   JS

  endpoint :select_category do |params|
    logger.info "!!! params[:boss_id]: #{params[:boss_id]}\n"
  end

end
