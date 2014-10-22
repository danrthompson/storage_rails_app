module ApplicationHelper
  def link_to_add_fields(name, f, association, pickup_request)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, pickup_request: pickup_request)
    end
    link_to(name, '#', class: "add_fields btn blue-bg white pull-right", data: {id: id, fields: fields.gsub("\n", "")})
  end
end