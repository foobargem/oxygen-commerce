module Admin::ProductsHelper

  def display_resort(product)
    if product.free_type_ticket?
      RESORT_OPTIONS.join(",")
    else
      product.resort
    end
  end

  def resort_collection_by_ticket(product)
    if product.free_type_ticket?
      RESORT_OPTIONS
    else
      [product.resort]
    end
  end

  def display_ticket_type(ticket_type)
    if TICKET_TYPE_OPTIONS.has_key?(ticket_type)
      TICKET_TYPE_OPTIONS[ticket_type]
    else
      ""
    end
  end

end
