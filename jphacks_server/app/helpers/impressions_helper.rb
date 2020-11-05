module ImpressionsHelper
  def value_count(material_id, value)
    Impression
      .includes(:material)
      .where(material_id: material_id)
      .where(value: value)
      .count
  end
end