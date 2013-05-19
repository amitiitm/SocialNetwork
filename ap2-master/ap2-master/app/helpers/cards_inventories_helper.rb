module CardsInventoriesHelper
  def inventory_actions(inventory)
    if inventory.allocated
      link_to("Manage", edit_cards_inventory_path(inventory), :class => "ajax")
    else
      "Salam!"
    end
  end
end
