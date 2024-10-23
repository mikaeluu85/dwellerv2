class GeographyInput < Formtastic::Inputs::StringInput
  def input_html_options
    super.merge(:value => object.send(method).to_s)
  end
end
